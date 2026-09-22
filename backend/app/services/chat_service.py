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


Language = Literal["ko", "en", "zh", "vi", "uz", "tr"]

# 프론트엔드(AppLanguage)와 동일한 6개 언어. 에이전트 호출이 실패했을 때 나가는
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
    "ko": "저는 외국인·이주노동자·유학생을 위한 AI 도우미예요. 노동 상담, 한국 생활 정보, 도움받을 기관 찾기 등 궁금한 점을 편하게 물어보세요.",
    "en": "I'm an AI assistant for foreign residents, migrant workers, and international students. Ask me about labor issues, life in Korea, or finding support organizations.",
    "zh": "我是为外籍居民、外籍劳动者和留学生提供帮助的AI助手。欢迎咨询劳动问题、韩国生活信息或查找相关机构。",
    "uz": "Men chet elliklar, mehnat muhojirlari va chet ellik talabalar uchun AI yordamchisiman. Mehnat masalalari, Koreyadagi hayot yoki yordam tashkilotlarini topish haqida soʻrang.",
    "vi": "Tôi là trợ lý AI dành cho người nước ngoài, lao động nhập cư và du học sinh. Bạn có thể hỏi về lao động, cuộc sống ở Hàn Quốc hoặc tìm cơ quan hỗ trợ.",
}
_OFF_TOPIC_ANSWER: _L = {
    "tr": "Bu hizmet yabancılara çalışma hayatı, Kore'de yaşam ve ilgili kuruluşları bulma konusunda yardımcı olur. İsteğiniz yardımcı olabileceğim kapsamın dışındadır.",
    "ko": "이 서비스는 외국인의 노동 상담, 한국 생활 정보, 관련 기관 찾기를 도와드려요. 요청하신 내용은 안내 범위를 벗어나 도움드리기 어려워요.",
    "en": "This service helps foreign residents with labor issues, life in Korea, and finding relevant organizations. Your request is outside the scope I can help with.",
    "zh": "本服务帮助外籍居民咨询劳动问题、了解韩国生活信息及查找相关机构。您的请求超出了我能提供帮助的范围。",
    "uz": "Bu xizmat chet elliklarga mehnat masalalari, Koreyadagi hayot va tegishli tashkilotlarni topishda yordam beradi. Soʻrovingiz yordam bera oladigan doiramdan tashqarida.",
    "vi": "Dịch vụ này hỗ trợ người nước ngoài về lao động, cuộc sống ở Hàn Quốc và tìm cơ quan phù hợp. Yêu cầu của bạn nằm ngoài phạm vi tôi có thể hỗ trợ.",
}

