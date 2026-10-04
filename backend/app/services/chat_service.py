"""챗봇 파이프라인 (에이전트구상.png).

1) genai로 '주제 판별(의도 분류)'만 먼저 하고(실패 시 키워드 폴백) — 이 게이트가
   "답변이 판단할 수 있는 소재인가?"에 해당한다. 분류는 직전 대화([이전 대화])도
   같이 보고 판단한다 — 그렇지 않으면 "그럼 저는 어떻게 해야 하나요?" 같은
   맥락 의존 후속 질문이 매번 off_topic으로 새서 답이 안 나가는 문제가 있었다.
   노동 상담·생활 정보·기관 찾기·meta는 에이전트를 부르고, off_topic만 에이전트 없이
   정중한 거절 문구로 바로 응답한다.
2) 소재가 있다고 판단되면 app.agent.pipeline.run_agent()로 Tools(사용자 이력
   조회·임금 계산·기관 조회)를 갖춘 Gemini 에이전트 루프를 돌려 최종 답변을
   받는다 — 더 이상 정적 문구만 내보내지 않고, 도구로 근거를 확보한 뒤 LLM이
   답변을 구성한다.
3) 에이전트 호출이 실패하면(자격증명 없음, 네트워크 오류 등) _CONTENT의 사전
   검수 문구로 폴백해 항상 응답할 수 있게 한다.
4) 로그인한 사용자(uid)라면 history_service로 이번 대화를 저장한다 — 이력
   저장 실패가 응답 자체를 막지는 않는다.
"""

import logging
from typing import Dict, List, Literal, Optional, TypedDict

from google.genai import types
from pydantic import BaseModel

from ..agent.pipeline import run_agent
from ..core.genai_client import get_genai_client, get_model_name
from ..core.logging_utils import log_exception_summary
from ..schemas.chat import ChatRequest, ChatResponse, ChatTurn, RoutingTarget
from ..schemas.org import Org
from . import history_service, org_service

logger = logging.getLogger(__name__)

Intent = Literal["wage", "accident", "contract", "life_info", "org_search", "meta", "off_topic"]

# 에이전트를 실제로 호출하는 의도 — 나머지(off_topic)는 정중히 거절만 하고
# Gemini를 부르지 않는다(비용·오남용 방지).
_AGENT_INTENTS: frozenset = frozenset({"wage", "accident", "contract", "life_info", "org_search", "meta"})

_ORG_CATEGORY_BY_INTENT = {
    "wage": "임금",
    "accident": "산재",
    "contract": "근로계약",
}


def _fallback_orgs(request: ChatRequest, intent: Intent, limit: int) -> List[Org]:
    """에이전트가 기관 도구를 호출하지 않거나 실패해도 기기 위치 기준의
    실제 거리와 상황별 기본 기관을 반환한다."""
    category = _ORG_CATEGORY_BY_INTENT.get(intent)
    if category is None:
        return []

    orgs = org_service.list_orgs(
        lat=request.latitude,
        lng=request.longitude,
        category=category,
    )
    if not orgs:
        orgs = org_service.list_orgs(
            lat=request.latitude,
            lng=request.longitude,
        )
    return orgs[:limit]


class IntentClassification(BaseModel):
    """genai structured output 스키마. 분류값만 받고 다른 자유 텍스트는 받지 않는다."""

    intent: Intent


Language = Literal["ko", "en", "zh", "vi", "uz", "tr", "ne", "tet", "lo", "mn", "my", "bn", "si", "id", "km", "ky", "th", "ur", "fil", "tg"]

# 프론트엔드(AppLanguage)와 동일한 20개 언어. 에이전트 호출이 실패했을 때 나가는
# 기본 안내 문구를 언어별로 제공한다 —
# 에이전트 정상 경로는 pipeline.run_agent()에 넘긴 language로 처리된다.
_L = Dict[Language, str]


class _ContentEntry(TypedDict):
    keywords: List[str]
    fact_answer: Optional[_L]
    risk_notice: Optional[_L]
    routing_target: Optional[RoutingTarget]


def _pick(text: Optional[_L], language: Language) -> Optional[str]:
    if text is None:
        return None
    return text.get(language) or text["ko"]


