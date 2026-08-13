import '../../../core/app_language.dart';
import 'category_detail.dart';

const Map<int, CategoryDetail> categoryDetailDataB = {
  5: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '다국어 진료 병원 찾기',
          en: 'Finding Hospitals with Multilingual Services',
          zh: '查找提供多语言诊疗的医院',
          vi: 'Tìm bệnh viện khám chữa bệnh đa ngôn ngữ',
        ),
        summary: L10nText(
          ko: '응급의료포털(E-Gen)에서 가까운 병원의 위치와 진료 시간을 확인한 뒤, 외국어 진료 가능 여부는 전화로 먼저 문의하는 것이 안전합니다.',
          en: 'Check the location and hours of nearby hospitals on the Emergency Medical Information Portal (E-Gen), then call ahead to confirm whether foreign-language services are available.',
          zh: '请先在急诊医疗信息门户(E-Gen)查询附近医院的位置和诊疗时间，再打电话确认是否提供外语诊疗服务，这样比较安全。',
          vi: 'Hãy kiểm tra vị trí và giờ khám của bệnh viện gần nhất trên Cổng thông tin y tế cấp cứu (E-Gen), sau đó gọi điện trước để hỏi xem có hỗ trợ khám bằng ngoại ngữ hay không cho an toàn.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '응급의료포털(E-Gen) 활용',
              en: 'Using the Emergency Medical Information Portal (E-Gen)',
              zh: '善用急诊医疗信息门户(E-Gen)',
              vi: 'Sử dụng Cổng thông tin y tế cấp cứu (E-Gen)',
            ),
            bullets: [
              L10nText(
                ko: '홈페이지·앱(e-gen.or.kr)에서 병원·약국 위치, 진료시간, 연락처 확인',
                en: 'Check hospital/pharmacy locations, hours, and contact numbers on the website or app (e-gen.or.kr)',
                zh: '可在网站或应用程序(e-gen.or.kr)上查询医院、药店的位置、诊疗时间和联系电话',
                vi: 'Kiểm tra vị trí, giờ khám và số liên hệ của bệnh viện, hiệu thuốc trên trang web hoặc ứng dụng (e-gen.or.kr)',
              ),
              L10nText(
                ko: '명절·공휴일에는 "문 여는 병의원" 별도 안내 제공',
                en: 'During holidays, a separate list of "hospitals and clinics open today" is provided',
                zh: '节假日期间提供单独的"营业医院·诊所"信息',
                vi: 'Vào dịp lễ, tết có cung cấp thông tin riêng về "bệnh viện, phòng khám đang mở cửa"',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '외국인 진료에 특화된 병원',
              en: 'Hospitals Specialized in Treating Foreigners',
              zh: '专门为外国人诊疗的医院',
              vi: 'Bệnh viện chuyên khám chữa bệnh cho người nước ngoài',
            ),
            bullets: [
              L10nText(
                ko: '대형병원 국제진료센터(서울대병원, 세브란스병원, 서울아산병원 등)에 외국어 전담 코디네이터 배치',
                en: 'International clinics at major hospitals (Seoul National University Hospital, Severance Hospital, Asan Medical Center, etc.) have dedicated foreign-language coordinators',
                zh: '大型医院的国际诊疗中心（首尔大学医院、世福兰斯医院、首尔峨山医院等）配有专门的外语协调员',
                vi: 'Trung tâm khám chữa bệnh quốc tế tại các bệnh viện lớn (Bệnh viện Đại học Quốc gia Seoul, Bệnh viện Severance, Trung tâm Y tế Asan, v.v.) có điều phối viên ngoại ngữ chuyên trách',
              ),
              L10nText(
                ko: '지역 보건소에서도 외국인 진료 협력병원을 안내받을 수 있습니다.',
                en: 'Local public health centers can also provide information on partner hospitals for treating foreigners.',
                zh: '当地保健所也可以为您提供合作诊疗外国人的医院信息。',
                vi: 'Trung tâm y tế công cộng tại địa phương cũng có thể hướng dẫn bạn về các bệnh viện hợp tác khám chữa bệnh cho người nước ngoài.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '외국인 진료협력병원 지정제도',
              en: 'Designated Partner Hospital System for Foreigners',
              zh: '外国人诊疗合作医院指定制度',
              vi: 'Chế độ chỉ định bệnh viện hợp tác khám chữa bệnh cho người nước ngoài',
            ),
            bullets: [
              L10nText(
                ko: '보건복지부·지자체가 지정한 외국인 진료협력병원은 다국어 안내와 통역 연계가 상대적으로 원활합니다.',
                en: 'Partner hospitals designated by the Ministry of Health and Welfare or local governments tend to offer smoother multilingual guidance and interpretation services.',
                zh: '由保健福祉部及地方政府指定的外国人诊疗合作医院，通常能提供较为顺畅的多语言指引和口译对接服务。',
                vi: 'Các bệnh viện hợp tác khám chữa bệnh cho người nước ngoài do Bộ Y tế và Phúc lợi hoặc chính quyền địa phương chỉ định thường có hướng dẫn đa ngôn ngữ và kết nối phiên dịch thuận tiện hơn.',
              ),
              L10nText(
                ko: '관할 보건소에 문의하면 인근 협력병원을 안내받을 수 있습니다.',
                en: 'Contact your local public health center to be directed to a nearby partner hospital.',
                zh: '咨询所属保健所即可获知附近的合作医院信息。',
                vi: 'Liên hệ trung tâm y tế công cộng quản lý khu vực của bạn để được hướng dẫn về bệnh viện hợp tác gần đó.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '첫 방문 전 준비',
              en: 'Preparing for Your First Visit',
              zh: '首次就诊前的准备事项',
              vi: 'Chuẩn bị trước khi khám lần đầu',
            ),
            bullets: [
              L10nText(
                ko: '외국인등록증과 건강보험 여부를 미리 확인하고, 가능하면 증상을 메모해 가면 소통이 수월합니다.',
                en: 'Check your Alien Registration Card (ARC) and health insurance status in advance, and if possible, write down your symptoms beforehand to make communication easier.',
                zh: '请提前确认好您的外国人登录证和健康保险参保情况，如果可以，最好将症状写下来带去，这样沟通会更顺畅。',
                vi: 'Hãy kiểm tra trước Thẻ đăng ký người nước ngoài (ARC) và tình trạng bảo hiểm y tế, nếu có thể hãy ghi chú triệu chứng trước khi đi để việc trao đổi được thuận lợi hơn.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '약국과 야간·주말 진료',
          en: 'Pharmacies and Night/Weekend Medical Care',
          zh: '药店与夜间、周末诊疗',
          vi: 'Hiệu thuốc và khám chữa bệnh vào ban đêm, cuối tuần',
        ),
        summary: L10nText(
          ko: '야간·주말에 문을 연 병의원과 약국은 응급의료포털에서 실시간으로 조회할 수 있습니다.',
          en: 'You can check in real time which hospitals, clinics, and pharmacies are open at night and on weekends through the Emergency Medical Information Portal.',
          zh: '您可以通过急诊医疗信息门户实时查询夜间、周末营业的医院、诊所和药店。',
          vi: 'Bạn có thể tra cứu theo thời gian thực các bệnh viện, phòng khám và hiệu thuốc mở cửa vào ban đêm, cuối tuần trên Cổng thông tin y tế cấp cứu.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '찾는 방법',
              en: 'How to Find Them',
              zh: '查询方法',
              vi: 'Cách tìm kiếm',
            ),
            bullets: [
              L10nText(
                ko: 'E-Gen 홈페이지·앱의 "약국 찾기·응급실 찾기" 메뉴에서 현재 위치 기준 검색',
                en: 'Use the "Find Pharmacy / Find Emergency Room" menu on the E-Gen website or app to search based on your current location',
                zh: '在E-Gen网站或应用程序的"查找药店·查找急诊室"菜单中，可根据当前位置进行搜索',
                vi: 'Sử dụng mục "Tìm hiệu thuốc · Tìm phòng cấp cứu" trên trang web hoặc ứng dụng E-Gen để tìm kiếm theo vị trí hiện tại',
              ),
              L10nText(
                ko: '보건복지부 콜센터 129, 서울시는 다산콜센터 120으로 전화 문의 가능',
                en: 'You can also call the Ministry of Health and Welfare Call Center at 129, or in Seoul, the Dasan Call Center at 120',
                zh: '也可致电保健福祉部呼叫中心129咨询，首尔市居民可致电茶山呼叫中心120',
                vi: 'Bạn cũng có thể gọi điện hỏi Trung tâm cuộc gọi Bộ Y tế và Phúc lợi theo số 129, tại Seoul là Trung tâm cuộc gọi Dasan theo số 120',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '이용 팁',
              en: 'Tips for Use',
              zh: '使用小贴士',
              vi: 'Mẹo sử dụng',
            ),
            bullets: [
              L10nText(
                ko: '공휴일 비상진료 기간에는 별도 안내 페이지가 열립니다.',
                en: 'A separate information page opens during holiday emergency care periods.',
                zh: '在公休日紧急诊疗期间，会开设专门的信息页面。',
                vi: 'Trong thời gian khám chữa bệnh khẩn cấp vào ngày lễ, sẽ có trang thông tin riêng được mở.',
              ),
              L10nText(
                ko: '처방전 없이 구매 가능한 상비약과 처방이 필요한 약을 구분해 문의하세요.',
                en: 'Distinguish between over-the-counter medicines that can be bought without a prescription and medicines that require a prescription when asking.',
                zh: '咨询时请注意区分无需处方即可购买的常备药和需要处方的药品。',
                vi: 'Khi hỏi, hãy phân biệt rõ thuốc thông thường có thể mua không cần đơn và thuốc cần có đơn thuốc.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '상비약과 처방약 구분',
              en: 'Distinguishing OTC and Prescription Medicines',
              zh: '常备药与处方药的区分',
              vi: 'Phân biệt thuốc thông thường và thuốc kê đơn',
            ),
            bullets: [
              L10nText(
                ko: '해열제·소화제 등 안전상비의약품은 편의점에서도 구매할 수 있습니다.',
                en: 'Safe household medicines such as fever reducers and digestive aids can also be bought at convenience stores.',
                zh: '退烧药、消化药等安全常备药品也可以在便利店购买。',
                vi: 'Các loại thuốc thông thường an toàn như thuốc hạ sốt, thuốc tiêu hóa cũng có thể mua tại cửa hàng tiện lợi.',
              ),
              L10nText(
                ko: '처방이 필요한 약은 병원 진료 후 처방전을 받아 약국에서 조제받아야 합니다.',
                en: 'Medicines requiring a prescription must be dispensed at a pharmacy using a prescription issued after a hospital consultation.',
                zh: '需要处方的药品必须在医院就诊后取得处方，再到药店配药。',
                vi: 'Đối với thuốc cần đơn, bạn phải khám bệnh viện để lấy đơn thuốc rồi mang đến hiệu thuốc để được cấp phát.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '응급실 이용과 119',
          en: 'Using the Emergency Room and Calling 119',
          zh: '使用急诊室与拨打119',
          vi: 'Sử dụng phòng cấp cứu và gọi 119',
        ),
        summary: L10nText(
          ko: '생명이 위급한 상황에서는 119에 신고하면 이송과 동시에 가까운 응급실을 안내받을 수 있습니다.',
          en: 'In a life-threatening emergency, calling 119 will get you transported and directed to the nearest emergency room at the same time.',
          zh: '在危及生命的紧急情况下，拨打119即可获得转运服务，同时被引导前往最近的急诊室。',
          vi: 'Trong tình huống nguy hiểm đến tính mạng, hãy gọi 119 để được đưa đi cấp cứu và hướng dẫn đến phòng cấp cứu gần nhất cùng lúc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '119 신고 요령',
              en: 'Tips for Calling 119',
              zh: '拨打119的要领',
              vi: 'Mẹo khi gọi 119',
            ),
            bullets: [
              L10nText(
                ko: '응급의료 관련 안내전화는 기존 1339에서 119로 통합되었습니다.',
                en: 'The emergency medical information hotline, formerly 1339, has been integrated into 119.',
                zh: '原有的急诊医疗咨询热线1339已并入119。',
                vi: 'Đường dây tư vấn y tế cấp cứu trước đây là 1339 nay đã được sáp nhập vào 119.',
              ),
              L10nText(
                ko: '위치, 증상, 나이를 최대한 명확히 전달하고, 언어가 어려우면 통역 연결을 요청하세요.',
                en: 'State your location, symptoms, and age as clearly as possible, and if language is a barrier, ask to be connected to an interpreter.',
                zh: '请尽可能清楚地说明所在位置、症状和年龄，如果语言沟通有困难，可以请求转接口译服务。',
                vi: 'Hãy trình bày rõ ràng nhất có thể về vị trí, triệu chứng và độ tuổi, nếu gặp khó khăn về ngôn ngữ, hãy yêu cầu kết nối phiên dịch.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '응급실 방문 시 준비물',
              en: 'What to Bring When Visiting the Emergency Room',
              zh: '前往急诊室时应携带的物品',
              vi: 'Những thứ cần mang theo khi đến phòng cấp cứu',
            ),
            bullets: [
              L10nText(
                ko: '외국인등록증(ARC), 건강보험 여부, 복용 중인 약 정보',
                en: 'Alien Registration Card (ARC), health insurance information, and details of any medications you are currently taking',
                zh: '外国人登录证(ARC)、健康保险参保情况、正在服用的药物信息',
                vi: 'Thẻ đăng ký người nước ngoài (ARC), thông tin bảo hiểm y tế, thông tin thuốc đang sử dụng',
              ),
              L10nText(
                ko: '산업재해로 인한 부상이라면 접수 시 "일하다 다쳤다"고 명확히 알려야 합니다 — ⑪산업재해 참고',
                en: 'If the injury was caused by a workplace accident, clearly state at check-in that you "were injured while working" — see ⑪ Industrial Accidents',
                zh: '如果是因工伤导致的受伤，登记时必须明确说明"工作时受伤"——请参考⑪工伤事故',
                vi: 'Nếu bị thương do tai nạn lao động, khi làm thủ tục phải nói rõ là "bị thương trong khi làm việc" — tham khảo mục ⑪ Tai nạn lao động',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '응급실 이용 시 비용',
              en: 'Costs of Using the Emergency Room',
              zh: '使用急诊室的费用',
              vi: 'Chi phí khi sử dụng phòng cấp cứu',
            ),
            bullets: [
              L10nText(
                ko: '응급실은 진료 후 응급의료관리료가 별도로 부과되며, 경증으로 판단되면 본인부담이 늘어날 수 있습니다.',
                en: 'An emergency medical management fee is charged separately after treatment, and if your condition is judged to be minor, your out-of-pocket share may increase.',
                zh: '急诊就诊后会另行收取急诊医疗管理费，若被判定为轻症，本人自付比例可能会提高。',
                vi: 'Sau khi khám tại phòng cấp cứu sẽ bị tính thêm phí quản lý y tế cấp cứu riêng, và nếu được chẩn đoán là nhẹ thì phần tự chi trả có thể tăng lên.',
              ),
              L10nText(
                ko: '야간·공휴일 진료는 가산료가 붙을 수 있으니 급하지 않다면 야간 진료 병원(2페이지)을 먼저 고려하세요.',
                en: 'Night and holiday treatment may incur an additional surcharge, so if it is not urgent, consider a night-hours hospital first (see page 2).',
                zh: '夜间、公休日诊疗可能会加收附加费，如果情况不紧急，请优先考虑夜间诊疗医院（见第2页）。',
                vi: 'Khám vào ban đêm, ngày lễ có thể bị tính thêm phụ phí, nếu không quá khẩn cấp hãy cân nhắc bệnh viện khám đêm trước (xem trang 2).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '건강보험 적용 여부 확인',
          en: 'Checking Your Health Insurance Coverage',
          zh: '确认健康保险适用情况',
          vi: 'Kiểm tra tình trạng áp dụng bảo hiểm y tế',
        ),
        summary: L10nText(
          ko: '건강보험 가입 여부에 따라 진료비 부담이 크게 달라지므로, 본인이 직장가입자인지 지역가입자인지 먼저 확인해야 합니다.',
          en: 'Your treatment costs vary greatly depending on whether you have health insurance, so first check whether you are a workplace-based subscriber or a self-employed/regional subscriber.',
          zh: '是否参加健康保险会极大影响诊疗费用的负担，因此请先确认自己属于职场参保人还是地区参保人。',
          vi: 'Chi phí khám chữa bệnh sẽ khác nhau rất nhiều tùy theo việc bạn có tham gia bảo hiểm y tế hay không, vì vậy trước tiên cần xác định bạn là người tham gia theo nơi làm việc hay người tham gia theo khu vực.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '가입 유형',
              en: 'Types of Enrollment',
              zh: '参保类型',
              vi: 'Loại hình tham gia bảo hiểm',
            ),
            bullets: [
              L10nText(
                ko: '직장가입자: 사업장에 고용되면 체류기간과 관계없이 가입, 보험료는 근로자·사업주가 절반씩 부담',
                en: 'Workplace-based subscriber: Enrolled as soon as you are employed at a workplace, regardless of length of stay; the premium is split equally between employee and employer',
                zh: '职场参保人：受雇于用人单位后，无论居留期限长短均自动参保，保险费由劳动者和用人单位各承担一半',
                vi: 'Người tham gia theo nơi làm việc: Khi được tuyển dụng tại nơi làm việc thì tham gia bảo hiểm bất kể thời gian lưu trú, phí bảo hiểm do người lao động và chủ sử dụng lao động chia đều mỗi bên một nửa',
              ),
              L10nText(
                ko: '지역가입자: 국내 체류 6개월 이상이면서 직장가입 대상이 아닌 경우 가입, 보험료 전액 본인 부담',
                en: 'Self-employed/regional subscriber: Applies if you have stayed in Korea for 6 months or more and are not a workplace-based subscriber; you bear the entire premium yourself',
                zh: '地区参保人：在韩居留满6个月以上且不属于职场参保对象时参保，保险费全额由本人承担',
                vi: 'Người tham gia theo khu vực: Áp dụng khi lưu trú tại Hàn Quốc từ 6 tháng trở lên và không thuộc đối tượng tham gia theo nơi làm việc, phí bảo hiểm do bản thân chi trả toàn bộ',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '미가입 상태에서 진료받을 때',
              en: 'Receiving Treatment Without Insurance',
              zh: '未参保状态下就诊时',
              vi: 'Khi khám chữa bệnh trong tình trạng chưa tham gia bảo hiểm',
            ),
            bullets: [
              L10nText(
                ko: '건강보험이 적용되지 않으면 진료비 전액을 본인이 부담하게 됩니다.',
                en: 'If health insurance does not apply, you will have to pay the full cost of treatment yourself.',
                zh: '如果没有健康保险，您将需要自行承担全部诊疗费用。',
                vi: 'Nếu không được áp dụng bảo hiểm y tế, bạn sẽ phải tự chi trả toàn bộ chi phí khám chữa bệnh.',
              ),
              L10nText(
                ko: '국민건강보험공단(1577-1000)에서 가입 여부와 자격 상태를 확인할 수 있습니다.',
                en: 'You can check your enrollment and eligibility status by contacting the National Health Insurance Service (NHIS) at 1577-1000.',
                zh: '可致电国民健康保险公团(1577-1000)确认参保情况及资格状态。',
                vi: 'Bạn có thể kiểm tra tình trạng tham gia và tư cách bảo hiểm tại Cơ quan Bảo hiểm Y tế Quốc dân (NHIS) qua số 1577-1000.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '건강보험 미가입 상태 대응',
              en: 'What to Do Without Health Insurance',
              zh: '未参加健康保险时的应对方法',
              vi: 'Cách xử lý khi chưa tham gia bảo hiểm y tế',
            ),
            bullets: [
              L10nText(
                ko: '진료비 부담이 큰 경우 병원 내 사회복지팀·의료사회사업실에 상담을 요청할 수 있습니다.',
                en: 'If the cost of treatment is a significant burden, you can request a consultation with the hospital\'s social welfare team or medical social work office.',
                zh: '若诊疗费用负担较大，可向医院内的社会福利科、医疗社会事业室申请咨询。',
                vi: 'Nếu gánh nặng chi phí khám chữa bệnh quá lớn, bạn có thể yêu cầu tư vấn tại bộ phận phúc lợi xã hội hoặc phòng công tác xã hội y tế trong bệnh viện.',
              ),
              L10nText(
                ko: '저소득층은 지자체의 긴급의료비 지원 제도를 문의할 수 있습니다.',
                en: 'Low-income individuals can inquire about emergency medical expense support programs offered by their local government.',
                zh: '低收入群体可咨询地方政府的紧急医疗费支援制度。',
                vi: 'Người có thu nhập thấp có thể hỏi về chế độ hỗ trợ chi phí y tế khẩn cấp của chính quyền địa phương.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '통역 지원 서비스',
          en: 'Interpretation Support Services',
          zh: '口译支援服务',
          vi: 'Dịch vụ hỗ trợ phiên dịch',
        ),
        summary: L10nText(
          ko: '진료 중 의사소통이 어려우면 무료 전화통역 서비스를 활용할 수 있습니다.',
          en: 'If communication is difficult during treatment, you can use free phone interpretation services.',
          zh: '如果就诊时沟通有困难，可以使用免费电话口译服务。',
          vi: 'Nếu gặp khó khăn trong giao tiếp khi khám bệnh, bạn có thể sử dụng dịch vụ phiên dịch qua điện thoại miễn phí.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: 'BBB코리아 전화통역',
              en: 'BBB Korea Phone Interpretation',
              zh: 'BBB Korea 电话口译',
              vi: 'Phiên dịch qua điện thoại BBB Korea',
            ),
            bullets: [
              L10nText(
                ko: '대표번호 1588-5644, 20개 언어, 24시간 무료 이용',
                en: 'Main number 1588-5644, available in 20 languages, free 24 hours a day',
                zh: '总机号码1588-5644，支持20种语言，24小时免费使用',
                vi: 'Số điện thoại chính 1588-5644, hỗ trợ 20 ngôn ngữ, miễn phí 24 giờ',
              ),
              L10nText(
                ko: '통역 자원봉사자가 병원 직원·환자와 번갈아 통화하는 3자 통화 방식',
                en: 'A three-way call format in which an interpreter volunteer speaks alternately with hospital staff and the patient',
                zh: '采用三方通话方式，由口译志愿者分别与医院工作人员和患者交替通话',
                vi: 'Hình thức cuộc gọi ba bên, trong đó tình nguyện viên phiên dịch lần lượt trao đổi với nhân viên bệnh viện và bệnh nhân',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '그 밖의 통역 지원',
              en: 'Other Interpretation Support',
              zh: '其他口译支援',
              vi: 'Hỗ trợ phiên dịch khác',
            ),
            bullets: [
              L10nText(
                ko: '법무부 외국인종합안내센터 1345에서도 생활 전반의 다국어 상담 가능',
                en: 'The Ministry of Justice Immigration Contact Center at 1345 also offers multilingual consultation on daily life in general',
                zh: '法务部外国人综合咨询中心1345也可提供涵盖日常生活各方面的多语言咨询',
                vi: 'Trung tâm tư vấn tổng hợp cho người nước ngoài của Bộ Tư pháp qua số 1345 cũng có thể tư vấn đa ngôn ngữ về đời sống nói chung',
              ),
              L10nText(
                ko: '일부 대형병원 국제진료센터는 자체 통역 인력을 상시 배치',
                en: 'Some international clinics at major hospitals keep their own interpreters on staff at all times',
                zh: '部分大型医院的国际诊疗中心配有常驻自有口译人员',
                vi: 'Một số trung tâm khám chữa bệnh quốc tế tại bệnh viện lớn bố trí thường trực đội ngũ phiên dịch riêng',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '다국어 안내 자료',
              en: 'Multilingual Information Materials',
              zh: '多语言指南资料',
              vi: 'Tài liệu hướng dẫn đa ngôn ngữ',
            ),
            bullets: [
              L10nText(
                ko: '국민건강보험공단·보건소는 주요 언어로 된 건강 정보 리플릿을 배포하고 있습니다.',
                en: 'The National Health Insurance Service and public health centers distribute health information leaflets in major languages.',
                zh: '国民健康保险公团和保健所会发放以主要语言印制的健康信息宣传册。',
                vi: 'Cơ quan Bảo hiểm Y tế Quốc dân và trung tâm y tế công cộng phát hành tờ rơi thông tin sức khỏe bằng các ngôn ngữ chính.',
              ),
              L10nText(
                ko: '병원 방문 전 BBB코리아·1345에 미리 전화해 통역 연결 가능 여부를 확인하면 대기 시간을 줄일 수 있습니다.',
                en: 'Calling BBB Korea or 1345 in advance to confirm interpreter availability before visiting the hospital can help reduce your waiting time.',
                zh: '在前往医院之前，先致电BBB Korea或1345确认是否能连接口译，可以减少等待时间。',
                vi: 'Trước khi đến bệnh viện, hãy gọi trước cho BBB Korea hoặc 1345 để xác nhận có thể kết nối phiên dịch hay không, việc này giúp giảm thời gian chờ đợi.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  6: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '외국인근로자 보험 총정리',
          en: 'Overview of Insurance for Foreign Workers',
          zh: '外国劳工保险总览',
          vi: 'Tổng quan bảo hiểm dành cho lao động nước ngoài',
        ),
        summary: L10nText(
          ko: '외국인근로자가 챙겨야 할 보험은 크게 4대 사회보험과 외국인전용보험 두 갈래이며, 가입 주체와 가입 기한이 각각 다릅니다.',
          en: 'The insurance foreign workers need to be aware of falls into two broad categories — the four major social insurances and insurance exclusively for foreigners — and each differs in who must enroll and by when.',
          zh: '外国劳工需要关注的保险大致分为两类：四大社会保险和外国人专用保险，两者的参保主体和参保期限各不相同。',
          vi: 'Bảo hiểm mà lao động nước ngoài cần lưu ý được chia thành hai nhóm lớn: 4 loại bảo hiểm xã hội chính và bảo hiểm dành riêng cho người nước ngoài, mỗi loại có đối tượng tham gia và thời hạn tham gia khác nhau.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '4대 사회보험',
              en: 'The Four Major Social Insurances',
              zh: '四大社会保险',
              vi: '4 loại bảo hiểm xã hội chính',
            ),
            bullets: [
              L10nText(
                ko: '산재보험(전원 의무) · 건강보험(의무) · 국민연금(상호주의) · 고용보험(비자별 상이) — 사업주가 가입 처리',
                en: 'Industrial accident compensation insurance (mandatory for all) · Health insurance (mandatory) · National Pension (reciprocity-based) · Employment insurance (varies by visa type) — enrollment is handled by the employer',
                zh: '工伤保险（全员强制）· 健康保险（强制）· 国民年金（对等原则）· 雇佣保险（因签证类型而异）——均由用人单位办理参保',
                vi: 'Bảo hiểm tai nạn lao động (bắt buộc với tất cả) · Bảo hiểm y tế (bắt buộc) · Quỹ hưu trí quốc dân (theo nguyên tắc có đi có lại) · Bảo hiểm việc làm (khác nhau tùy loại visa) — do chủ sử dụng lao động làm thủ tục tham gia',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '외국인전용보험',
              en: 'Insurance Exclusively for Foreigners',
              zh: '外国人专用保险',
              vi: 'Bảo hiểm dành riêng cho người nước ngoài',
            ),
            bullets: [
              L10nText(
                ko: '출국만기보험·신탁(사업주 가입) · 임금체불 보증보험(사업주 가입) · 귀국비용보험·신탁(근로자 가입) · 상해보험(근로자 가입)',
                en: 'Departure Guarantee Insurance/Trust (employer-enrolled) · Wage Arrears Guarantee Insurance (employer-enrolled) · Return-Trip Cost Insurance/Trust (worker-enrolled) · Accident Insurance (worker-enrolled)',
                zh: '离境满期保险·信托（用人单位参保）· 拖欠工资保证保险（用人单位参保）· 回国费用保险·信托（劳动者参保）· 伤害保险（劳动者参保）',
                vi: 'Bảo hiểm/Ủy thác mãn hạn xuất cảnh (chủ sử dụng lao động tham gia) · Bảo hiểm bảo lãnh nợ lương (chủ sử dụng lao động tham gia) · Bảo hiểm/Ủy thác chi phí về nước (người lao động tham gia) · Bảo hiểm tai nạn thương tật (người lao động tham gia)',
              ),
              L10nText(
                ko: '근거: 외국인근로자의 고용 등에 관한 법률',
                en: 'Legal basis: Act on the Employment, etc. of Foreign Workers',
                zh: '法律依据：《外国劳工雇佣等相关法律》',
                vi: 'Căn cứ pháp lý: Luật về việc làm của lao động nước ngoài',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '미가입 시 불이익',
              en: 'Disadvantages of Non-Enrollment',
              zh: '未参保的不利后果',
              vi: 'Bất lợi khi không tham gia bảo hiểm',
            ),
            bullets: [
              L10nText(
                ko: '산재보험 미가입 사업장에서 사고가 나도 근로자는 산재보상을 받을 수 있습니다(사업주가 이후 국가에 비용을 상환).',
                en: 'Even if an accident occurs at a workplace that has not enrolled in industrial accident compensation insurance, the worker can still receive compensation (the employer must later reimburse the state).',
                zh: '即使工伤保险未参保的单位发生事故，劳动者仍可获得工伤赔偿（用人单位事后需向国家偿还相关费用）。',
                vi: 'Ngay cả khi xảy ra tai nạn tại nơi làm việc chưa tham gia bảo hiểm tai nạn lao động, người lao động vẫn có thể nhận được bồi thường tai nạn lao động (chủ sử dụng lao động sau đó phải hoàn trả chi phí cho nhà nước).',
              ),
              L10nText(
                ko: '건강보험 미가입 상태로 진료받으면 진료비 전액을 본인이 부담하게 됩니다.',
                en: 'If you receive treatment without health insurance, you must bear the full cost of treatment yourself.',
                zh: '若在未参加健康保险的状态下就诊，需自行承担全部诊疗费用。',
                vi: 'Nếu khám chữa bệnh trong tình trạng chưa tham gia bảo hiểm y tế, bạn sẽ phải tự chi trả toàn bộ chi phí khám chữa bệnh.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '가입 여부 확인 방법',
              en: 'How to Check Your Enrollment Status',
              zh: '参保情况确认方法',
              vi: 'Cách kiểm tra tình trạng tham gia bảo hiểm',
            ),
            bullets: [
              L10nText(
                ko: '국민건강보험공단(1577-1000), 국민연금공단(1355)에서 본인 가입 상태를 확인할 수 있습니다.',
                en: 'You can check your enrollment status by contacting the National Health Insurance Service (1577-1000) or the National Pension Service (1355).',
                zh: '可致电国民健康保险公团(1577-1000)或国民年金公团(1355)确认本人的参保状态。',
                vi: 'Bạn có thể kiểm tra tình trạng tham gia bảo hiểm của bản thân tại Cơ quan Bảo hiểm Y tế Quốc dân (1577-1000) hoặc Công đoàn Quỹ hưu trí quốc dân (1355).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '산재보험과 국민연금',
          en: 'Industrial Accident Insurance and the National Pension',
          zh: '工伤保险与国民年金',
          vi: 'Bảo hiểm tai nạn lao động và Quỹ hưu trí quốc dân',
        ),
        summary: L10nText(
          ko: '산재보험은 체류자격과 관계없이 모든 근로자에게 적용되지만, 국민연금은 본국과의 상호주의 여부에 따라 가입 대상에서 제외될 수 있습니다.',
          en: 'Industrial accident insurance applies to all workers regardless of their visa status, but the National Pension may exclude certain nationals depending on whether reciprocity exists with their home country.',
          zh: '工伤保险适用于所有劳动者，与居留资格无关；但国民年金是否适用则取决于与本国之间是否存在对等原则，可能会被排除在参保对象之外。',
          vi: 'Bảo hiểm tai nạn lao động áp dụng cho mọi người lao động bất kể tư cách lưu trú, nhưng Quỹ hưu trí quốc dân có thể loại trừ một số quốc tịch khỏi đối tượng tham gia tùy theo việc có áp dụng nguyên tắc có đi có lại với nước sở tại hay không.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '산재보험',
              en: 'Industrial Accident Insurance',
              zh: '工伤保险',
              vi: 'Bảo hiểm tai nạn lao động',
            ),
            bullets: [
              L10nText(
                ko: '내·외국인을 구분하지 않고 모든 근로자가 가입 대상',
                en: 'All workers are covered, with no distinction between Korean nationals and foreigners',
                zh: '不区分本国人与外国人，所有劳动者均为参保对象',
                vi: 'Tất cả người lao động đều thuộc đối tượng tham gia, không phân biệt người Hàn Quốc hay người nước ngoài',
              ),
              L10nText(
                ko: '보험료는 사업주가 전액 부담, 근로자 부담 없음',
                en: 'The premium is paid entirely by the employer; the worker pays nothing',
                zh: '保险费全部由用人单位承担，劳动者无需负担',
                vi: 'Phí bảo hiểm do chủ sử dụng lao động chi trả toàn bộ, người lao động không phải đóng',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '국민연금',
              en: 'National Pension',
              zh: '国民年金',
              vi: 'Quỹ hưu trí quốc dân',
            ),
            bullets: [
              L10nText(
                ko: '18세 이상 60세 미만 근로자는 원칙적으로 의무가입',
                en: 'Workers aged 18 to under 60 are, in principle, required to enroll',
                zh: '原则上，年满18周岁不满60周岁的劳动者须强制参保',
                vi: 'Về nguyên tắc, người lao động từ 18 tuổi đến dưới 60 tuổi bắt buộc phải tham gia',
              ),
              L10nText(
                ko: '본국 법이 한국 국민에게 국민연금에 상응하는 연금을 적용하지 않는 국가 출신은 가입 대상에서 제외(상호주의)',
                en: 'Nationals of countries whose laws do not provide Korean citizens with a pension equivalent to the National Pension are excluded from enrollment (reciprocity principle)',
                zh: '若本国法律未对韩国国民适用相当于国民年金的养老金制度，则该国国民不属于参保对象（对等原则）',
                vi: 'Công dân của quốc gia mà pháp luật nước đó không áp dụng chế độ hưu trí tương đương cho công dân Hàn Quốc sẽ bị loại khỏi đối tượng tham gia (nguyên tắc có đi có lại)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '국민연금 반환일시금',
              en: 'National Pension Lump-Sum Refund',
              zh: '国民年金退还一次性给付金',
              vi: 'Khoản hoàn trả một lần của Quỹ hưu trí quốc dân',
            ),
            bullets: [
              L10nText(
                ko: '상호주의로 가입 대상이었거나 가입 후 출국하는 경우, 요건을 충족하면 반환일시금을 청구할 수 있습니다.',
                en: 'If you were enrolled under the reciprocity principle or are leaving Korea after enrollment, you can claim a lump-sum refund if you meet the requirements.',
                zh: '若因对等原则曾参保，或参保后出国，只要符合条件即可申请退还一次性给付金。',
                vi: 'Nếu đã tham gia theo nguyên tắc có đi có lại hoặc xuất cảnh sau khi tham gia, bạn có thể yêu cầu khoản hoàn trả một lần nếu đáp ứng đủ điều kiện.',
              ),
              L10nText(
                ko: '청구 방법은 출국 전후 국민연금공단에서 안내받을 수 있습니다.',
                en: 'You can get guidance on how to claim it from the National Pension Service before or after departure.',
                zh: '出国前后均可向国民年金公团咨询申请方法。',
                vi: 'Bạn có thể được hướng dẫn về cách yêu cầu tại Công đoàn Quỹ hưu trí quốc dân trước hoặc sau khi xuất cảnh.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '건강보험과 고용보험',
          en: 'Health Insurance and Employment Insurance',
          zh: '健康保险与雇佣保险',
          vi: 'Bảo hiểm y tế và bảo hiểm việc làm',
        ),
        summary: L10nText(
          ko: '건강보험은 의무가입이지만, 고용보험은 체류자격에 따라 의무와 임의가입으로 나뉩니다.',
          en: 'Health insurance is mandatory, but employment insurance is either mandatory or optional depending on your visa status.',
          zh: '健康保险为强制参保，而雇佣保险则根据居留资格分为强制参保和自愿参保两种情况。',
          vi: 'Bảo hiểm y tế là bắt buộc, nhưng bảo hiểm việc làm được chia thành bắt buộc hoặc tự nguyện tùy theo tư cách lưu trú.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '건강보험',
              en: 'Health Insurance',
              zh: '健康保险',
              vi: 'Bảo hiểm y tế',
            ),
            bullets: [
              L10nText(
                ko: '직장가입: 고용과 동시 가입, 보험료 근로자·사업주 절반씩 부담',
                en: 'Workplace-based enrollment: You are enrolled as soon as you are employed; the premium is split equally between worker and employer',
                zh: '职场参保：受雇的同时即自动参保，保险费由劳动者和用人单位各承担一半',
                vi: 'Tham gia theo nơi làm việc: Được tham gia ngay khi được tuyển dụng, phí bảo hiểm do người lao động và chủ sử dụng lao động chia đều mỗi bên một nửa',
              ),
              L10nText(
                ko: '지역가입: 체류 6개월 이상이면서 직장가입 대상이 아닌 경우, 보험료 전액 본인 부담',
                en: 'Regional enrollment: If you have stayed 6 months or more and are not eligible for workplace-based enrollment, you bear the entire premium yourself',
                zh: '地区参保：居留满6个月以上且不属于职场参保对象时，保险费全额由本人承担',
                vi: 'Tham gia theo khu vực: Khi lưu trú từ 6 tháng trở lên và không thuộc đối tượng tham gia theo nơi làm việc, phí bảo hiểm do bản thân chi trả toàn bộ',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '고용보험',
              en: 'Employment Insurance',
              zh: '雇佣保险',
              vi: 'Bảo hiểm việc làm',
            ),
            bullets: [
              L10nText(
                ko: 'E-9·H-2 체류자격: 고용보험 당연 피보험자이나, 실업급여·육아휴직급여는 별도 가입신청이 있어야 적용',
                en: 'E-9/H-2 visa holders: Automatically insured under employment insurance, but unemployment benefits and childcare leave benefits require a separate enrollment application',
                zh: 'E-9、H-2签证：自动成为雇佣保险的被保险人，但失业补助金、育儿休职补助金需另行申请参保后方可适用',
                vi: 'Diện lưu trú E-9, H-2: Đương nhiên là đối tượng được bảo hiểm việc làm bảo vệ, nhưng trợ cấp thất nghiệp và trợ cấp nghỉ chăm con cần đăng ký tham gia riêng mới được áp dụng',
              ),
              L10nText(
                ko: 'D-1~D-6, D-10 체류자격: 고용보험 가입 불가',
                en: 'D-1 through D-6 and D-10 visa holders: Not eligible to enroll in employment insurance',
                zh: 'D-1~D-6、D-10签证：不可参加雇佣保险',
                vi: 'Diện lưu trú D-1~D-6, D-10: Không thể tham gia bảo hiểm việc làm',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '실업급여 신청 조건',
              en: 'Conditions for Claiming Unemployment Benefits',
              zh: '申请失业补助金的条件',
              vi: 'Điều kiện xin trợ cấp thất nghiệp',
            ),
            bullets: [
              L10nText(
                ko: '고용보험에 가입한 근로자가 비자발적으로 이직한 경우 실업급여를 신청할 수 있습니다.',
                en: 'Workers enrolled in employment insurance who leave their job involuntarily can apply for unemployment benefits.',
                zh: '已参加雇佣保险的劳动者若非自愿离职，可申请领取失业补助金。',
                vi: 'Người lao động đã tham gia bảo hiểm việc làm nếu nghỉ việc không tự nguyện có thể xin trợ cấp thất nghiệp.',
              ),
              L10nText(
                ko: '자진 퇴사는 원칙적으로 대상에서 제외되나, 정당한 이직 사유가 인정되면 예외가 있습니다.',
                en: 'Voluntary resignation is generally excluded, but exceptions apply if a legitimate reason for leaving is recognized.',
                zh: '原则上自愿离职不属于申请对象，但如认定存在正当离职理由，则可有例外。',
                vi: 'Về nguyên tắc, tự nguyện nghỉ việc không thuộc đối tượng được hưởng, nhưng vẫn có ngoại lệ nếu lý do nghỉ việc được công nhận là chính đáng.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '출국만기보험과 보증보험 (사업주 가입)',
          en: 'Departure Guarantee Insurance and Guarantee Insurance (Employer-Enrolled)',
          zh: '离境满期保险与保证保险（用人单位参保）',
          vi: 'Bảo hiểm mãn hạn xuất cảnh và bảo hiểm bảo lãnh (chủ sử dụng lao động tham gia)',
        ),
        summary: L10nText(
          ko: '두 보험 모두 사업주가 가입하는 보험이지만, 근로자의 퇴직금과 체불 임금을 보장한다는 점에서 근로자가 반드시 알아야 합니다.',
          en: 'Both of these insurances are enrolled in by the employer, but since they guarantee the worker\'s severance pay and unpaid wages, workers must understand them as well.',
          zh: '这两种保险均由用人单位参保，但由于它们保障的是劳动者的退职金和拖欠工资，劳动者本人也必须了解相关内容。',
          vi: 'Cả hai loại bảo hiểm này đều do chủ sử dụng lao động tham gia, nhưng vì chúng bảo đảm tiền trợ cấp thôi việc và tiền lương bị nợ của người lao động nên người lao động nhất định phải nắm rõ.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '출국만기보험·신탁',
              en: 'Departure Guarantee Insurance/Trust',
              zh: '离境满期保险·信托',
              vi: 'Bảo hiểm/Ủy thác mãn hạn xuất cảnh',
            ),
            bullets: [
              L10nText(
                ko: '목적: 근로자 출국 시 받는 퇴직금 대체 재원 확보',
                en: 'Purpose: To secure funds that substitute for the severance pay a worker receives upon departure from Korea',
                zh: '目的：确保劳动者出境时可领取的、用以替代退职金的资金来源',
                vi: 'Mục đích: Bảo đảm nguồn tài chính thay thế cho tiền trợ cấp thôi việc mà người lao động nhận được khi xuất cảnh',
              ),
              L10nText(
                ko: '가입 의무자: 사업주 — 근로자는 만기 시 직접 수령',
                en: 'Party required to enroll: The employer — the worker receives the payout directly upon maturity',
                zh: '参保义务人：用人单位——劳动者在保险满期时可直接领取',
                vi: 'Người có nghĩa vụ tham gia: Chủ sử dụng lao động — người lao động nhận trực tiếp khi đáo hạn',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '임금체불 보증보험',
              en: 'Wage Arrears Guarantee Insurance',
              zh: '拖欠工资保证保险',
              vi: 'Bảo hiểm bảo lãnh nợ lương',
            ),
            bullets: [
              L10nText(
                ko: '목적: 사업주가 임금을 지급하지 못할 경우를 대비한 보증',
                en: 'Purpose: To provide a guarantee in case the employer is unable to pay wages',
                zh: '目的：为用人单位无法支付工资的情况提供保证',
                vi: 'Mục đích: Bảo lãnh cho trường hợp chủ sử dụng lao động không thể trả lương',
              ),
              L10nText(
                ko: '체불 발생 시 ⑩임금체불 절차와 함께 확인해야 하는 보험입니다.',
                en: 'If wage arrears occur, this is an insurance you should check together with the procedure in ⑩ Wage Arrears.',
                zh: '发生拖欠工资时，应与⑩拖欠工资处理程序一并确认这项保险。',
                vi: 'Khi xảy ra nợ lương, đây là loại bảo hiểm cần kiểm tra cùng với quy trình tại mục ⑩ Nợ lương.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '출국만기보험 수령 방법',
              en: 'How to Receive Departure Guarantee Insurance Payouts',
              zh: '离境满期保险的领取方法',
              vi: 'Cách nhận bảo hiểm mãn hạn xuất cảnh',
            ),
            bullets: [
              L10nText(
                ko: '출국 예정일 며칠 전부터 신청할 수 있으며, 원칙적으로 출국과 동시에 지급됩니다.',
                en: 'You can apply a few days before your scheduled departure date, and payment is, in principle, made at the time of departure.',
                zh: '可在预定出境日期前数日提出申请，原则上会在出境的同时支付。',
                vi: 'Có thể đăng ký từ vài ngày trước ngày dự kiến xuất cảnh, và về nguyên tắc sẽ được chi trả cùng lúc với việc xuất cảnh.',
              ),
              L10nText(
                ko: '사업장을 변경해도 재직 기간이 합산되어 계속 적립됩니다.',
                en: 'Even if you change workplaces, your total period of employment is combined and continues to accrue.',
                zh: '即使更换工作单位，在职期间也会累计合并，持续计提。',
                vi: 'Ngay cả khi thay đổi nơi làm việc, thời gian làm việc vẫn được cộng dồn và tiếp tục tích lũy.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '귀국비용보험과 상해보험 (근로자 가입)',
          en: 'Return-Trip Cost Insurance and Accident Insurance (Worker-Enrolled)',
          zh: '回国费用保险与伤害保险（劳动者参保）',
          vi: 'Bảo hiểm chi phí về nước và bảo hiểm tai nạn thương tật (người lao động tham gia)',
        ),
        summary: L10nText(
          ko: '이 두 보험은 근로자 본인이 직접 가입해야 하며, 가입 기한을 넘기면 취업활동에 제약이 있을 수 있습니다.',
          en: 'These two insurances must be enrolled in by the worker personally, and missing the enrollment deadline may restrict your ability to work.',
          zh: '这两种保险必须由劳动者本人亲自参保，若超过参保期限，可能会对其就业活动造成限制。',
          vi: 'Hai loại bảo hiểm này phải do chính người lao động tham gia, nếu quá thời hạn tham gia có thể bị hạn chế hoạt động việc làm.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '귀국비용보험·신탁',
              en: 'Return-Trip Cost Insurance/Trust',
              zh: '回国费用保险·信托',
              vi: 'Bảo hiểm/Ủy thác chi phí về nước',
            ),
            bullets: [
              L10nText(
                ko: '대상: E-9, H-2 체류자격 근로자',
                en: 'Applies to: Workers with E-9 or H-2 visa status',
                zh: '适用对象：持E-9、H-2居留资格的劳动者',
                vi: 'Đối tượng: Người lao động có tư cách lưu trú E-9, H-2',
              ),
              L10nText(
                ko: '가입 기한: 근로계약 효력발생일부터 3개월 이내',
                en: 'Enrollment deadline: Within 3 months from the effective date of the employment contract',
                zh: '参保期限：自劳动合同生效之日起3个月内',
                vi: 'Thời hạn tham gia: Trong vòng 3 tháng kể từ ngày hợp đồng lao động có hiệu lực',
              ),
              L10nText(
                ko: '목적: 귀국 항공료 등 귀국비용 충당',
                en: 'Purpose: To cover return-trip costs such as airfare home',
                zh: '目的：用于支付回国机票等回国费用',
                vi: 'Mục đích: Trang trải chi phí về nước như vé máy bay hồi hương',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '상해보험',
              en: 'Accident Insurance',
              zh: '伤害保险',
              vi: 'Bảo hiểm tai nạn thương tật',
            ),
            bullets: [
              L10nText(
                ko: '대상: E-9, H-2 체류자격 근로자',
                en: 'Applies to: Workers with E-9 or H-2 visa status',
                zh: '适用对象：持E-9、H-2居留资格的劳动者',
                vi: 'Đối tượng: Người lao động có tư cách lưu trú E-9, H-2',
              ),
              L10nText(
                ko: '가입 기한: 근로계약 효력발생일부터 15일 이내',
                en: 'Enrollment deadline: Within 15 days from the effective date of the employment contract',
                zh: '参保期限：自劳动合同生效之日起15日内',
                vi: 'Thời hạn tham gia: Trong vòng 15 ngày kể từ ngày hợp đồng lao động có hiệu lực',
              ),
              L10nText(
                ko: '목적: 업무상 재해 이외의 질병·사망 등 대비',
                en: 'Purpose: To provide coverage for illness, death, and other events not related to occupational accidents',
                zh: '目的：为非因工伤引起的疾病、死亡等情况提供保障',
                vi: 'Mục đích: Phòng ngừa bệnh tật, tử vong, v.v. không phải do tai nạn lao động',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '미가입 시 불이익',
              en: 'Disadvantages of Non-Enrollment',
              zh: '未参保的不利后果',
              vi: 'Bất lợi khi không tham gia bảo hiểm',
            ),
            bullets: [
              L10nText(
                ko: '두 보험 모두 가입하지 않으면 사업주가 과태료를 부과받을 수 있고, 근로자 본인의 사고·귀국 대비가 되지 않습니다.',
                en: 'If neither insurance is obtained, the employer may be fined, and the worker will have no coverage in case of an accident or when returning home.',
                zh: '若两种保险均未参保，用人单位可能会被处以罚款，同时劳动者本人也无法在发生事故或回国时获得保障。',
                vi: 'Nếu không tham gia cả hai loại bảo hiểm này, chủ sử dụng lao động có thể bị phạt tiền, và bản thân người lao động sẽ không có sự chuẩn bị khi gặp tai nạn hoặc khi về nước.',
              ),
              L10nText(
                ko: '가입 여부는 근로복지공단 또는 취급 보험사에서 확인할 수 있습니다.',
                en: 'You can check your enrollment status with the Korea Workers\' Compensation and Welfare Service or the insurance company handling the policy.',
                zh: '可向勤劳福祉公团或承保的保险公司确认参保情况。',
                vi: 'Bạn có thể kiểm tra tình trạng tham gia tại Công đoàn Phúc lợi Lao động hoặc công ty bảo hiểm phụ trách.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  7: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '계약 전 필수 체크사항',
          en: 'Essential Checks Before Signing a Lease',
          zh: '签约前必须核实的事项',
          vi: 'Những điều cần kiểm tra bắt buộc trước khi ký hợp đồng',
        ),
        summary: L10nText(
          ko: '계약서에 서명하기 전 등기부등본으로 집주인과 권리관계를 직접 확인하는 것이 가장 중요합니다.',
          en: 'Before signing a lease, it is most important to directly verify the landlord\'s identity and the property\'s rights using the property register.',
          zh: '在签署合同之前，最重要的是通过不动产登记簿誊本亲自核实房东身份及房产的权利关系。',
          vi: 'Trước khi ký hợp đồng, điều quan trọng nhất là tự mình xác nhận danh tính chủ nhà và quan hệ quyền lợi thông qua bản sao sổ đăng ký bất động sản.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '등기부등본 확인',
              en: 'Checking the Property Register',
              zh: '核实不动产登记簿誊本',
              vi: 'Kiểm tra bản sao sổ đăng ký bất động sản',
            ),
            bullets: [
              L10nText(
                ko: '집주인 이름이 등기부등본상 소유자와 같은지 확인',
                en: 'Check whether the landlord\'s name matches the registered owner on the property register',
                zh: '确认房东姓名是否与不动产登记簿誊本上登记的所有人一致',
                vi: 'Kiểm tra xem tên chủ nhà có trùng khớp với tên chủ sở hữu ghi trên sổ đăng ký bất động sản hay không',
              ),
              L10nText(
                ko: '근저당 등 선순위 권리가 보증금보다 과도하게 많지 않은지 확인',
                en: 'Check that any senior liens, such as mortgages, are not excessively large compared to your deposit',
                zh: '确认根抵押权等优先权利金额是否远高于押金',
                vi: 'Kiểm tra xem các quyền ưu tiên như thế chấp có vượt quá mức so với tiền đặt cọc hay không',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '확인할 서류',
              en: 'Documents to Check',
              zh: '需要核实的文件',
              vi: 'Các giấy tờ cần kiểm tra',
            ),
            bullets: [
              L10nText(
                ko: '건축물대장(불법건축물 여부), 등기부등본(권리관계)',
                en: 'Building register (to check for illegal construction), property register (rights and ownership)',
                zh: '建筑物登记簿（是否为违章建筑）、不动产登记簿誊本（权利关系）',
                vi: 'Sổ đăng ký công trình xây dựng (kiểm tra công trình bất hợp pháp), bản sao sổ đăng ký bất động sản (quan hệ quyền lợi)',
              ),
              L10nText(
                ko: '계약자가 실제 소유자 본인인지, 대리인이라면 위임장·인감증명서 확인',
                en: 'Whether the contracting party is the actual owner, or if acting as an agent, check the power of attorney and certificate of seal impression',
                zh: '确认签约人是否为实际所有人本人；若为代理人，需核实委托书及印鉴证明',
                vi: 'Xác nhận người ký hợp đồng có phải là chủ sở hữu thực sự hay không, nếu là người đại diện thì kiểm tra giấy ủy quyền và giấy chứng nhận con dấu',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '공인중개사 확인',
              en: 'Verifying the Licensed Real Estate Agent',
              zh: '核实房产中介资质',
              vi: 'Xác minh môi giới bất động sản có chứng chỉ hành nghề',
            ),
            bullets: [
              L10nText(
                ko: '공인중개사를 통한 계약이라면 등록번호와 정식 개설등록 여부를 확인할 수 있습니다.',
                en: 'If the contract is made through a licensed real estate agent, you can check their registration number and confirm they are officially registered.',
                zh: '如果是通过房产中介签约，可以核实其登记编号及是否正式登记开业。',
                vi: 'Nếu ký hợp đồng qua môi giới bất động sản có chứng chỉ, bạn có thể kiểm tra số đăng ký và việc đã đăng ký mở văn phòng chính thức hay chưa.',
              ),
              L10nText(
                ko: '중개대상물 확인·설명서를 계약서와 함께 반드시 받으세요.',
                en: 'Be sure to receive the property confirmation and explanation document together with the lease contract.',
                zh: '请务必在签订合同的同时索取《中介标的物确认说明书》。',
                vi: 'Hãy chắc chắn nhận được bản xác nhận và giải trình về đối tượng môi giới cùng với hợp đồng.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '임대차계약서 작성 체크리스트',
          en: 'Checklist for Writing a Lease Agreement',
          zh: '租赁合同撰写核对清单',
          vi: 'Danh sách kiểm tra khi soạn hợp đồng thuê nhà',
        ),
        summary: L10nText(
          ko: '계약서에는 보증금, 계약기간, 특약사항이 정확히 기재되어야 하며, 구두 약속은 반드시 특약으로 남겨야 합니다.',
          en: 'The lease must accurately state the deposit, lease term, and any special provisions, and any verbal agreements must always be recorded as special provisions.',
          zh: '合同中应准确记载押金、合同期限及特别约定事项，口头约定务必以特别条款的形式书面记录下来。',
          vi: 'Hợp đồng cần ghi chính xác tiền đặt cọc, thời hạn hợp đồng và các điều khoản đặc biệt, mọi thỏa thuận miệng nhất định phải được ghi lại thành điều khoản đặc biệt.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '필수 기재 항목',
              en: 'Mandatory Items to Include',
              zh: '必须记载的事项',
              vi: 'Các mục bắt buộc phải ghi',
            ),
            bullets: [
              L10nText(
                ko: '임대인·임차인 인적사항, 보증금·월세 금액과 지급일, 계약기간, 목적물 주소',
                en: 'Personal details of the landlord and tenant, the deposit/monthly rent amount and due date, the lease term, and the address of the property',
                zh: '出租人、承租人的个人信息，押金、月租金额及支付日期，合同期限，标的物地址',
                vi: 'Thông tin cá nhân của bên cho thuê, bên thuê; số tiền đặt cọc, tiền thuê hàng tháng và ngày thanh toán; thời hạn hợp đồng; địa chỉ đối tượng cho thuê',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '외국인이 특히 주의할 점',
              en: 'Points Foreigners Should Pay Special Attention To',
              zh: '外国人尤其需要注意的事项',
              vi: 'Những điều người nước ngoài đặc biệt cần lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '계약서 원본 1부를 반드시 본인이 보관',
                en: 'Always keep one original copy of the contract for yourself',
                zh: '务必自行保管一份合同原件',
                vi: 'Nhất định phải tự mình giữ một bản gốc hợp đồng',
              ),
              L10nText(
                ko: '이해가 어려운 특약사항은 서명 전 통역 지원(1345, BBB코리아)을 활용해 확인',
                en: 'For any special provisions that are hard to understand, use interpretation support (1345, BBB Korea) to confirm them before signing',
                zh: '若有难以理解的特别条款，签字前请利用口译支援服务（1345、BBB Korea）进行确认',
                vi: 'Với các điều khoản đặc biệt khó hiểu, hãy dùng dịch vụ hỗ trợ phiên dịch (1345, BBB Korea) để xác nhận trước khi ký',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '특약사항 예시',
              en: 'Examples of Special Provisions',
              zh: '特别条款示例',
              vi: 'Ví dụ về điều khoản đặc biệt',
            ),
            bullets: [
              L10nText(
                ko: '"입주 전 발견된 하자는 임대인이 수리한다"처럼 구두 약속은 반드시 특약으로 남겨야 합니다.',
                en: 'Verbal agreements — such as "the landlord will repair any defects found before move-in" — must always be recorded as a special provision.',
                zh: '诸如"入住前发现的瑕疵由房东负责维修"之类的口头约定，务必以特别条款的形式记录下来。',
                vi: 'Các thỏa thuận miệng như "chủ nhà sẽ sửa chữa các hư hỏng phát hiện trước khi dọn vào" nhất định phải được ghi lại thành điều khoản đặc biệt.',
              ),
              L10nText(
                ko: '관리비 항목(전기·수도·인터넷 포함 여부)과 금액을 구체적으로 기재하세요.',
                en: 'Specify in detail the maintenance fee items (whether electricity, water, and internet are included) and the amount.',
                zh: '请具体记载管理费包含的项目（是否包含电费、水费、网络费等）及金额。',
                vi: 'Hãy ghi rõ ràng các hạng mục phí quản lý (có bao gồm điện, nước, internet hay không) và số tiền cụ thể.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '보증금 보호: 체류지변경신고와 확정일자',
          en: 'Protecting Your Deposit: Reporting a Change of Residence and Getting a Fixed Date',
          zh: '押金保护：居留地变更申报与确定日期',
          vi: 'Bảo vệ tiền đặt cọc: Khai báo thay đổi nơi cư trú và xin ngày xác định',
        ),
        summary: L10nText(
          ko: '외국인은 주민등록 전입신고 대신 체류지변경신고를 하고, 임대차계약서에 확정일자를 받아야 보증금에 대한 법적 보호(대항력·우선변제권)를 얻습니다.',
          en: 'Foreigners must file a report of change of residence (instead of a resident registration move-in report) and obtain a fixed date on the lease agreement in order to gain legal protection for their deposit — the right of opposability and the priority repayment right.',
          zh: '外国人应办理居留地变更申报（而非韩国国民的居民登记迁入申报），并在租赁合同上取得确定日期，才能获得对押金的法律保护（对抗力、优先受偿权）。',
          vi: 'Người nước ngoài cần khai báo thay đổi nơi cư trú (thay vì khai báo chuyển đến cư trú theo đăng ký thường trú) và xin ngày xác định trên hợp đồng thuê nhà thì mới được bảo vệ pháp lý đối với tiền đặt cọc (hiệu lực đối kháng, quyền được ưu tiên hoàn trả).',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '두 가지 요건을 모두 갖춰야 하는 이유',
              en: 'Why You Need Both Requirements',
              zh: '为何两个条件缺一不可',
              vi: 'Lý do cần đáp ứng đủ cả hai điều kiện',
            ),
            bullets: [
              L10nText(
                ko: '대항력: 이사 + 체류지변경신고를 마친 다음 날부터 발생',
                en: 'Right of opposability: Takes effect the day after you have moved in and completed the change-of-residence report',
                zh: '对抗力：自搬入并完成居留地变更申报的次日起生效',
                vi: 'Hiệu lực đối kháng: Phát sinh từ ngày hôm sau khi hoàn tất việc chuyển đến ở và khai báo thay đổi nơi cư trú',
              ),
              L10nText(
                ko: '우선변제권: 대항력 + 확정일자를 모두 갖춰야 발생, 경매·매매 시 순위대로 보증금을 우선 돌려받을 수 있습니다.',
                en: 'Priority repayment right: Arises only when you have both the right of opposability and a fixed date; in the event of an auction or sale, it allows you to recover your deposit ahead of other creditors according to your priority ranking.',
                zh: '优先受偿权：须同时具备对抗力和确定日期才能生效，在拍卖或买卖时可按顺位优先领回押金。',
                vi: 'Quyền được ưu tiên hoàn trả: Chỉ phát sinh khi có đủ cả hiệu lực đối kháng và ngày xác định, khi đấu giá hoặc mua bán tài sản, bạn có thể được ưu tiên nhận lại tiền đặt cọc theo thứ tự.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '확정일자 받는 방법',
              en: 'How to Obtain a Fixed Date',
              zh: '如何取得确定日期',
              vi: 'Cách xin ngày xác định',
            ),
            bullets: [
              L10nText(
                ko: '방법 A: 이사한 주민센터에 임대차계약서 원본 지참 방문 (체류지변경신고와 동시 처리 권장)',
                en: 'Method A: Visit the community service center of your new address with the original lease agreement (it is recommended to process this together with your change-of-residence report)',
                zh: '方法A：携带租赁合同原件前往迁入地的居民中心办理（建议与居留地变更申报同时办理）',
                vi: 'Cách A: Mang bản gốc hợp đồng thuê nhà đến trung tâm dân sự nơi chuyển đến (nên xử lý cùng lúc với khai báo thay đổi nơi cư trú)',
              ),
              L10nText(
                ko: '방법 B: 인터넷등기소(iros.go.kr)에서 온라인 신청, 24시간 가능',
                en: 'Method B: Apply online 24 hours a day through the Internet Registry Office (iros.go.kr)',
                zh: '方法B：可通过互联网登记处(iros.go.kr)在线申请，24小时均可办理',
                vi: 'Cách B: Đăng ký trực tuyến trên Văn phòng Đăng ký Internet (iros.go.kr), có thể thực hiện 24 giờ',
              ),
              L10nText(
                ko: '체류지변경신고 기한은 전입 후 15일 이내입니다 — ④체류신고 참고',
                en: 'The deadline for reporting a change of residence is within 15 days of moving in — see ④ Residence Reporting',
                zh: '居留地变更申报期限为迁入后15日内——请参考④居留申报',
                vi: 'Thời hạn khai báo thay đổi nơi cư trú là trong vòng 15 ngày kể từ khi chuyển đến — tham khảo mục ④ Khai báo cư trú',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '전세보증금 반환보증 가입',
              en: 'Enrolling in Jeonse Deposit Return Guarantee Insurance',
              zh: '投保全税押金返还保证',
              vi: 'Tham gia bảo lãnh hoàn trả tiền đặt cọc Jeonse',
            ),
            bullets: [
              L10nText(
                ko: '주택도시보증공사(HUG) 등의 전세보증금 반환보증에 가입하면 임대인이 반환하지 못해도 보증기관이 대신 지급합니다.',
                en: 'If you enroll in a Jeonse deposit return guarantee, such as one offered by the Korea Housing & Urban Guarantee Corporation (HUG), the guarantee institution will pay you even if the landlord is unable to return your deposit.',
                zh: '如果投保住宅都市保证公社(HUG)等机构提供的全税押金返还保证，即使房东无法退还押金，也会由担保机构代为支付。',
                vi: 'Nếu tham gia bảo lãnh hoàn trả tiền đặt cọc Jeonse của Tổng công ty Bảo lãnh Nhà ở và Đô thị Hàn Quốc (HUG) và các tổ chức khác, ngay cả khi chủ nhà không thể hoàn trả, tổ chức bảo lãnh sẽ chi trả thay.',
              ),
              L10nText(
                ko: '가입은 계약 초기에 가능하므로 계약과 동시에 알아보는 것이 안전합니다.',
                en: 'Enrollment is only possible early in the lease term, so it is safest to look into it as soon as you sign the contract.',
                zh: '由于只能在合同初期投保，建议在签约的同时立即咨询办理，以确保安全。',
                vi: 'Việc tham gia chỉ có thể thực hiện vào giai đoạn đầu hợp đồng, vì vậy nên tìm hiểu ngay khi ký hợp đồng để đảm bảo an toàn.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '계약 종료와 보증금 미반환 대응',
          en: 'Lease Termination and Responding to an Unreturned Deposit',
          zh: '合同终止与押金未返还的应对措施',
          vi: 'Kết thúc hợp đồng và cách xử lý khi không được hoàn trả tiền đặt cọc',
        ),
        summary: L10nText(
          ko: '계약이 끝났는데 보증금을 돌려받지 못하면 임차권등기명령을 먼저 검토하고, 전세사기 피해라면 전담 지원기관에 문의합니다.',
          en: 'If your lease has ended but you have not gotten your deposit back, first consider an order for registration of the lease right, and if you have been a victim of Jeonse fraud, contact the dedicated support agency.',
          zh: '如果合同已到期但押金尚未退还，请先考虑申请租赁权登记命令；如果是全税诈骗受害者，请联系专门的支援机构。',
          vi: 'Nếu hợp đồng đã kết thúc nhưng chưa nhận lại được tiền đặt cọc, trước tiên hãy xem xét lệnh đăng ký quyền thuê nhà; nếu là nạn nhân lừa đảo Jeonse, hãy liên hệ cơ quan hỗ trợ chuyên trách.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '임차권등기명령',
              en: 'Order for Registration of the Lease Right',
              zh: '租赁权登记命令',
              vi: 'Lệnh đăng ký quyền thuê nhà',
            ),
            bullets: [
              L10nText(
                ko: '이사를 나가야 하는데 보증금을 못 받았다면, 이사 전에 임차권등기명령을 신청해 대항력·우선변제권을 유지한 채 이사할 수 있습니다.',
                en: 'If you need to move out but have not received your deposit, you can apply for an order for registration of the lease right before moving, allowing you to move out while retaining your right of opposability and priority repayment right.',
                zh: '如果需要搬走但尚未收到押金，可以在搬家前申请租赁权登记命令，从而在保留对抗力和优先受偿权的前提下搬离。',
                vi: 'Nếu phải chuyển đi nhưng chưa nhận được tiền đặt cọc, bạn có thể đăng ký lệnh đăng ký quyền thuê nhà trước khi chuyển đi để chuyển nhà trong khi vẫn duy trì hiệu lực đối kháng và quyền được ưu tiên hoàn trả.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '전세사기 피해 지원',
              en: 'Support for Jeonse Fraud Victims',
              zh: '全税诈骗受害者支援',
              vi: 'Hỗ trợ nạn nhân lừa đảo Jeonse',
            ),
            bullets: [
              L10nText(
                ko: '주택도시보증공사(HUG) 전세피해지원센터: 1533-8119',
                en: 'Korea Housing & Urban Guarantee Corporation (HUG) Jeonse Damage Support Center: 1533-8119',
                zh: '住宅都市保证公社(HUG)全税受害支援中心：1533-8119',
                vi: 'Trung tâm hỗ trợ thiệt hại Jeonse của Tổng công ty Bảo lãnh Nhà ở và Đô thị Hàn Quốc (HUG): 1533-8119',
              ),
              L10nText(
                ko: 'HUG 경·공매 지원 콜센터: 1588-1663',
                en: 'HUG Auction/Public Sale Support Call Center: 1588-1663',
                zh: 'HUG拍卖·公卖支援呼叫中心：1588-1663',
                vi: 'Tổng đài hỗ trợ đấu giá·bán đấu giá công khai của HUG: 1588-1663',
              ),
              L10nText(
                ko: '대한법률구조공단(132)에서 무료 법률상담 가능 — ⑫상담기관 참고',
                en: 'Free legal consultation is available from the Korea Legal Aid Corporation (132) — see ⑫ Counseling Agencies',
                zh: '可拨打大韩法律救助公团(132)获得免费法律咨询——请参考⑫咨询机构',
                vi: 'Có thể tư vấn pháp lý miễn phí tại Tổng công ty Trợ giúp pháp lý Hàn Quốc (132) — tham khảo mục ⑫ Cơ quan tư vấn',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '이사 나가기 전 체크',
              en: 'Checks Before Moving Out',
              zh: '搬离前的核查事项',
              vi: 'Kiểm tra trước khi chuyển đi',
            ),
            bullets: [
              L10nText(
                ko: '관리비·공과금 정산 내역을 서면으로 남기고, 원상복구 상태를 사진으로 촬영해두세요.',
                en: 'Keep a written record of the maintenance fee and utility bill settlement, and take photos documenting the property\'s condition upon restoration.',
                zh: '请以书面形式保留管理费、公共事业费结算记录，并拍照记录房屋恢复原状的情况。',
                vi: 'Hãy lưu lại bằng văn bản việc quyết toán phí quản lý, hóa đơn tiện ích, và chụp ảnh tình trạng khôi phục nguyên trạng của căn hộ.',
              ),
              L10nText(
                ko: '보증금을 받기 전에는 열쇠·비밀번호를 넘기지 않는 것이 원칙입니다.',
                en: 'As a rule, do not hand over the keys or door lock password until you have received your deposit.',
                zh: '原则上，在收到押金之前不要交出钥匙或密码。',
                vi: 'Về nguyên tắc, không nên giao chìa khóa hoặc mật khẩu cho đến khi nhận được tiền đặt cọc.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '주거 시설 안전 수칙',
          en: 'Safety Rules for Your Home',
          zh: '居住设施安全守则',
          vi: 'Quy tắc an toàn nơi ở',
        ),
        summary: L10nText(
          ko: '화재·가스·전기 등 기본 안전 수칙을 입주 초기에 확인해두면 사고를 예방할 수 있습니다.',
          en: 'Checking basic safety rules for fire, gas, and electricity as soon as you move in can help prevent accidents.',
          zh: '在入住初期确认好防火、燃气、用电等基本安全守则，可以预防事故的发生。',
          vi: 'Nếu kiểm tra các quy tắc an toàn cơ bản về cháy nổ, ga, điện ngay khi mới chuyển vào, bạn có thể phòng ngừa tai nạn.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '입주 시 확인할 안전 설비',
              en: 'Safety Equipment to Check When Moving In',
              zh: '入住时应确认的安全设施',
              vi: 'Thiết bị an toàn cần kiểm tra khi chuyển vào',
            ),
            bullets: [
              L10nText(
                ko: '화재감지기·소화기 위치, 가스 밸브 잠금 방법, 비상구·계단 위치',
                en: 'The location of fire detectors and fire extinguishers, how to shut off the gas valve, and the location of emergency exits and stairs',
                zh: '火灾探测器、灭火器的位置，燃气阀门的关闭方法，紧急出口、楼梯的位置',
                vi: 'Vị trí đầu báo cháy, bình chữa cháy, cách khóa van ga, vị trí lối thoát hiểm, cầu thang',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '사고 발생 시',
              en: 'In Case of an Accident',
              zh: '发生事故时',
              vi: 'Khi xảy ra tai nạn',
            ),
            bullets: [
              L10nText(
                ko: '화재·가스사고: 119',
                en: 'Fire or gas accidents: Call 119',
                zh: '火灾、燃气事故：拨打119',
                vi: 'Sự cố cháy nổ, ga: Gọi 119',
              ),
              L10nText(
                ko: '시설 하자(누수, 난방 고장 등)는 임대인에게 즉시 서면(문자·카카오톡)으로 통보해 기록을 남기세요.',
                en: 'For facility defects (leaks, heating breakdowns, etc.), notify the landlord immediately in writing (text message or KakaoTalk) to keep a record.',
                zh: '如出现设施瑕疵（漏水、暖气故障等），请立即以书面形式（短信、KakaoTalk）通知房东并留存记录。',
                vi: 'Đối với hư hỏng thiết bị (rò rỉ nước, hỏng hệ thống sưởi, v.v.), hãy thông báo ngay cho chủ nhà bằng văn bản (tin nhắn, KakaoTalk) để lưu lại bằng chứng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '화재보험 가입 확인',
              en: 'Checking Fire Insurance Enrollment',
              zh: '确认是否投保火灾保险',
              vi: 'Kiểm tra việc tham gia bảo hiểm cháy nổ',
            ),
            bullets: [
              L10nText(
                ko: '일부 임대차계약은 화재보험 가입이 의무 특약으로 포함되어 있으니 계약서를 확인하세요.',
                en: 'Some lease agreements include fire insurance enrollment as a mandatory special provision, so check your contract.',
                zh: '部分租赁合同将投保火灾保险作为强制性特别条款，请务必核对合同内容。',
                vi: 'Một số hợp đồng thuê nhà có điều khoản đặc biệt bắt buộc tham gia bảo hiểm cháy nổ, vì vậy hãy kiểm tra hợp đồng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '공동주택 생활수칙',
              en: 'Rules for Living in Multi-Unit Housing',
              zh: '集体住宅生活守则',
              vi: 'Quy tắc sinh hoạt tại nhà chung cư',
            ),
            bullets: [
              L10nText(
                ko: '소음·쓰레기 배출 요일 등 공동주택 관리규약을 입주 초기에 확인해두면 이웃 갈등을 줄일 수 있습니다.',
                en: 'Checking the management rules of your multi-unit building — such as noise policies and designated trash disposal days — early on can help reduce conflicts with neighbors.',
                zh: '入住初期了解集体住宅的管理规约（如噪音规定、垃圾投放日等），有助于减少邻里矛盾。',
                vi: 'Nếu tìm hiểu quy định quản lý chung cư (như tiếng ồn, ngày đổ rác quy định) ngay từ đầu, bạn có thể giảm bớt xung đột với hàng xóm.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  8: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '교통카드 종류와 발급',
          en: 'Types of Transit Cards and How to Get One',
          zh: '交通卡种类与办理',
          vi: 'Các loại thẻ giao thông và cách phát hành',
        ),
        summary: L10nText(
          ko: '티머니·캐시비 등 선불 교통카드는 편의점에서 바로 구매할 수 있고, 외국인등록번호가 있으면 K-패스 같은 환급형 카드도 만들 수 있습니다.',
          en: 'Prepaid transit cards such as T-money and Cashbee can be bought directly at convenience stores, and if you have an Alien Registration Number, you can also get a refund-type card like K-Pass.',
          zh: '像T-money、Cashbee这样的预付交通卡可以直接在便利店购买；若持有外国人登录号码，还可以办理K-Pass等返还型交通卡。',
          vi: 'Thẻ giao thông trả trước như T-money, Cashbee có thể mua trực tiếp tại cửa hàng tiện lợi, và nếu có số đăng ký người nước ngoài, bạn cũng có thể làm thẻ hoàn tiền như K-Pass.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '선불 교통카드',
              en: 'Prepaid Transit Cards',
              zh: '预付交通卡',
              vi: 'Thẻ giao thông trả trước',
            ),
            bullets: [
              L10nText(
                ko: '편의점(CU, GS25 등)에서 카드 구매 후 현금·계좌로 충전',
                en: 'Buy the card at a convenience store (CU, GS25, etc.) and top it up with cash or a bank account',
                zh: '在便利店（CU、GS25等）购买卡片后，可用现金或银行账户充值',
                vi: 'Mua thẻ tại cửa hàng tiện lợi (CU, GS25, v.v.) sau đó nạp tiền bằng tiền mặt hoặc tài khoản ngân hàng',
              ),
              L10nText(
                ko: '모바일 티머니 앱으로도 발급·충전 가능',
                en: 'You can also issue and top up a card through the mobile T-money app',
                zh: '也可通过手机T-money应用程序办理和充值',
                vi: 'Cũng có thể phát hành và nạp tiền qua ứng dụng T-money trên điện thoại',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'K-패스 카드',
              en: 'K-Pass Card',
              zh: 'K-Pass卡',
              vi: 'Thẻ K-Pass',
            ),
            bullets: [
              L10nText(
                ko: '신용·체크·선불 카드 형태로 발급, 외국인등록번호로 회원가입 가능',
                en: 'Issued as a credit, debit, or prepaid card; you can sign up for membership using your Alien Registration Number',
                zh: '可办理为信用卡、借记卡或预付卡形式，可使用外国人登录号码注册会员',
                vi: 'Được phát hành dưới dạng thẻ tín dụng, thẻ ghi nợ hoặc thẻ trả trước, có thể đăng ký thành viên bằng số đăng ký người nước ngoài',
              ),
              L10nText(
                ko: 'K-패스 홈페이지·앱(korea-pass.kr)에서 카드 등록',
                en: 'Register your card on the K-Pass website or app (korea-pass.kr)',
                zh: '可在K-Pass网站或应用程序(korea-pass.kr)上登记卡片',
                vi: 'Đăng ký thẻ trên trang web hoặc ứng dụng K-Pass (korea-pass.kr)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '지역별 특화 카드',
              en: 'Region-Specific Cards',
              zh: '地区特色交通卡',
              vi: 'Thẻ đặc thù theo khu vực',
            ),
            bullets: [
              L10nText(
                ko: '일부 지자체는 K-패스를 기반으로 추가 환급 혜택을 주는 자체 카드를 운영합니다(예: 경기패스, 인천 I-패스 등).',
                en: 'Some local governments operate their own cards, built on top of K-Pass, that offer additional refund benefits (e.g., Gyeonggi Pass, Incheon I-Pass).',
                zh: '部分地方政府在K-Pass的基础上运营自有卡片，提供额外的返还优惠（如京畿Pass、仁川I-Pass等）。',
                vi: 'Một số chính quyền địa phương vận hành thẻ riêng dựa trên nền tảng K-Pass, cung cấp thêm ưu đãi hoàn tiền (ví dụ: Gyeonggi Pass, Incheon I-Pass, v.v.).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: 'K-패스 활용법',
          en: 'How to Use K-Pass',
          zh: 'K-Pass使用方法',
          vi: 'Cách sử dụng K-Pass',
        ),
        summary: L10nText(
          ko: '월 15회 이상 대중교통을 이용하면 지출액의 일부를 다음 달에 환급받는 제도로, 매달 자동 정산됩니다.',
          en: 'If you use public transportation 15 or more times a month, you get part of your spending refunded the following month; the amount is automatically calculated each month.',
          zh: '每月使用公共交通15次以上，可在次月获得部分支出的返还，每月自动结算。',
          vi: 'Đây là chế độ hoàn lại một phần chi phí vào tháng sau nếu sử dụng phương tiện công cộng từ 15 lần trở lên trong tháng, được tự động quyết toán hàng tháng.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '이용 방법',
              en: 'How to Use It',
              zh: '使用方法',
              vi: 'Cách sử dụng',
            ),
            bullets: [
              L10nText(
                ko: 'K-패스 홈페이지·앱 회원가입 후 보유 교통카드 번호 등록',
                en: 'Sign up for membership on the K-Pass website or app, then register the number of your existing transit card',
                zh: '在K-Pass网站或应用程序注册会员后，登记您现有交通卡的卡号',
                vi: 'Đăng ký thành viên trên trang web hoặc ứng dụng K-Pass, sau đó đăng ký số thẻ giao thông đang sở hữu',
              ),
              L10nText(
                ko: '월 15회 이상 대중교통 이용 시 초과분에 대해 환급 적용',
                en: 'When you use public transportation 15 or more times in a month, the refund applies to the portion beyond the threshold',
                zh: '每月使用公共交通达15次以上时，超出部分将享受返还',
                vi: 'Khi sử dụng phương tiện công cộng từ 15 lần trở lên trong tháng, phần vượt quá sẽ được áp dụng hoàn tiền',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '지역별·연령별로 환급 비율이 다를 수 있으므로 앱에서 본인 조건을 확인하세요.',
                en: 'Refund rates may differ by region and age group, so check your own eligibility conditions in the app.',
                zh: '各地区、各年龄段的返还比例可能有所不同，请在应用程序中确认自身条件。',
                vi: 'Tỷ lệ hoàn tiền có thể khác nhau theo khu vực và độ tuổi, vì vậy hãy kiểm tra điều kiện của bản thân trên ứng dụng.',
              ),
              L10nText(
                ko: '기존 기후동행카드 이용자는 K-패스 제휴 카드로 별도 전환·등록이 필요합니다.',
                en: 'Existing Climate Card users need to separately switch to and register a K-Pass partner card.',
                zh: '现有的气候同行卡用户需要另行转换并登记为K-Pass合作卡。',
                vi: 'Người dùng thẻ Climate Card hiện tại cần chuyển đổi và đăng ký riêng sang thẻ liên kết K-Pass.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '환급률',
              en: 'Refund Rates',
              zh: '返还比例',
              vi: 'Tỷ lệ hoàn tiền',
            ),
            bullets: [
              L10nText(
                ko: '일반(만 19세 이상): 20%, 청년(만 19~34세, 경기·인천은 만 39세까지): 30%, 저소득층(기초생활수급자·차상위계층): 53%',
                en: 'General (age 19 and over): 20%; Youth (age 19–34, up to age 39 in Gyeonggi and Incheon): 30%; Low-income (basic livelihood recipients and near-poverty households): 53%',
                zh: '一般人群（满19周岁以上）：20%；青年（满19~34周岁，京畿道、仁川市可至满39周岁）：30%；低收入群体（基础生活保障对象、次贫困阶层）：53%',
                vi: 'Đối tượng thông thường (từ 19 tuổi trở lên): 20%; Thanh niên (19-34 tuổi, riêng Gyeonggi, Incheon áp dụng đến 39 tuổi): 30%; Hộ thu nhập thấp (đối tượng hưởng trợ cấp sinh hoạt cơ bản, hộ cận nghèo): 53%',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '대중교통 이용법',
          en: 'How to Use Public Transportation',
          zh: '公共交通使用方法',
          vi: 'Cách sử dụng phương tiện giao thông công cộng',
        ),
        summary: L10nText(
          ko: '버스·지하철 모두 교통카드 태그로 환승 할인이 자동 적용되며, 하차 시에도 반드시 태그해야 정확한 요금이 계산됩니다.',
          en: 'On both buses and the subway, transfer discounts are applied automatically when you tag your transit card, and you must also tag when getting off to ensure the correct fare is calculated.',
          zh: '无论是公交车还是地铁，刷交通卡都会自动享受换乘优惠，下车时也必须刷卡，才能准确计算车费。',
          vi: 'Cả xe buýt và tàu điện ngầm đều tự động áp dụng giảm giá chuyển tuyến khi quẹt thẻ giao thông, và khi xuống xe cũng phải quẹt thẻ để tính đúng cước phí.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '환승 이용 원칙',
              en: 'Transfer Rules',
              zh: '换乘使用原则',
              vi: 'Nguyên tắc chuyển tuyến',
            ),
            bullets: [
              L10nText(
                ko: '하차 시 미태그 시 다음 탑승에서 기본요금이 다시 부과될 수 있습니다.',
                en: 'If you forget to tag when getting off, the base fare may be charged again on your next ride.',
                zh: '如果下车时未刷卡，下次乘车时可能会重新收取起步价。',
                vi: 'Nếu quên quẹt thẻ khi xuống xe, cước phí cơ bản có thể bị tính lại ở lượt lên xe tiếp theo.',
              ),
              L10nText(
                ko: '환승 인정 시간과 횟수는 지역마다 다르므로 지자체 대중교통 안내를 확인하세요.',
                en: 'The time limit and number of transfers allowed vary by region, so check your local government\'s public transportation guidelines.',
                zh: '各地区认可的换乘时间和次数不同，请查询当地政府的公共交通指南。',
                vi: 'Thời gian và số lần chuyển tuyến được công nhận khác nhau tùy khu vực, hãy kiểm tra hướng dẫn giao thông công cộng của chính quyền địa phương.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '노선 확인',
              en: 'Checking Routes',
              zh: '路线查询',
              vi: 'Kiểm tra tuyến đường',
            ),
            bullets: [
              L10nText(
                ko: '네이버지도·카카오맵·각 지역 버스정보시스템(BIS) 앱에서 실시간 도착 정보 확인 가능',
                en: 'Real-time arrival information can be checked on Naver Map, Kakao Map, and each region\'s Bus Information System (BIS) app',
                zh: '可在Naver地图、Kakao地图及各地区公交信息系统(BIS)应用程序中查询实时到站信息',
                vi: 'Có thể kiểm tra thông tin đến bến theo thời gian thực trên Naver Map, Kakao Map và ứng dụng Hệ thống thông tin xe buýt (BIS) của từng khu vực',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '버스전용차로와 환승센터',
              en: 'Bus-Only Lanes and Transfer Centers',
              zh: '公交专用车道与换乘中心',
              vi: 'Làn đường dành riêng cho xe buýt và trung tâm chuyển tuyến',
            ),
            bullets: [
              L10nText(
                ko: '광역버스 전용차로, BRT(간선급행버스) 등을 이용하면 출퇴근 시간을 줄일 수 있습니다.',
                en: 'Using intercity bus-only lanes and BRT (Bus Rapid Transit) services can reduce your commuting time.',
                zh: '利用广域公交专用车道、BRT（干线快速公交）等，可以缩短通勤时间。',
                vi: 'Sử dụng làn đường dành riêng cho xe buýt liên vùng, BRT (xe buýt nhanh trục chính) có thể giúp giảm thời gian đi làm.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '외국면허 국내면허 교환: 대상과 서류',
          en: 'Converting a Foreign License to a Korean License: Eligibility and Documents',
          zh: '外国驾照换领韩国驾照：对象与所需材料',
          vi: 'Đổi bằng lái nước ngoài sang bằng lái Hàn Quốc: Đối tượng và hồ sơ',
        ),
        summary: L10nText(
          ko: '본국과 한국 사이에 운전면허 상호인정 협약이 체결되어 있는지에 따라 필요한 절차가 크게 달라집니다.',
          en: 'The procedure required differs significantly depending on whether a driver\'s license mutual recognition agreement has been signed between your home country and Korea.',
          zh: '所需的办理程序会因本国是否与韩国签订驾照互认协议而有很大差异。',
          vi: 'Thủ tục cần thiết sẽ khác nhau rất nhiều tùy theo việc nước sở tại có ký hiệp định công nhận lẫn nhau về giấy phép lái xe với Hàn Quốc hay không.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '공통 필요서류',
              en: 'Documents Required for All Applicants',
              zh: '通用所需材料',
              vi: 'Hồ sơ chung cần thiết',
            ),
            bullets: [
              L10nText(
                ko: '여권, 외국인등록증(ARC), 외국면허증 원본, 6개월 이내 촬영한 규격사진, 출입국사실증명서',
                en: 'Passport, Alien Registration Card (ARC), original foreign driver\'s license, a standard ID photo taken within the last 6 months, and a certificate of entry/exit facts',
                zh: '护照、外国人登录证(ARC)、外国驾照原件、6个月内拍摄的规格照片、出入境事实证明书',
                vi: 'Hộ chiếu, Thẻ đăng ký người nước ngoài (ARC), bằng lái nước ngoài bản gốc, ảnh thẻ chụp trong vòng 6 tháng, giấy chứng nhận xuất nhập cảnh',
              ),
              L10nText(
                ko: '면허증에 대한 아포스티유 인증서 또는 대사관 확인서(국가별로 상이)',
                en: 'An apostille certificate or embassy confirmation letter for your license (requirements vary by country)',
                zh: '驾照的海牙认证书或大使馆确认书（因国家而异）',
                vi: 'Giấy chứng nhận Apostille hoặc giấy xác nhận của đại sứ quán đối với bằng lái (khác nhau tùy quốc gia)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '협약체결국 vs 미체결국',
              en: 'Agreement Countries vs. Non-Agreement Countries',
              zh: '协议缔结国与非缔结国',
              vi: 'Quốc gia đã ký hiệp định và quốc gia chưa ký hiệp định',
            ),
            bullets: [
              L10nText(
                ko: '협약체결국(한국면허 인정국) 면허: 서류심사 + 적성검사(신체검사)만으로 교환 가능',
                en: 'Licenses from agreement countries (countries that recognize Korean licenses): Can be converted with just document screening and an aptitude test (physical exam)',
                zh: '协议缔结国（认可韩国驾照的国家）驾照：只需材料审查和适性检查（体检）即可换领',
                vi: 'Bằng lái của quốc gia đã ký hiệp định (quốc gia công nhận bằng lái Hàn Quốc): Chỉ cần thẩm tra hồ sơ và kiểm tra năng lực thích ứng (khám sức khỏe) là có thể đổi bằng',
              ),
              L10nText(
                ko: '협약 미체결국 면허: 적성검사 + 학과시험(객관식 40문항, 한국어·영어·중국어·베트남어 중 선택) 응시 필요',
                en: 'Licenses from non-agreement countries: Require an aptitude test plus a written exam (40 multiple-choice questions, available in Korean, English, Chinese, or Vietnamese)',
                zh: '非协议缔结国驾照：需参加适性检查及学科考试（40道客观题，可选韩语、英语、中文、越南语作答）',
                vi: 'Bằng lái của quốc gia chưa ký hiệp định: Cần kiểm tra năng lực thích ứng và thi lý thuyết (40 câu trắc nghiệm, được chọn tiếng Hàn, tiếng Anh, tiếng Trung hoặc tiếng Việt)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '국제운전면허증과의 차이',
              en: 'Difference from an International Driving Permit',
              zh: '与国际驾照的区别',
              vi: 'Sự khác biệt với bằng lái xe quốc tế',
            ),
            bullets: [
              L10nText(
                ko: '국제운전면허증은 발급일로부터 1년만 유효합니다.',
                en: 'An International Driving Permit is valid for only 1 year from the date of issue.',
                zh: '国际驾照自签发之日起仅一年内有效。',
                vi: 'Bằng lái xe quốc tế chỉ có hiệu lực trong 1 năm kể từ ngày cấp.',
              ),
              L10nText(
                ko: '한국에 1년 이상 체류하며 운전하려면 국제운전면허증이 아니라 반드시 국내면허로 교환해야 합니다.',
                en: 'If you plan to stay in Korea for 1 year or more and drive, you must convert to a Korean license instead of relying on an International Driving Permit.',
                zh: '如果计划在韩居留一年以上并需要开车，必须换领韩国国内驾照，而不能仅凭国际驾照。',
                vi: 'Nếu lưu trú tại Hàn Quốc từ 1 năm trở lên và có nhu cầu lái xe, bạn bắt buộc phải đổi sang bằng lái trong nước chứ không thể chỉ dùng bằng lái xe quốc tế.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '외국면허 국내면허 교환: 절차와 유의사항',
          en: 'Converting a Foreign License to a Korean License: Procedure and Notes',
          zh: '外国驾照换领韩国驾照：办理程序与注意事项',
          vi: 'Đổi bằng lái nước ngoài sang bằng lái Hàn Quốc: Quy trình và lưu ý',
        ),
        summary: L10nText(
          ko: '신청은 전국 운전면허시험장 또는 경찰서 민원실에서 접수하며, 신체검사료 등 소정의 수수료가 발생합니다.',
          en: 'Applications are accepted at driver\'s license test centers or police station civil affairs offices nationwide, and a set fee, including a physical exam fee, applies.',
          zh: '可在全国各地的驾照考试场或警察署民愿室提交申请，需缴纳体检费等一定费用。',
          vi: 'Có thể nộp đơn tại trung tâm sát hạch bằng lái xe hoặc phòng dân nguyện của đồn cảnh sát trên toàn quốc, và sẽ phát sinh một khoản phí nhất định như phí khám sức khỏe.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '신청 절차',
              en: 'Application Procedure',
              zh: '申请流程',
              vi: 'Quy trình đăng ký',
            ),
            bullets: [
              L10nText(
                ko: '도로교통공단 안전운전 통합민원(safedriving.or.kr)에서 사전예약 후 방문 권장',
                en: 'It is recommended to make a reservation in advance through the Korea Road Traffic Authority\'s Integrated Civil Service for Safe Driving (safedriving.or.kr) before visiting',
                zh: '建议先通过道路交通公团安全驾驶综合民愿网站(safedriving.or.kr)预约后再前往办理',
                vi: 'Nên đặt lịch hẹn trước qua trang Dân nguyện tổng hợp lái xe an toàn của Cơ quan An toàn Giao thông Đường bộ Hàn Quốc (safedriving.or.kr) trước khi đến',
              ),
              L10nText(
                ko: '접수 → 서류심사 → 적성검사(신체검사) → (미체결국은 학과시험) → 면허증 발급',
                en: 'Application → document screening → aptitude test (physical exam) → (written exam for non-agreement countries) → license issuance',
                zh: '受理 → 材料审查 → 适性检查（体检）→（非协议国需参加学科考试）→ 发放驾照',
                vi: 'Nộp hồ sơ → thẩm tra hồ sơ → kiểm tra năng lực thích ứng (khám sức khỏe) → (thi lý thuyết đối với quốc gia chưa ký hiệp định) → cấp bằng lái',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '수수료 및 참고',
              en: 'Fees and Notes',
              zh: '费用及参考事项',
              vi: 'Lệ phí và tham khảo',
            ),
            bullets: [
              L10nText(
                ko: '신체검사료: 1종 대형·특수면허 8,000원, 그 외 면허 7,000원 (2026년 기준, 매년 변동 가능)',
                en: 'Physical exam fee: 8,000 won for Class 1 large/special vehicle licenses, 7,000 won for other licenses (as of 2026; subject to change annually)',
                zh: '体检费：1种大型·特殊驾照8,000韩元，其他驾照7,000韩元（以2026年为准，每年可能变动）',
                vi: 'Phí khám sức khỏe: 8.000 won đối với bằng lái hạng 1 loại lớn, đặc biệt, 7.000 won đối với các loại bằng lái khác (tính đến năm 2026, có thể thay đổi hàng năm)',
              ),
              L10nText(
                ko: '국가별 정확한 필요서류는 도로교통공단 안전운전 통합민원에서 확인하는 것이 가장 정확합니다.',
                en: 'For the exact documents required for your country, the most accurate source is the Korea Road Traffic Authority\'s Integrated Civil Service for Safe Driving.',
                zh: '各国具体所需材料，以道路交通公团安全驾驶综合民愿网站的信息为准，最为准确。',
                vi: 'Để biết chính xác hồ sơ cần thiết theo từng quốc gia, nên kiểm tra tại Dân nguyện tổng hợp lái xe an toàn của Cơ quan An toàn Giao thông Đường bộ Hàn Quốc là chính xác nhất.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '면허 갱신·적성검사',
              en: 'License Renewal and Aptitude Tests',
              zh: '驾照更新与适性检查',
              vi: 'Gia hạn bằng lái và kiểm tra năng lực thích ứng',
            ),
            bullets: [
              L10nText(
                ko: '국내면허 취득 후에도 면허 종류에 따라 정기적으로 적성검사를 받아야 면허가 유지됩니다.',
                en: 'Even after obtaining a Korean license, you must periodically undergo an aptitude test, depending on the license type, to keep it valid.',
                zh: '即使取得韩国国内驾照后，根据驾照种类不同，仍需定期接受适性检查，驾照才能维持有效。',
                vi: 'Ngay cả sau khi có bằng lái trong nước, tùy loại bằng lái mà bạn vẫn phải định kỳ kiểm tra năng lực thích ứng thì bằng lái mới được duy trì.',
              ),
              L10nText(
                ko: '적성검사 기간을 넘기면 면허가 취소될 수 있으니 갱신 안내를 놓치지 마세요.',
                en: 'If you miss the aptitude test deadline, your license may be revoked, so do not miss the renewal notice.',
                zh: '如果错过适性检查期限，驾照可能会被吊销，请务必留意更新通知。',
                vi: 'Nếu quá thời hạn kiểm tra năng lực thích ứng, bằng lái có thể bị thu hồi, vì vậy đừng bỏ lỡ thông báo gia hạn.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
};