_CONTENT: Dict[Intent, _ContentEntry] = {
    "org_search": {
        "keywords": ["기관", "센터", "문의처", "상담소", "출입국사무소",
                     "support center", "support centre", "咨询中心", "trung tâm hỗ trợ", "yordam markazi"],
        "fact_answer": {
            "ko": "지금은 기관 정보를 확인하기 어려워요. 잠시 후 필요한 도움과 지역을 함께 알려주시면 관련 기관을 찾아드릴게요.",
            "tr": "Şu anda kuruluş bilgilerini doğrulayamıyorum. Biraz sonra ihtiyacınız olan desteği ve bulunduğunuz bölgeyi belirtirseniz uygun kuruluşları bulmanıza yardımcı olabilirim.",
            "en": "I can't check organization details right now. Please try again shortly with the help you need and your area so I can look for a suitable organization.",
            "zh": "暂时无法确认机构信息。请稍后告知您需要的帮助和所在地区，我会帮您查找相关机构。",
            "vi": "Hiện tôi chưa thể kiểm tra thông tin cơ quan. Vui lòng thử lại sau và cho biết bạn cần hỗ trợ gì, ở khu vực nào để tôi tìm cơ quan phù hợp.",
            "uz": "Hozir tashkilot maʼlumotlarini tekshira olmayapman. Birozdan keyin qanday yordam kerakligini va hududingizni ayting, mos tashkilotni topishga yordam beraman.",
        },
        "risk_notice": None,
        "routing_target": None,
    },
    "wage": {
        "keywords": ["임금", "체불", "월급", "급여"],
        "fact_answer": {
            "ko": "근로기준법상 사용자는 퇴직·지급일로부터 14일 이내에 임금을 지급해야 해요. 이미 기간이 지났다면 진정 제기가 가능해요.",
            "tr": "İş Standartları Kanunu uyarınca işverenler, işten ayrılma veya ödeme tarihinden itibaren 14 gün içinde ücretleri ödemelidir. Bu süre geçtiyse şikâyette bulunabilirsiniz.",
            "en": "Under the Labor Standards Act, employers must pay wages within 14 days of resignation or the payment date. If that period has already passed, you can file a complaint.",
            "zh": "根据《劳动基准法》，雇主须在离职或发薪日起14天内支付工资。如果已超过该期限，您可以提出申诉。",
            "uz": "Mehnat standartlari toʻgʻrisidagi qonunga koʻra, ish beruvchi ishdan ketish yoki toʻlov kunidan boshlab 14 kun ichida ish haqini toʻlashi kerak. Ushbu muddat oʻtgan boʻlsa, shikoyat berishingiz mumkin.",
            "vi": "Theo Luật Tiêu chuẩn Lao động, người sử dụng lao động phải trả lương trong vòng 14 ngày kể từ ngày nghỉ việc hoặc ngày trả lương. Nếu đã quá thời hạn, bạn có thể nộp đơn khiếu nại.",
        },
        "risk_notice": {
            "ko": "즉시 대응이 필요한 사안으로 보여요. 정확한 판단은 AI가 아닌 아래 네비게이터·전문가를 통해 확인해 주세요.",
            "tr": "Bu durum acil müdahale gerektiriyor olabilir. Ayrıntıları aşağıdaki rehber veya bir uzman aracılığıyla doğrulayın.",
            "en": "This looks like it needs immediate attention. Please confirm the details with the navigator/expert below rather than relying only on AI.",
            "zh": "这似乎是需要立即处理的事项。请通过下方的导航工具或专家进行确认，而非仅依赖AI判断。",
            "uz": "Bu masala zudlik bilan chora koʻrishni talab qilishi mumkin. Tafsilotlarni quyidagi yoʻriqnoma yoki mutaxassis yordamida aniqlashtiring.",
            "vi": "Đây có vẻ là vấn đề cần xử lý ngay. Vui lòng xác nhận với chuyên gia/công cụ điều hướng bên dưới thay vì chỉ dựa vào AI.",
        },
        "routing_target": RoutingTarget(module="module3-wage"),
    },
    "accident": {
        "keywords": ["산재", "다쳤", "부상", "사고"],
        "fact_answer": {
            "ko": "업무 중 다쳤다면 산재보험으로 치료비를 처리할 수 있어요. 사업주의 공상 처리 요구는 거절할 수 있어요.",
            "tr": "İş sırasında yaralandıysanız tedavi masrafları iş kazası sigortası kapsamında karşılanabilir. İşverenin olayı özel bir anlaşmayla çözme talebini reddedebilirsiniz.",
            "en": "If you were injured at work, medical costs can be covered by industrial accident insurance. You can refuse an employer's request to handle it as a private injury instead.",
            "zh": "如果在工作中受伤，可以通过工伤保险处理治疗费用。您可以拒绝雇主要求以私伤方式处理的要求。",
            "uz": "Ish vaqtida jarohat olgan boʻlsangiz, davolanish xarajatlari ishlab chiqarishdagi baxtsiz hodisalar sugʻurtasi orqali qoplanishi mumkin. Ish beruvchining hodisani xususiy tartibda hal qilish talabini rad etishingiz mumkin.",
            "vi": "Nếu bị thương trong khi làm việc, chi phí điều trị có thể được xử lý qua bảo hiểm tai nạn lao động. Bạn có thể từ chối yêu cầu của người sử dụng lao động muốn xử lý như tai nạn cá nhân.",
        },
        "risk_notice": {
            "ko": "사고 사실관계 정리가 필요해 보여요. 산재 대응 네비게이터에서 증빙을 정리해 드릴게요.",
            "tr": "Kazaya ilişkin bilgileri düzenlemek gerekiyor. İş kazası rehberi kanıtları toplamanıza yardımcı olabilir.",
            "en": "It looks like the facts of the accident need to be organized. The workplace-injury navigator can help you put together the evidence.",
            "zh": "看起来需要整理事故的事实经过。工伤应对导航工具可以帮助您整理相关证据。",
            "uz": "Hodisa tafsilotlarini tartibga solish kerak. Ishlab chiqarishdagi jarohatlar boʻyicha yoʻriqnoma dalillarni jamlashga yordam beradi.",
            "vi": "Có vẻ cần sắp xếp lại các tình tiết vụ tai nạn. Công cụ điều hướng ứng phó tai nạn lao động sẽ giúp bạn tổng hợp bằng chứng.",
        },
        "routing_target": RoutingTarget(module="module3-accident"),
    },
    "contract": {
        "keywords": ["계약서", "근로계약"],
        "fact_answer": {
            "ko": "근로계약서에는 임금·근무시간·휴게시간 등 11개 필수 확인 항목이 있어요. 백과사전 탭의 체크리스트에서 확인할 수 있어요.",
            "tr": "İş sözleşmesinde ücret, çalışma saatleri ve dinlenme süreleri dâhil kontrol edilmesi gereken 11 temel madde bulunur. Bunları ansiklopedi sekmesindeki kontrol listesinden inceleyebilirsiniz.",
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
                     "life in korea", "visa", "韩国生活", "cuộc sống ở hàn quốc", "koreyada yashash"],
        "fact_answer": {
            "ko": "한국 생활 정보를 안내해 드릴 수 있어요. 지금은 자세한 정보를 확인하기 어려우니 잠시 후 궁금한 주제와 상황을 알려주세요.",
            "tr": "Kore'de yaşam hakkında bilgi verebilirim. Şu anda ayrıntıları doğrulayamıyorum; lütfen biraz sonra merak ettiğiniz konuyu ve durumunuzu belirtin.",
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
        "keywords": ["너는 누구", "당신은 누구", "뭐하는 곳", "뭐 하는 곳", "사용법", "안녕하세요", "안녕"],
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