_META_FALLBACK_ANSWER: _L = {
    "tr": "Yabancılar, göçmen işçiler ve uluslararası öğrenciler için bir yapay zekâ asistanıyım. Çalışma hayatı, Kore'de yaşam veya destek kuruluşlarını bulma konusunda soru sorabilirsiniz.",
    "tg": "Ман ёвари зеҳни сунъӣ барои хориҷиён, коргарони муҳоҷир ва донишҷӯёни байналмилалӣ ҳастам. Шумо метавонед дар бораи ҳаёти корӣ, зиндагӣ дар Корея ё дарёфти ташкилотҳои дастгирӣ савол диҳед.",
    "fil": "Ako ay isang AI assistant para sa mga dayuhan, migranteng manggagawa, at internasyonal na estudyante. Maaari kang magtanong tungkol sa buhay sa trabaho, pamumuhay sa Korea, o paghahanap ng mga organisasyon ng suporta.",
    "ur": "میں غیر ملکیوں، تارکین وطن مزدوروں اور بین الاقوامی طلباء کے لیے ایک AI اسسٹنٹ ہوں۔ آپ کام کی زندگی، کوریا میں زندگی یا معاون تنظیموں کو تلاش کرنے کے بارے میں سوالات پوچھ سکتے ہیں۔",
    "th": "ฉันเป็นผู้ช่วย AI สำหรับชาวต่างชาติ แรงงานข้ามชาติ และนักเรียนต่างชาติ คุณสามารถถามคำถามเกี่ยวกับชีวิตการทำงาน การใช้ชีวิตในเกาหลี หรือการค้นหาองค์กรสนับสนุนได้",
    "ky": "Мен чет элдиктер, мигрант жумушчулар жана эл аралык студенттер үчүн жасалма интеллект ассистентимин. Жумуш жашоосу, Кореядагы жашоо же колдоо уюмдарын табуу боюнча суроолорду бере аласыз.",
    "km": "ខ្ញុំជាជំនួយការ AI សម្រាប់ជនបរទេស ពលករចំណាកស្រុក និងនិស្សិតអន្តរជាតិ។ អ្នកអាចសួរសំណួរអំពីជីវិតការងារ ជីវិតនៅកូរ៉េ ឬការស្វែងរកអង្គការជំនួយ។",
    "id": "Saya adalah asisten AI untuk orang asing, pekerja migran, dan pelajar internasional. Anda dapat bertanya tentang kehidupan kerja, kehidupan di Korea, atau mencari organisasi pendukung.",
    "si": "මම විදේශිකයන්, සංක්‍රමණික කම්කරුවන් සහ ජාත්‍යන්තර සිසුන් සඳහා AI සහායකයෙක්මි. ඔබට රැකියා ජීවිතය, කොරියාවේ ජීවිතය හෝ ආධාරක සංවිධාන සොයා ගැනීම ගැන ප්‍රශ්න ඇසිය හැකිය.",
    "bn": "আমি বিদেশী, অভিবাসী শ্রমিক এবং আন্তর্জাতিক শিক্ষার্থীদের জন্য একজন এআই সহকারী। আপনি কর্মজীবন, কোরিয়ায় জীবনযাপন বা সহায়তা সংস্থাগুলি খুঁজে বের করা সম্পর্কে প্রশ্ন জিজ্ঞাসা করতে পারেন।",
    "my": "ကျွန်ုပ်သည် နိုင်ငံခြားသားများ၊ ရွှေ့ပြောင်းအလုပ်သမားများနှင့် နိုင်ငံတကာကျောင်းသားများအတွက် AI လက်ထောက်တစ်ဦး ဖြစ်ပါသည်။ အလုပ်သမားဘဝ၊ ကိုရီးယားတွင် နေထိုင်ခြင်း သို့မဟုတ် ပံ့ပိုးကူညီရေးအဖွဲ့အစည်းများ ရှာဖွေခြင်းနှင့်ပတ်သက်၍ မေးမြန်းနိုင်ပါသည်။",
    "mn": "Би гадаадын иргэд, цагаач ажилчид, олон улсын оюутнуудад зориулсан хиймэл оюун ухааны туслах юм. Та ажлын амьдрал, Солонгост амьдрах эсвэл дэмжих байгууллагуудыг олох талаар асуулт асууж болно.",
    "lo": "ຂ້ອຍເປັນຜູ້ຊ່ວຍ AI ສໍາລັບຄົນຕ່າງປະເທດ, ແຮງງານເຄື່ອນຍ້າຍ ແລະ ນັກສຶກສາຕ່າງປະເທດ. ທ່ານສາມາດຖາມຄໍາຖາມກ່ຽວກັບຊີວິດການເຮັດວຽກ, ການດໍາລົງຊີວິດຢູ່ໃນເກົາຫຼີ ຫຼື ການຊອກຫາອົງການຊ່ວຍເຫຼືອ.",
    "tet": "Ha'u nu'udar asisténsia intelijénsia artifisiál ba ema estranjeiru, traballadór migrante no estudante internasionál. Bele husu pergunta kona-ba vida serbisu, moris iha Koreia ka oinsá atu hetan organizasaun apoiu.",
    "ne": "म विदेशीहरू, आप्रवासी कामदारहरू र अन्तर्राष्ट्रिय विद्यार्थीहरूको लागि एक एआई सहायक हुँ। तपाईंले कामको जीवन, कोरियामा जीवन वा सहयोग संस्थाहरू खोज्ने बारे प्रश्नहरू सोध्न सक्नुहुन्छ।",
    "ko": "저는 외국인·이주노동자·유학생을 위한 AI 도우미예요. 노동 상담, 한국 생활 정보, 도움받을 기관 찾기 등 궁금한 점을 편하게 물어보세요.",
    "en": "I'm an AI assistant for foreign residents, migrant workers, and international students. Ask me about labor issues, life in Korea, or finding support organizations.",
    "zh": "我是为外籍居民、外籍劳动者和留学生提供帮助的AI助手。欢迎咨询劳动问题、韩国生活信息或查找相关机构。",
    "uz": "Men chet elliklar, mehnat muhojirlari va chet ellik talabalar uchun AI yordamchisiman. Mehnat masalalari, Koreyadagi hayot yoki yordam tashkilotlarini topish haqida soʻrang.",
    "vi": "Tôi là trợ lý AI dành cho người nước ngoài, lao động nhập cư và du học sinh. Bạn có thể hỏi về lao động, cuộc sống ở Hàn Quốc hoặc tìm cơ quan hỗ trợ.",
}
_OFF_TOPIC_ANSWER: _L = {
    "tr": "Bu hizmet yabancılara çalışma hayatı, Kore'de yaşam ve ilgili kuruluşları bulma konusunda yardımcı olur. İsteğiniz yardımcı olabileceğim kapsamın dışındadır.",
    "tg": "Ин хидмат ба хориҷиён дар бораи ҳаёти корӣ, зиндагӣ дар Корея ва дарёфти ташкилотҳои дахлдор кӯмак мерасонад. Хоҳиши шумо берун аз доираи кӯмаки ман аст.",
    "fil": "Ang serbisyong ito ay tumutulong sa mga dayuhan sa buhay sa trabaho, pamumuhay sa Korea, at paghahanap ng mga kaugnay na organisasyon. Ang iyong kahilingan ay nasa labas ng saklaw na maaari kong tulungan.",
    "ur": "یہ سروس غیر ملکیوں کو کام کی زندگی، کوریا میں زندگی اور متعلقہ تنظیموں کو تلاش کرنے میں مدد کرتی ہے۔ آپ کی درخواست میری مدد کرنے کی گنجائش سے باہر ہے۔",
    "th": "บริการนี้ช่วยชาวต่างชาติเกี่ยวกับชีวิตการทำงาน การใช้ชีวิตในเกาหลี และการค้นหาองค์กรที่เกี่ยวข้อง คำขอของคุณอยู่นอกเหนือขอบเขตที่ฉันสามารถช่วยเหลือได้",
    "ky": "Бул кызмат чет элдиктерге жумуш жашоосу, Кореядагы жашоо жана тиешелүү уюмдарды табуу боюнча жардам берет. Сиздин сурооңуз мен жардам бере ала турган чектен тышкары.",
    "km": "សេវាកម្មនេះជួយជនបរទេសអំពីជីវិតការងារ ជីវិតនៅកូរ៉េ និងការស្វែងរកអង្គការពាក់ព័ន្ធ។ សំណើរបស់អ្នកគឺហួសពីវិសាលភាពដែលខ្ញុំអាចជួយបាន។",
    "id": "Layanan ini membantu orang asing dengan kehidupan kerja, kehidupan di Korea, dan menemukan organisasi terkait. Permintaan Anda berada di luar cakupan yang dapat saya bantu.",
    "si": "මෙම සේවාව විදේශිකයන්ට රැකියා ජීවිතය, කොරියාවේ ජීවිතය සහ අදාළ සංවිධාන සොයා ගැනීමට උපකාරී වේ. ඔබේ ඉල්ලීම මට උදව් කළ හැකි විෂය පථයෙන් බැහැරය.",
    "bn": "এই পরিষেবাটি বিদেশীদের কর্মজীবন, কোরিয়ায় জীবনযাপন এবং সংশ্লিষ্ট সংস্থাগুলি খুঁজে পেতে সহায়তা করে। আপনার অনুরোধটি আমার সাহায্য করার সীমার বাইরে।",
    "my": "ဤဝန်ဆောင်မှုသည် နိုင်ငံခြားသားများအား အလုပ်သမားဘဝ၊ ကိုရီးယားတွင် နေထိုင်ခြင်းနှင့် သက်ဆိုင်ရာ အဖွဲ့အစည်းများ ရှာဖွေခြင်းတို့တွင် ကူညီပေးပါသည်။ သင်၏ တောင်းဆိုချက်သည် ကျွန်ုပ်ကူညီနိုင်သည့် အတိုင်းအတာပြင်ပတွင် ရှိပါသည်။",
    "mn": "Энэхүү үйлчилгээ нь гадаадын иргэдэд ажлын амьдрал, Солонгост амьдрах, холбогдох байгууллагуудыг олоход тусалдаг. Таны хүсэлт миний тусалж чадах хүрээнээс гадуур байна.",
    "lo": "ບໍລິການນີ້ຊ່ວຍເຫຼືອຄົນຕ່າງປະເທດກ່ຽວກັບຊີວິດການເຮັດວຽກ, ການດໍາລົງຊີວິດຢູ່ໃນເກົາຫຼີ ແລະ ການຊອກຫາອົງການທີ່ກ່ຽວຂ້ອງ. ຄໍາຮ້ອງຂໍຂອງທ່ານຢູ່ນອກຂອບເຂດທີ່ຂ້ອຍສາມາດຊ່ວຍໄດ້.",
    "tet": "Servisu ida-ne'e ajuda ema estranjeiru kona-ba vida serbisu, moris iha Koreia no oinsá atu hetan organizasaun relevante. Ita-nia pedidu la iha ha'u-nia kbiit atu ajuda.",
    "ne": "यो सेवाले विदेशीहरूलाई कामको जीवन, कोरियामा जीवन र सम्बन्धित संस्थाहरू खोज्न मद्दत गर्दछ। तपाईंको अनुरोध मैले मद्दत गर्न सक्ने दायरा बाहिर छ।",
    "ko": "이 서비스는 외국인의 노동 상담, 한국 생활 정보, 관련 기관 찾기를 도와드려요. 요청하신 내용은 안내 범위를 벗어나 도움드리기 어려워요.",
    "en": "This service helps foreign residents with labor issues, life in Korea, and finding relevant organizations. Your request is outside the scope I can help with.",
    "zh": "本服务帮助外籍居民咨询劳动问题、了解韩国生活信息及查找相关机构。您的请求超出了我能提供帮助的范围。",
    "uz": "Bu xizmat chet elliklarga mehnat masalalari, Koreyadagi hayot va tegishli tashkilotlarni topishda yordam beradi. Soʻrovingiz yordam bera oladigan doiramdan tashqarida.",
    "vi": "Dịch vụ này hỗ trợ người nước ngoài về lao động, cuộc sống ở Hàn Quốc và tìm cơ quan phù hợp. Yêu cầu của bạn nằm ngoài phạm vi tôi có thể hỗ trợ.",
}

