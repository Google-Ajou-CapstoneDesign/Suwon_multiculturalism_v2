import '../../../core/app_language.dart';
import 'category_detail.dart';

const Map<int, CategoryDetail> categoryDetailDataA = {
  1: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: 'ARC 개요 & 법정 발급 의무',
          en: 'ARC Overview & Legal Obligation to Register',
          zh: 'ARC 概览与法定登记义务',
          vi: 'Tổng quan về ARC & Nghĩa vụ đăng ký theo luật định',
        ),
        summary: L10nText(
          ko: '대한민국에 90일을 초과하여 체류하는 모든 외국인은 입국 후 90일 이내에 외국인등록을 마쳐야 하며, 이는 모든 한국 생활 행정의 출발점입니다.',
          en: 'Any foreigner staying in the Republic of Korea for more than 90 days must complete alien registration within 90 days of entry — this is the starting point for all administrative procedures in life in Korea.',
          zh: '在大韩民国停留超过90天的所有外国人,必须在入境后90天内完成外国人登录,这是在韩国生活中一切行政事务的起点。',
          vi: 'Mọi người nước ngoài lưu trú tại Hàn Quốc quá 90 ngày phải hoàn tất đăng ký người nước ngoài trong vòng 90 ngày kể từ ngày nhập cảnh — đây là bước khởi đầu cho mọi thủ tục hành chính trong đời sống tại Hàn Quốc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '외국인등록증(ARC)이란',
              en: 'What Is the Alien Registration Card (ARC)',
              zh: '什么是外国人登录证(ARC)',
              vi: 'Thẻ đăng ký người nước ngoài (ARC) là gì',
            ),
            bullets: [
              L10nText(
                ko: '<b>정의:</b> 출입국관리법 제31조에 따라 장기 체류 외국인에게 발급되는 법적 공인 신분증',
                en: '<b>Definition:</b> An officially recognized legal ID card issued to long-term foreign residents under Article 31 of the Immigration Control Act',
                zh: '<b>定义:</b> 根据《出入境管理法》第31条,向长期滞留外国人颁发的法定官方身份证件',
                vi: '<b>Định nghĩa:</b> Thẻ nhận dạng pháp lý chính thức được cấp cho người nước ngoài cư trú dài hạn theo Điều 31 Luật Quản lý xuất nhập cảnh',
              ),
              L10nText(
                ko: '<b>역할:</b> 내국인의 주민등록증과 동일한 효력을 가지며 한국 내 합법적 신분 증명',
                en: '<b>Role:</b> Carries the same legal effect as a Korean citizen\'s resident registration card and proves legal status in Korea',
                zh: '<b>作用:</b> 与韩国国民的居民登录证具有同等效力,用于证明在韩国境内的合法身份',
                vi: '<b>Vai trò:</b> Có hiệu lực tương đương thẻ đăng ký cư trú của công dân Hàn Quốc, dùng để chứng minh tư cách cư trú hợp pháp tại Hàn Quốc',
              ),
              L10nText(
                ko: '<b>필수성:</b> 은행 계좌 개설, 휴대폰 개통, 건강보험 가입, 근로계약에 모두 필요',
                en: '<b>Necessity:</b> Required for opening a bank account, activating a mobile phone, enrolling in health insurance, and signing an employment contract',
                zh: '<b>必要性:</b> 开设银行账户、办理手机开通、加入健康保险、签订劳动合同均需使用',
                vi: '<b>Tính cần thiết:</b> Cần thiết để mở tài khoản ngân hàng, đăng ký thuê bao điện thoại, tham gia bảo hiểm y tế và ký hợp đồng lao động',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '법정 신청 기한과 불이익',
              en: 'Statutory Application Deadline and Penalties',
              zh: '法定申请期限与处罚',
              vi: 'Thời hạn đăng ký theo luật định và bất lợi khi vi phạm',
            ),
            bullets: [
              L10nText(
                ko: '<b>신청 기한:</b> 입국한 날부터 90일 이내 (입국 당일 포함)',
                en: '<b>Application deadline:</b> Within 90 days of the date of entry (the day of entry is included)',
                zh: '<b>申请期限:</b> 自入境之日起90天内(含入境当天)',
                vi: '<b>Thời hạn đăng ký:</b> Trong vòng 90 ngày kể từ ngày nhập cảnh (tính cả ngày nhập cảnh)',
              ),
              L10nText(
                ko: '<b>기한 초과 시:</b> 출입국관리법 위반으로 최대 1,000만 원 이하 과태료 및 비자 연장 불이익',
                en: '<b>If the deadline is missed:</b> This is a violation of the Immigration Control Act, resulting in a fine of up to KRW 10,000,000 and disadvantages when extending your visa',
                zh: '<b>逾期未办理时:</b> 属于违反《出入境管理法》,最高可处1,000万韩元以下罚款,并对签证延期产生不利影响',
                vi: '<b>Nếu quá thời hạn:</b> Bị coi là vi phạm Luật Quản lý xuất nhập cảnh, có thể bị phạt tiền tối đa 10.000.000 won và gặp bất lợi khi gia hạn visa',
              ),
              L10nText(
                ko: '<b>예외 대상:</b> 90일 이하 단기 체류자(C-3 등), 외교·공무·협정 체류자격 소지자',
                en: '<b>Exceptions:</b> Short-term stayers of 90 days or less (e.g. C-3), and holders of diplomatic, official, or agreement status of stay',
                zh: '<b>例外对象:</b> 90天以内的短期滞留者(如C-3等)、持有外交·公务·协定滞留资格者',
                vi: '<b>Đối tượng ngoại lệ:</b> Người lưu trú ngắn hạn từ 90 ngày trở xuống (như C-3...), người có tư cách lưu trú ngoại giao, công vụ, hiệp định',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '입국 후 가장 먼저 처리해야 하는 이유',
              en: 'Why This Should Be Your First Task After Entering Korea',
              zh: '为何应在入境后第一时间办理',
              vi: 'Lý do cần xử lý đầu tiên sau khi nhập cảnh',
            ),
            bullets: [
              L10nText(
                ko: '순서: 입국 → 방문예약 → ARC 신청·접수증 수령 → 통신 개통 & 계좌 개설',
                en: 'Order: Entry → Visit reservation → ARC application & receipt of application slip → Mobile phone activation & bank account opening',
                zh: '顺序:入境 → 预约到访 → 申请ARC并领取受理证 → 开通通讯 & 开设账户',
                vi: 'Trình tự: Nhập cảnh → Đặt lịch hẹn → Nộp hồ sơ ARC và nhận biên nhận → Đăng ký thuê bao điện thoại & mở tài khoản ngân hàng',
              ),
              L10nText(
                ko: 'ARC 접수증(임시 신분증)이 나와야 통신사 본인인증(PASS)과 은행 계좌 개설이 가능합니다.',
                en: 'You need the ARC application receipt (a temporary ID) before you can complete mobile carrier identity verification (PASS) or open a bank account.',
                zh: '只有拿到ARC受理证(临时身份证明)后,才能进行通讯运营商实名认证(PASS)和开设银行账户。',
                vi: 'Chỉ khi có biên nhận ARC (giấy tờ tùy thân tạm thời) thì mới có thể xác thực danh tính qua nhà mạng (PASS) và mở tài khoản ngân hàng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '온라인으로 미리 확인할 수 있는 것',
              en: 'What You Can Check Online in Advance',
              zh: '可提前在线查询的事项',
              vi: 'Những gì có thể kiểm tra trước qua mạng',
            ),
            bullets: [
              L10nText(
                ko: '하이코리아에서 본인의 관할 출입국·외국인관서를 도로명 주소로 미리 조회할 수 있습니다.',
                en: 'On HiKorea, you can look up your jurisdiction\'s immigration and foreigner office in advance by entering your road-name address.',
                zh: '可以在HiKorea网站上,通过输入道路名地址提前查询自己所属的出入境·外国人厅(事务所)。',
                vi: 'Bạn có thể tra cứu trước văn phòng xuất nhập cảnh và người nước ngoài quản lý khu vực của mình trên trang HiKorea bằng cách nhập địa chỉ theo tên đường.',
              ),
              L10nText(
                ko: '접수증을 받은 뒤에도 하이코리아 [증명서 발급]에서 외국인등록 사실증명을 온라인으로 뗄 수 있습니다.',
                en: 'Even after receiving the application receipt, you can print a certificate of alien registration online through HiKorea\'s [Certificate Issuance] menu.',
                zh: '领取受理证后,也可以在HiKorea的[证明文件签发]菜单中在线打印外国人登录事实证明。',
                vi: 'Sau khi nhận biên nhận, bạn vẫn có thể xin cấp trực tuyến giấy xác nhận đăng ký người nước ngoài qua mục [Cấp giấy chứng nhận] trên HiKorea.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '발급 신청 필수 서류 & 체류지 증빙 가이드',
          en: 'Required Application Documents & Proof-of-Residence Guide',
          zh: '申请所需材料与居所证明指南',
          vi: 'Hồ sơ bắt buộc khi đăng ký & Hướng dẫn chứng minh nơi cư trú',
        ),
        summary: L10nText(
          ko: '여권, 사진, 통합신청서, 수수료와 함께 반려율이 가장 높은 체류지 입증 서류를 미리 준비해야 합니다.',
          en: 'Along with your passport, photo, integrated application form, and fee, you should prepare in advance the proof-of-residence documents that most often cause applications to be rejected.',
          zh: '除护照、照片、综合申请书和手续费外,还应提前准备驳回率最高的居所证明文件。',
          vi: 'Ngoài hộ chiếu, ảnh, đơn đăng ký tổng hợp và lệ phí, bạn cần chuẩn bị trước giấy tờ chứng minh nơi cư trú — hạng mục có tỷ lệ bị trả hồ sơ cao nhất.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '공통 필수 제출 서류',
              en: 'Common Required Documents',
              zh: '共同必需提交材料',
              vi: 'Hồ sơ bắt buộc chung',
            ),
            bullets: [
              L10nText(
                ko: '여권 원본 및 사본 (유효기간 남은 실물)',
                en: 'Original passport and a copy (must be physically valid, with remaining validity)',
                zh: '护照原件及复印件(须为有效期内的实物护照)',
                vi: 'Hộ chiếu gốc và bản sao (hộ chiếu thật còn hạn sử dụng)',
              ),
              L10nText(
                ko: '통합신청서: 출입국관리법 시행규칙 [별지 제34호 서식] (외국인등록 체크)',
                en: 'Integrated application form: Enforcement Rules of the Immigration Control Act [Attached Form No. 34] (check the "Alien Registration" box)',
                zh: '综合申请书:《出入境管理法施行规则》[附表第34号格式](勾选外国人登录项)',
                vi: 'Đơn đăng ký tổng hợp: Mẫu số 34 theo Quy tắc thi hành Luật Quản lý xuất nhập cảnh (đánh dấu mục đăng ký người nước ngoài)',
              ),
              L10nText(
                ko: '표준규격 사진 1매: 최근 6개월 이내 촬영, 흰색 배경 (3.5cm × 4.5cm)',
                en: '1 standard-size photo: taken within the last 6 months, white background (3.5cm × 4.5cm)',
                zh: '标准规格照片1张:近6个月内拍摄,白色背景(3.5cm × 4.5cm)',
                vi: '1 ảnh cỡ chuẩn: chụp trong vòng 6 tháng gần nhất, nền trắng (3.5cm × 4.5cm)',
              ),
              L10nText(
                ko: '발급 수수료: 30,000원 (현금 또는 관서 내 수입인지·ATM 결제)',
                en: 'Issuance fee: KRW 30,000 (cash, or revenue stamp/ATM payment at the office)',
                zh: '签发手续费:30,000韩元(现金,或在机构内以印花税票·ATM支付)',
                vi: 'Lệ phí cấp thẻ: 30.000 won (tiền mặt, hoặc mua tem lệ phí/thanh toán qua ATM tại văn phòng)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '체류지 입증 서류 (반려 방지 핵심)',
              en: 'Proof-of-Residence Documents (Key to Avoiding Rejection)',
              zh: '居所证明文件(避免驳回的关键)',
              vi: 'Giấy tờ chứng minh nơi cư trú (yếu tố then chốt để tránh bị trả hồ sơ)',
            ),
            bullets: [
              L10nText(
                ko: '자취·임대차: 본인 명의 임대차계약서 사본',
                en: 'Living alone / renting: a copy of the lease agreement in your own name',
                zh: '独自租房居住:以本人名义签订的租赁合同复印件',
                vi: 'Thuê nhà ở riêng: bản sao hợp đồng thuê nhà đứng tên bản thân',
              ),
              L10nText(
                ko: '회사 기숙사: 숙소제공확인서 + 사업주 임대차계약서 또는 등기부등본 사본',
                en: 'Company dormitory: a housing-provision confirmation letter + a copy of the employer\'s lease agreement or property register',
                zh: '公司宿舍:住宿提供确认书 + 雇主的租赁合同或不动产登记簿誊本复印件',
                vi: 'Ký túc xá công ty: giấy xác nhận cung cấp chỗ ở + bản sao hợp đồng thuê nhà của chủ sử dụng lao động hoặc giấy chứng nhận đăng ký bất động sản',
              ),
              L10nText(
                ko: '학교 기숙사: 기숙사 입주확인서 또는 기숙사비 납입영수증',
                en: 'School dormitory: a dormitory residence confirmation letter or a dormitory fee payment receipt',
                zh: '学校宿舍:宿舍入住确认书或宿舍费缴纳收据',
                vi: 'Ký túc xá trường học: giấy xác nhận ở ký túc xá hoặc biên lai nộp phí ký túc xá',
              ),
              L10nText(
                ko: '타인 거주지: 거주·숙소제공확인서 + 제공자 신분증·임대차계약서 사본',
                en: 'Residing at another person\'s home: a residence/housing-provision confirmation letter + a copy of the provider\'s ID and lease agreement',
                zh: '寄居他人住所:居住·住宿提供确认书 + 提供者身份证及租赁合同复印件',
                vi: 'Ở nhờ nhà người khác: giấy xác nhận cư trú/cung cấp chỗ ở + bản sao giấy tờ tùy thân và hợp đồng thuê nhà của người cho ở',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '체류자격(비자)별 추가 서류',
              en: 'Additional Documents by Status of Stay (Visa Type)',
              zh: '按滞留资格(签证类型)划分的补充材料',
              vi: 'Hồ sơ bổ sung theo từng loại tư cách lưu trú (visa)',
            ),
            bullets: [
              L10nText(
                ko: 'E-9(비전문취업): 사업자등록증 사본, 표준근로계약서 사본',
                en: 'E-9 (Non-professional Employment): a copy of the business registration certificate, a copy of the standard labor contract',
                zh: 'E-9(非专门就业):营业执照复印件、标准劳动合同复印件',
                vi: 'E-9 (Lao động phổ thông): bản sao giấy đăng ký kinh doanh, bản sao hợp đồng lao động chuẩn',
              ),
              L10nText(
                ko: 'D-2·D-4(유학·어학연수): 표준입학허가서 또는 재학증명서',
                en: 'D-2/D-4 (Study Abroad/Language Training): a standard certificate of admission or certificate of enrollment',
                zh: 'D-2·D-4(留学·语言研修):标准入学许可书或在学证明',
                vi: 'D-2/D-4 (Du học/Du học tiếng): giấy phép nhập học chuẩn hoặc giấy xác nhận đang theo học',
              ),
              L10nText(
                ko: 'H-2(방문취업): 취업교육 이수증 (취업 예정자인 경우)',
                en: 'H-2 (Working Visit): a certificate of completion of employment training (if you plan to be employed)',
                zh: 'H-2(访问就业):就业教育结业证(拟就业者需提供)',
                vi: 'H-2 (Thăm thân kết hợp làm việc): giấy chứng nhận hoàn thành đào tạo việc làm (nếu dự định đi làm)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '반려되는 흔한 사유',
              en: 'Common Reasons for Rejection',
              zh: '常见的驳回原因',
              vi: 'Những lý do phổ biến khiến hồ sơ bị trả lại',
            ),
            bullets: [
              L10nText(
                ko: '사진이 규격(3.5×4.5cm)·배경색과 다르거나 6개월이 지난 사진인 경우',
                en: 'The photo does not match the required size (3.5×4.5cm) or background color, or was taken more than 6 months ago',
                zh: '照片规格(3.5×4.5cm)或背景色不符,或拍摄时间超过6个月',
                vi: 'Ảnh không đúng kích cỡ (3,5×4,5cm), sai màu nền, hoặc đã chụp quá 6 tháng',
              ),
              L10nText(
                ko: '체류지 서류상 주소와 신청서에 적은 주소가 일치하지 않는 경우',
                en: 'The address on the residence documents does not match the address written on the application form',
                zh: '居所证明文件上的地址与申请书填写的地址不一致',
                vi: 'Địa chỉ trên giấy tờ cư trú không khớp với địa chỉ ghi trong đơn đăng ký',
              ),
              L10nText(
                ko: '임대차계약서에 임차인 이름이 신청자 본인이 아닌데 위임 서류가 없는 경우',
                en: 'The tenant named on the lease agreement is not the applicant, and no power-of-attorney document is provided',
                zh: '租赁合同上的承租人姓名并非申请人本人,且未提供委托证明文件',
                vi: 'Tên người thuê trên hợp đồng thuê nhà không phải là người nộp đơn nhưng không có giấy ủy quyền',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '하이코리아 방문예약 단계별 가이드',
          en: 'Step-by-Step Guide to Booking a Visit on HiKorea',
          zh: 'HiKorea预约到访分步指南',
          vi: 'Hướng dẫn từng bước đặt lịch hẹn trên HiKorea',
        ),
        summary: L10nText(
          ko: '출입국관서 방문 전 하이코리아 사전 예약은 필수이며, 관할 관서는 회사 주소가 아닌 실제 거주하는 체류지 주소 기준입니다.',
          en: 'Booking your visit on HiKorea in advance is mandatory before visiting an immigration office, and your jurisdiction is determined by your actual residential address, not your workplace address.',
          zh: '在前往出入境机构之前,必须提前在HiKorea预约,所属机构以实际居住的居所地址为准,而非公司地址。',
          vi: 'Trước khi đến văn phòng xuất nhập cảnh, bắt buộc phải đặt lịch hẹn trước trên HiKorea, và văn phòng phụ trách được xác định theo địa chỉ cư trú thực tế, không phải địa chỉ công ty.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '방문예약 신청 경로',
              en: 'How to Apply for a Visit Reservation',
              zh: '预约到访申请路径',
              vi: 'Đường dẫn đặt lịch hẹn',
            ),
            bullets: [
              L10nText(
                ko: '접속 경로: 하이코리아(hikorea.go.kr) → [방문예약] → [방문예약 신청]',
                en: 'Path: HiKorea (hikorea.go.kr) → [Visit Reservation] → [Apply for Visit Reservation]',
                zh: '路径:HiKorea(hikorea.go.kr) → [预约到访] → [申请预约到访]',
                vi: 'Đường dẫn: HiKorea (hikorea.go.kr) → [Đặt lịch hẹn] → [Đăng ký đặt lịch hẹn]',
              ),
              L10nText(
                ko: '비회원 예약: ARC 미발급자는 [비회원 방문예약] → [여권번호 인증]으로 예약',
                en: 'Non-member reservation: those without an ARC should book via [Non-member Visit Reservation] → [Passport Number Verification]',
                zh: '非会员预约:尚未取得ARC者可通过[非会员预约到访] → [护照号码认证]进行预约',
                vi: 'Đặt lịch không thành viên: người chưa có ARC đặt lịch qua mục [Đặt lịch hẹn không thành viên] → [Xác thực số hộ chiếu]',
              ),
              L10nText(
                ko: '여권상의 영문 성명, 여권번호, 국적, 생년월일을 정확히 입력해야 합니다.',
                en: 'You must enter your English name, passport number, nationality, and date of birth exactly as they appear on your passport.',
                zh: '须准确填写护照上的英文姓名、护照号码、国籍及出生日期。',
                vi: 'Bạn phải nhập chính xác họ tên tiếng Anh, số hộ chiếu, quốc tịch và ngày sinh theo đúng thông tin trên hộ chiếu.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '관할 출입국·외국인관서 선택 주의사항',
              en: 'Cautions When Choosing Your Jurisdictional Immigration Office',
              zh: '选择管辖出入境·外国人厅的注意事项',
              vi: 'Lưu ý khi chọn văn phòng xuất nhập cảnh và người nước ngoài phụ trách',
            ),
            bullets: [
              L10nText(
                ko: '관할 기준: 실제 거주하는 체류지 주소 기준 관서 선택 (회사·학교 주소가 아님)',
                en: 'Jurisdiction criterion: choose the office based on your actual residential address (not your company or school address)',
                zh: '管辖标准:以实际居住的居所地址选择所属机构(不是公司或学校地址)',
                vi: 'Tiêu chí xác định: chọn văn phòng theo địa chỉ cư trú thực tế (không phải địa chỉ công ty hay trường học)',
              ),
              L10nText(
                ko: '타 관서 예약 시: 거주지 관할이 아닌 타 관서 방문 시 현장에서 접수가 즉시 거부됩니다.',
                en: 'If you book the wrong office: visiting an office outside your residential jurisdiction will result in your application being refused on the spot.',
                zh: '预约其他机构时:若前往非居住地管辖的其他机构,现场将立即被拒绝受理。',
                vi: 'Khi đặt lịch nhầm văn phòng: nếu đến văn phòng không thuộc khu vực cư trú, hồ sơ sẽ bị từ chối tiếp nhận ngay tại chỗ.',
              ),
              L10nText(
                ko: '관할 확인: 하이코리아 [관할관서 안내] 메뉴에서 도로명 주소 입력 후 확인',
                en: 'Checking jurisdiction: enter your road-name address in HiKorea\'s [Jurisdictional Office Guide] menu to confirm',
                zh: '查询管辖机构:在HiKorea的[管辖机构查询]菜单中输入道路名地址后确认',
                vi: 'Kiểm tra văn phòng phụ trách: nhập địa chỉ theo tên đường vào mục [Hướng dẫn văn phòng phụ trách] trên HiKorea để xác nhận',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '방문예약 팁 & 90일 만료 임박 시 대처',
              en: 'Reservation Tips & What to Do When the 90-Day Deadline Is Approaching',
              zh: '预约小贴士及90天期限临近时的应对方法',
              vi: 'Mẹo đặt lịch hẹn & Cách xử lý khi thời hạn 90 ngày sắp hết',
            ),
            bullets: [
              L10nText(
                ko: '취소표 공략: 예약 마감 시 매일 자정(00:00) 전후 취소표가 발생하므로 수시 확인',
                en: 'Catching cancellations: when slots are fully booked, cancelled slots tend to open up around midnight (00:00) each day, so check frequently',
                zh: '争抢取消名额:预约满员时,每天午夜(00:00)前后常会出现取消的名额,请随时留意查看',
                vi: 'Săn suất hủy: khi hết lịch hẹn, các suất bị hủy thường xuất hiện quanh thời điểm nửa đêm (00:00) mỗi ngày, nên hãy kiểm tra thường xuyên',
              ),
              L10nText(
                ko: '90일 임박 대처: 만료가 1주일 이내로 다가온 경우 1345에 전화해 긴급 현장 접수를 문의하세요.',
                en: 'When the 90-day deadline is near: if your deadline is within a week, call 1345 to ask about emergency walk-in processing.',
                zh: '90天期限临近时的应对:若期限已不足一周,请致电1345咨询紧急现场受理事宜。',
                vi: 'Khi thời hạn 90 ngày sắp hết: nếu thời hạn còn lại chưa đến một tuần, hãy gọi 1345 để hỏi về việc tiếp nhận khẩn cấp tại chỗ.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '예약 변경·취소 방법',
              en: 'How to Change or Cancel a Reservation',
              zh: '预约变更·取消方法',
              vi: 'Cách thay đổi hoặc hủy lịch hẹn',
            ),
            bullets: [
              L10nText(
                ko: '하이코리아 [나의 예약 내역]에서 기존 예약을 취소하고 새로 예약할 수 있습니다.',
                en: 'You can cancel your existing reservation and make a new one in HiKorea\'s [My Reservation History].',
                zh: '可以在HiKorea的[我的预约记录]中取消原有预约并重新预约。',
                vi: 'Bạn có thể hủy lịch hẹn hiện tại và đặt lịch mới trong mục [Lịch sử đặt hẹn của tôi] trên HiKorea.',
              ),
              L10nText(
                ko: '노쇼(무단 불참)가 반복되면 이후 예약이 제한될 수 있으니 참석이 어려우면 반드시 취소하세요.',
                en: 'Repeated no-shows may restrict your ability to make future reservations, so be sure to cancel if you cannot attend.',
                zh: '若多次爽约(无故缺席),可能导致今后预约受限,如无法前往请务必取消预约。',
                vi: 'Việc nhiều lần không đến mà không hủy lịch (no-show) có thể khiến bạn bị hạn chế đặt lịch sau này, vì vậy hãy chắc chắn hủy nếu không thể tham dự.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '관서 현장 접수 & 지문·생체 등록 절차',
          en: 'On-site Application & Fingerprint/Biometric Registration Procedure',
          zh: '机构现场受理及指纹·生物信息登记流程',
          vi: 'Thủ tục nộp hồ sơ trực tiếp & Đăng ký vân tay, sinh trắc học tại văn phòng',
        ),
        summary: L10nText(
          ko: '예약 시간 15분 전 도착이 필수이며, 현장 생체 등록 후 받는 접수증은 실물 카드가 나올 때까지 임시 신분증 역할을 합니다.',
          en: 'You must arrive 15 minutes before your reservation time; the application receipt you get after on-site biometric registration serves as a temporary ID until the physical card is issued.',
          zh: '必须在预约时间前15分钟到达,现场完成生物信息登记后领取的受理证,在实体卡制发前将作为临时身份证明使用。',
          vi: 'Bạn phải đến trước giờ hẹn ít nhất 15 phút; biên nhận nhận được sau khi đăng ký sinh trắc học tại chỗ sẽ đóng vai trò giấy tờ tùy thân tạm thời cho đến khi có thẻ thật.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '관서 방문 현장 접수 수칙',
              en: 'Rules for On-site Application at the Office',
              zh: '到访机构现场受理须知',
              vi: 'Quy tắc khi nộp hồ sơ trực tiếp tại văn phòng',
            ),
            bullets: [
              L10nText(
                ko: '도착 시간: 예약 시간 최소 15분 전 도착 (15분 이상 지연 시 예약 자동 취소)',
                en: 'Arrival time: arrive at least 15 minutes before your reservation time (arriving more than 15 minutes late automatically cancels your reservation)',
                zh: '到达时间:至少提前15分钟到达预约时间(迟到超过15分钟将自动取消预约)',
                vi: 'Giờ đến: đến trước giờ hẹn ít nhất 15 phút (nếu trễ quá 15 phút, lịch hẹn sẽ tự động bị hủy)',
              ),
              L10nText(
                ko: '수수료 결제: 관서 내 수입인지 창구·ATM에서 30,000원 납부 (우편 수령 시 배송비 약 4,000원 별도)',
                en: 'Fee payment: pay KRW 30,000 at the revenue stamp counter or ATM inside the office (an additional delivery fee of about KRW 4,000 applies if you choose postal delivery)',
                zh: '缴纳手续费:在机构内的印花税票窗口或ATM缴纳30,000韩元(若选择邮寄领取,另需支付约4,000韩元邮费)',
                vi: 'Thanh toán lệ phí: nộp 30.000 won tại quầy tem lệ phí hoặc ATM trong văn phòng (nếu chọn nhận qua bưu điện, phải trả thêm phí vận chuyển khoảng 4.000 won)',
              ),
              L10nText(
                ko: '창구 호출: 번호표 호출 시 제출 서류 뭉치 제출 및 공무원 서류 검토',
                en: 'Counter call: when your number is called, submit your full set of documents for the official to review',
                zh: '窗口叫号:叫到号码后提交全部材料,由工作人员进行审核',
                vi: 'Gọi số tại quầy: khi được gọi số, nộp toàn bộ hồ sơ để cán bộ kiểm tra',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '지문·얼굴 생체정보 등록',
              en: 'Fingerprint and Facial Biometric Registration',
              zh: '指纹·面部生物信息登记',
              vi: 'Đăng ký vân tay và sinh trắc học khuôn mặt',
            ),
            bullets: [
              L10nText(
                ko: '등록 목적: 출입국관리법 제31조제2항에 따른 외국인 생체 식별 정보 등록',
                en: 'Purpose: registering foreigners\' biometric identification data under Article 31, Paragraph 2 of the Immigration Control Act',
                zh: '登记目的:依据《出入境管理法》第31条第2款登记外国人生物识别信息',
                vi: 'Mục đích đăng ký: đăng ký thông tin sinh trắc học nhận dạng người nước ngoài theo Điều 31 Khoản 2 Luật Quản lý xuất nhập cảnh',
              ),
              L10nText(
                ko: '진행 방식: 스캐너에 양손 검지 지문 스캔 및 디지털 카메라 얼굴 촬영',
                en: 'Process: scanning both index fingerprints on the scanner and taking a facial photo with a digital camera',
                zh: '流程:在扫描仪上扫描双手食指指纹,并用数码相机拍摄面部照片',
                vi: 'Quy trình: quét vân tay ngón trỏ hai tay trên máy quét và chụp ảnh khuôn mặt bằng máy ảnh kỹ thuật số',
              ),
              L10nText(
                ko: '팁: 손이 건조하면 인식이 안 되므로 방문 전 손을 씻고 로션을 바르는 것이 좋습니다.',
                en: 'Tip: dry hands can cause recognition failures, so it helps to wash your hands and apply lotion before your visit.',
                zh: '小贴士:手部干燥可能导致识别失败,建议到访前先洗手并涂抹护手霜。',
                vi: 'Mẹo: tay khô có thể khiến máy không nhận diện được, nên rửa tay và thoa kem dưỡng trước khi đến.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '접수증(임시 신분증) 수령 및 백업',
              en: 'Receiving and Backing Up the Application Receipt (Temporary ID)',
              zh: '领取及备份受理证(临时身份证明)',
              vi: 'Nhận và sao lưu biên nhận (giấy tờ tùy thân tạm thời)',
            ),
            bullets: [
              L10nText(
                ko: '접수증 수령: 접수 완료 시 \'외국인등록 사실증명 접수증\' 교부',
                en: 'Receiving the slip: once your application is accepted, you will be issued a "Certificate of Alien Registration Application Receipt"',
                zh: '领取受理证:受理完成后,将获发《外国人登录事实证明受理证》',
                vi: 'Nhận biên nhận: khi hồ sơ được tiếp nhận, bạn sẽ được cấp "Biên nhận xác nhận đăng ký người nước ngoài"',
              ),
              L10nText(
                ko: '수령 예정일 확인: 하단에 적힌 카드 수령 예정일(보통 2~4주 뒤) 확인',
                en: 'Checking the expected pickup date: check the expected card receipt date (usually 2–4 weeks later) printed at the bottom',
                zh: '确认预计领取日期:确认单据下方标注的预计领卡日期(通常为2~4周后)',
                vi: 'Kiểm tra ngày dự kiến nhận thẻ: kiểm tra ngày dự kiến nhận thẻ (thường sau 2-4 tuần) được ghi ở phía dưới',
              ),
              L10nText(
                ko: '사진 백업: 실물 카드 수령 전까지 신분 증명 서류이므로 받자마자 촬영해 백업하세요.',
                en: 'Photo backup: this slip serves as your ID document until you receive the physical card, so take a photo of it and back it up as soon as you receive it.',
                zh: '拍照备份:在领取实体卡之前,该受理证即为身份证明文件,请在拿到后立即拍照备份。',
                vi: 'Sao lưu bằng ảnh chụp: đây là giấy tờ chứng minh danh tính cho đến khi nhận thẻ thật, nên hãy chụp ảnh lưu lại ngay khi nhận được.',
              ),
              L10nText(
                ko: '이 접수증만으로도 하이코리아 회원가입과 통신 개통(PASS 인증)을 진행할 수 있습니다.',
                en: 'With just this receipt, you can already sign up for HiKorea and complete mobile carrier activation (PASS verification).',
                zh: '仅凭此受理证即可完成HiKorea会员注册以及通讯开通(PASS认证)。',
                vi: 'Chỉ với biên nhận này, bạn đã có thể đăng ký thành viên HiKorea và kích hoạt thuê bao di động (xác thực PASS).',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '서류는 원본 지참이 원칙',
              en: 'Original Documents Must Be Brought as a Rule',
              zh: '原则上须携带材料原件',
              vi: 'Nguyên tắc phải mang theo bản gốc giấy tờ',
            ),
            bullets: [
              L10nText(
                ko: '사본만으로는 접수가 거부될 수 있으므로 임대차계약서 등은 원본을 함께 지참하세요.',
                en: 'A copy alone may be refused, so bring the original of documents such as the lease agreement along with the copy.',
                zh: '仅凭复印件可能被拒绝受理,请将租赁合同等文件的原件一并携带。',
                vi: 'Chỉ dùng bản sao có thể bị từ chối tiếp nhận, nên hãy mang theo bản gốc của hợp đồng thuê nhà và các giấy tờ khác.',
              ),
              L10nText(
                ko: '미성년자는 법정대리인(부모) 동반 또는 위임장이 필요할 수 있습니다.',
                en: 'Minors may need to be accompanied by a legal guardian (parent) or provide a power of attorney.',
                zh: '未成年人可能需要法定代理人(父母)陪同或提供委托书。',
                vi: 'Người chưa thành niên có thể cần người đại diện hợp pháp (cha mẹ) đi cùng hoặc cần có giấy ủy quyền.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '카드 수령 & 체류지 변경신고 의무',
          en: 'Receiving the Card & the Obligation to Report a Change of Address',
          zh: '领取实体卡及居所变更申报义务',
          vi: 'Nhận thẻ & Nghĩa vụ khai báo thay đổi nơi cư trú',
        ),
        summary: L10nText(
          ko: '발급에는 약 2~4주가 소요되며, 이사 시에는 전입한 날부터 15일 이내에 체류지 변경신고를 해야 합니다.',
          en: 'Issuance takes about 2–4 weeks, and if you move, you must report the change of residence within 15 days of moving in.',
          zh: '制发大约需要2~4周时间;若搬家,须在迁入之日起15天内申报居所变更。',
          vi: 'Việc cấp thẻ mất khoảng 2-4 tuần; khi chuyển nhà, bạn phải khai báo thay đổi nơi cư trú trong vòng 15 ngày kể từ ngày chuyển đến.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '외국인등록증 실물 수령 방법',
              en: 'How to Receive the Physical Alien Registration Card',
              zh: '领取实体外国人登录证的方法',
              vi: 'Cách nhận thẻ đăng ký người nước ngoài thật',
            ),
            bullets: [
              L10nText(
                ko: '방법 A (등기우편 수령): 신청 시 우편 배송 선택 시 체류지로 배송 (본인 수령, 2~3주)',
                en: 'Method A (registered mail): if you choose postal delivery at the time of application, the card is sent to your residence (must be received by you in person, 2–3 weeks)',
                zh: '方式A(挂号邮寄领取):申请时选择邮寄配送,将送至居所地址(须本人签收,约2~3周)',
                vi: 'Cách A (nhận qua thư bảo đảm): nếu chọn hình thức gửi bưu điện khi đăng ký, thẻ sẽ được gửi đến nơi cư trú (chính chủ nhận, 2-3 tuần)',
              ),
              L10nText(
                ko: '방법 B (관서 방문 수령): 수령 예정일 이후 관서 방문 수령 (접수증 및 여권 지참, 3~4주)',
                en: 'Method B (pickup at the office): visit the office after the expected receipt date to collect it in person (bring the application receipt and passport, 3–4 weeks)',
                zh: '方式B(到机构领取):在预计领取日之后前往机构领取(须携带受理证及护照,约3~4周)',
                vi: 'Cách B (nhận tại văn phòng): đến văn phòng nhận sau ngày dự kiến (mang theo biên nhận và hộ chiếu, 3-4 tuần)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'ARC 수령 후 필수 조치',
              en: 'Required Steps After Receiving the ARC',
              zh: '领取ARC后必须采取的措施',
              vi: 'Các việc bắt buộc sau khi nhận ARC',
            ),
            bullets: [
              L10nText(
                ko: '프로필 등록: ARC 13자리 등록번호, 체류자격, 체류만료일 등록',
                en: 'Profile registration: register your 13-digit ARC number, status of stay, and expiration date',
                zh: '登记个人资料:登录13位ARC登记号码、滞留资格及滞留到期日',
                vi: 'Đăng ký hồ sơ: đăng ký số ARC 13 chữ số, tư cách lưu trú và ngày hết hạn lưu trú',
              ),
              L10nText(
                ko: '만료일 알림: 등록 시 체류 만료 90일·60일·30일 전 자동 연장 알림 작동',
                en: 'Expiration reminders: once registered, automatic renewal reminders are triggered 90, 60, and 30 days before your stay expires',
                zh: '到期提醒:完成登记后,系统将在滞留到期前90天、60天、30天自动发送续签提醒',
                vi: 'Nhắc nhở hết hạn: sau khi đăng ký, hệ thống sẽ tự động nhắc gia hạn trước khi hết hạn lưu trú 90, 60 và 30 ngày',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '체류지 변경(이사) 시 15일 이내 신고 의무',
              en: 'Obligation to Report Within 15 Days When You Change Residence (Move)',
              zh: '居所变更(搬家)时须在15天内申报的义务',
              vi: 'Nghĩa vụ khai báo trong vòng 15 ngày khi thay đổi nơi cư trú (chuyển nhà)',
            ),
            bullets: [
              L10nText(
                ko: '신고 기한: 전입한 날부터 15일 이내 (출입국관리법 제36조제1항)',
                en: 'Reporting deadline: within 15 days of the date you move in (Article 36, Paragraph 1 of the Immigration Control Act)',
                zh: '申报期限:自迁入之日起15天内(《出入境管理法》第36条第1款)',
                vi: 'Thời hạn khai báo: trong vòng 15 ngày kể từ ngày chuyển đến (Điều 36 Khoản 1 Luật Quản lý xuất nhập cảnh)',
              ),
              L10nText(
                ko: '신고처: 시·군·구청, 읍·면·동 주민센터 또는 관할 출입국관서 (하이코리아 온라인 가능)',
                en: 'Where to report: city/county/district office, town/township/neighborhood community center, or your jurisdictional immigration office (online reporting via HiKorea is also available)',
                zh: '申报地点:市·郡·区厅、邑·面·洞居民中心,或管辖出入境机构(也可通过HiKorea在线申报)',
                vi: 'Nơi khai báo: ủy ban thành phố/quận/huyện, trung tâm dân cư phường/xã, hoặc văn phòng xuất nhập cảnh phụ trách (cũng có thể khai báo trực tuyến qua HiKorea)',
              ),
              L10nText(
                ko: '위반 시: 기한 초과는 100만 원 이하 과태료, 아예 신고하지 않으면 100만 원 이하 벌금(같은 법 제98조제2호)의 형사처벌 대상입니다.',
                en: 'Penalties: missing the deadline results in a fine of up to KRW 1,000,000; failing to report at all is subject to criminal punishment with a fine of up to KRW 1,000,000 (Article 98, Item 2 of the same Act).',
                zh: '违反时的处罚:逾期申报处1,000,000韩元以下罚款;完全未申报则属刑事处罚对象,处1,000,000韩元以下罚金(同法第98条第2号)。',
                vi: 'Khi vi phạm: quá thời hạn sẽ bị phạt tiền tối đa 1.000.000 won; nếu hoàn toàn không khai báo sẽ bị xử phạt hình sự với mức phạt tiền tối đa 1.000.000 won (Điều 98 Khoản 2 cùng luật).',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'ARC 분실·훼손 시 재발급',
              en: 'Reissuance in Case of Loss or Damage',
              zh: 'ARC遗失·损坏时的补发',
              vi: 'Cấp lại khi ARC bị mất hoặc hư hỏng',
            ),
            bullets: [
              L10nText(
                ko: '분실 시 가까운 출입국·외국인관서 또는 하이코리아에서 재발급 신청이 가능합니다.',
                en: 'If lost, you can apply for reissuance at your nearest immigration and foreigner office or through HiKorea.',
                zh: '遗失时,可前往就近的出入境·外国人厅或通过HiKorea申请补发。',
                vi: 'Nếu bị mất, bạn có thể xin cấp lại tại văn phòng xuất nhập cảnh và người nước ngoài gần nhất hoặc qua HiKorea.',
              ),
              L10nText(
                ko: '재발급 수수료가 별도로 발생하며, 분실 사실을 인지한 즉시 신청하는 것이 안전합니다.',
                en: 'A separate reissuance fee applies, and it is safest to apply as soon as you realize the card is lost.',
                zh: '补发需另行缴纳手续费,建议一发现遗失就立即申请,以确保安全。',
                vi: 'Sẽ phát sinh lệ phí cấp lại riêng, và nên nộp đơn xin cấp lại ngay khi phát hiện bị mất để đảm bảo an toàn.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  2: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '하이코리아 개요 & 계정 관리',
          en: 'HiKorea Overview & Account Management',
          zh: 'HiKorea概览与账户管理',
          vi: 'Tổng quan về HiKorea & Quản lý tài khoản',
        ),
        summary: L10nText(
          ko: '외국인 등록번호(ARC) 보유자만 가입 가능하며, 대한민국 체류 외국인의 모든 출입국·비자 행정을 처리하는 최우선 필수 포털입니다.',
          en: 'Only holders of a foreign registration number (ARC) can sign up; it is the essential go-to portal for handling all immigration and visa administration for foreigners staying in the Republic of Korea.',
          zh: '仅持有外国人登记号码(ARC)者方可注册,是处理在韩外国人一切出入境·签证行政事务的首要必备门户网站。',
          vi: 'Chỉ những người có số đăng ký người nước ngoài (ARC) mới có thể đăng ký; đây là cổng thông tin thiết yếu hàng đầu để xử lý mọi thủ tục xuất nhập cảnh và visa cho người nước ngoài lưu trú tại Hàn Quốc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '하이코리아(HiKorea)란',
              en: 'What Is HiKorea',
              zh: '什么是HiKorea',
              vi: 'HiKorea là gì',
            ),
            bullets: [
              L10nText(
                ko: '정의: 법무부 출입국·외국인정책본부 공식 민원 포털',
                en: 'Definition: the official civil affairs portal of the Ministry of Justice\'s Korea Immigration Service',
                zh: '定义:法务部出入境·外国人政策本部的官方民愿服务门户网站',
                vi: 'Định nghĩa: cổng dịch vụ hành chính công chính thức của Cục Xuất nhập cảnh và Chính sách người nước ngoài thuộc Bộ Tư pháp',
              ),
              L10nText(
                ko: '중요성: 관서 방문 없이 온라인으로 비자 연장, 자격 변경, 방문예약 등을 종합 처리',
                en: 'Importance: lets you handle visa extensions, status changes, visit reservations, and more entirely online, without visiting an office',
                zh: '重要性:无需到访机构,即可在线综合办理签证延期、资格变更、预约到访等事项',
                vi: 'Tầm quan trọng: xử lý tổng hợp việc gia hạn visa, thay đổi tư cách lưu trú, đặt lịch hẹn... trực tuyến mà không cần đến văn phòng',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '회원가입 조건 및 준비물',
              en: 'Membership Requirements and What You Need',
              zh: '会员注册条件及所需材料',
              vi: 'Điều kiện đăng ký thành viên và những thứ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '필수: 외국인등록증(ARC) 실물 및 유효한 등록번호',
                en: 'Required: the physical Alien Registration Card (ARC) and a valid registration number',
                zh: '必备条件:实体外国人登录证(ARC)及有效的登记号码',
                vi: 'Bắt buộc: thẻ đăng ký người nước ngoài (ARC) thật và số đăng ký còn hiệu lực',
              ),
              L10nText(
                ko: '인증: 본인 명의 한국 휴대폰 번호 또는 금융인증서',
                en: 'Verification: a Korean mobile phone number in your own name, or a financial certificate',
                zh: '认证方式:以本人名义开通的韩国手机号码或金融认证书',
                vi: 'Xác thực: số điện thoại di động Hàn Quốc đứng tên bản thân hoặc chứng thư xác thực tài chính',
              ),
              L10nText(
                ko: '외국인등록증 미발급 단기 체류자는 회원가입이 불가하며 비회원으로 신청해야 합니다.',
                en: 'Short-term stayers who have not been issued an Alien Registration Card cannot sign up as members and must apply as non-members instead.',
                zh: '尚未取得外国人登录证的短期滞留者无法注册为会员,须以非会员身份申请。',
                vi: 'Người lưu trú ngắn hạn chưa được cấp thẻ đăng ký người nước ngoài không thể đăng ký thành viên và phải đăng ký với tư cách không phải thành viên.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'ID·비밀번호 분실 시 대처',
              en: 'What to Do If You Lose Your ID or Password',
              zh: '账号·密码遗失时的应对方法',
              vi: 'Cách xử lý khi quên ID hoặc mật khẩu',
            ),
            bullets: [
              L10nText(
                ko: '온라인: [비밀번호 찾기] → ARC 번호 + 휴대폰 SMS 본인인증',
                en: 'Online: [Find Password] → verify with your ARC number + mobile SMS authentication',
                zh: '在线:[查找密码] → 输入ARC号码并通过手机短信完成实名认证',
                vi: 'Trực tuyến: [Tìm mật khẩu] → xác thực bằng số ARC + tin nhắn SMS điện thoại',
              ),
              L10nText(
                ko: '인증 실패 시: 관할 출입국·외국인관서 방문해 계정 초기화',
                en: 'If verification fails: visit your jurisdictional immigration and foreigner office to reset your account',
                zh: '认证失败时:前往管辖出入境·外国人厅办理账户重置',
                vi: 'Nếu xác thực thất bại: đến văn phòng xuất nhập cảnh và người nước ngoài phụ trách để khôi phục tài khoản',
              ),
              L10nText(
                ko: '전화 도움: 1345 외국인종합안내센터 (365일 다국어 상담)',
                en: 'Phone support: call the 1345 Immigration Contact Center (multilingual assistance, 365 days a year)',
                zh: '电话咨询:1345外国人综合咨询中心(全年365天多语言咨询)',
                vi: 'Hỗ trợ qua điện thoại: Trung tâm tư vấn tổng hợp người nước ngoài 1345 (tư vấn đa ngôn ngữ 365 ngày)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '모바일로도 이용 가능',
              en: 'Also Available on Mobile',
              zh: '也可通过手机使用',
              vi: 'Cũng có thể sử dụng trên di động',
            ),
            bullets: [
              L10nText(
                ko: '모바일 하이코리아 앱에서도 전자민원 신청, 방문예약, 처리현황 조회를 할 수 있습니다.',
                en: 'The HiKorea mobile app also lets you submit online civil applications, book visit reservations, and check processing status.',
                zh: '在HiKorea手机应用中同样可以申请电子民愿、预约到访以及查询办理进度。',
                vi: 'Ứng dụng di động HiKorea cũng cho phép nộp đơn hành chính trực tuyến, đặt lịch hẹn và tra cứu tiến độ xử lý.',
              ),
              L10nText(
                ko: 'PC와 앱 계정은 동일하게 연동되므로 앱에서 먼저 가입해도 무방합니다.',
                en: 'Your PC and app accounts are linked as one, so it is fine to sign up through the app first.',
                zh: '电脑端与手机应用账户是互通的,因此也可以先在手机应用上注册。',
                vi: 'Tài khoản trên máy tính và ứng dụng được liên kết với nhau, nên bạn có thể đăng ký trước trên ứng dụng cũng không sao.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '하이코리아 전자민원 연장 신청 가이드',
          en: 'Guide to Applying for an Online Extension on HiKorea',
          zh: 'HiKorea电子民愿延期申请指南',
          vi: 'Hướng dẫn nộp đơn gia hạn trực tuyến trên HiKorea',
        ),
        summary: L10nText(
          ko: '전자민원 연장 신청 시 수수료 할인을 받으며, 체류 만료일 4개월 전부터 온라인으로 신청할 수 있습니다.',
          en: 'Applying for an extension through the online civil affairs system gets you a fee discount, and you can apply online starting 4 months before your stay expires.',
          zh: '通过电子民愿申请延期可享受手续费优惠,并且可以在滞留到期日前4个月起在线申请。',
          vi: 'Khi nộp đơn gia hạn qua hệ thống hành chính trực tuyến, bạn được giảm lệ phí, và có thể nộp đơn trực tuyến từ 4 tháng trước ngày hết hạn lưu trú.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '1단계: 접속 및 로그인',
              en: 'Step 1: Access and Log In',
              zh: '第1步:登录网站',
              vi: 'Bước 1: Truy cập và đăng nhập',
            ),
            bullets: [
              L10nText(
                ko: '공식 웹사이트(hikorea.go.kr) 접속 후 로그인',
                en: 'Go to the official website (hikorea.go.kr) and log in',
                zh: '登录官方网站(hikorea.go.kr)',
                vi: 'Truy cập trang web chính thức (hikorea.go.kr) và đăng nhập',
              ),
              L10nText(
                ko: '상단 메인메뉴 [전자민원] → [전자민원 신청] 클릭',
                en: 'Click [Online Civil Affairs] → [Apply for Online Civil Affairs] in the top main menu',
                zh: '点击顶部主菜单中的[电子民愿] → [电子民愿申请]',
                vi: 'Nhấp vào [Dịch vụ hành chính trực tuyến] → [Nộp đơn hành chính trực tuyến] trên thanh menu chính',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '2단계: 민원선택 및 통합신청서 작성',
              en: 'Step 2: Select the Service and Fill Out the Integrated Application',
              zh: '第2步:选择服务项目并填写综合申请书',
              vi: 'Bước 2: Chọn dịch vụ và điền đơn đăng ký tổng hợp',
            ),
            bullets: [
              L10nText(
                ko: '목록 중 [등록외국인의 체류기간 연장허가] 선택',
                en: 'From the list, select [Permission to Extend the Period of Stay for Registered Foreigners]',
                zh: '在列表中选择[已登记外国人滞留期限延期许可]',
                vi: 'Trong danh sách, chọn [Cho phép gia hạn thời gian lưu trú của người nước ngoài đã đăng ký]',
              ),
              L10nText(
                ko: '약관 동의 후 신청인 인적사항 및 체류지 주소·기간 확인',
                en: 'After agreeing to the terms, confirm the applicant\'s personal details and residence address and period',
                zh: '同意条款后,确认申请人个人信息及居所地址·期限',
                vi: 'Sau khi đồng ý điều khoản, kiểm tra thông tin cá nhân của người nộp đơn cùng địa chỉ và thời hạn cư trú',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '3단계: 제출서류 업로드 및 결제',
              en: 'Step 3: Upload Documents and Pay',
              zh: '第3步:上传提交材料并缴费',
              vi: 'Bước 3: Tải lên hồ sơ và thanh toán',
            ),
            bullets: [
              L10nText(
                ko: '비자별 필수 서류를 JPG·PDF 파일로 첨부',
                en: 'Attach the documents required for your visa type as JPG or PDF files',
                zh: '将各签证类型所需材料以JPG·PDF格式上传',
                vi: 'Đính kèm hồ sơ bắt buộc theo từng loại visa dưới dạng file JPG hoặc PDF',
              ),
              L10nText(
                ko: '수수료 결제: 전자민원 수수료(방문 대비 할인)',
                en: 'Fee payment: pay the online civil affairs fee (discounted compared to an in-person visit)',
                zh: '缴纳手续费:电子民愿手续费(比现场办理更优惠)',
                vi: 'Thanh toán lệ phí: lệ phí dịch vụ hành chính trực tuyến (được giảm so với nộp trực tiếp)',
              ),
              L10nText(
                ko: '[마이페이지] → [민원신청 현황]에서 처리 상태 실시간 조회',
                en: 'Check processing status in real time under [My Page] → [Application Status]',
                zh: '可在[我的页面] → [民愿申请状态]中实时查询办理进度',
                vi: 'Tra cứu tình trạng xử lý theo thời gian thực tại [Trang cá nhân] → [Tình trạng nộp đơn]',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '연장 시기를 놓쳤다면',
              en: 'If You Miss the Extension Window',
              zh: '若错过延期申请时机',
              vi: 'Nếu lỡ thời điểm gia hạn',
            ),
            bullets: [
              L10nText(
                ko: '체류기간 만료 전에 신청하지 못했다면 만료 전 최대한 빨리 관할 관서에 사유를 소명해야 합니다.',
                en: 'If you were unable to apply before your period of stay expires, you must explain the reason to your jurisdictional office as soon as possible before it expires.',
                zh: '若未能在滞留期限届满前提出申请,须在到期前尽快向管辖机构说明理由。',
                vi: 'Nếu không thể nộp đơn trước khi hết thời hạn lưu trú, bạn phải giải trình lý do với văn phòng phụ trách càng sớm càng tốt trước khi hết hạn.',
              ),
              L10nText(
                ko: '정당한 사유 없이 기한을 넘기면 범칙금 또는 출국명령 대상이 될 수 있습니다.',
                en: 'Missing the deadline without a legitimate reason can result in a fine or a departure order.',
                zh: '若无正当理由逾期,可能面临罚款或出境令处分。',
                vi: 'Nếu quá thời hạn mà không có lý do chính đáng, bạn có thể bị phạt tiền hoặc bị ra lệnh xuất cảnh.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: 'E-9 비자 체류기간 연장 절차 및 서류',
          en: 'E-9 Visa: Extension Procedure and Documents',
          zh: 'E-9签证滞留期限延期流程与所需材料',
          vi: 'Thủ tục và hồ sơ gia hạn thời gian lưu trú visa E-9',
        ),
        summary: L10nText(
          ko: '고용허가제(E-9) 근로자는 사업주와의 표준근로계약 연장 및 고용센터의 재고용 허가가 선행되어야 출입국 연장이 가능합니다.',
          en: 'Employment Permit System (E-9) workers must first extend their standard labor contract with their employer and obtain re-employment permission from an Employment Center before their immigration extension is possible.',
          zh: '雇佣许可制(E-9)劳动者须先与雇主延长标准劳动合同,并取得雇佣中心的再雇佣许可,才能办理出入境延期。',
          vi: 'Người lao động theo Chế độ cấp phép việc làm (E-9) phải gia hạn hợp đồng lao động chuẩn với chủ sử dụng lao động và được Trung tâm việc làm cấp phép tái tuyển dụng trước, thì mới có thể gia hạn xuất nhập cảnh.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: 'E-9 체류연장 핵심 조건',
              en: 'Key Requirements for E-9 Stay Extension',
              zh: 'E-9滞留延期核心条件',
              vi: 'Điều kiện cốt lõi để gia hạn lưu trú E-9',
            ),
            bullets: [
              L10nText(
                ko: '기본 체류기간: 최초 3년 + 재고용 허가 시 1년 10개월 (최대 4년 10개월)',
                en: 'Basic period of stay: an initial 3 years, plus 1 year and 10 months upon re-employment permission (up to 4 years and 10 months total)',
                zh: '基本滞留期限:首次3年 + 获得再雇佣许可后可延长1年10个月(最长4年10个月)',
                vi: 'Thời gian lưu trú cơ bản: ban đầu 3 năm + thêm 1 năm 10 tháng khi được cấp phép tái tuyển dụng (tối đa 4 năm 10 tháng)',
              ),
              L10nText(
                ko: '선행 절차: 관할 고용센터에서 [재고용 허가서] 발급 완료 필수',
                en: 'Prerequisite: the [Re-employment Permit] must first be issued by your jurisdictional Employment Center',
                zh: '前置程序:须先在管辖雇佣中心取得[再雇佣许可书]',
                vi: 'Thủ tục tiên quyết: phải được Trung tâm việc làm phụ trách cấp [Giấy phép tái tuyển dụng] trước',
              ),
              L10nText(
                ko: '사업장 이탈 또는 불법체류 이력이 없을 것',
                en: 'You must have no history of leaving your workplace without authorization or of illegal stay',
                zh: '须无擅自离岗或非法滞留记录',
                vi: 'Không có tiền sử tự ý rời nơi làm việc hoặc lưu trú bất hợp pháp',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'E-9 연장 필수 제출 서류',
              en: 'Required Documents for E-9 Extension',
              zh: 'E-9延期所需提交材料',
              vi: 'Hồ sơ bắt buộc khi gia hạn E-9',
            ),
            bullets: [
              L10nText(
                ko: '여권 원본·사본, 외국인등록증(ARC), 통합신청서',
                en: 'Original and copy of passport, Alien Registration Card (ARC), integrated application form',
                zh: '护照原件及复印件、外国人登录证(ARC)、综合申请书',
                vi: 'Hộ chiếu gốc và bản sao, thẻ đăng ký người nước ngoài (ARC), đơn đăng ký tổng hợp',
              ),
              L10nText(
                ko: '고용노동부 발행: 재고용 허가서 및 표준근로계약서 사본',
                en: 'Issued by the Ministry of Employment and Labor: the re-employment permit and a copy of the standard labor contract',
                zh: '雇佣劳动部签发:再雇佣许可书及标准劳动合同复印件',
                vi: 'Do Bộ Việc làm và Lao động cấp: giấy phép tái tuyển dụng và bản sao hợp đồng lao động chuẩn',
              ),
              L10nText(
                ko: '사업주 서류: 사업자등록증 사본, 숙소제공확인서 및 주거환경 증빙',
                en: 'Employer documents: a copy of the business registration certificate, a housing-provision confirmation letter, and proof of living conditions',
                zh: '雇主材料:营业执照复印件、住宿提供确认书及居住环境证明',
                vi: 'Hồ sơ của chủ sử dụng lao động: bản sao giấy đăng ký kinh doanh, giấy xác nhận cung cấp chỗ ở và giấy chứng minh điều kiện nơi ở',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'E-9 근로자 주의사항',
              en: 'Cautions for E-9 Workers',
              zh: 'E-9劳动者注意事项',
              vi: 'Lưu ý dành cho người lao động E-9',
            ),
            bullets: [
              L10nText(
                ko: '재고용 허가서는 고용센터, 체류기간 연장허가는 출입국관서로 신청 창구가 다릅니다. 두 절차를 순서대로 밟아야 합니다.',
                en: 'The re-employment permit is handled by the Employment Center, while the stay extension permit is handled by the immigration office — these are different application windows. You must complete the two procedures in order.',
                zh: '再雇佣许可书由雇佣中心受理,滞留期限延期许可由出入境机构受理,两者申请窗口不同,须依次办理这两个程序。',
                vi: 'Giấy phép tái tuyển dụng do Trung tâm việc làm xử lý, còn giấy phép gia hạn thời gian lưu trú do văn phòng xuất nhập cảnh xử lý — đây là hai nơi nộp đơn khác nhau. Bạn phải hoàn tất hai thủ tục này theo đúng trình tự.',
              ),
              L10nText(
                ko: '사업장 변경 중인 경우: [구직등록필증] 제출 후 유예기간 연장',
                en: 'If you are in the process of changing workplaces: submit the [Job-Seeking Registration Certificate] to extend your grace period',
                zh: '正在更换工作单位时:提交[求职登记证]以延长宽限期',
                vi: 'Trong trường hợp đang chuyển nơi làm việc: nộp [Giấy chứng nhận đăng ký tìm việc] để gia hạn thời gian ân hạn',
              ),
              L10nText(
                ko: '만료일 경과 시 출입국관리법 위반 과태료 및 불이익이 발생합니다.',
                en: 'Letting the deadline pass results in a fine for violating the Immigration Control Act and other disadvantages.',
                zh: '一旦超过到期日,将构成违反《出入境管理法》,产生罚款及其他不利后果。',
                vi: 'Nếu để quá ngày hết hạn sẽ bị phạt tiền do vi phạm Luật Quản lý xuất nhập cảnh và gặp các bất lợi khác.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '재고용 허가 신청 시기',
              en: 'When to Apply for Re-employment Permission',
              zh: '再雇佣许可的申请时间',
              vi: 'Thời điểm nộp đơn xin cấp phép tái tuyển dụng',
            ),
            bullets: [
              L10nText(
                ko: '재고용 허가는 체류기간 만료 전 일정 기간 안에 고용센터에 신청해야 하므로 만료일을 미리 계산해두어야 합니다.',
                en: 'Re-employment permission must be applied for at the Employment Center within a set period before your stay expires, so you should calculate your expiration date in advance.',
                zh: '再雇佣许可须在滞留期限届满前的规定期间内向雇佣中心申请,因此应提前推算好到期日。',
                vi: 'Giấy phép tái tuyển dụng phải được nộp tại Trung tâm việc làm trong khoảng thời gian nhất định trước khi hết hạn lưu trú, vì vậy cần tính trước ngày hết hạn.',
              ),
              L10nText(
                ko: '사업주와 근로자 모두의 동의가 필요한 절차이므로 만료 임박 전에 미리 상의하세요.',
                en: 'Since this procedure requires the consent of both the employer and the worker, discuss it well before the deadline approaches.',
                zh: '该程序需要雇主与劳动者双方同意,请在到期临近前提前协商。',
                vi: 'Đây là thủ tục cần sự đồng ý của cả chủ sử dụng lao động và người lao động, nên hãy trao đổi trước khi gần đến hạn.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: 'D-2 / D-4 비자 체류연장 절차 및 서류',
          en: 'D-2 / D-4 Visa: Stay Extension Procedure and Documents',
          zh: 'D-2 / D-4签证滞留延期流程与所需材料',
          vi: 'Thủ tục và hồ sơ gia hạn lưu trú visa D-2 / D-4',
        ),
        summary: L10nText(
          ko: '유학생(D-2) 및 어학연수생(D-4)은 일정 기준 이상의 성적 및 재정능력(체류비용 잔고증명)을 입증해야 연장이 승인됩니다.',
          en: 'International students (D-2) and language trainees (D-4) must demonstrate academic performance and financial capacity (a certificate of sufficient balance for living costs) above a set standard for their extension to be approved.',
          zh: '留学生(D-2)及语言研修生(D-4)须证明达到一定标准以上的成绩及经济能力(生活费余额证明),延期方能获批。',
          vi: 'Du học sinh (D-2) và người học tiếng (D-4) phải chứng minh thành tích học tập và khả năng tài chính (giấy chứng nhận số dư đủ chi phí sinh hoạt) đạt tiêu chuẩn nhất định thì việc gia hạn mới được phê duyệt.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: 'D-2·D-4 연장 승인 심사 기준',
              en: 'Review Criteria for D-2/D-4 Extension Approval',
              zh: 'D-2·D-4延期审批标准',
              vi: 'Tiêu chí xét duyệt gia hạn D-2/D-4',
            ),
            bullets: [
              L10nText(
                ko: 'D-2(유학): 직전 학기 평점 평균(GPA) C학점(2.0) 이상 권장',
                en: 'D-2 (Study Abroad): a GPA of C (2.0) or higher in the previous semester is recommended',
                zh: 'D-2(留学):建议上一学期平均绩点(GPA)达到C(2.0)以上',
                vi: 'D-2 (Du học): khuyến nghị điểm trung bình học kỳ trước (GPA) từ C (2.0) trở lên',
              ),
              L10nText(
                ko: 'D-4(어학): 출석률 80% 이상 필수 충족',
                en: 'D-4 (Language Training): an attendance rate of 80% or higher is mandatory',
                zh: 'D-4(语言研修):必须满足出勤率80%以上',
                vi: 'D-4 (Du học tiếng): bắt buộc phải đạt tỷ lệ đi học từ 80% trở lên',
              ),
              L10nText(
                ko: '성적 미달 또는 출석률 저하 시 사유서 제출 및 단기 연장 부여',
                en: 'If grades or attendance fall short, you must submit a written explanation and will be granted only a short-term extension',
                zh: '成绩不达标或出勤率下降时,须提交说明材料,并仅获批短期延期',
                vi: 'Nếu điểm số không đạt hoặc tỷ lệ đi học thấp, phải nộp bản giải trình và chỉ được cấp gia hạn ngắn hạn',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '필수 제출 서류',
              en: 'Required Documents',
              zh: '必需提交材料',
              vi: 'Hồ sơ bắt buộc',
            ),
            bullets: [
              L10nText(
                ko: '여권 원본, 외국인등록증(ARC), 통합신청서',
                en: 'Original passport, Alien Registration Card (ARC), integrated application form',
                zh: '护照原件、外国人登录证(ARC)、综合申请书',
                vi: 'Hộ chiếu gốc, thẻ đăng ký người nước ngoài (ARC), đơn đăng ký tổng hợp',
              ),
              L10nText(
                ko: '학교 발급: 재학증명서, 성적증명서, 등록금 납입증명서',
                en: 'Issued by the school: certificate of enrollment, transcript, and proof of tuition payment',
                zh: '学校签发:在学证明、成绩证明、学费缴纳证明',
                vi: 'Do nhà trường cấp: giấy xác nhận đang theo học, bảng điểm, giấy xác nhận đóng học phí',
              ),
              L10nText(
                ko: '재정 증빙: 본인 명의 은행 잔고증명서 (학비 + 체류비 충족)',
                en: 'Proof of finances: a bank balance certificate in your own name (covering tuition plus living expenses)',
                zh: '经济能力证明:以本人名义开具的银行余额证明(须涵盖学费+生活费)',
                vi: 'Chứng minh tài chính: giấy chứng nhận số dư ngân hàng đứng tên bản thân (đủ trang trải học phí + chi phí sinh hoạt)',
              ),
              L10nText(
                ko: '체류지 입증 서류 (기숙사 확인서 또는 임대차계약서)',
                en: 'Proof of residence (dormitory confirmation letter or lease agreement)',
                zh: '居所证明文件(宿舍确认书或租赁合同)',
                vi: 'Giấy tờ chứng minh nơi cư trú (giấy xác nhận ký túc xá hoặc hợp đồng thuê nhà)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유학생 필수 유의사항',
              en: 'Essential Cautions for International Students',
              zh: '留学生必知注意事项',
              vi: 'Lưu ý bắt buộc dành cho du học sinh',
            ),
            bullets: [
              L10nText(
                ko: '시간제 취업(아르바이트)을 하려면 반드시 사전 [시간제 취업 허가]가 필요합니다.',
                en: 'To take a part-time job, you must first obtain [Part-time Employment Permission] in advance.',
                zh: '若想从事兼职工作,必须事先取得[兼职就业许可]。',
                vi: 'Muốn làm việc bán thời gian phải xin [Giấy phép làm việc bán thời gian] trước.',
              ),
              L10nText(
                ko: '허가 없이 근로 시 체류기간 연장 불허 및 벌금 처분을 받을 수 있습니다.',
                en: 'Working without permission can result in your stay extension being denied and a fine being imposed.',
                zh: '未经许可从事工作,可能导致滞留延期申请被拒并被处以罚款。',
                vi: 'Nếu làm việc mà không có giấy phép, bạn có thể bị từ chối gia hạn lưu trú và bị phạt tiền.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '휴학·조기수료 시 유의점',
              en: 'Cautions for Leave of Absence or Early Completion',
              zh: '休学·提前结业时的注意事项',
              vi: 'Lưu ý khi bảo lưu hoặc hoàn thành sớm chương trình học',
            ),
            bullets: [
              L10nText(
                ko: '휴학하면 원칙적으로 유학(D-2) 체류자격 유지가 어려워질 수 있어 사전에 학교 국제처와 상담해야 합니다.',
                en: 'Taking a leave of absence can, in principle, make it difficult to maintain your D-2 (Study Abroad) status of stay, so you should consult your school\'s international affairs office beforehand.',
                zh: '休学原则上可能导致难以维持留学(D-2)滞留资格,应事先与学校国际处进行咨询。',
                vi: 'Việc bảo lưu về nguyên tắc có thể gây khó khăn cho việc duy trì tư cách lưu trú du học (D-2), nên cần tham vấn trước với phòng quốc tế của trường.',
              ),
              L10nText(
                ko: '조기 졸업·수료 시에는 체류자격 변경(구직 D-10 등)을 별도로 검토해야 합니다.',
                en: 'If you graduate or complete your program early, you must separately consider a change of status of stay (such as job-seeking status D-10).',
                zh: '提前毕业·结业时,须另行考虑滞留资格变更(如求职D-10等)。',
                vi: 'Khi tốt nghiệp hoặc hoàn thành chương trình sớm, cần xem xét riêng việc thay đổi tư cách lưu trú (như visa tìm việc D-10...).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '체류자격 변경 (E-7-4 / F-2-R) 승급 요건',
          en: 'Status of Stay Change (E-7-4 / F-2-R): Upgrade Requirements',
          zh: '滞留资格变更(E-7-4 / F-2-R)升级要求',
          vi: 'Điều kiện nâng cấp thay đổi tư cách lưu trú (E-7-4 / F-2-R)',
        ),
        summary: L10nText(
          ko: '숙련기능인력(E-7-4) 및 지역특화형(F-2-R) 비자 전환을 통해 장기 체류 및 가족 동반 자격을 확보할 수 있습니다.',
          en: 'By switching to the Skilled Worker (E-7-4) or Region-Specific (F-2-R) visa, you can secure long-term stay and the right to bring family members.',
          zh: '通过转换为熟练技能人才(E-7-4)或地区特化型(F-2-R)签证,可获得长期滞留及携带家属的资格。',
          vi: 'Bằng cách chuyển sang visa Lao động kỹ năng (E-7-4) hoặc Đặc thù khu vực (F-2-R), bạn có thể đảm bảo tư cách lưu trú dài hạn và bảo lãnh gia đình.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: 'E-7-4(숙련기능인력) 자격 변경 요건',
              en: 'Requirements for E-7-4 (Skilled Worker) Status Change',
              zh: 'E-7-4(熟练技能人才)资格变更要求',
              vi: 'Điều kiện thay đổi tư cách lưu trú E-7-4 (Lao động kỹ năng)',
            ),
            bullets: [
              L10nText(
                ko: '근속 요건: 최근 10년 중 E-9·H-2 자격으로 4년 이상 근무',
                en: 'Work tenure requirement: at least 4 years of employment under E-9 or H-2 status within the last 10 years',
                zh: '任职年限要求:近10年内以E-9·H-2资格工作满4年以上',
                vi: 'Yêu cầu thời gian làm việc: đã làm việc từ 4 năm trở lên với tư cách E-9 hoặc H-2 trong 10 năm gần nhất',
              ),
              L10nText(
                ko: 'K-point 점수: 총 300점 중 200점 이상 획득',
                en: 'K-point score: at least 200 out of a total of 300 points',
                zh: 'K-point评分:总分300分中须获得200分以上',
                vi: 'Điểm K-point: đạt từ 200 điểm trở lên trên tổng số 300 điểm',
              ),
              L10nText(
                ko: '소득 요건: 최근 2년간 연평균 소득 2,600만 원 이상',
                en: 'Income requirement: an average annual income of at least KRW 26,000,000 over the last 2 years',
                zh: '收入要求:近2年年平均收入达2,600万韩元以上',
                vi: 'Yêu cầu thu nhập: thu nhập bình quân năm trong 2 năm gần nhất từ 26.000.000 won trở lên',
              ),
              L10nText(
                ko: '한국어: TOPIK 2급 이상 또는 사회통합프로그램 2단계 이수',
                en: 'Korean language: TOPIK Level 2 or higher, or completion of Level 2 of the Social Integration Program',
                zh: '韩语能力:TOPIK 2级以上或完成社会融合项目第2阶段',
                vi: 'Tiếng Hàn: TOPIK cấp 2 trở lên hoặc hoàn thành giai đoạn 2 Chương trình hòa nhập xã hội',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: 'F-2-R(지역특화형 비자) 자격 변경 요건',
              en: 'Requirements for F-2-R (Region-Specific Visa) Status Change',
              zh: 'F-2-R(地区特化型签证)资格变更要求',
              vi: 'Điều kiện thay đổi tư cách lưu trú F-2-R (visa đặc thù khu vực)',
            ),
            bullets: [
              L10nText(
                ko: '지역 지정: 인구감소지역 지정 지자체 5년 이상 거주·취업 약정',
                en: 'Regional designation: a commitment to reside and work for at least 5 years in a local government area designated as a population-declining region',
                zh: '地区指定:承诺在被指定为人口减少地区的地方自治体居住·就业满5年以上',
                vi: 'Chỉ định khu vực: cam kết cư trú và làm việc từ 5 năm trở lên tại địa phương được chỉ định là khu vực suy giảm dân số',
              ),
              L10nText(
                ko: '소득 기준: 전년도 1인당 국민총소득(GNI) 70% 이상 소득 충족',
                en: 'Income standard: income of at least 70% of the previous year\'s per-capita Gross National Income (GNI)',
                zh: '收入标准:达到上一年度人均国民总收入(GNI)70%以上',
                vi: 'Tiêu chuẩn thu nhập: đạt từ 70% trở lên thu nhập quốc dân bình quân đầu người (GNI) của năm trước',
              ),
              L10nText(
                ko: '학력·자격: 전문학사 이상 학위 또는 지정 자격증 보유',
                en: 'Education/qualification: an associate degree or higher, or possession of a designated professional certification',
                zh: '学历·资质:具有专科以上学历或指定资格证书',
                vi: 'Học vấn/chứng chỉ: có bằng cao đẳng trở lên hoặc sở hữu chứng chỉ chuyên môn được chỉ định',
              ),
              L10nText(
                ko: '한국어: 사회통합프로그램 4단계 이상 또는 TOPIK 3급 이상',
                en: 'Korean language: Level 4 or higher of the Social Integration Program, or TOPIK Level 3 or higher',
                zh: '韩语能力:社会融合项目第4阶段以上或TOPIK 3级以上',
                vi: 'Tiếng Hàn: giai đoạn 4 trở lên Chương trình hòa nhập xã hội hoặc TOPIK cấp 3 trở lên',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '자격 변경 혜택',
              en: 'Benefits of a Status Change',
              zh: '资格变更的优惠',
              vi: 'Lợi ích khi thay đổi tư cách lưu trú',
            ),
            bullets: [
              L10nText(
                ko: '체류기간 지속 연장 가능 및 자유로운 사업장 이직권 확보',
                en: 'Continuous stay extensions become possible, and you gain the right to freely change workplaces',
                zh: '可持续延长滞留期限,并获得自由更换工作单位的权利',
                vi: 'Có thể liên tục gia hạn thời gian lưu trú và có quyền tự do chuyển nơi làm việc',
              ),
              L10nText(
                ko: '배우자 및 미성년 자녀 동반 초청(F-3·F-2-8) 자격 부여',
                en: 'You become eligible to invite your spouse and minor children to join you (F-3/F-2-8 status)',
                zh: '获得邀请配偶及未成年子女陪同来韩(F-3·F-2-8)的资格',
                vi: 'Được cấp tư cách bảo lãnh vợ/chồng và con chưa thành niên (F-3/F-2-8)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '신청 접수처',
              en: 'Where to Apply',
              zh: '申请受理处',
              vi: 'Nơi tiếp nhận hồ sơ',
            ),
            bullets: [
              L10nText(
                ko: '체류자격 변경은 하이코리아 전자민원 또는 관할 출입국·외국인관서 방문으로 신청할 수 있습니다.',
                en: 'You can apply for a status of stay change either through HiKorea\'s online civil affairs system or by visiting your jurisdictional immigration and foreigner office.',
                zh: '滞留资格变更可通过HiKorea电子民愿或到访管辖出入境·外国人厅申请。',
                vi: 'Bạn có thể nộp đơn thay đổi tư cách lưu trú qua hệ thống hành chính trực tuyến HiKorea hoặc đến trực tiếp văn phòng xuất nhập cảnh và người nước ngoài phụ trách.',
              ),
              L10nText(
                ko: '요건 충족 여부를 사전에 1345 또는 관서 상담을 통해 확인해보는 것을 권합니다.',
                en: 'It is recommended that you check in advance whether you meet the requirements by calling 1345 or consulting with the office.',
                zh: '建议提前通过1345或机构咨询确认自己是否符合条件。',
                vi: 'Nên kiểm tra trước xem có đáp ứng đủ điều kiện hay không bằng cách gọi 1345 hoặc tư vấn tại văn phòng.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  3: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '고용허가제(EPS)란',
          en: 'What Is the Employment Permit System (EPS)',
          zh: '什么是雇佣许可制(EPS)',
          vi: 'Chế độ cấp phép việc làm (EPS) là gì',
        ),
        summary: L10nText(
          ko: '고용허가제는 내국인을 구하지 못한 사업주가 정부의 허가를 받아 외국인근로자를 합법적으로 고용하는 제도이며, 구인부터 사업장 배치까지 전 과정이 정부기관을 거칩니다.',
          en: 'The Employment Permit System lets employers who cannot find Korean workers legally hire foreign workers with government permission, with the entire process — from recruitment to workplace placement — going through government agencies.',
          zh: '雇佣许可制是指招不到本国员工的雇主经政府许可后合法雇佣外国劳动者的制度,从招聘到分配工作单位的全过程均须经过政府机构办理。',
          vi: 'Chế độ cấp phép việc làm là chế độ cho phép chủ sử dụng lao động không tuyển được lao động trong nước được chính phủ cấp phép để tuyển dụng hợp pháp lao động nước ngoài, toàn bộ quá trình từ tuyển dụng đến phân công nơi làm việc đều thông qua cơ quan nhà nước.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '고용허가제의 기본 구조',
              en: 'Basic Structure of the Employment Permit System',
              zh: '雇佣许可制的基本结构',
              vi: 'Cấu trúc cơ bản của Chế độ cấp phép việc làm',
            ),
            bullets: [
              L10nText(
                ko: '근거 법령: 외국인근로자의 고용 등에 관한 법률',
                en: 'Legal basis: the Act on the Employment, etc. of Foreign Workers',
                zh: '法律依据:《外国人劳动者雇佣等相关法律》',
                vi: 'Căn cứ pháp lý: Luật về việc tuyển dụng người lao động nước ngoài',
              ),
              L10nText(
                ko: '담당 기관: 고용노동부(제도 총괄), 한국산업인력공단(EPS 실무·해외 송출), 고용센터(허가서 발급)',
                en: 'Responsible agencies: the Ministry of Employment and Labor (overall policy), the Human Resources Development Service of Korea (EPS operations and overseas sending), and Employment Centers (permit issuance)',
                zh: '主管机构:雇佣劳动部(制度总管)、韩国产业人力公团(EPS事务·海外派遣)、雇佣中心(许可证签发)',
                vi: 'Cơ quan phụ trách: Bộ Việc làm và Lao động (quản lý chung chế độ), Cơ quan Phát triển nguồn nhân lực Hàn Quốc (nghiệp vụ EPS, đưa lao động ra nước ngoài), Trung tâm việc làm (cấp giấy phép)',
              ),
              L10nText(
                ko: '대상 비자: 비전문취업(E-9), 방문취업(H-2)',
                en: 'Applicable visas: Non-professional Employment (E-9), Working Visit (H-2)',
                zh: '适用签证:非专门就业(E-9)、访问就业(H-2)',
                vi: 'Visa áp dụng: Lao động phổ thông (E-9), Thăm thân kết hợp làm việc (H-2)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '전체 흐름 한눈에 보기',
              en: 'The Whole Process at a Glance',
              zh: '整体流程一览',
              vi: 'Tổng quan toàn bộ quy trình',
            ),
            bullets: [
              L10nText(
                ko: '입국 전: 구인노력 → 고용허가서 발급 → 표준근로계약 체결 → 사증발급인정서·비자 발급',
                en: 'Before entry: recruitment effort → issuance of the employment permit → signing of the standard labor contract → issuance of the visa confirmation certificate/visa',
                zh: '入境前:招聘努力 → 签发雇佣许可证 → 签订标准劳动合同 → 签发签证签发认定书·签证',
                vi: 'Trước khi nhập cảnh: nỗ lực tuyển dụng → cấp giấy phép tuyển dụng → ký hợp đồng lao động chuẩn → cấp giấy xác nhận cấp visa/visa',
              ),
              L10nText(
                ko: '입국 후: 입국 → 취업교육 → 건강검진 → 사업장 배치 → 근로 시작',
                en: 'After entry: entry → employment training → health checkup → workplace placement → start of work',
                zh: '入境后:入境 → 就业教育 → 健康检查 → 分配工作单位 → 开始工作',
                vi: 'Sau khi nhập cảnh: nhập cảnh → đào tạo việc làm → khám sức khỏe → phân công nơi làm việc → bắt đầu làm việc',
              ),
              L10nText(
                ko: '전체 소요기간은 통상 3~6개월로 알려져 있습니다.',
                en: 'The whole process is generally known to take about 3–6 months.',
                zh: '整个过程通常需要3~6个月左右。',
                vi: 'Toàn bộ quá trình thường được biết là mất khoảng 3-6 tháng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '허용 업종과 제도 구분',
              en: 'Permitted Industries and System Types',
              zh: '允许行业与制度分类',
              vi: 'Ngành nghề được phép và phân loại chế độ',
            ),
            bullets: [
              L10nText(
                ko: '일반고용허가제(E-9): 제조업·건설업·농축산업·어업·일부 서비스업 등 정부가 지정한 업종에서만 고용 가능',
                en: 'General Employment Permit System (E-9): employment is allowed only in industries designated by the government, such as manufacturing, construction, agriculture/livestock, fisheries, and some service sectors',
                zh: '一般雇佣许可制(E-9):仅限在政府指定的制造业、建筑业、农畜产业、渔业及部分服务业等行业雇佣',
                vi: 'Chế độ cấp phép việc làm thông thường (E-9): chỉ được tuyển dụng trong các ngành do chính phủ chỉ định như sản xuất, xây dựng, nông súc sản, ngư nghiệp, một số ngành dịch vụ',
              ),
              L10nText(
                ko: '특례고용허가제(H-2, 방문취업): 중국·구소련 지역 동포가 대상이며 취업 허용 업종 범위가 더 넓습니다.',
                en: 'Special Employment Permit System (H-2, Working Visit): applies to overseas Koreans from China and the former Soviet Union region, and permits employment in a broader range of industries.',
                zh: '特例雇佣许可制(H-2,访问就业):以中国及前苏联地区同胞为对象,允许从事的行业范围更广。',
                vi: 'Chế độ cấp phép việc làm đặc biệt (H-2, Thăm thân kết hợp làm việc): áp dụng cho kiều bào tại Trung Quốc và khu vực Liên Xô cũ, phạm vi ngành nghề được phép làm việc rộng hơn.',
              ),
              L10nText(
                ko: '매년 정부가 업종별 외국인력 도입 규모(쿼터)를 정해 발표합니다.',
                en: 'Every year the government sets and announces the quota for foreign workers by industry.',
                zh: '政府每年会确定并公布各行业引进外国人力的规模(配额)。',
                vi: 'Mỗi năm chính phủ quy định và công bố quy mô tiếp nhận lao động nước ngoài (hạn ngạch) theo từng ngành.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '구직자명부 등록 전 준비',
              en: 'Preparation Before Registering on the Job-Seekers List',
              zh: '登记求职者名册前的准备',
              vi: 'Chuẩn bị trước khi đăng ký vào danh sách người tìm việc',
            ),
            bullets: [
              L10nText(
                ko: 'EPS-TOPIK(한국어능력시험) 합격과 건강검진 통과가 구직자명부 등록의 전제조건입니다.',
                en: 'Passing the EPS-TOPIK (Korean language proficiency test) and passing a health checkup are prerequisites for registering on the job-seekers list.',
                zh: '通过EPS-TOPIK(韩国语能力考试)及体检合格是登记求职者名册的前提条件。',
                vi: 'Đỗ kỳ thi EPS-TOPIK (kỳ thi năng lực tiếng Hàn) và vượt qua khám sức khỏe là điều kiện tiên quyết để đăng ký vào danh sách người tìm việc.',
              ),
              L10nText(
                ko: '시험 합격의 유효기간은 발표일로부터 2년이며, 그 안에 구직자로 등록해야 합니다.',
                en: 'A passing test result is valid for 2 years from the announcement date, and you must register as a job seeker within that period.',
                zh: '考试合格成绩自公布之日起有效期为2年,须在此期限内登记为求职者。',
                vi: 'Kết quả thi đỗ có hiệu lực trong 2 năm kể từ ngày công bố, và phải đăng ký làm người tìm việc trong khoảng thời gian đó.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '입국 전 절차',
          en: 'Procedures Before Entry',
          zh: '入境前流程',
          vi: 'Thủ tục trước khi nhập cảnh',
        ),
        summary: L10nText(
          ko: '사업주의 구인 신청부터 근로계약 체결, 비자 발급까지는 근로자가 아니라 사업주와 송출기관이 진행하는 구간입니다.',
          en: 'From the employer\'s recruitment application through signing the labor contract to visa issuance, this stage is handled by the employer and the sending agency, not the worker.',
          zh: '从雇主提出招聘申请、签订劳动合同到签发签证,这一阶段是由雇主与派遣机构进行,而非劳动者本人。',
          vi: 'Từ giai đoạn chủ sử dụng lao động nộp đơn tuyển dụng, ký hợp đồng lao động cho đến cấp visa, đây là giai đoạn do chủ sử dụng lao động và cơ quan phái cử thực hiện, không phải người lao động.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '사업주 측 절차',
              en: 'Employer-Side Procedures',
              zh: '雇主一方的流程',
              vi: 'Thủ tục phía chủ sử dụng lao động',
            ),
            bullets: [
              L10nText(
                ko: '내국인 구인 신청 → 미충원 시 고용센터에서 고용허가서 발급',
                en: 'Apply to recruit Korean workers → if the position remains unfilled, the Employment Center issues an employment permit',
                zh: '本国人招聘申请 → 未招满时由雇佣中心签发雇佣许可证',
                vi: 'Nộp đơn tuyển dụng lao động trong nước → nếu không tuyển đủ, Trung tâm việc làm cấp giấy phép tuyển dụng',
              ),
              L10nText(
                ko: '송출국 인력풀에서 근로자 선정 후 표준근로계약서 체결',
                en: 'Select a worker from the sending country\'s labor pool, then sign the standard labor contract',
                zh: '从派遣国人才库中挑选劳动者后,签订标准劳动合同',
                vi: 'Chọn người lao động từ nguồn nhân lực của nước phái cử, sau đó ký hợp đồng lao động chuẩn',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '근로자가 확인해야 할 것',
              en: 'What Workers Should Check',
              zh: '劳动者应确认的事项',
              vi: 'Những điều người lao động cần kiểm tra',
            ),
            bullets: [
              L10nText(
                ko: '표준근로계약서에 적힌 사업장명·업종·임금·근로시간이 실제와 같은지 송출기관을 통해 확인',
                en: 'Confirm through the sending agency that the workplace name, industry, wages, and working hours stated in the standard labor contract match the actual conditions',
                zh: '通过派遣机构确认标准劳动合同上记载的单位名称、行业、工资、工作时间是否与实际相符',
                vi: 'Kiểm tra qua cơ quan phái cử xem tên nơi làm việc, ngành nghề, tiền lương, giờ làm việc ghi trong hợp đồng lao động chuẩn có đúng với thực tế hay không',
              ),
              L10nText(
                ko: '사증발급인정서 발급 후 주한공관에서 E-9/H-2 비자 신청',
                en: 'After the visa confirmation certificate is issued, apply for the E-9/H-2 visa at a Korean diplomatic mission',
                zh: '签发签证签发认定书后,在驻当地韩国使领馆申请E-9/H-2签证',
                vi: 'Sau khi cấp giấy xác nhận cấp visa, nộp đơn xin visa E-9/H-2 tại cơ quan đại diện ngoại giao Hàn Quốc',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '표준근로계약 기간',
              en: 'Standard Labor Contract Period',
              zh: '标准劳动合同期限',
              vi: 'Thời hạn hợp đồng lao động chuẩn',
            ),
            bullets: [
              L10nText(
                ko: '최초 근로계약 기간은 최대 3년 이내에서 사업주와 협의해 정합니다.',
                en: 'The initial labor contract period is set through agreement with the employer, up to a maximum of 3 years.',
                zh: '首次劳动合同期限在最长3年以内,由雇主协商确定。',
                vi: 'Thời hạn hợp đồng lao động lần đầu được thỏa thuận với chủ sử dụng lao động, tối đa trong vòng 3 năm.',
              ),
              L10nText(
                ko: '계약 기간은 이후 재고용 절차를 통해 연장할 수 있습니다 — ②비자 참고',
                en: 'The contract period can later be extended through the re-employment procedure — see ② Visa',
                zh: '合同期限可通过后续再雇佣程序延长 — 参见②签证',
                vi: 'Thời hạn hợp đồng có thể được gia hạn sau đó thông qua thủ tục tái tuyển dụng — tham khảo mục ② Visa',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '송출기관의 역할',
              en: 'Role of the Sending Agency',
              zh: '派遣机构的作用',
              vi: 'Vai trò của cơ quan phái cử',
            ),
            bullets: [
              L10nText(
                ko: '송출국 정부가 지정한 송출기관이 인력풀 관리와 서류 확인을 담당합니다.',
                en: 'A sending agency designated by the sending country\'s government manages the labor pool and verifies documents.',
                zh: '由派遣国政府指定的派遣机构负责人才库管理及材料核验。',
                vi: 'Cơ quan phái cử do chính phủ nước phái cử chỉ định chịu trách nhiệm quản lý nguồn nhân lực và xác minh hồ sơ.',
              ),
              L10nText(
                ko: '부당한 송출 비용을 요구받았다면 한국산업인력공단 EPS 상담센터(1577-0071)에 문의할 수 있습니다.',
                en: 'If you are asked to pay an unfair sending fee, you can contact the Human Resources Development Service of Korea\'s EPS Counseling Center (1577-0071).',
                zh: '如遭遇不合理的派遣费用要求,可致电韩国产业人力公团EPS咨询中心(1577-0071)咨询。',
                vi: 'Nếu bị yêu cầu trả phí phái cử bất hợp lý, bạn có thể liên hệ Trung tâm tư vấn EPS của Cơ quan Phát triển nguồn nhân lực Hàn Quốc (1577-0071).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '입국 당일부터 취업교육까지',
          en: 'From Arrival Day to Employment Training',
          zh: '从入境当天到就业教育',
          vi: 'Từ ngày nhập cảnh đến khi đào tạo việc làm',
        ),
        summary: L10nText(
          ko: '입국 후 15일 이내에 취업교육을 마쳐야 하며, 교육을 이수해야 다음 단계인 건강검진과 사업장 배치로 넘어갑니다.',
          en: 'Employment training must be completed within 15 days of entry; only after completing it can you move on to the next stage — the health checkup and workplace placement.',
          zh: '须在入境后15天内完成就业教育,只有完成教育才能进入下一阶段——体检及分配工作单位。',
          vi: 'Phải hoàn thành đào tạo việc làm trong vòng 15 ngày sau khi nhập cảnh, và chỉ khi hoàn thành đào tạo mới có thể chuyển sang giai đoạn tiếp theo là khám sức khỏe và phân công nơi làm việc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '공항 도착 후 첫 절차',
              en: 'First Steps After Arriving at the Airport',
              zh: '抵达机场后的首要流程',
              vi: 'Thủ tục đầu tiên sau khi đến sân bay',
            ),
            bullets: [
              L10nText(
                ko: '인천공항 등 지정 공항에서 한국산업인력공단(EPS) 인솔에 따라 교육기관으로 이동',
                en: 'At a designated airport such as Incheon International Airport, you will be guided by the Human Resources Development Service of Korea (EPS) to a training institution',
                zh: '在仁川机场等指定机场,在韩国产业人力公团(EPS)的带领下前往教育机构',
                vi: 'Tại sân bay được chỉ định như sân bay Incheon, được Cơ quan Phát triển nguồn nhân lực Hàn Quốc (EPS) hướng dẫn di chuyển đến cơ sở đào tạo',
              ),
              L10nText(
                ko: '여권, 표준근로계약서 사본 지참 필수',
                en: 'You must bring your passport and a copy of the standard labor contract',
                zh: '必须携带护照及标准劳动合同复印件',
                vi: 'Bắt buộc phải mang theo hộ chiếu và bản sao hợp đồng lao động chuẩn',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '취업교육 이수 의무',
              en: 'Obligation to Complete Employment Training',
              zh: '完成就业教育的义务',
              vi: 'Nghĩa vụ hoàn thành đào tạo việc làm',
            ),
            bullets: [
              L10nText(
                ko: '입국일로부터 15일 이내 한국산업인력공단 또는 지정 외국인 취업교육기관에서 교육 이수',
                en: 'Complete training within 15 days of entry at the Human Resources Development Service of Korea or a designated foreign worker training institution',
                zh: '须在入境之日起15天内,在韩国产业人力公团或指定外国人就业教育机构完成教育',
                vi: 'Hoàn thành đào tạo trong vòng 15 ngày kể từ ngày nhập cảnh tại Cơ quan Phát triển nguồn nhân lực Hàn Quốc hoặc cơ sở đào tạo việc làm cho người nước ngoài được chỉ định',
              ),
              L10nText(
                ko: '교육 내용: 한국어·산업안전·한국문화·근로기준법 기초',
                en: 'Training content: basic Korean language, industrial safety, Korean culture, and the Labor Standards Act',
                zh: '教育内容:基础韩语、产业安全、韩国文化、劳动基准法基础',
                vi: 'Nội dung đào tạo: tiếng Hàn cơ bản, an toàn công nghiệp, văn hóa Hàn Quốc, kiến thức cơ bản về Luật tiêu chuẩn lao động',
              ),
              L10nText(
                ko: '교육 미이수 시 사업장 배치가 지연됩니다.',
                en: 'Failure to complete the training delays workplace placement.',
                zh: '未完成教育将导致分配工作单位延迟。',
                vi: 'Nếu không hoàn thành đào tạo, việc phân công nơi làm việc sẽ bị trì hoãn.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '교육 비용과 이수증',
              en: 'Training Costs and Certificate of Completion',
              zh: '教育费用与结业证书',
              vi: 'Chi phí đào tạo và giấy chứng nhận hoàn thành',
            ),
            bullets: [
              L10nText(
                ko: '취업교육 비용은 사업주가 부담하는 것이 원칙입니다.',
                en: 'In principle, the employer bears the cost of the employment training.',
                zh: '原则上就业教育费用由雇主承担。',
                vi: 'Về nguyên tắc, chi phí đào tạo việc làm do chủ sử dụng lao động chi trả.',
              ),
              L10nText(
                ko: '이수 후 발급되는 취업교육 수료증은 사업장 배치 절차에서 제출 서류로 쓰입니다.',
                en: 'The certificate of completion issued after training is used as a required document in the workplace placement process.',
                zh: '完成教育后颁发的就业教育结业证将作为分配工作单位程序中的提交材料。',
                vi: 'Giấy chứng nhận hoàn thành đào tạo việc làm được cấp sau khi hoàn thành sẽ được dùng làm hồ sơ nộp trong thủ tục phân công nơi làm việc.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '교육 중 유의사항',
              en: 'Cautions During Training',
              zh: '教育期间注意事项',
              vi: 'Lưu ý trong thời gian đào tạo',
            ),
            bullets: [
              L10nText(
                ko: '교육 기간 중 무단이탈하면 이후 절차 전체가 지연되거나 불이익을 받을 수 있습니다.',
                en: 'Leaving without authorization during the training period can delay the entire subsequent process or result in other disadvantages.',
                zh: '若在教育期间擅自离开,可能导致后续整个流程延迟或产生其他不利后果。',
                vi: 'Nếu tự ý rời khỏi trong thời gian đào tạo, toàn bộ thủ tục sau đó có thể bị trì hoãn hoặc gặp bất lợi.',
              ),
              L10nText(
                ko: '건강 문제 등으로 교육 참석이 어려우면 즉시 교육기관에 알려야 합니다.',
                en: 'If health issues or other reasons make it difficult to attend training, you must notify the training institution immediately.',
                zh: '若因健康问题等原因难以参加教育,须立即通知教育机构。',
                vi: 'Nếu vì lý do sức khỏe hoặc lý do khác mà khó tham gia đào tạo, phải báo ngay cho cơ sở đào tạo.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '건강검진과 사업장 배치',
          en: 'Health Checkup and Workplace Placement',
          zh: '体检与分配工作单位',
          vi: 'Khám sức khỏe và phân công nơi làm việc',
        ),
        summary: L10nText(
          ko: '취업교육 수료 후 지정 건강검진기관에서 검진을 받고, 이상이 없으면 계약된 사업장으로 배치됩니다.',
          en: 'After completing employment training, you undergo an examination at a designated health checkup institution, and if no issues are found, you are assigned to the contracted workplace.',
          zh: '完成就业教育后,须在指定体检机构接受检查,若无异常即被分配至签约的工作单位。',
          vi: 'Sau khi hoàn thành đào tạo việc làm, bạn sẽ khám sức khỏe tại cơ sở khám sức khỏe được chỉ định, nếu không có vấn đề gì sẽ được phân công đến nơi làm việc theo hợp đồng.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '건강검진',
              en: 'Health Checkup',
              zh: '体检',
              vi: 'Khám sức khỏe',
            ),
            bullets: [
              L10nText(
                ko: '검진 항목에 마약류 등 약물 검사가 포함됩니다.',
                en: 'The checkup includes a drug test for substances such as narcotics.',
                zh: '体检项目中包括毒品等药物检测。',
                vi: 'Hạng mục khám bao gồm cả xét nghiệm chất ma túy và các chất gây nghiện khác.',
              ),
              L10nText(
                ko: '검진 결과에 취업 부적합 사유가 있으면 배치가 보류될 수 있습니다.',
                en: 'If the checkup finds you unfit for employment, your placement may be put on hold.',
                zh: '若体检结果发现不适合就业的情况,分配工作单位可能被暂缓。',
                vi: 'Nếu kết quả khám cho thấy không đủ điều kiện làm việc, việc phân công có thể bị tạm hoãn.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '사업장 배치',
              en: 'Workplace Placement',
              zh: '分配工作单位',
              vi: 'Phân công nơi làm việc',
            ),
            bullets: [
              L10nText(
                ko: '표준근로계약서에 명시된 사업장으로 이동, 사업주가 마중 또는 교통편 안내',
                en: 'You travel to the workplace specified in the standard labor contract; the employer meets you or arranges transportation',
                zh: '前往标准劳动合同中指定的工作单位,由雇主接站或安排交通',
                vi: 'Di chuyển đến nơi làm việc ghi trong hợp đồng lao động chuẩn, chủ sử dụng lao động sẽ đón hoặc hướng dẫn phương tiện di chuyển',
              ),
              L10nText(
                ko: '배치 직후 사업주와 근로계약서 원본을 다시 한 번 대조 확인',
                en: 'Immediately after placement, cross-check the original labor contract with your employer once more',
                zh: '分配到岗后应立即与雇主再次核对劳动合同原件',
                vi: 'Ngay sau khi được phân công, hãy đối chiếu lại bản gốc hợp đồng lao động với chủ sử dụng lao động một lần nữa',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '배치 후 수습기간 임금',
              en: 'Wages During the Probation Period After Placement',
              zh: '分配后试用期工资',
              vi: 'Tiền lương trong thời gian thử việc sau khi được phân công',
            ),
            bullets: [
              L10nText(
                ko: '근로계약 기간이 1년 이상이고 수습 시작 후 3개월 이내인 경우에 한해 최저임금의 90%까지 감액할 수 있습니다.',
                en: 'Only when the labor contract period is 1 year or longer and within the first 3 months of probation can wages be reduced to as low as 90% of the minimum wage.',
                zh: '仅当劳动合同期限在1年以上且处于试用开始后3个月以内时,方可将工资降至最低工资的90%。',
                vi: 'Chỉ khi thời hạn hợp đồng lao động từ 1 năm trở lên và trong vòng 3 tháng kể từ khi bắt đầu thử việc, mới được giảm lương xuống tối đa còn 90% mức lương tối thiểu.',
              ),
              L10nText(
                ko: '단순노무직으로 분류되면 수습기간에도 최저임금 100%를 받아야 합니다.',
                en: 'If your job is classified as simple labor, you must receive 100% of the minimum wage even during the probation period.',
                zh: '若被归类为简单劳务工种,即使在试用期也须获得最低工资的100%。',
                vi: 'Nếu được phân loại là công việc lao động giản đơn, dù trong thời gian thử việc vẫn phải nhận đủ 100% mức lương tối thiểu.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '무단이탈 시 불이익',
              en: 'Disadvantages of Leaving Without Authorization',
              zh: '擅自离职的不利后果',
              vi: 'Bất lợi khi tự ý rời khỏi nơi làm việc',
            ),
            bullets: [
              L10nText(
                ko: '정당한 사유 없이 사업장을 이탈하면 불법체류로 처리되어 이후 재입국이 어려워질 수 있습니다.',
                en: 'Leaving your workplace without a legitimate reason is treated as illegal stay and can make it difficult to re-enter Korea in the future.',
                zh: '若无正当理由擅自离开工作单位,将被视为非法滞留,今后可能难以再次入境。',
                vi: 'Nếu tự ý rời khỏi nơi làm việc mà không có lý do chính đáng, sẽ bị coi là lưu trú bất hợp pháp và có thể gặp khó khăn khi nhập cảnh trở lại sau này.',
              ),
              L10nText(
                ko: '부득이한 사정이 있다면 사업장 변경 절차(④체류신고)를 통해 합법적으로 옮겨야 합니다.',
                en: 'If there are unavoidable circumstances, you must transfer legally through the workplace change procedure (see ④ Residence Reporting).',
                zh: '如有不得已的情况,须通过更换工作单位程序(参见④滞留申报)合法转移。',
                vi: 'Nếu có lý do bất khả kháng, phải chuyển nơi làm việc một cách hợp pháp thông qua thủ tục thay đổi nơi làm việc (tham khảo mục ④ Khai báo lưu trú).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '취업 후 첫 달 체크리스트',
          en: 'First-Month Checklist After Starting Work',
          zh: '就业后首月清单',
          vi: 'Danh sách việc cần làm trong tháng đầu sau khi đi làm',
        ),
        summary: L10nText(
          ko: '사업장 배치 이후에는 외국인등록(ARC), 통신 개통, 계좌 개설, 4대보험 가입을 순서대로 처리해야 다음 생활이 이어집니다.',
          en: 'After workplace placement, you must complete alien registration (ARC), mobile phone activation, bank account opening, and enrollment in the four major social insurances, in that order, for the rest of your life in Korea to proceed smoothly.',
          zh: '分配至工作单位后,须依次完成外国人登录(ARC)、通讯开通、开设账户、加入四大保险,后续生活才能顺利展开。',
          vi: 'Sau khi được phân công nơi làm việc, cần lần lượt hoàn tất đăng ký người nước ngoài (ARC), đăng ký thuê bao điện thoại, mở tài khoản ngân hàng, tham gia 4 loại bảo hiểm xã hội để cuộc sống tiếp theo được thuận lợi.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '근무 시작 직후 처리할 행정',
              en: 'Administrative Tasks Right After Starting Work',
              zh: '开始工作后应立即办理的行政事务',
              vi: 'Thủ tục hành chính cần xử lý ngay sau khi bắt đầu làm việc',
            ),
            bullets: [
              L10nText(
                ko: '입국 후 90일 이내 외국인등록(ARC) 신청 — ①등록증 참고',
                en: 'Apply for alien registration (ARC) within 90 days of entry — see ① Registration Card',
                zh: '入境后90天内申请外国人登录(ARC)——参见①登录证',
                vi: 'Đăng ký người nước ngoài (ARC) trong vòng 90 ngày sau khi nhập cảnh — tham khảo mục ① Thẻ đăng ký',
              ),
              L10nText(
                ko: '근로계약 효력발생일부터 15일 이내 상해보험, 3개월 이내 귀국비용보험·신탁 가입 — ⑥보험 참고',
                en: 'Enroll in injury insurance within 15 days of the labor contract taking effect, and in return-cost insurance/trust within 3 months — see ⑥ Insurance',
                zh: '自劳动合同生效之日起15天内加入伤害保险,3个月内加入回国费用保险·信托——参见⑥保险',
                vi: 'Tham gia bảo hiểm tai nạn trong vòng 15 ngày kể từ ngày hợp đồng lao động có hiệu lực, tham gia bảo hiểm/ủy thác chi phí về nước trong vòng 3 tháng — tham khảo mục ⑥ Bảo hiểm',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '문의처',
              en: 'Where to Get Help',
              zh: '咨询处',
              vi: 'Nơi liên hệ tư vấn',
            ),
            bullets: [
              L10nText(
                ko: 'EPS 고용허가제 통합서비스(eps.hrdkorea.or.kr), 한국산업인력공단 지역본부',
                en: 'EPS Employment Permit System Integrated Service (eps.hrdkorea.or.kr), regional headquarters of the Human Resources Development Service of Korea',
                zh: 'EPS雇佣许可制综合服务(eps.hrdkorea.or.kr)、韩国产业人力公团地区总部',
                vi: 'Dịch vụ tổng hợp Chế độ cấp phép việc làm EPS (eps.hrdkorea.or.kr), trụ sở khu vực của Cơ quan Phát triển nguồn nhân lực Hàn Quốc',
              ),
              L10nText(
                ko: '법무부 외국인종합안내센터 1345(09:00~22:00, 한국어·영어·중국어 외 다수 언어)',
                en: 'Ministry of Justice Immigration Contact Center 1345 (09:00–22:00, available in Korean, English, Chinese, and many other languages)',
                zh: '法务部外国人综合咨询中心1345(09:00~22:00,提供韩语、英语、中文及多种其他语言服务)',
                vi: 'Trung tâm tư vấn tổng hợp người nước ngoài của Bộ Tư pháp 1345 (09:00~22:00, hỗ trợ tiếng Hàn, tiếng Anh, tiếng Trung và nhiều ngôn ngữ khác)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '사업장 변경은 원칙적으로 제한',
              en: 'Workplace Changes Are Restricted in Principle',
              zh: '原则上限制更换工作单位',
              vi: 'Về nguyên tắc, việc thay đổi nơi làm việc bị hạn chế',
            ),
            bullets: [
              L10nText(
                ko: '취업활동 기간 중 사업장 변경은 원칙적으로 최초 입국 후 3회, 재고용 연장 기간 중 2회를 넘을 수 없습니다.',
                en: 'In principle, you cannot change workplaces more than 3 times after your initial entry, and no more than 2 times during a re-employment extension period.',
                zh: '原则上,在就业活动期间,首次入境后更换工作单位不得超过3次,再雇佣延长期间不得超过2次。',
                vi: 'Về nguyên tắc, trong thời gian hoạt động việc làm, không được thay đổi nơi làm việc quá 3 lần sau lần nhập cảnh đầu tiên, và không quá 2 lần trong thời gian gia hạn tái tuyển dụng.',
              ),
              L10nText(
                ko: '사업주의 근로조건 위반 등 근로자 책임이 아닌 사유라면 횟수 제한 없이 변경할 수 있습니다 — ④체류신고 참고',
                en: 'If the reason is not the worker\'s fault — such as the employer violating working conditions — there is no limit on the number of changes. See ④ Residence Reporting.',
                zh: '若因雇主违反劳动条件等非劳动者自身责任的原因,更换次数不受限制——参见④滞留申报',
                vi: 'Nếu lý do không phải trách nhiệm của người lao động, chẳng hạn như chủ sử dụng lao động vi phạm điều kiện làm việc, thì được thay đổi không giới hạn số lần — tham khảo mục ④ Khai báo lưu trú',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '첫 급여 받기 전 확인',
              en: 'What to Check Before Your First Paycheck',
              zh: '领取首笔工资前的确认事项',
              vi: 'Kiểm tra trước khi nhận lương tháng đầu tiên',
            ),
            bullets: [
              L10nText(
                ko: '근로계약서에 적힌 임금 항목과 실제 급여명세서 항목이 일치하는지 첫 달부터 대조하세요.',
                en: 'From the first month, check that the wage items listed in your labor contract match the actual items on your pay stub.',
                zh: '从第一个月起就应核对劳动合同上记载的工资项目与实际工资单项目是否一致。',
                vi: 'Ngay từ tháng đầu tiên, hãy đối chiếu các khoản lương ghi trong hợp đồng lao động với các khoản thực tế trên phiếu lương.',
              ),
              L10nText(
                ko: '3.3% 사업소득세로 처리되고 있다면 근로자성이 의심되는 상황이니 ⑨근로계약서를 확인하세요.',
                en: 'If your pay is being processed as a 3.3% business income tax deduction, this raises doubts about your status as an employee — check ⑨ Labor Contract.',
                zh: '若被按3.3%的营业所得税处理,则说明劳动者身份存疑,请查看⑨劳动合同。',
                vi: 'Nếu lương đang bị khấu trừ thuế thu nhập kinh doanh 3,3%, đây là dấu hiệu đáng ngờ về tư cách người lao động, hãy kiểm tra mục ⑨ Hợp đồng lao động.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  4: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '체류신고, 왜 중요한가',
          en: 'Why Residence Reporting Matters',
          zh: '为何滞留申报如此重要',
          vi: 'Tại sao khai báo lưu trú lại quan trọng',
        ),
        summary: L10nText(
          ko: '체류신고는 선택이 아니라 출입국관리법상 의무이며, 종류별로 신고 기한과 신고처가 다릅니다.',
          en: 'Residence reporting is not optional — it is a legal obligation under the Immigration Control Act, and the reporting deadline and location differ depending on the type.',
          zh: '滞留申报并非可选事项,而是《出入境管理法》规定的义务,不同种类的申报有各自的申报期限和申报地点。',
          vi: 'Khai báo lưu trú không phải là tùy chọn mà là nghĩa vụ theo Luật Quản lý xuất nhập cảnh, mỗi loại khai báo có thời hạn và nơi khai báo khác nhau.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '네 가지 신고 종류',
              en: 'The Four Types of Reports',
              zh: '四种申报类型',
              vi: 'Bốn loại khai báo',
            ),
            bullets: [
              L10nText(
                ko: '체류지 변경신고(이사), 사업장 변경신고(이직), 출국 전 신고, 외국인등록 사실증명 등 증명서 발급 신청',
                en: 'Report of change of residence (moving), report of change of workplace (job change), report before departure, and applications for certificates such as the alien registration fact certificate',
                zh: '居所变更申报(搬家)、工作单位变更申报(换工作)、出境前申报、外国人登录事实证明等证明文件签发申请',
                vi: 'Khai báo thay đổi nơi cư trú (chuyển nhà), khai báo thay đổi nơi làm việc (đổi việc), khai báo trước khi xuất cảnh, xin cấp các giấy chứng nhận như giấy xác nhận đăng ký người nước ngoài',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '공통 원칙',
              en: 'Common Principles',
              zh: '共同原则',
              vi: 'Nguyên tắc chung',
            ),
            bullets: [
              L10nText(
                ko: '모든 신고는 하이코리아(hikorea.go.kr) 온라인 또는 관할 기관 방문·우편으로 가능합니다.',
                en: 'All reports can be filed either online through HiKorea (hikorea.go.kr) or by visiting or mailing the relevant authority.',
                zh: '所有申报均可通过HiKorea(hikorea.go.kr)在线办理,或到访管辖机构、邮寄办理。',
                vi: 'Tất cả các loại khai báo đều có thể thực hiện trực tuyến qua HiKorea (hikorea.go.kr) hoặc đến trực tiếp/gửi thư đến cơ quan phụ trách.',
              ),
              L10nText(
                ko: '기한을 넘기면 온라인 신고가 제한되어 관할 출입국·외국인관서를 직접 방문해야 하는 경우가 있습니다.',
                en: 'If you miss the deadline, online reporting may be restricted, requiring you to visit your jurisdictional immigration and foreigner office in person.',
                zh: '若超过期限,在线申报可能受限,需亲自前往管辖出入境·外国人厅办理。',
                vi: 'Nếu quá thời hạn, việc khai báo trực tuyến có thể bị hạn chế, khi đó phải trực tiếp đến văn phòng xuất nhập cảnh và người nước ngoài phụ trách.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '신고별 담당기관 한눈에',
              en: 'Responsible Authority for Each Report Type at a Glance',
              zh: '各类申报的主管机构一览',
              vi: 'Tổng quan cơ quan phụ trách theo từng loại khai báo',
            ),
            bullets: [
              L10nText(
                ko: '체류지 변경: 시·군·구청·읍면동 주민센터 또는 관할 출입국·외국인관서',
                en: 'Change of residence: city/county/district office, town/township/neighborhood community center, or jurisdictional immigration and foreigner office',
                zh: '居所变更:市·郡·区厅、邑面洞居民中心或管辖出入境·外国人厅',
                vi: 'Thay đổi nơi cư trú: ủy ban thành phố/quận/huyện, trung tâm dân cư phường/xã hoặc văn phòng xuất nhập cảnh và người nước ngoài phụ trách',
              ),
              L10nText(
                ko: '사업장 변경: 고용센터(신청) → 출입국·외국인관서(근무처 변경허가)',
                en: 'Change of workplace: Employment Center (application) → immigration and foreigner office (permission for workplace change)',
                zh: '工作单位变更:雇佣中心(申请) → 出入境·外国人厅(工作单位变更许可)',
                vi: 'Thay đổi nơi làm việc: Trung tâm việc làm (nộp đơn) → văn phòng xuất nhập cảnh và người nước ngoài (cấp phép thay đổi nơi làm việc)',
              ),
              L10nText(
                ko: '재입국허가·각종 증명서: 하이코리아 또는 관할 관서',
                en: 'Re-entry permit and various certificates: HiKorea or your jurisdictional office',
                zh: '再入境许可·各类证明文件:HiKorea或管辖机构',
                vi: 'Giấy phép tái nhập cảnh và các loại giấy chứng nhận: HiKorea hoặc văn phòng phụ trách',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '공통으로 챙길 서류',
              en: 'Documents to Prepare for All Reports',
              zh: '通用必备材料',
              vi: 'Giấy tờ chung cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '여권, 외국인등록증(ARC)은 모든 신고에서 공통으로 필요합니다.',
                en: 'Your passport and Alien Registration Card (ARC) are required for all types of reports.',
                zh: '护照及外国人登录证(ARC)是所有申报共同所需的材料。',
                vi: 'Hộ chiếu và thẻ đăng ký người nước ngoài (ARC) là giấy tờ chung cần thiết cho mọi loại khai báo.',
              ),
              L10nText(
                ko: '온라인 신고 시 공동인증서·간편인증 등 본인인증 수단을 미리 준비하세요.',
                en: 'For online reporting, prepare an identity verification method in advance, such as a public certificate or simple authentication.',
                zh: '在线申报时,请提前准备好联合认证书、简易认证等身份验证方式。',
                vi: 'Khi khai báo trực tuyến, hãy chuẩn bị trước phương tiện xác thực danh tính như chứng thư xác thực công cộng, xác thực đơn giản...',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '체류지 변경신고 (이사했을 때)',
          en: 'Report of Change of Residence (When You Move)',
          zh: '居所变更申报(搬家时)',
          vi: 'Khai báo thay đổi nơi cư trú (khi chuyển nhà)',
        ),
        summary: L10nText(
          ko: '새로운 체류지로 이사한 날부터 15일 이내에 신고해야 하며, 늦으면 100만 원 이하 과태료가 부과됩니다.',
          en: 'You must report within 15 days of moving to a new residence; being late results in a fine of up to KRW 1,000,000.',
          zh: '须在迁入新居所之日起15天内申报,逾期将被处以100万韩元以下罚款。',
          vi: 'Phải khai báo trong vòng 15 ngày kể từ ngày chuyển đến nơi cư trú mới, nếu trễ sẽ bị phạt tiền tối đa 1.000.000 won.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '신고 기한과 신고처',
              en: 'Reporting Deadline and Location',
              zh: '申报期限与申报地点',
              vi: 'Thời hạn và nơi khai báo',
            ),
            bullets: [
              L10nText(
                ko: '기한: 전입한 날부터 15일 이내 (출입국관리법 제36조제1항)',
                en: 'Deadline: within 15 days of the date you move in (Article 36, Paragraph 1 of the Immigration Control Act)',
                zh: '期限:自迁入之日起15天内(《出入境管理法》第36条第1款)',
                vi: 'Thời hạn: trong vòng 15 ngày kể từ ngày chuyển đến (Điều 36 Khoản 1 Luật Quản lý xuất nhập cảnh)',
              ),
              L10nText(
                ko: '신고처: 새 체류지의 시·군·구청, 읍·면·동 주민센터, 또는 관할 출입국·외국인관서 — 하이코리아 온라인 신고도 가능',
                en: 'Where to report: the city/county/district office or town/township/neighborhood community center of your new residence, or your jurisdictional immigration and foreigner office — online reporting via HiKorea is also available',
                zh: '申报地点:新居所所在的市·郡·区厅、邑·面·洞居民中心,或管辖出入境·外国人厅——也可通过HiKorea在线申报',
                vi: 'Nơi khai báo: ủy ban thành phố/quận/huyện, trung tâm dân cư phường/xã nơi cư trú mới, hoặc văn phòng xuất nhập cảnh và người nước ngoài phụ trách — cũng có thể khai báo trực tuyến qua HiKorea',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '위반 시 불이익',
              en: 'Penalties for Violation',
              zh: '违反时的不利后果',
              vi: 'Bất lợi khi vi phạm',
            ),
            bullets: [
              L10nText(
                ko: '기한 초과: 100만 원 이하 과태료',
                en: 'Missing the deadline: a fine of up to KRW 1,000,000',
                zh: '逾期:处100万韩元以下罚款',
                vi: 'Quá thời hạn: phạt tiền tối đa 1.000.000 won',
              ),
              L10nText(
                ko: '아예 신고하지 않은 경우: 100만 원 이하 벌금 (같은 법 제98조제2호)',
                en: 'Failing to report at all: a criminal fine of up to KRW 1,000,000 (Article 98, Item 2 of the same Act)',
                zh: '完全未申报:处100万韩元以下罚金(同法第98条第2号)',
                vi: 'Hoàn toàn không khai báo: phạt tiền hình sự tối đa 1.000.000 won (Điều 98 Khoản 2 cùng luật)',
              ),
              L10nText(
                ko: '주거(⑦)에서 다루는 보증금 보호(대항력)도 이 신고를 마쳐야 발생합니다.',
                en: 'The deposit protection (right of opposition against third parties) covered in Housing (⑦) also only takes effect once this report is completed.',
                zh: '在住房(⑦)部分提到的押金保护(对抗力)也须完成此项申报后方能生效。',
                vi: 'Việc bảo vệ tiền đặt cọc (quyền đối kháng) được đề cập trong mục Nhà ở (⑦) cũng chỉ phát sinh hiệu lực sau khi hoàn tất khai báo này.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '온라인 신고 방법',
              en: 'How to Report Online',
              zh: '在线申报方法',
              vi: 'Cách khai báo trực tuyến',
            ),
            bullets: [
              L10nText(
                ko: '하이코리아 로그인 → [민원신청] → [체류지 변경신고] → 새 주소 입력 후 제출',
                en: 'Log in to HiKorea → [Civil Application] → [Report of Change of Residence] → enter your new address and submit',
                zh: '登录HiKorea → [民愿申请] → [居所变更申报] → 输入新地址后提交',
                vi: 'Đăng nhập HiKorea → [Nộp đơn hành chính] → [Khai báo thay đổi nơi cư trú] → nhập địa chỉ mới rồi nộp',
              ),
              L10nText(
                ko: '온라인 신고는 기한(15일) 이내에만 가능하며, 기한을 넘기면 반드시 방문해야 합니다.',
                en: 'Online reporting is only available within the deadline (15 days); if you miss it, you must visit in person.',
                zh: '在线申报仅在期限(15天)内可用,若超过期限则必须亲自到访办理。',
                vi: 'Khai báo trực tuyến chỉ khả dụng trong thời hạn (15 ngày), nếu quá thời hạn bắt buộc phải đến trực tiếp.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '전입신고와의 관계',
              en: 'Relationship with Resident Registration Report',
              zh: '与迁入申报的关系',
              vi: 'Mối quan hệ với khai báo chuyển đến (dành cho công dân Hàn Quốc)',
            ),
            bullets: [
              L10nText(
                ko: '외국인은 내국인의 \'전입신고\' 대신 이 \'체류지 변경신고\'를 하며, 효력은 유사합니다.',
                en: 'Foreigners file this "report of change of residence" instead of the "resident registration report" that Korean citizens file, and it has a similar effect.',
                zh: '外国人以此\'居所变更申报\'代替本国人的\'迁入申报\',效力类似。',
                vi: 'Người nước ngoài thực hiện \'khai báo thay đổi nơi cư trú\' này thay cho \'khai báo chuyển đến\' của công dân Hàn Quốc, và có hiệu lực tương tự.',
              ),
              L10nText(
                ko: '임대차 보증금 보호(⑦주거)를 받으려면 이 신고와 확정일자를 함께 준비해야 합니다.',
                en: 'To receive lease deposit protection (⑦ Housing), you must complete this report together with obtaining a fixed date (확정일자).',
                zh: '若想获得租赁押金保护(⑦住房),须同时完成此项申报及取得确定日期(确定日期)。',
                vi: 'Để được bảo vệ tiền đặt cọc thuê nhà (mục ⑦ Nhà ở), cần chuẩn bị khai báo này cùng với việc lấy xác nhận ngày xác định (확정일자).',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '사업장 변경신고 (이직했을 때)',
          en: 'Report of Change of Workplace (When You Change Jobs)',
          zh: '工作单位变更申报(换工作时)',
          vi: 'Khai báo thay đổi nơi làm việc (khi đổi việc)',
        ),
        summary: L10nText(
          ko: 'E-9·H-2 근로자가 이직할 때는 근로계약 종료일로부터 1개월 이내 사업장 변경 신청, 이후 3개월 이내 근무처 변경허가까지 마쳐야 합니다.',
          en: 'When E-9/H-2 workers change jobs, they must apply for a workplace change within 1 month of the labor contract ending, then obtain workplace change permission within 3 months after that.',
          zh: 'E-9·H-2劳动者换工作时,须在劳动合同终止之日起1个月内申请更换工作单位,此后3个月内完成工作单位变更许可。',
          vi: 'Khi người lao động E-9/H-2 đổi việc, phải nộp đơn thay đổi nơi làm việc trong vòng 1 tháng kể từ ngày kết thúc hợp đồng lao động, sau đó phải hoàn tất việc xin cấp phép thay đổi nơi làm việc trong vòng 3 tháng.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '신청 기한',
              en: 'Application Deadlines',
              zh: '申请期限',
              vi: 'Thời hạn nộp đơn',
            ),
            bullets: [
              L10nText(
                ko: '사업장 변경 신청: 근로계약 종료일부터 1개월 이내 (고용센터)',
                en: 'Workplace change application: within 1 month of the labor contract ending (at the Employment Center)',
                zh: '更换工作单位申请:自劳动合同终止之日起1个月内(雇佣中心)',
                vi: 'Nộp đơn thay đổi nơi làm việc: trong vòng 1 tháng kể từ ngày kết thúc hợp đồng lao động (tại Trung tâm việc làm)',
              ),
              L10nText(
                ko: '근무처 변경허가: 사업장 변경 신청 후 3개월 이내 (출입국·외국인관서)',
                en: 'Workplace change permission: within 3 months of the workplace change application (at the immigration and foreigner office)',
                zh: '工作单位变更许可:更换工作单位申请后3个月内(出入境·外国人厅)',
                vi: 'Cấp phép thay đổi nơi làm việc: trong vòng 3 tháng sau khi nộp đơn thay đổi nơi làm việc (tại văn phòng xuất nhập cảnh và người nước ngoài)',
              ),
              L10nText(
                ko: '기한을 넘기면 원칙적으로 출국 대상이 되므로 가장 엄격하게 지켜야 하는 기한입니다.',
                en: 'Missing this deadline in principle makes you subject to departure, so it is the deadline that must be observed most strictly.',
                zh: '一旦超过期限,原则上将成为出境处分对象,因此这是必须最严格遵守的期限。',
                vi: 'Nếu quá thời hạn này, về nguyên tắc sẽ thuộc diện phải xuất cảnh, vì vậy đây là thời hạn cần tuân thủ nghiêm ngặt nhất.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '예외 사유',
              en: 'Exceptions',
              zh: '例外情形',
              vi: 'Trường hợp ngoại lệ',
            ),
            bullets: [
              L10nText(
                ko: '업무상 재해·질병·임신·출산 등으로 기한 내 신청이 어려운 경우, 그 사유가 없어진 날부터 기간을 다시 계산합니다.',
                en: 'If applying within the deadline is difficult due to a work-related injury, illness, pregnancy, childbirth, or similar reason, the period is recalculated starting from the day that reason no longer applies.',
                zh: '若因工伤、疾病、怀孕、分娩等原因难以在期限内申请,则自该事由消失之日起重新计算期限。',
                vi: 'Nếu khó nộp đơn trong thời hạn vì lý do tai nạn lao động, bệnh tật, mang thai, sinh con..., thời hạn sẽ được tính lại từ ngày lý do đó không còn nữa.',
              ),
              L10nText(
                ko: '임금체불(⑩)로 사업장을 변경하는 경우, 체불이 증명되면 변경 횟수 제한에서 차감되지 않습니다.',
                en: 'If you change workplaces due to unpaid wages (⑩), and the unpaid wages are proven, it does not count against the limit on the number of changes.',
                zh: '若因拖欠工资(⑩)而更换工作单位,一旦拖欠事实被证实,则不计入更换次数限制。',
                vi: 'Nếu thay đổi nơi làm việc do bị nợ lương (mục ⑩), khi chứng minh được việc nợ lương thì sẽ không bị trừ vào giới hạn số lần thay đổi.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '변경 가능 횟수 제한',
              en: 'Limit on the Number of Changes Allowed',
              zh: '可变更次数限制',
              vi: 'Giới hạn số lần được phép thay đổi',
            ),
            bullets: [
              L10nText(
                ko: '최초 취업활동 기간 중 원칙적으로 3회, 재고용 특례 기간 중 2회를 초과할 수 없습니다.',
                en: 'In principle, you cannot exceed 3 changes during the initial employment period, or 2 changes during a re-employment special period.',
                zh: '原则上,首次就业活动期间不得超过3次,再雇佣特例期间不得超过2次。',
                vi: 'Về nguyên tắc, không được vượt quá 3 lần trong thời gian hoạt động việc làm lần đầu, và 2 lần trong thời gian đặc lệ tái tuyển dụng.',
              ),
              L10nText(
                ko: '사업주 귀책 사유(근로조건 위반, 폭행, 임금체불 등)로 인한 변경은 횟수에서 제외됩니다.',
                en: 'Changes caused by the employer\'s fault (violation of working conditions, assault, unpaid wages, etc.) are excluded from the count.',
                zh: '因雇主责任(违反劳动条件、施暴、拖欠工资等)导致的更换不计入次数。',
                vi: 'Việc thay đổi do lỗi của chủ sử dụng lao động (vi phạm điều kiện làm việc, hành hung, nợ lương...) sẽ không bị tính vào số lần thay đổi.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '구직 기간 중 유의사항',
              en: 'Cautions During the Job-Seeking Period',
              zh: '求职期间注意事项',
              vi: 'Lưu ý trong thời gian tìm việc',
            ),
            bullets: [
              L10nText(
                ko: '사업장 변경 신청 후 구직 기간에는 고용센터의 구인정보를 통해 새 사업장을 찾아야 합니다.',
                en: 'During the job-seeking period after applying for a workplace change, you must find a new workplace through job listings at the Employment Center.',
                zh: '申请更换工作单位后的求职期间,须通过雇佣中心的招聘信息寻找新的工作单位。',
                vi: 'Trong thời gian tìm việc sau khi nộp đơn thay đổi nơi làm việc, phải tìm nơi làm việc mới thông qua thông tin tuyển dụng của Trung tâm việc làm.',
              ),
              L10nText(
                ko: '정해진 기간 안에 새 사업장을 구하지 못하면 원칙적으로 출국 대상이 됩니다.',
                en: 'If you fail to find a new workplace within the set period, you will in principle be subject to departure.',
                zh: '若未能在规定期限内找到新工作单位,原则上将成为出境处分对象。',
                vi: 'Nếu không tìm được nơi làm việc mới trong thời hạn quy định, về nguyên tắc sẽ thuộc diện phải xuất cảnh.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '출국 전 신고와 재입국허가',
          en: 'Reporting Before Departure and Re-entry Permission',
          zh: '出境前申报与再入境许可',
          vi: 'Khai báo trước khi xuất cảnh và giấy phép tái nhập cảnh',
        ),
        summary: L10nText(
          ko: '외국인등록을 마친 사람이 출국 후 1년 이내(영주자격은 2년 이내) 재입국하는 경우 재입국허가가 면제됩니다. 그 기간을 넘기려면 별도로 재입국허가를 받아야 합니다.',
          en: 'If a person who has completed alien registration re-enters within 1 year of departure (2 years for permanent residents), re-entry permission is waived. If you need to exceed that period, you must separately obtain re-entry permission.',
          zh: '已完成外国人登录者若在出境后1年内(永久居留资格为2年内)再入境,可免除再入境许可。若需超过该期限,须另行申请再入境许可。',
          vi: 'Người đã hoàn tất đăng ký người nước ngoài nếu tái nhập cảnh trong vòng 1 năm kể từ ngày xuất cảnh (2 năm đối với tư cách thường trú) sẽ được miễn giấy phép tái nhập cảnh. Nếu muốn vượt quá thời hạn đó, phải xin cấp phép tái nhập cảnh riêng.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '재입국허가 면제 기준',
              en: 'Criteria for Re-entry Permission Waiver',
              zh: '免除再入境许可的标准',
              vi: 'Tiêu chí miễn giấy phép tái nhập cảnh',
            ),
            bullets: [
              L10nText(
                ko: '일반 외국인등록자: 출국일로부터 1년 이내 재입국 시 면제 (단, 체류기간 만료일이 그보다 먼저 오면 그 날짜까지)',
                en: 'General registered foreigners: waived if re-entering within 1 year of departure (but only until the expiration date of your stay, if that comes sooner)',
                zh: '一般外国人登录者:出境之日起1年内再入境可免除(但若滞留期限届满日更早,则以该日期为准)',
                vi: 'Người đăng ký người nước ngoài thông thường: được miễn nếu tái nhập cảnh trong vòng 1 năm kể từ ngày xuất cảnh (tuy nhiên nếu ngày hết hạn lưu trú đến sớm hơn thì chỉ được miễn đến ngày đó)',
              ),
              L10nText(
                ko: '영주자격(F-5) 소지자: 출국일로부터 2년 이내 재입국 시 면제',
                en: 'Holders of Permanent Residence (F-5) status: waived if re-entering within 2 years of departure',
                zh: '持永久居留资格(F-5)者:出境之日起2年内再入境可免除',
                vi: 'Người có tư cách thường trú (F-5): được miễn nếu tái nhập cảnh trong vòng 2 năm kể từ ngày xuất cảnh',
              ),
              L10nText(
                ko: '면제 기간을 넘겨 출국하려면 사전에 단수 또는 복수 재입국허가를 신청해야 합니다.',
                en: 'If you plan to stay outside Korea beyond the waiver period, you must apply in advance for a single or multiple re-entry permit.',
                zh: '若打算超过免除期限出境,须提前申请单次或多次再入境许可。',
                vi: 'Nếu dự định xuất cảnh vượt quá thời gian miễn, phải xin cấp phép tái nhập cảnh một lần hoặc nhiều lần trước khi xuất cảnh.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Cautions',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '재입국허가 없이 면제기간을 넘기면 체류자격이 상실될 수 있습니다.',
                en: 'Exceeding the waiver period without re-entry permission can result in the loss of your status of stay.',
                zh: '若无再入境许可而超过免除期限,可能导致滞留资格丧失。',
                vi: 'Nếu vượt quá thời gian miễn mà không có giấy phép tái nhập cảnh, có thể bị mất tư cách lưu trú.',
              ),
              L10nText(
                ko: '정확한 본인 만료일은 하이코리아 또는 1345에서 확인하는 것이 안전합니다.',
                en: 'For safety, verify your exact expiration date through HiKorea or by calling 1345.',
                zh: '建议通过HiKorea或拨打1345确认自己准确的到期日,以确保安全。',
                vi: 'Để đảm bảo an toàn, nên kiểm tra chính xác ngày hết hạn của bản thân qua HiKorea hoặc gọi 1345.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '복수 재입국허가',
              en: 'Multiple Re-entry Permission',
              zh: '多次再入境许可',
              vi: 'Giấy phép tái nhập cảnh nhiều lần',
            ),
            bullets: [
              L10nText(
                ko: '면제기간을 넘겨 여러 차례 출입국할 계획이면 출국 전 복수 재입국허가를 미리 신청할 수 있습니다.',
                en: 'If you plan to travel in and out of Korea multiple times beyond the waiver period, you can apply in advance for multiple re-entry permission before departure.',
                zh: '若计划超过免除期限多次出入境,可在出境前提前申请多次再入境许可。',
                vi: 'Nếu dự định xuất nhập cảnh nhiều lần vượt quá thời gian miễn, có thể xin cấp phép tái nhập cảnh nhiều lần trước khi xuất cảnh.',
              ),
              L10nText(
                ko: '허가 유효기간 내라면 횟수 제한 없이 재입국할 수 있습니다.',
                en: 'As long as it is within the permit\'s validity period, you can re-enter an unlimited number of times.',
                zh: '只要在许可有效期内,便可不限次数地再入境。',
                vi: 'Trong thời hạn hiệu lực của giấy phép, có thể tái nhập cảnh không giới hạn số lần.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '면제기간을 넘겨 출국해버렸다면',
              en: 'If You Have Already Departed Beyond the Waiver Period',
              zh: '若已超过免除期限出境',
              vi: 'Nếu đã xuất cảnh vượt quá thời gian miễn',
            ),
            bullets: [
              L10nText(
                ko: '체류자격이 상실될 수 있으므로, 출국 전 반드시 본인의 정확한 면제 만료일을 확인하세요.',
                en: 'Since your status of stay may be lost, always check your exact waiver expiration date before departing.',
                zh: '由于可能导致滞留资格丧失,出境前请务必确认自己准确的免除到期日。',
                vi: 'Vì có thể bị mất tư cách lưu trú, hãy chắc chắn kiểm tra ngày hết hạn miễn chính xác của bản thân trước khi xuất cảnh.',
              ),
              L10nText(
                ko: '이미 기간을 넘겼다면 재외공관 또는 1345에 상담해 재입국 가능 여부를 확인해야 합니다.',
                en: 'If you have already exceeded the period, consult a Korean overseas mission or call 1345 to check whether re-entry is still possible.',
                zh: '若已超过期限,须向驻外使领馆或拨打1345咨询,确认是否仍可再入境。',
                vi: 'Nếu đã quá thời hạn, cần tham vấn cơ quan đại diện ngoại giao Hàn Quốc ở nước ngoài hoặc gọi 1345 để xác nhận có thể tái nhập cảnh hay không.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '외국인등록 사실증명 등 증명서 발급',
          en: 'Issuance of the Certificate of Alien Registration and Other Certificates',
          zh: '外国人登录事实证明等证明文件签发',
          vi: 'Cấp giấy xác nhận đăng ký người nước ngoài và các giấy chứng nhận khác',
        ),
        summary: L10nText(
          ko: '은행·행정 절차에서 주민등록등본 대신 요구되는 서류로, 하이코리아 온라인 또는 관할 관서 방문으로 발급받을 수 있습니다.',
          en: 'This document is required in place of a resident registration copy for banking and administrative procedures, and can be issued online through HiKorea or by visiting your jurisdictional office.',
          zh: '这是在银行、行政手续中用以代替居民登录誊本的文件,可通过HiKorea在线或到访管辖机构申请签发。',
          vi: 'Đây là giấy tờ được yêu cầu thay cho bản sao đăng ký cư trú trong các thủ tục ngân hàng, hành chính, có thể xin cấp trực tuyến qua HiKorea hoặc đến trực tiếp văn phòng phụ trách.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '외국인등록 사실증명이란',
              en: 'What Is the Certificate of Alien Registration',
              zh: '什么是外国人登录事实证明',
              vi: 'Giấy xác nhận đăng ký người nước ngoài là gì',
            ),
            bullets: [
              L10nText(
                ko: '외국인등록을 마친 사람에게 발급되는 공적 증명서로, 법령상 주민등록표 등본·초본이 필요한 자리에 대신 사용됩니다.',
                en: 'An official certificate issued to those who have completed alien registration; it is used in place of a resident registration copy or abstract wherever the law requires one.',
                zh: '这是发给已完成外国人登录者的官方证明文件,用于代替法律规定须提供的居民登录誊本·抄本。',
                vi: 'Đây là giấy chứng nhận chính thức được cấp cho người đã hoàn tất đăng ký người nước ngoài, được dùng thay thế ở những nơi pháp luật yêu cầu bản sao/bản trích lục đăng ký cư trú.',
              ),
              L10nText(
                ko: '발급처: 하이코리아 온라인 발급, 정부24, 관할 출입국·외국인관서',
                en: 'Where to obtain it: online through HiKorea, Government24, or your jurisdictional immigration and foreigner office',
                zh: '签发渠道:HiKorea在线签发、政府24(Gov24)、管辖出入境·外国人厅',
                vi: 'Nơi cấp: cấp trực tuyến qua HiKorea, Gov24 (정부24), văn phòng xuất nhập cảnh và người nước ngoài phụ trách',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '함께 알아두면 좋은 증명서',
              en: 'Other Certificates Worth Knowing About',
              zh: '值得一并了解的证明文件',
              vi: 'Các giấy chứng nhận khác nên biết',
            ),
            bullets: [
              L10nText(
                ko: '외국인등록증 재발급: 분실·훼손·기재사항 변경 시 신청',
                en: 'Reissuance of the Alien Registration Card: applied for when it is lost, damaged, or when recorded information changes',
                zh: '外国人登录证补发:遗失、损坏、登记事项变更时申请',
                vi: 'Cấp lại thẻ đăng ký người nước ngoài: nộp đơn khi bị mất, hư hỏng hoặc thay đổi thông tin ghi trên thẻ',
              ),
              L10nText(
                ko: '체류자격 외 활동허가서: 유학생 아르바이트 등 별도 허가가 필요한 경우',
                en: 'Permit for activities outside your status of stay: needed for cases like international students taking part-time jobs',
                zh: '资格外活动许可书:留学生打工等需要另行许可的情况',
                vi: 'Giấy phép hoạt động ngoài tư cách lưu trú: cần thiết cho các trường hợp như du học sinh làm thêm cần xin phép riêng',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '체류자격외활동허가',
              en: 'Permit for Activities Outside Your Status of Stay',
              zh: '资格外活动许可',
              vi: 'Giấy phép hoạt động ngoài tư cách lưu trú',
            ),
            bullets: [
              L10nText(
                ko: '원래 체류자격의 활동 범위를 벗어난 활동(예: 유학생 아르바이트)을 하려면 사전에 별도 허가가 필요합니다.',
                en: 'To engage in activities outside the scope of your original status of stay (e.g. a part-time job as an international student), you need separate permission in advance.',
                zh: '若想从事超出原滞留资格活动范围的活动(如留学生打工),须事先取得另行许可。',
                vi: 'Muốn thực hiện hoạt động ngoài phạm vi tư cách lưu trú ban đầu (ví dụ: du học sinh làm thêm) thì cần xin phép riêng trước.',
              ),
              L10nText(
                ko: '허가 없이 활동하면 처벌 대상이 되며 이후 체류에도 불이익이 있을 수 있습니다.',
                en: 'Engaging in such activities without permission is subject to punishment and may also cause disadvantages for your future stay.',
                zh: '若未经许可而从事此类活动,将受到处罚,并可能对今后的滞留产生不利影响。',
                vi: 'Nếu hoạt động mà không có giấy phép sẽ bị xử phạt và có thể gặp bất lợi cho việc lưu trú sau này.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '증명서 발급 수수료',
              en: 'Certificate Issuance Fees',
              zh: '证明文件签发手续费',
              vi: 'Lệ phí cấp giấy chứng nhận',
            ),
            bullets: [
              L10nText(
                ko: '온라인 발급은 대부분 무료이거나 소액이며, 방문 발급은 수수료가 별도로 부과될 수 있습니다.',
                en: 'Online issuance is mostly free or a small fee, while in-person issuance may incur a separate charge.',
                zh: '在线签发大多免费或收取少量费用,现场签发可能须另行缴纳手续费。',
                vi: 'Cấp trực tuyến hầu hết miễn phí hoặc phí thấp, còn cấp trực tiếp có thể phải trả lệ phí riêng.',
              ),
              L10nText(
                ko: '정확한 금액은 하이코리아 또는 정부24 고지 화면에서 확인하세요.',
                en: 'Check the exact amount on the notice screen of HiKorea or Government24.',
                zh: '准确金额请在HiKorea或政府24(Gov24)的通知页面确认。',
                vi: 'Hãy kiểm tra số tiền chính xác trên màn hình thông báo của HiKorea hoặc Gov24 (정부24).',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
};
