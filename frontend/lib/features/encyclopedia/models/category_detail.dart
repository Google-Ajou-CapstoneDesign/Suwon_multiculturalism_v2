import 'app_language.dart';

/// 5단 카드 템플릿의 캡션(①~⑤) 인덱스(0~4)와 본문.
class DetailStep {
  const DetailStep({required this.captionIndex, required this.text});

  final int captionIndex;
  final L10nText text;
}

/// 카테고리 상세 콘텐츠. 검수를 마친 3개 카테고리(ARC 발급·계약서 체크리스트·
/// 권리구제 지원제도)만 채워져 있고, 나머지는 categoryDetailById에 키가 없어
/// "이 항목은 2차 단계에서 채웁니다" 안내로 대체된다.
class CategoryDetail {
  const CategoryDetail({required this.steps, this.hasGuidePhotos = false, required this.checklist});

  final List<DetailStep> steps;

  /// true면 ⑤ 단계별 가이드(화면 캡처 자리)를 추가로 보여준다.
  final bool hasGuidePhotos;
  final List<L10nText> checklist;
}

const Map<int, CategoryDetail> categoryDetailById = {
  1: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '출입국사무소에서 발급하는 외국인 신분증입니다.',
          en: 'The ID card for foreign residents, issued by the immigration office.',
          vi: 'Thẻ căn cước cho người nước ngoài, do cơ quan xuất nhập cảnh cấp.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '관할 출입국·외국인청 방문 (사전 예약 필요)',
          en: 'Visit your local immigration office (book an appointment first).',
          vi: 'Đến văn phòng xuất nhập cảnh phụ trách (cần đặt lịch trước).',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '한국에 90일 넘게 머무는 외국인이 반드시 발급받아야 하는 신분증입니다.',
          en: 'Required for anyone staying in Korea longer than 90 days.',
          vi: 'Bắt buộc với người ở Hàn Quốc trên 90 ngày.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '입국 후 90일 이내. 은행 계좌와 휴대폰 개통 전에 먼저 필요합니다.',
          en: 'Within 90 days of arrival. You need it before opening a bank account or getting a phone.',
          vi: 'Trong vòng 90 ngày sau khi nhập cảnh. Cần có trước khi mở tài khoản hoặc đăng ký điện thoại.',
        ),
      ),
    ],
    hasGuidePhotos: true,
    checklist: [
      L10nText(ko: '여권', en: 'Passport', vi: 'Hộ chiếu'),
      L10nText(ko: '표준규격 사진 1매', en: 'One standard ID photo', vi: 'Một ảnh thẻ tiêu chuẩn'),
      L10nText(ko: '수수료 3만원', en: 'Fee: 30,000 KRW', vi: 'Lệ phí: 30.000 KRW'),
      L10nText(ko: '체류지 입증 서류', en: 'Proof of address', vi: 'Giấy tờ chứng minh nơi ở'),
    ],
  ),
  11: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '계약서에 반드시 있어야 할 항목을 확인합니다.',
          en: 'Check that your contract includes everything it must.',
          vi: 'Kiểm tra hợp đồng có đủ các mục bắt buộc.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '앱에서 확인 · 사업주에게 사본 요청',
          en: 'Check in the app, and ask your employer for a copy.',
          vi: 'Xem trong ứng dụng và yêu cầu chủ sử dụng lao động bản sao.',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '임금·근로시간·휴일 등 근로조건을 문서로 남긴 것입니다.',
          en: 'A written record of your pay, hours, and days off.',
          vi: 'Văn bản ghi lại tiền lương, giờ làm và ngày nghỉ.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '서명하기 직전에 확인하세요.',
          en: 'Check it right before you sign.',
          vi: 'Kiểm tra ngay trước khi ký.',
        ),
      ),
    ],
    checklist: [
      L10nText(
        ko: '임금 구성 항목이 적혀 있는가',
        en: 'Is the breakdown of pay written out?',
        vi: 'Đã ghi rõ các khoản lương chưa?',
      ),
      L10nText(
        ko: '근로시간과 휴게시간이 적혀 있는가',
        en: 'Are working hours and breaks written out?',
        vi: 'Đã ghi giờ làm và giờ nghỉ chưa?',
      ),
      L10nText(
        ko: '수습기간과 그때의 임금이 적혀 있는가',
        en: 'Is the probation period and its pay written out?',
        vi: 'Đã ghi thời gian thử việc và mức lương chưa?',
      ),
      L10nText(
        ko: '내가 아는 언어로 된 사본을 받았는가',
        en: 'Did you get a copy in a language you read?',
        vi: 'Bạn đã nhận bản sao bằng ngôn ngữ mình đọc được chưa?',
      ),
    ],
  ),
  17: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '혼자 해결하기 어려울 때 도와줄 곳을 연결합니다.',
          en: "Connects you to people who can help when you can't fix it alone.",
          vi: 'Kết nối bạn với nơi có thể giúp khi bạn không tự giải quyết được.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '경기도 마을노무사 제도 · 수원시비정규직노동자복지센터',
          en: 'Gyeonggi Village Labor Attorney program · Suwon Non-regular Workers Welfare Center',
          vi: 'Chương trình luật sư lao động Gyeonggi · Trung tâm phúc lợi lao động Suwon',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '노무사 선임 비용을 지원받아 상담과 대리를 받는 제도입니다.',
          en: 'A program that covers the cost of hiring a labor attorney for advice and representation.',
          vi: 'Chương trình hỗ trợ chi phí thuê luật sư lao động để tư vấn và đại diện.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '임금을 못 받았거나 다쳤는데 회사가 처리해주지 않을 때',
          en: "When you haven't been paid, or you were injured and your workplace won't act.",
          vi: 'Khi bạn chưa được trả lương, hoặc bị thương mà công ty không xử lý.',
        ),
      ),
    ],
    checklist: [
      L10nText(ko: '신청 조건 확인하기', en: 'Check whether you qualify', vi: 'Kiểm tra điều kiện đăng ký'),
      L10nText(
        ko: '가까운 상담기관 찾기',
        en: 'Find the nearest support center',
        vi: 'Tìm trung tâm hỗ trợ gần nhất',
      ),
      L10nText(
        ko: '상담 전 준비할 서류',
        en: 'Documents to bring to your appointment',
        vi: 'Giấy tờ cần mang khi tư vấn',
      ),
    ],
  ),
};

/// 5단 카드 캡션 라벨(①~⑤), 언어별.
const detailStepCaptions = [
  L10nText(ko: '① 아이콘·제목', en: '① Title', vi: '① Tiêu đề'),
  L10nText(ko: '② 접근 경로', en: '② Where to go', vi: '② Nơi thực hiện'),
  L10nText(ko: '③ 정의', en: '③ What it is', vi: '③ Định nghĩa'),
  L10nText(ko: '④ 사용 시점', en: '④ When you need it', vi: '④ Thời điểm cần'),
  L10nText(ko: '⑤ 단계별 가이드', en: '⑤ Step-by-step guide', vi: '⑤ Hướng dẫn từng bước'),
];