_CONTENT: Dict[Intent, _ContentEntry] = {
    "org_search": {
        "keywords": ["기관", "센터", "문의처", "상담소", "출입국사무소",
                     "support center", "support centre", "咨询中心", "trung tâm hỗ trợ", "yordam markazi",
                     "संस्था", "सहायता केन्द्र", "सल्लाह केन्द्र", "सम्पर्क नम्बर",
                     "sentru apoiu", "organizasaun", "sentru konsulta", "númeru kontaktu",
                     "ສູນຊ່ວຍເຫຼືອ", "ສູນໃຫ້ຄໍາປຶກສາ", "ເບີໂທລະສັບຂອງອົງກອນ", "дэмжих төв", "зөвлөгөө өгөх төв", "байгууллагын утасны дугаар", "ပံ့ပိုးကူညီရေး စင်တာ", "အကြံပေးရေး စင်တာ", "အဖွဲ့အစည်း၏ ဖုန်းနံပါတ်", "সহায়তা কেন্দ্র", "পরামর্শ কেন্দ্র", "সংস্থার ফোন নম্বর", "ආධාරක මධ්‍යස්ථානය", "උපදේශන මධ්‍යස්ථානය", "ආයතනයේ දුරකථන අංකය", "pusat dukungan", "pusat konsultasi", "nomor telepon organisasi", "មជ្ឈមណ្ឌលគាំទ្រ", "មជ្ឈមណ្ឌលប្រឹក្សាយោបល់", "លេខទូរស័ព្ទរបស់ស្ថាប័ន", "колдоо борбору", "кеңеш берүү борбору", "уюмдун телефон номери", "ศูนย์สนับสนุน", "ศูนย์ให้คำปรึกษา", "เบอร์โทรศัพท์ขององค์กร", "امدادی مرکز", "مشاورتی مرکز", "ادارے کا فون نمبر", "sentro ng suporta", "sentro ng pagpapayo", "numero ng telepono ng organisasyon", "маркази дастгирӣ", "маркази машваратӣ", "рақами телефони ташкилот"],
        "fact_answer": {
            "ko": "지금은 기관 정보를 확인하기 어려워요. 잠시 후 필요한 도움과 지역을 함께 알려주시면 관련 기관을 찾아드릴게요.",
            "tr": "Şu anda kuruluş bilgilerini doğrulayamıyorum. Biraz sonra ihtiyacınız olan desteği ve bulunduğunuz bölgeyi belirtirseniz uygun kuruluşları bulmanıza yardımcı olabilirim.",
            "tg": "Дар айни замон ман наметавонам маълумоти ташкилотро тасдиқ кунам. Агар шумо баъдтар дастгирии лозима ва минтақаи худро нишон диҳед, ман метавонам ба шумо дар дарёфти ташкилотҳои мувофиқ кӯмак расонам.",
            "fil": "Sa kasalukuyan, hindi ko mapatunayan ang impormasyon ng organisasyon. Kung maaari mong tukuyin ang suportang kailangan mo at ang iyong rehiyon sa ibang pagkakataon, matutulungan kitang makahanap ng mga angkop na organisasyon.",
            "ur": "میں فی الحال تنظیم کی معلومات کی تصدیق نہیں کر سکتا۔ اگر آپ تھوڑی دیر بعد اپنی ضرورت کی مدد اور اپنے علاقے کی وضاحت کریں تو میں آپ کو مناسب تنظیموں کو تلاش کرنے میں مدد کر سکتا ہوں۔",
            "th": "ขณะนี้ฉันไม่สามารถยืนยันข้อมูลองค์กรได้ หากคุณระบุประเภทความช่วยเหลือที่คุณต้องการและภูมิภาคที่คุณอยู่ ฉันจะช่วยคุณค้นหาองค์กรที่เหมาะสมได้ในภายหลัง",
            "ky": "Учурда уюмдардын маалыматын ырастай албайм. Бир аздан кийин сизге керектүү колдоону жана жайгашкан аймагыңызды көрсөтсөңүз, ылайыктуу уюмдарды табууга жардам бере алам.",
            "km": "បច្ចុប្បន្ន ខ្ញុំមិនអាចផ្ទៀងផ្ទាត់ព័ត៌មានអង្គការបានទេ។ ប្រសិនបើអ្នកបញ្ជាក់ពីការគាំទ្រដែលអ្នកត្រូវការ និងតំបន់ដែលអ្នកស្ថិតនៅបន្តិចទៀត ខ្ញុំអាចជួយអ្នកស្វែងរកអង្គការសមស្របបាន។",
            "id": "Saat ini saya tidak dapat memverifikasi informasi organisasi. Jika Anda menyebutkan dukungan yang Anda butuhkan dan wilayah Anda sebentar lagi, saya dapat membantu Anda menemukan organisasi yang sesuai.",
            "si": "මට දැනට සංවිධාන තොරතුරු සත්‍යාපනය කළ නොහැක. ඔබට අවශ්‍ය සහාය සහ ඔබේ ප්‍රදේශය ටික වේලාවකට පසු සඳහන් කළහොත්, සුදුසු සංවිධාන සොයා ගැනීමට මට ඔබට උදව් කළ හැකිය.",
            "bn": "আমি বর্তমানে সংস্থার তথ্য যাচাই করতে পারছি না। আপনি যদি কিছুক্ষণ পরে আপনার প্রয়োজনীয় সহায়তা এবং আপনার অবস্থান উল্লেখ করেন তবে আমি আপনাকে উপযুক্ত সংস্থাগুলি খুঁজে পেতে সহায়তা করতে পারি।",
            "my": "လက်ရှိတွင် အဖွဲ့အစည်းဆိုင်ရာ အချက်အလက်များကို ကျွန်ုပ် အတည်မပြုနိုင်ပါ။ ခဏအကြာတွင် သင်လိုအပ်သော အကူအညီနှင့် သင်၏ ဒေသကို ဖော်ပြပါက သင့်လျော်သော အဖွဲ့အစည်းများကို ရှာဖွေရာတွင် ကျွန်ုပ် ကူညီနိုင်ပါသည်။",
            "mn": "Би одоогоор байгууллагын мэдээллийг баталгаажуулах боломжгүй байна. Хэрэв танд хэрэгтэй дэмжлэг болон байгаа бүс нутгаа хэсэг хугацааны дараа зааж өгвөл би танд тохирох байгууллагуудыг олоход тусалж чадна.",
            "lo": "ຂ້ອຍບໍ່ສາມາດຢືນຢັນຂໍ້ມູນອົງການໄດ້ໃນຕອນນີ້. ຖ້າທ່ານລະບຸການຊ່ວຍເຫຼືອທີ່ທ່ານຕ້ອງການ ແລະ ພາກພື້ນຂອງທ່ານໃນພາຍຫຼັງ, ຂ້ອຍສາມາດຊ່ວຍທ່ານຊອກຫາອົງການທີ່ເໝາະສົມໄດ້.",
            "tet": "Agora daudaun, ha'u la bele verifika informasaun organizasaun nian. Se karik depois ita bele fó sai apoiu saida mak ita presiza no fatin ne'ebé ita hela, ha'u bele ajuda ita atu hetan organizasaun ne'ebé adekuadu.",
            "ne": "म हाल संस्थाको जानकारी प्रमाणित गर्न सक्दिनँ। यदि तपाईंले केही समयपछि तपाईंलाई आवश्यक पर्ने सहयोग र तपाईंको क्षेत्र बताउनुभयो भने, म तपाईंलाई उपयुक्त संस्थाहरू फेला पार्न मद्दत गर्न सक्छु।",
            "en": "I can't check organization details right now. Please try again shortly with the help you need and your area so I can look for a suitable organization.",
            "zh": "暂时无法确认机构信息。请稍后告知您需要的帮助和所在地区，我会帮您查找相关机构。",
            "vi": "Hiện tôi chưa thể kiểm tra thông tin cơ quan. Vui lòng thử lại sau và cho biết bạn cần hỗ trợ gì, ở khu vực nào để tôi tìm cơ quan phù hợp.",
            "uz": "Hozir tashkilot maʼlumotlarini tekshira olmayapman. Birozdan keyin qanday yordam kerakligini va hududingizni ayting, mos tashkilotni topishga yordam beraman.",
        },
        "risk_notice": None,
        "routing_target": None,
    },
    "wage": {
        "keywords": ["임금", "체불", "월급", "급여", "तलब", "ज्याला", "पारिश्रमिक", "saláriu", "salariu",
                     "ຄ່າຈ້າງ", "цалин", "လစာ", "বেতন", "වැටුප්", "gaji", "ប្រាក់ឈ្នួល", "эмгек акы", "ค่าจ้าง", "تنخواہ", "sahod", "музди меҳнат", "ຄ່າຈ້າງທີ່ຍັງບໍ່ໄດ້ຈ່າຍ", "цалин хөлс өгөөгүй", "မရသေးသော လုပ်ခလစာ", "လုပ်ခလစာ", "অপরিশোধিত বেতন", "মজুরি", "නොගෙවූ වැටුප්", "gaji yang belum dibayar", "upah", "ប្រាក់ឈ្នួលមិនទាន់បានបង់", "төлөнбөгөн эмгек акы", "ค่าจ้างค้างชำระ", "بقایا تنخواہ", "اجرت", "hindi nabayarang sahod", "музди меҳнати пардохтнашуда", "музд"],
        "fact_answer": {
            "ko": "근로기준법상 사용자는 퇴직·지급일로부터 14일 이내에 임금을 지급해야 해요. 이미 기간이 지났다면 진정 제기가 가능해요.",
            "tr": "İş Standartları Kanunu uyarınca işverenler, işten ayrılma veya ödeme tarihinden itibaren 14 gün içinde ücretleri ödemelidir. Bu süre geçtiyse şikâyette bulunabilirsiniz.",
            "tg": "Мутобиқи Қонун дар бораи стандартҳои меҳнат, корфармоён бояд музди меҳнатро дар давоми 14 рӯз аз санаи қатъи кор ё пардохт пардохт кунанд. Агар ин мӯҳлат гузашта бошад, шумо метавонед шикоят кунед.",
            "fil": "Ayon sa Labor Standards Act, dapat bayaran ng mga employer ang sahod sa loob ng 14 araw mula sa pagtatapos ng trabaho o petsa ng pagbabayad. Kung lumipas na ang panahong ito, maaari kang mag-file ng reklamo.",
            "ur": "لیبر اسٹینڈرڈز قانون کے مطابق، آجروں کو ملازمت چھوڑنے یا ادائیگی کی تاریخ سے 14 دنوں کے اندر اجرت ادا کرنی چاہیے۔ اگر یہ مدت گزر چکی ہے، تو آپ شکایت درج کر سکتے ہیں۔",
            "th": "ตามพระราชบัญญัติมาตรฐานแรงงาน นายจ้างต้องจ่ายค่าจ้างภายใน 14 วันนับจากวันที่ลาออกหรือวันที่จ่ายเงิน หากเกินกำหนดนี้ คุณสามารถยื่นเรื่องร้องเรียนได้",
            "ky": "Эмгек стандарттары мыйзамына ылайык, иш берүүчүлөр жумуштан кеткен же төлөө күнүнөн тартып 14 күндүн ичинде эмгек акыны төлөшү керек. Эгер бул мөөнөт өтүп кетсе, арыз менен кайрылсаңыз болот.",
            "km": "យោងតាមច្បាប់ស្តីពីស្តង់ដារការងារ និយោជកត្រូវតែបង់ប្រាក់ឈ្នួលក្នុងរយៈពេល 14 ថ្ងៃគិតចាប់ពីថ្ងៃឈប់សម្រាក ឬថ្ងៃបង់ប្រាក់។ ប្រសិនបើរយៈពេលនេះបានកន្លងផុតទៅ អ្នកអាចដាក់ពាក្យបណ្តឹងបាន។",
            "id": "Berdasarkan Undang-Undang Standar Ketenagakerjaan, pengusaha harus membayar upah dalam waktu 14 hari sejak tanggal pengunduran diri atau tanggal pembayaran. Jika periode ini telah berlalu, Anda dapat mengajukan keluhan.",
            "si": "කම්කරු ප්‍රමිති පනතට අනුව, සේවා යෝජකයන් සේවයෙන් ඉවත් වූ දින සිට හෝ ගෙවීමේ දින සිට දින 14 ක් ඇතුළත වැටුප් ගෙවිය යුතුය. මෙම කාලය ඉක්මවා ඇත්නම්, ඔබට පැමිණිල්ලක් ඉදිරිපත් කළ හැකිය.",
            "bn": "শ্রম মান আইন অনুসারে, নিয়োগকর্তাদের অবশ্যই চাকরি ছাড়ার বা অর্থপ্রদানের তারিখ থেকে 14 দিনের মধ্যে মজুরি পরিশোধ করতে হবে। এই সময়সীমা অতিক্রম করলে আপনি অভিযোগ দায়ের করতে পারেন।",
            "my": "အလုပ်သမားစံနှုန်းဥပဒေအရ အလုပ်ရှင်များသည် အလုပ်မှ ထွက်ခွာသည့်နေ့ သို့မဟုတ် လုပ်ခလစာ ပေးချေရမည့်နေ့မှစ၍ 14 ရက်အတွင်း လုပ်ခလစာ ပေးချေရမည်။ ဤကာလ ကျော်လွန်ပါက တိုင်ကြားနိုင်သည်။",
            "mn": "Хөдөлмөрийн стандартын тухай хуулийн дагуу ажил олгогчид ажлаас халагдсан эсвэл төлбөр хийх өдрөөс хойш 14 хоногийн дотор цалин хөлсийг төлөх ёстой. Хэрэв энэ хугацаа өнгөрсөн бол та гомдол гаргаж болно.",
            "lo": "ອີງຕາມກົດໝາຍມາດຕະຖານແຮງງານ, ນາຍຈ້າງຕ້ອງຈ່າຍຄ່າຈ້າງພາຍໃນ 14 ວັນ ນັບແຕ່ວັນທີ່ລາອອກ ຫຼື ວັນທີ່ຈ່າຍເງິນ. ຖ້າໄລຍະເວລານີ້ຜ່ານໄປແລ້ວ, ທ່ານສາມາດຍື່ນຄໍາຮ້ອງຮຽນໄດ້.",
            "tet": "Tuir Lei Padrão Traballu, empregadór sira tenke selu saláriu iha loron 14 nia laran hahú husi data demisaun ka pagamentu. Se tempu ne'e liu ona, ita bele halo keixa.",
            "ne": "श्रम मानक कानून अनुसार, रोजगारदाताहरूले काम छोडेको वा भुक्तानी मितिबाट 14 दिन भित्र ज्याला भुक्तानी गर्नुपर्छ। यदि यो अवधि बितिसकेको छ भने, तपाईं उजुरी गर्न सक्नुहुन्छ।",
            "en": "Under the Labor Standards Act, employers must pay wages within 14 days of resignation or the payment date. If that period has already passed, you can file a complaint.",
            "zh": "根据《劳动基准法》，雇主须在离职或发薪日起14天内支付工资。如果已超过该期限，您可以提出申诉。",
            "uz": "Mehnat standartlari toʻgʻrisidagi qonunga koʻra, ish beruvchi ishdan ketish yoki toʻlov kunidan boshlab 14 kun ichida ish haqini toʻlashi kerak. Ushbu muddat oʻtgan boʻlsa, shikoyat berishingiz mumkin.",
            "vi": "Theo Luật Tiêu chuẩn Lao động, người sử dụng lao động phải trả lương trong vòng 14 ngày kể từ ngày nghỉ việc hoặc ngày trả lương. Nếu đã quá thời hạn, bạn có thể nộp đơn khiếu nại.",
        },
        "risk_notice": {
            "ko": "즉시 대응이 필요한 사안으로 보여요. 정확한 판단은 AI가 아닌 아래 네비게이터·전문가를 통해 확인해 주세요.",
            "tr": "Bu durum acil müdahale gerektiriyor olabilir. Ayrıntıları aşağıdaki rehber veya bir uzman aracılığıyla doğrulayın.",
            "tg": "Ин ҳолат метавонад вокуниши фавриро талаб кунад. Тафсилотро тавассути дастури зер ё мутахассис тасдиқ кунед.",
            "fil": "Ang sitwasyong ito ay maaaring nangangailangan ng agarang interbensyon. Patunayan ang mga detalye sa pamamagitan ng gabay sa ibaba o sa pamamagitan ng isang eksperto.",
            "ur": "اس صورتحال کو فوری مداخلت کی ضرورت ہو سکتی ہے۔ ذیل میں دی گئی گائیڈ یا کسی ماہر کے ذریعے تفصیلات کی تصدیق کریں۔",
            "th": "สถานการณ์นี้อาจต้องได้รับการดำเนินการอย่างเร่งด่วน โปรดยืนยันรายละเอียดผ่านคู่มือด้านล่างหรือปรึกษาผู้เชี่ยวชาญ",
            "ky": "Бул кырдаал шашылыш кийлигишүүнү талап кылышы мүмкүн. Толук маалыматты төмөнкү колдонмо же адис аркылуу текшериңиз.",
            "km": "ស្ថានភាពនេះអាចទាមទារឱ្យមានអន្តរាគមន៍ជាបន្ទាន់។ ផ្ទៀងផ្ទាត់ព័ត៌មានលម្អិតតាមរយៈមគ្គុទ្ទេសក៍ខាងក្រោម ឬអ្នកជំនាញ។",
            "id": "Situasi ini mungkin memerlukan tindakan segera. Verifikasi detailnya melalui panduan di bawah atau melalui seorang ahli.",
            "si": "මෙම තත්ත්වය සඳහා හදිසි මැදිහත්වීමක් අවශ්‍ය විය හැකිය. පහත මාර්ගෝපදේශය හෝ විශේෂඥයෙකු හරහා විස්තර තහවුරු කරන්න.",
            "bn": "এই পরিস্থিতিটির জন্য জরুরি হস্তক্ষেপের প্রয়োজন হতে পারে। নিচের নির্দেশিকা বা একজন বিশেষজ্ঞের মাধ্যমে বিস্তারিত যাচাই করুন।",
            "my": "ဤအခြေအနေသည် အရေးပေါ် ကိုင်တွယ်ဖြေရှင်းရန် လိုအပ်နိုင်သည်။ အောက်ပါ လမ်းညွှန် သို့မဟုတ် ကျွမ်းကျင်သူတစ်ဦးမှတစ်ဆင့် အသေးစိတ်အချက်အလက်များကို အတည်ပြုပါ။",
            "mn": "Энэ нөхцөл байдал яаралтай арга хэмжээ авахыг шаардаж магадгүй. Доорх гарын авлага эсвэл мэргэжилтнээр дамжуулан дэлгэрэнгүй мэдээллийг баталгаажуулна уу.",
            "lo": "ສະຖານະການນີ້ອາດຈະຕ້ອງການການແຊກແຊງດ່ວນ. ກະລຸນາກວດສອບລາຍລະອຽດຜ່ານຄູ່ມືຂ້າງລຸ່ມນີ້ ຫຼື ຜູ້ຊ່ຽວຊານ.",
            "tet": "Situasaun ida-ne'e bele presiza intervensaun urjente. Verifika detallu sira liuhusi gias iha kraik ka liuhusi espesialista ida.",
            "ne": "यो अवस्थालाई तत्काल हस्तक्षेप आवश्यक हुन सक्छ। तलको मार्गदर्शक वा एक विशेषज्ञ मार्फत विवरणहरू प्रमाणित गर्नुहोस्।",
            "en": "This looks like it needs immediate attention. Please confirm the details with the navigator/expert below rather than relying only on AI.",
            "zh": "这似乎是需要立即处理的事项。请通过下方的导航工具或专家进行确认，而非仅依赖AI判断。",
            "uz": "Bu masala zudlik bilan chora koʻrishni talab qilishi mumkin. Tafsilotlarni quyidagi yoʻriqnoma yoki mutaxassis yordamida aniqlashtiring.",
            "vi": "Đây có vẻ là vấn đề cần xử lý ngay. Vui lòng xác nhận với chuyên gia/công cụ điều hướng bên dưới thay vì chỉ dựa vào AI.",
        },
        "routing_target": RoutingTarget(module="module3-wage"),
    },
    "accident": {
        "keywords": ["산재", "다쳤", "부상", "사고", "कार्यस्थल दुर्घटना", "काम गर्दा घाइते", "काममा चोट",
                     "asidente servisu", "kanek iha servisu",
                     "ອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກ", "ການບາດເຈັບໃນບ່ອນເຮັດວຽກ", "ажлын ослын даатгал", "ажлын байран дахь гэмтэл", "လုပ်ငန်းခွင် မတော်တဆမှု", "လုပ်ငန်းခွင်တွင် ထိခိုက်ဒဏ်ရာရခြင်း", "কর্মক্ষেত্রে দুর্ঘটনা", "কর্মক্ষেত্রে আঘাত", "රැකියා අනතුර", "රැකියා ස්ථානයේ තුවාල", "kecelakaan kerja", "cedera di tempat kerja", "គ្រោះថ្នាក់ការងារ", "របួសនៅកន្លែងធ្វើការ", "өндүрүштүк кырсык", "жумуш ордунда жаракат алуу", "อุบัติเหตุจากการทำงาน", "การบาดเจ็บในที่ทำงาน", "کام پر حادثہ", "کام کی جگہ پر چوٹ", "aksidente sa trabaho", "pinsala sa lugar ng trabaho", "ҳодисаи нохуш дар ҷои кор", "ҷароҳат дар ҷои кор"],
        "fact_answer": {
            "ko": "업무 중 다쳤다면 산재보험으로 치료비를 처리할 수 있어요. 사업주의 공상 처리 요구는 거절할 수 있어요.",
            "tr": "İş sırasında yaralandıysanız tedavi masrafları iş kazası sigortası kapsamında karşılanabilir. İşverenin olayı özel bir anlaşmayla çözme talebini reddedebilirsiniz.",
            "tg": "Агар шумо ҳангоми кор ҷароҳат бардошта бошед, хароҷоти табобат метавонад аз ҳисоби суғуртаи садамаи меҳнатӣ пӯшонида шавад. Шумо метавонед дархости корфарморо барои ҳалли ҳодиса бо созишномаи хусусӣ рад кунед.",
            "fil": "Kung nasugatan ka sa trabaho, ang mga gastos sa paggamot ay maaaring sakop ng insurance sa aksidente sa trabaho. Maaari mong tanggihan ang kahilingan ng employer na ayusin ang insidente sa pamamagitan ng isang pribadong kasunduan.",
            "ur": "اگر آپ کام کے دوران زخمی ہوئے ہیں، تو علاج کے اخراجات کام پر حادثے کے بیمے کے تحت پورے کیے جا سکتے ہیں۔ آپ آجر کی جانب سے کسی خاص معاہدے کے ذریعے واقعے کو حل کرنے کی درخواست کو مسترد کر سکتے ہیں۔",
            "th": "หากคุณได้รับบาดเจ็บระหว่างทำงาน ค่ารักษาพยาบาลอาจได้รับการคุ้มครองภายใต้ประกันอุบัติเหตุจากการทำงาน คุณสามารถปฏิเสธคำขอของนายจ้างที่จะยุติเรื่องด้วยข้อตกลงส่วนตัวได้",
            "ky": "Жумуш учурунда жаракат алсаңыз, дарылоо чыгымдары өндүрүштүк кырсыктан камсыздандыруу аркылуу жабылышы мүмкүн. Иш берүүчүнүн окуяны жеке келишим менен чечүү талабынан баш тарта аласыз.",
            "km": "ប្រសិនបើអ្នករងរបួសក្នុងពេលធ្វើការ ថ្លៃព្យាបាលអាចត្រូវបានរ៉ាប់រងក្រោមការធានារ៉ាប់រងគ្រោះថ្នាក់ការងារ។ អ្នកអាចបដិសេធសំណើរបស់និយោជកដើម្បីដោះស្រាយឧប្បត្តិហេតុដោយកិច្ចព្រមព្រៀងឯកជន។",
            "id": "Jika Anda terluka saat bekerja, biaya pengobatan dapat ditanggung oleh asuransi kecelakaan kerja. Anda dapat menolak permintaan pengusaha untuk menyelesaikan insiden tersebut dengan kesepakatan pribadi.",
            "si": "රැකියාවේදී තුවාල සිදුවුවහොත්, ප්‍රතිකාර වියදම් රැකියා අනතුරු රක්ෂණය යටතේ ආවරණය කළ හැකිය. විශේෂ ගිවිසුමක් මගින් සිද්ධිය විසඳීමට සේවා යෝජකයාගේ ඉල්ලීම ඔබට ප්‍රතික්ෂේප කළ හැකිය.",
            "bn": "কাজের সময় আহত হলে, চিকিৎসার খরচ কর্মক্ষেত্রে দুর্ঘটনা বীমার আওতায় কভার করা যেতে পারে। আপনি নিয়োগকর্তার একটি বিশেষ চুক্তির মাধ্যমে ঘটনাটি নিষ্পত্তি করার অনুরোধ প্রত্যাখ্যান করতে পারেন।",
            "my": "အလုပ်လုပ်နေစဉ် ထိခိုက်ဒဏ်ရာရပါက ဆေးကုသစရိတ်များကို လုပ်ငန်းခွင်ထိခိုက်မှု အာမခံဖြင့် အကျုံးဝင်နိုင်သည်။ အလုပ်ရှင်၏ အထူးသဘောတူညီချက်ဖြင့် ပြဿနာကို ဖြေရှင်းရန် တောင်းဆိုမှုကို သင် ငြင်းပယ်နိုင်သည်။",
            "mn": "Хэрэв та ажил дээрээ гэмтсэн бол эмчилгээний зардлыг ажлын ослын даатгалаар нөхөн төлж болно. Ажил олгогчийн ослыг тусгай гэрээгээр шийдвэрлэх хүсэлтийг татгалзаж болно.",
            "lo": "ຖ້າທ່ານໄດ້ຮັບບາດເຈັບໃນເວລາເຮັດວຽກ, ຄ່າປິ່ນປົວອາດຈະຖືກຄຸ້ມຄອງໂດຍປະກັນໄພອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກ. ທ່ານສາມາດປະຕິເສດຄໍາຮ້ອງຂໍຂອງນາຍຈ້າງທີ່ຈະແກ້ໄຂເຫດການດ້ວຍຂໍ້ຕົກລົງສ່ວນຕົວ.",
            "tet": "Se ita kanek durante serbisu, kustu tratamentu bele kobre husi seguru asidente serbisu. Ita bele la simu empregadór nia pedidu atu rezolve kazu ne'e ho akordu privadu.",
            "ne": "यदि तपाईं कामको क्रममा घाइते हुनुभयो भने, उपचार खर्च कार्यस्थल दुर्घटना बीमा अन्तर्गत कभर हुन सक्छ। तपाईंले रोजगारदाताको घटनालाई विशेष सम्झौता मार्फत समाधान गर्ने अनुरोध अस्वीकार गर्न सक्नुहुन्छ।",
            "en": "If you were injured at work, medical costs can be covered by industrial accident insurance. You can refuse an employer's request to handle it as a private injury instead.",
            "zh": "如果在工作中受伤，可以通过工伤保险处理治疗费用。您可以拒绝雇主要求以私伤方式处理的要求。",
            "uz": "Ish vaqtida jarohat olgan boʻlsangiz, davolanish xarajatlari ishlab chiqarishdagi baxtsiz hodisalar sugʻurtasi orqali qoplanishi mumkin. Ish beruvchining hodisani xususiy tartibda hal qilish talabini rad etishingiz mumkin.",
            "vi": "Nếu bị thương trong khi làm việc, chi phí điều trị có thể được xử lý qua bảo hiểm tai nạn lao động. Bạn có thể từ chối yêu cầu của người sử dụng lao động muốn xử lý như tai nạn cá nhân.",
        },
        "risk_notice": {
            "ko": "사고 사실관계 정리가 필요해 보여요. 산재 대응 네비게이터에서 증빙을 정리해 드릴게요.",
            "tr": "Kazaya ilişkin bilgileri düzenlemek gerekiyor. İş kazası rehberi kanıtları toplamanıza yardımcı olabilir.",
            "tg": "Маълумот дар бораи садама бояд тартиб дода шавад. Дастури садамаи меҳнатӣ метавонад ба шумо дар ҷамъоварии далелҳо кӯмак расонад.",
            "fil": "Kailangan ayusin ang impormasyon tungkol sa aksidente. Ang gabay sa aksidente sa trabaho ay makakatulong sa iyo na mangolekta ng ebidensya.",
            "ur": "حادثے سے متعلق معلومات کو منظم کرنے کی ضرورت ہے۔ کام پر حادثے کی گائیڈ ثبوت جمع کرنے میں آپ کی مدد کر سکتی ہے۔",
            "th": "จำเป็นต้องจัดระเบียบข้อมูลเกี่ยวกับอุบัติเหตุ คู่มืออุบัติเหตุจากการทำงานสามารถช่วยคุณรวบรวมหลักฐานได้",
            "ky": "Кырсыкка байланыштуу маалыматты иретке келтирүү керек. Өндүрүштүк кырсык боюнча колдонмо далилдерди чогултууга жардам берет.",
            "km": "ព័ត៌មានអំពីឧប្បត្តិហេតុចាំបាច់ត្រូវរៀបចំ។ មគ្គុទ្ទេសក៍គ្រោះថ្នាក់ការងារអាចជួយអ្នកប្រមូលភស្តុតាង។",
            "id": "Informasi mengenai kecelakaan perlu diatur. Panduan kecelakaan kerja dapat membantu Anda mengumpulkan bukti.",
            "si": "අනතුර පිළිබඳ තොරතුරු සංවිධානය කිරීම අවශ්‍ය වේ. රැකියා අනතුරු මාර්ගෝපදේශය සාක්ෂි රැස් කිරීමට ඔබට උපකාරී වනු ඇත.",
            "bn": "দুর্ঘটনা সম্পর্কিত তথ্য সংগঠিত করা প্রয়োজন। কর্মক্ষেত্রে দুর্ঘটনা নির্দেশিকা আপনাকে প্রমাণ সংগ্রহ করতে সহায়তা করতে পারে।",
            "my": "မတော်တဆမှုနှင့်ပတ်သက်သည့် အချက်အလက်များကို စုစည်းရန် လိုအပ်ပါသည်။ လုပ်ငန်းခွင်ထိခိုက်မှု လမ်းညွှန်သည် သက်သေခံအထောက်အထားများ စုဆောင်းရာတွင် ကူညီပေးနိုင်သည်။",
            "mn": "Ослын талаарх мэдээллийг эмхэтгэх шаардлагатай байна. Ажлын ослын гарын авлага нь нотлох баримт цуглуулахад тусална.",
            "lo": "ຂໍ້ມູນກ່ຽວກັບອຸບັດຕິເຫດຈໍາເປັນຕ້ອງໄດ້ຈັດລະບຽບ. ຄູ່ມືອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກສາມາດຊ່ວຍທ່ານເກັບກໍາຫຼັກຖານໄດ້.",
            "tet": "Presiza organiza informasaun kona-ba asidente. Gias asidente serbisu bele ajuda ita atu halibur evidénsia.",
            "ne": "दुर्घटना सम्बन्धी जानकारी व्यवस्थित गर्न आवश्यक छ। कार्यस्थल दुर्घटना मार्गदर्शकले तपाईंलाई प्रमाणहरू सङ्कलन गर्न मद्दत गर्न सक्छ।",
            "en": "It looks like the facts of the accident need to be organized. The workplace-injury navigator can help you put together the evidence.",
            "zh": "看起来需要整理事故的事实经过。工伤应对导航工具可以帮助您整理相关证据。",
            "uz": "Hodisa tafsilotlarini tartibga solish kerak. Ishlab chiqarishdagi jarohatlar boʻyicha yoʻriqnoma dalillarni jamlashga yordam beradi.",
            "vi": "Có vẻ cần sắp xếp lại các tình tiết vụ tai nạn. Công cụ điều hướng ứng phó tai nạn lao động sẽ giúp bạn tổng hợp bằng chứng.",
        },
        "routing_target": RoutingTarget(module="module3-accident"),
    },
    "contract": {
        "keywords": ["계약서", "근로계약", "रोजगार सम्झौता", "श्रम सम्झौता", "kontratu servisu",
                     "ສັນຍາການຈ້າງງານ", "хөдөлмөрийн гэрээ", "အလုပ်သမား စာချုပ်", "কাজের চুক্তি", "රැකියා කොන්ත්‍රාත්තුව", "kontrak kerja", "កិច្ចសន្យាការងារ", "эмгек келишими", "สัญญาจ้างงาน", "ملازمت کا معاہدہ", "kontrata sa trabaho", "шартномаи корӣ"],
        "fact_answer": {
            "ko": "근로계약서에는 임금·근무시간·휴게시간 등 11개 필수 확인 항목이 있어요. 백과사전 탭의 체크리스트에서 확인할 수 있어요.",
            "tr": "İş sözleşmesinde ücret, çalışma saatleri ve dinlenme süreleri dâhil kontrol edilmesi gereken 11 temel madde bulunur. Bunları ansiklopedi sekmesindeki kontrol listesinden inceleyebilirsiniz.",
            "tg": "Шартномаи корӣ 11 банди асосиро дар бар мегирад, ки бояд тафтиш карда шавад, аз ҷумла музди меҳнат, соатҳои корӣ ва вақтҳои истироҳат. Шумо метавонед онҳоро аз рӯйхати санҷиш дар ҷадвали энсиклопедия дида бароед.",
            "fil": "Mayroong 11 pangunahing bagay na dapat suriin sa isang kontrata sa trabaho, kabilang ang sahod, oras ng trabaho, at panahon ng pahinga. Maaari mong suriin ang mga ito mula sa checklist sa tab ng encyclopedia.",
            "ur": "ملازمت کے معاہدے میں 11 بنیادی چیزیں ہیں جن کی جانچ پڑتال کی جانی چاہیے، بشمول اجرت، کام کے اوقات اور آرام کے وقفے۔ آپ انسائیکلوپیڈیا ٹیب میں چیک لسٹ سے ان کا جائزہ لے سکتے ہیں۔",
            "th": "มี 11 ประเด็นสำคัญที่ต้องตรวจสอบในสัญญาจ้างงาน รวมถึงค่าจ้าง ชั่วโมงการทำงาน และเวลาพักผ่อน คุณสามารถตรวจสอบสิ่งเหล่านี้ได้จากรายการตรวจสอบในแท็บสารานุกรม",
            "ky": "Эмгек келишиминде эмгек акы, жумуш убактысы жана эс алуу убактысы сыяктуу текшерилиши керек болгон 11 негизги пункт бар. Аларды энциклопедия бөлүмүндөгү текшерүү тизмесинен карап чыксаңыз болот.",
            "km": "កិច្ចសន្យាការងារមាន 11 ចំណុចសំខាន់ៗដែលត្រូវពិនិត្យ រួមទាំងប្រាក់ឈ្នួល ម៉ោងធ្វើការ និងម៉ោងសម្រាក។ អ្នកអាចពិនិត្យមើលចំណុចទាំងនេះពីបញ្ជីត្រួតពិនិត្យនៅក្នុងផ្ទាំងសព្វវចនាធិប្បាយ។",
            "id": "Ada 11 poin penting yang perlu diperiksa dalam kontrak kerja, termasuk upah, jam kerja, dan waktu istirahat. Anda dapat memeriksanya dari daftar periksa di tab ensiklopedia.",
            "si": "රැකියා කොන්ත්‍රාත්තුවේ වැටුප්, වැඩ කරන වේලාවන් සහ විවේක කාලය ඇතුළුව පරීක්ෂා කළ යුතු මූලික කරුණු 11 ක් ඇත. ඔබට ඒවා විශ්වකෝෂ ටැබයේ ඇති පිරික්සුම් ලැයිස්තුවෙන් පරීක්ෂා කළ හැකිය.",
            "bn": "কর্মসংস্থান চুক্তিতে মজুরি, কাজের সময় এবং বিশ্রামের সময় সহ 11টি মূল বিষয় পরীক্ষা করা প্রয়োজন। আপনি এনসাইক্লোপিডিয়া ট্যাবের চেকলিস্ট থেকে এগুলি পর্যালোচনা করতে পারেন।",
            "my": "အလုပ်သမားစာချုပ်တွင် လုပ်ခလစာ၊ အလုပ်ချိန်နှင့် အနားယူချိန်များ အပါအဝင် စစ်ဆေးရမည့် အဓိကအချက် 11 ချက် ပါဝင်သည်။ ၎င်းတို့ကို စွယ်စုံကျမ်းကဏ္ဍရှိ စစ်ဆေးရမည့်စာရင်းမှတစ်ဆင့် စစ်ဆေးနိုင်သည်။",
            "mn": "Хөдөлмөрийн гэрээнд цалин, ажлын цаг, амралтын цаг зэрэг шалгах ёстой 11 үндсэн зүйл байдаг. Та эдгээрийг нэвтэрхий толь хэсгийн шалгах хуудаснаас үзэж болно.",
            "lo": "ມີ 11 ລາຍການຫຼັກທີ່ຕ້ອງກວດສອບໃນສັນຍາການຈ້າງງານ, ລວມທັງຄ່າຈ້າງ, ຊົ່ວໂມງເຮັດວຽກ ແລະ ເວລາພັກຜ່ອນ. ທ່ານສາມາດກວດເບິ່ງສິ່ງເຫຼົ່ານີ້ໄດ້ຈາກລາຍການກວດສອບໃນແຖບສານຸກົມ.",
            "tet": "Iha artigu fundamentál 11 ne'ebé presiza verifika iha kontratu serbisu, inklui saláriu, oras serbisu no tempu deskansa. Ita bele haree ida-ne'e husi lista verifikasaun iha tab ensiklopédia.",
            "ne": "रोजगार सम्झौतामा ज्याला, काम गर्ने घण्टा र आरामको समय सहित 11 वटा मुख्य बुँदाहरू जाँच गर्नुपर्छ। तपाईंले यी कुराहरू इन्साइक्लोपीडिया ट्याबमा रहेको चेकलिस्टबाट हेर्न सक्नुहुन्छ।",
            "en": "An employment contract has 11 required items to check, including wages, working hours, and break time. You can review them in the checklist under the Encyclopedia tab.",
            "zh": "劳动合同中有工资、工作时间、休息时间等11项必须确认的内容。您可以在百科全书标签的检查清单中查看。",
            "uz": "Mehnat shartnomasida ish haqi, ish vaqti va tanaffus kabi tekshirilishi kerak boʻlgan 11 ta asosiy band bor. Ularni ensiklopediya boʻlimidagi tekshiruv roʻyxatidan koʻrishingiz mumkin.",
            "vi": "Hợp đồng lao động có 11 mục bắt buộc cần kiểm tra như lương, giờ làm việc, giờ nghỉ. Bạn có thể xem trong danh sách kiểm tra ở tab Bách khoa toàn thư.",
        },
        "risk_notice": None,
        "routing_target": RoutingTarget(module="module1", category_id="contract_check"),
    },
    "life_info": {
        "keywords": ["한국 생활", "생활 정보", "외국인등록", "체류", "비자", "건강보험",
                     "교통카드", "쓰레기", "한국어 교육", "은행 계좌",
                     "life in korea", "visa", "韩国生活", "cuộc sống ở hàn quốc", "koreyada yashash",
                     "भिसा", "कोरियामा जीवन", "बैंक खाता", "स्वास्थ्य बीमा",
                     "vida iha korea", "viza", "konta banku", "seguru saúde",
                     "ບັນຊີທະນາຄານ", "ວີຊາ", "ປະກັນສຸຂະພາບ", "ຊີວິດໃນເກົາຫຼີ", "банкны данс", "виз", "эрүүл мэндийн даатгал", "солонгос дахь амьдрал", "ဘဏ်အကောင့်", "ဗီဇာ", "ကျန်းမာရေး အာမခံ", "ကိုရီးယားနိုင်ငံတွင် နေထိုင်ခြင်း", "ব্যাংক অ্যাকাউন্ট", "ভিসা", "স্বাস্থ্য বীমা", "কোরিয়ান জীবন", "බැංකු ගිණුම", "වීසා", "සෞඛ්‍ය රක්ෂණය", "කොරියානු ජීවිතය", "rekening bank", "visa", "asuransi kesehatan", "kehidupan di korea", "គណនីធនាគារ", "ទិដ្ឋាការ", "ការធានារ៉ាប់រងសុខភាព", "ជីវិតនៅកូរ៉េ", "банк эсеби", "виза", "медициналык камсыздандыруу", "кореядагы жашоо", "บัญชีธนาคาร", "วีซ่า", "ประกันสุขภาพ", "ชีวิตในเกาหลี", "بینک اکاؤنٹ", "ویزا", "صحت کا بیمہ", "کوریائی زندگی", "bank account", "seguro sa kalusugan", "buhay sa korea", "ҳисоби бонкӣ", "раводид", "суғуртаи тиббӣ", "ҳаёти корея"],
        "fact_answer": {
            "ko": "한국 생활 정보를 안내해 드릴 수 있어요. 지금은 자세한 정보를 확인하기 어려우니 잠시 후 궁금한 주제와 상황을 알려주세요.",
            "tr": "Kore'de yaşam hakkında bilgi verebilirim. Şu anda ayrıntıları doğrulayamıyorum; lütfen biraz sonra merak ettiğiniz konuyu ve durumunuzu belirtin.",
            "tg": "Ман метавонам дар бораи зиндагӣ дар Корея маълумот диҳам. Дар айни замон ман наметавонам тафсилотро тасдиқ кунам; лутфан баъдтар мавзӯи таваҷҷӯҳи худро ва вазъияти худро нишон диҳед.",
            "fil": "Maaari akong magbigay ng impormasyon tungkol sa pamumuhay sa Korea. Sa kasalukuyan, hindi ko mapatunayan ang mga detalye; mangyaring tukuyin ang paksa na kinagigiliwan mo at ang iyong sitwasyon sa ibang pagkakataon.",
            "ur": "میں کوریا میں زندگی کے بارے میں معلومات فراہم کر سکتا ہوں۔ میں فی الحال تفصیلات کی تصدیق نہیں کر سکتا؛ براہ کرم تھوڑی دیر بعد اس موضوع اور اپنی صورتحال کی وضاحت کریں جس کے بارے میں آپ جاننا چاہتے ہیں۔",
            "th": "ฉันสามารถให้ข้อมูลเกี่ยวกับการใช้ชีวิตในเกาหลีได้ ขณะนี้ฉันไม่สามารถยืนยันรายละเอียดได้ โปรดระบุหัวข้อที่คุณสงสัยและสถานการณ์ของคุณในภายหลัง",
            "ky": "Мен Кореядагы жашоо жөнүндө маалымат бере алам. Учурда толук маалыматты ырастай албайм; сураныч, бир аздан кийин кызыккан темаңызды жана абалыңызды көрсөтүңүз.",
            "km": "ខ្ញុំអាចផ្តល់ព័ត៌មានអំពីជីវិតនៅកូរ៉េ។ បច្ចុប្បន្ន ខ្ញុំមិនអាចផ្ទៀងផ្ទាត់ព័ត៌មានលម្អិតបានទេ; សូមបញ្ជាក់ប្រធានបទដែលអ្នកចង់ដឹង និងស្ថានភាពរបស់អ្នកបន្តិចទៀត។",
            "id": "Saya dapat memberikan informasi tentang kehidupan di Korea. Saat ini saya tidak dapat memverifikasi detailnya; mohon sebutkan topik yang Anda minati dan situasi Anda sebentar lagi.",
            "si": "මට කොරියාවේ ජීවිතය ගැන තොරතුරු ලබා දිය හැකිය. මට දැනට විස්තර තහවුරු කළ නොහැක; කරුණාකර ටික වේලාවකට පසු ඔබට කුතුහලයක් ඇති මාතෘකාව සහ ඔබේ තත්ත්වය සඳහන් කරන්න.",
            "bn": "আমি কোরিয়ায় জীবনযাপন সম্পর্কে তথ্য দিতে পারি। আমি বর্তমানে বিস্তারিত যাচাই করতে পারছি না; অনুগ্রহ করে কিছুক্ষণ পরে আপনি যে বিষয়ে আগ্রহী এবং আপনার পরিস্থিতি উল্লেখ করুন।",
            "my": "ကိုရီးယားတွင် နေထိုင်ခြင်းနှင့်ပတ်သက်သည့် အချက်အလက်များကို ကျွန်ုပ် ပေးနိုင်ပါသည်။ လက်ရှိတွင် အသေးစိတ်အချက်အလက်များကို အတည်မပြုနိုင်ပါ။ ခဏအကြာတွင် သင်သိလိုသည့် အကြောင်းအရာနှင့် သင်၏ အခြေအနေကို ဖော်ပြပါ။",
            "mn": "Би Солонгост амьдрах тухай мэдээлэл өгч чадна. Би одоогоор дэлгэрэнгүй мэдээллийг баталгаажуулах боломжгүй байна; та хэсэг хугацааны дараа сонирхож буй сэдэв болон нөхцөл байдлаа зааж өгнө үү.",
            "lo": "ຂ້ອຍສາມາດໃຫ້ຂໍ້ມູນກ່ຽວກັບການດໍາລົງຊີວິດຢູ່ໃນເກົາຫຼີ. ຂ້ອຍບໍ່ສາມາດຢືນຢັນລາຍລະອຽດໄດ້ໃນຕອນນີ້; ກະລຸນາລະບຸຫົວຂໍ້ທີ່ທ່ານສົນໃຈ ແລະ ສະຖານະການຂອງທ່ານໃນພາຍຫຼັງ.",
            "tet": "Ha'u bele fó informasaun kona-ba moris iha Koreia. Agora daudaun, ha'u la bele verifika detallu sira; favor ida, depois fó sai tópiku ne'ebé ita hakarak hatene no ita-nia situasaun.",
            "ne": "म कोरियामा जीवनको बारेमा जानकारी दिन सक्छु। म हाल विवरणहरू प्रमाणित गर्न सक्दिनँ; कृपया केही समयपछि तपाईंलाई चासो भएको विषय र तपाईंको अवस्था बताउनुहोस्।",
            "en": "I can help with information about life in Korea. I can't verify the details right now; please try again shortly with your topic and situation.",
            "zh": "我可以提供韩国生活信息。目前暂时无法核实详细信息，请稍后告知您关心的主题和具体情况。",
            "vi": "Tôi có thể cung cấp thông tin về cuộc sống ở Hàn Quốc. Hiện chưa thể xác minh chi tiết; vui lòng thử lại sau và cho biết chủ đề, hoàn cảnh của bạn.",
            "uz": "Koreyadagi hayot haqida maʼlumot berishga yordam bera olaman. Hozir tafsilotlarni tekshira olmayapman; birozdan keyin mavzu va vaziyatingizni ayting.",
        },
        "risk_notice": None,
        "routing_target": None,
    },
    "meta": {
        # 노동 상담 소재는 아니지만 서비스가 직접 답해도 되는 것("너는 누구니?" 등).
        # genai 미설정 시엔 키워드로만 대충 잡는다 — 정교함보다는 완전히 놓치지
        # 않는 게 목적이라 최소한만 넣는다.
        "keywords": ["너는 누구", "당신은 누구", "뭐하는 곳", "뭐 하는 곳", "사용법", "안녕하세요", "안녕",
                     "नमस्ते", "तपाईं को", "कसरी प्रयोग", "bondia", "botardi", "ita mak sé", "oinsá uza",
                     "ສະບາຍດີ", "ທ່ານແມ່ນໃຜ", "сайн байна уу", "та хэн бэ", "မင်္ဂလာပါ", "ခင်ဗျား ဘယ်သူလဲ", "হ্যালো", "আপনি কে", "ආයුබෝවන්", "ඔබ කවුද?", "halo", "siapa anda", "ជំរាបសួរ", "អ្នកជានរណា", "саламатсызбы", "сиз кимсиз?", "สวัสดี", "คุณคือใคร", "ہیلو", "آپ کون ہیں", "magandang araw po", "sino po kayo", "салом", "шумо кистед?"],
        "fact_answer": _META_FALLBACK_ANSWER,
        "risk_notice": None,
        "routing_target": None,
    },
    "off_topic": {
        # 노동 상담과 무관해 정중히 거절해야 하는 것("돈 버는 어플리케이션 설계해줘" 등).
        # 키워드 폴백에서 아무 것도 안 걸리면 여기로 떨어지는 기본값이기도 하다.
        "keywords": [],
        "fact_answer": _OFF_TOPIC_ANSWER,
        "risk_notice": None,
        "routing_target": None,
    },
}

_SYSTEM_INSTRUCTION = (
    """당신은 외국인·이주노동자·유학생을 위한 Local Bridge 서비스의 질문 분류기입니다.
    노동 상담뿐 아니라 한국에서의 생활 정보 제공과 관련 기관 찾기도 서비스 범위입니다.
    [이전 대화]가 주어지면 맥락으로 참고하고, [분류할 메시지](없으면 입력 전체)를
    사용 언어와 관계없이 아래 일곱 가지 중 하나로 분류하세요.

    - wage: 임금·급여 미지급, 체불 관련
    - accident: 업무 중 발생한 산업재해·사고·부상 관련
    - contract: 근로계약서 관련
    - life_info: 외국인의 한국 생활·정착에 필요한 정보나 절차 문의.
      체류·비자·외국인등록, 의료·건강보험, 주거·임대차, 교통, 은행·통신,
      교육·한국어 학습, 공공서비스, 문화·생활 규칙 등을 포함합니다.
      예: "한국에서 은행 계좌를 어떻게 만들어요?", "쓰레기는 어떻게 버려요?",
      "외국인도 건강보험에 가입할 수 있나요?", "한국 생활 정보를 알려줘".
    - org_search: 도움받을 기관·센터·상담소·관공서·의료기관 등을 찾아달라는 요청,
      기관의 위치·연락처·이용시간·지원 서비스·방문 방법 문의.
      노동 문제와 직접 관련이 없어도 포함합니다.
      예: "가까운 외국인 지원센터 찾아줘", "한국어를 배울 수 있는 기관이 어디야?",
      "임금체불 상담받을 곳 알려줘", "그 센터 전화번호가 뭐야?".
    - meta: 이 서비스/AI 자체에 대한 질문이나 인사(예: "너는 누구니?",
      "뭘 도와줄 수 있어?", "안녕", "사용법 알려줘") — 노동 상담 소재는 아니지만
      서비스가 직접 답해도 되는 것
    - off_topic: 노동 상담·한국 생활 정보·기관 안내·서비스 이용과 무관한 요청
      (예: "돈 버는 어플리케이션 설계해줘", "판타지 소설 써줘" 등).
      노동 관련 단어가 없다는 이유만으로 한국 생활 정보나 기관 문의를 제외하지 마세요.

    여러 항목에 걸치면 지금 사용자가 원하는 행동을 기준으로 하나를 고르세요.
    기관을 찾아달라거나 연락처·위치를 묻는 것이 핵심이면 org_search를 우선합니다.
    임금·산재·근로계약 자체의 권리·대응 절차 문의는 각각 wage/accident/contract이며,
    그 밖의 한국 생활 정보·절차 문의는 life_info입니다.

    [이전 대화]의 흐름상 지금 메시지가 노동 상담·한국 생활 정보·기관 안내의 자연스러운
    후속 질문(예: "그럼 저는 어떻게 해야 하나요?", "얼마나 받을 수 있어요?")이면
    그 맥락에 맞는 카테고리로 분류하세요 — 메시지 자체에 키워드가 없다고 무조건
    off_topic으로 분류하지 마세요.
    생활 절차 안내 뒤 "준비물은?"은 life_info, 기관 추천 뒤
    "거기는 토요일에도 열어?"는 org_search로 분류하세요.

    분류값 외에 설명·조언·새로운 문장을 절대 만들지 마세요.
    """
)


def _format_history_for_prompt(history: List[ChatTurn], *, limit: int = 6) -> str:
    if not history:
        return ""
    lines = [
        f"{'사용자' if turn.role == 'user' else '상담사'}: {turn.text}"
        for turn in history[-limit:]
    ]
    return "\n".join(lines)


def _classify_with_genai(message: str, history: List[ChatTurn]) -> Optional[Intent]:
    client = get_genai_client()
    if client is None:
        return None
    history_block = _format_history_for_prompt(history)
    contents = (
        f"[이전 대화]\n{history_block}\n\n[분류할 메시지]\n{message}"
        if history_block
        else message
    )
    try:
        response = client.models.generate_content(
            model=get_model_name(),
            contents=contents,
            config=types.GenerateContentConfig(
                http_options=types.HttpOptions(timeout=15000, retry_options=types.HttpRetryOptions(attempts=1)),
                system_instruction=_SYSTEM_INSTRUCTION,
                response_mime_type="application/json",
                response_schema=IntentClassification,
                temperature=0,
            ),
        )
        parsed = response.parsed
        if not isinstance(parsed, IntentClassification):
            return None
        return parsed.intent
    except Exception as exc:
        log_exception_summary(logger, "genai 의도 분류 실패 — 키워드 규칙으로 폴백합니다.", exc)
        logger.exception("genai 의도 분류 실패 전체 트레이스백")
        return None


def _classify_with_keywords(message: str) -> Intent:
    for intent, content in _CONTENT.items():
        if intent == "off_topic":
            continue
        if any(keyword.casefold() in message.casefold() for keyword in content["keywords"]):
            return intent
    return "off_topic"


async def answer(request: ChatRequest, uid: Optional[str] = None) -> ChatResponse:
    import asyncio

    intent = (
        await asyncio.to_thread(_classify_with_genai, request.message, request.history)
        or _classify_with_keywords(request.message)
    )
    content = _CONTENT[intent]
    language: Language = request.language

    fact_answer = _pick(content["fact_answer"], language)
    # risk_notice/routing_target은 예전엔 intent만 보고 무조건 채웠다 — 그러면
    # 가벼운 질문에도 매번 경고문구·네비게이터 버튼이 떴다. 이제는 에이전트가
    # flag_urgent_action 도구로 "지금 안내가 필요한 상황인지" 직접 판단한
    # 경우에만 채운다(urgent).
    risk_notice: Optional[str] = None
    routing_target: Optional[RoutingTarget] = None
    orgs = await asyncio.to_thread(_fallback_orgs, request, intent, limit=2)

    if intent in _AGENT_INTENTS:
        try:
            agent_result = await run_agent(
                message=request.message,
                uid=uid,
                visa_group=request.visa_group,
                lifecycle_stage=request.lifecycle_stage,
                history=request.history,
                language=language,
                latitude=request.latitude,
                longitude=request.longitude,
            )
            fact_answer = agent_result.text
            if agent_result.urgent:
                risk_notice = _pick(content["risk_notice"], language)
                routing_target = content["routing_target"]
            if agent_result.orgs:
                orgs = agent_result.orgs[:2]
        except Exception as exc:
            log_exception_summary(logger, "에이전트 응답 생성 실패 — 사전 검수 문구로 폴백합니다.", exc)
            logger.exception("에이전트 응답 생성 실패 전체 트레이스백")
            fact_answer = _pick(content["fact_answer"], language)
            # 에이전트가 아예 실패하면 "지금 안내가 필요한 상황인지" 판단을
            # 대신해줄 수 없으니, wage/accident/contract는 예전처럼 intent 기반
            # 고정 안내로 안전하게 폴백한다(과소 안내보다는 과다 안내가 낫다).
            # 생활 정보·기관 찾기·meta에는 노동 문제용 경고·라우팅을 붙이지 않는다.
            if intent in {"wage", "accident", "contract"}:
                risk_notice = _pick(content["risk_notice"], language)
                routing_target = content["routing_target"]
                orgs = await asyncio.to_thread(_fallback_orgs, request, intent, limit=2)

    response = ChatResponse(
        fact_answer=fact_answer,
        risk_notice=risk_notice,
        routing_target=routing_target,
        recommended_orgs=orgs,
    )

    if uid:
        await asyncio.to_thread(history_service.save_turn, uid, request.message, fact_answer)

    return response
