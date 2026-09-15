import '../../../core/app_language.dart';
import '../models/flow_block.dart';
import '../models/form_field_spec.dart';

/// 임금체불 진정서 항목 — html_files/임금체불네비게이터.html의 WAGE_FIELDS를 이
/// 앱의 실제 데이터 상황에 맞게 재태깅했다. 이 앱에는 사용자 이름·외국인등록번호·
/// 주소·이메일·사업주 정보를 담는 프로필 필드가 없어서(UserProfileController엔
/// language/visaStatus/contractStored/payslipStored뿐), 원본 HTML이 "auto"로 표시한
/// 개인정보 필드를 그대로 자동입력 처리하면 실제 법적 서류에 허위 정보를 자동으로
/// 채워 넣는 셈이라 blank(직접입력)로 바꿨다. 임금계산기에 이미 입력된 값(입사일·
/// 퇴사일·사업장 규모)만 진짜 auto다.
const wageFields = <FormSection>[
  FormSection(
    title: L10nText(
      ko: '1. 진정인 · 근로자 본인',
      en: '1. Complainant · yourself',
      zh: '1. 申诉人·劳动者本人',
      vi: '1. Người khiếu nại · bản thân',
      uz: "1. Shikoyatchi · oʻzingiz",
    ),
    fields: [
      FormFieldSpec(
        key: 'name',
        label: L10nText(
          ko: '성명',
          en: 'Name',
          zh: '姓名',
          vi: 'Họ tên',
          uz: "Ism",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '외국인등록증상 성명',
          en: 'Name as on your Alien Registration Card',
          zh: '外国人登录证上的姓名',
          vi: 'Họ tên trên Thẻ đăng ký người nước ngoài',
          uz: "Chet el fuqarosini roʻyxatga olish kartangizdagi ism",
        ),
      ),
      FormFieldSpec(
        key: 'arc',
        label: L10nText(
          ko: '외국인등록번호',
          en: 'ARC number',
          zh: '外国人登录号',
          vi: 'Số thẻ ARC',
          uz: "ARC raqami",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'addr',
        label: L10nText(
          ko: '주소 · 휴대전화',
          en: 'Address · mobile',
          zh: '住址·手机',
          vi: 'Địa chỉ · di động',
          uz: "Manzil · mobil",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'email',
        label: L10nText(
          ko: '전자우편',
          en: 'Email',
          zh: '电子邮箱',
          vi: 'Thư điện tử',
          uz: "Elektron pochta",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
    ],
  ),
  FormSection(
    title: L10nText(
      ko: '2. 피진정인 · 사업주',
      en: '2. Employer complained of',
      zh: '2. 被申诉人',
      vi: '2. Bên bị khiếu nại',
      uz: "2. Shikoyat qilingan ish beruvchi",
    ),
    fields: [
      FormFieldSpec(
        key: 'empname',
        label: L10nText(
          ko: '성명 · 연락처',
          en: 'Name · contact',
          zh: '姓名·联系方式',
          vi: 'Họ tên · liên lạc',
          uz: "Ism · aloqa",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '사장님 성함과 연락처',
          en: "Employer's name and contact",
          zh: '雇主姓名与联系方式',
          vi: 'Họ tên và liên lạc của chủ',
          uz: "Ish beruvchining ismi va aloqa maʼlumotlari",
        ),
      ),
      FormFieldSpec(
        key: 'biztype',
        label: L10nText(
          ko: '사업체 구분',
          en: 'Type of workplace',
          zh: '单位区分',
          vi: 'Loại cơ sở',
          uz: "Ish joyi turi",
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'biz',
            label: L10nText(
              ko: '사업장',
              en: 'Workplace',
              zh: '单位',
              vi: 'Cơ sở',
              uz: "Ish joyi",
            ),
          ),
          FormFieldOption(
            value: 'site',
            label: L10nText(
              ko: '공사현장',
              en: 'Construction site',
              zh: '工地',
              vi: 'Công trường',
              uz: "Qurilish maydonchasi",
            ),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'bizaddr',
        label: L10nText(
          ko: '사업장명 · 주소',
          en: 'Workplace name · address',
          zh: '单位名称·地址',
          vi: 'Tên & địa chỉ cơ sở',
          uz: "Ish joyi nomi · manzili",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '실제로 일한 사업장명과 주소',
          en: 'Name and address of where you actually worked',
          zh: '实际工作单位名称及地址',
          vi: 'Tên và địa chỉ nơi bạn thực sự làm việc',
          uz: "Haqiqatda ishlagan joyingizning nomi va manzili",
        ),
      ),
      FormFieldSpec(
        key: 'workers',
        label: L10nText(
          ko: '근로자 수',
          en: 'Number of employees',
          zh: '劳动者人数',
          vi: 'Số lao động',
          uz: "Xodimlar soni",
        ),
        type: FormFieldType.segmented,
        tag: FillTag.auto,
        hint: L10nText(
          ko: '임금계산기에서 고른 사업장 규모를 불러옵니다',
          en: 'Loaded from the workplace size you chose in the wage calculator',
          zh: '从工资计算器中选择的单位规模导入',
          vi: 'Lấy từ quy mô cơ sở bạn đã chọn trong máy tính lương',
          uz: "Ish haqi kalkulyatorida tanlagan ish joyi hajmidan yuklangan",
        ),
        options: [
          FormFieldOption(
            value: 'over5',
            label: L10nText(
              ko: '5인 이상',
              en: '5 or more',
              zh: '5人以上',
              vi: 'Từ 5 người',
              uz: "5 yoki undan koʻp",
            ),
          ),
          FormFieldOption(
            value: 'under5',
            label: L10nText(
              ko: '5인 미만',
              en: 'Under 5',
              zh: '不足5人',
              vi: 'Dưới 5 người',
              uz: "5 dan kam",
            ),
          ),
          FormFieldOption(
            value: 'unknown',
            label: L10nText(
              ko: '잘 모름',
              en: 'Not sure',
              zh: '不清楚',
              vi: 'Không rõ',
              uz: "Ishonchim komil emas",
            ),
          ),
        ],
      ),
    ],
  ),
  FormSection(
    title: L10nText(
      ko: '3. 진정 내용 · 체불 내역',
      en: '3. Details of the complaint',
      zh: '3. 申诉内容',
      vi: '3. Nội dung khiếu nại',
      uz: "3. Shikoyat tafsilotlari",
    ),
    fields: [
      FormFieldSpec(
        key: 'start',
        label: L10nText(
          ko: '입사일',
          en: 'Start date',
          zh: '入职日',
          vi: 'Ngày vào làm',
          uz: "Boshlanish sanasi",
        ),
        type: FormFieldType.date,
        tag: FillTag.auto,
        hint: L10nText(
          ko: '임금계산기에 입력한 입사일을 불러옵니다',
          en: 'Loaded from the hire date you entered in the wage calculator',
          zh: '从工资计算器中输入的入职日导入',
          vi: 'Lấy từ ngày vào làm bạn đã nhập trong máy tính lương',
          uz: "Ish haqi kalkulyatoriga kiritgan ishga kirish sanasidan yuklangan",
        ),
      ),
      FormFieldSpec(
        key: 'end',
        label: L10nText(
          ko: '퇴사일(재직 중이면 비움)',
          en: 'End date (leave blank if still working)',
          zh: '离职日（在职则留空）',
          vi: 'Ngày nghỉ (bỏ trống nếu còn làm)',
          uz: "Tugash sanasi (agar hali ham ishlayotgan boʻlsangiz, boʻsh qoldiring)",
        ),
        type: FormFieldType.date,
        tag: FillTag.auto,
      ),
      FormFieldSpec(
        key: 'resigned',
        label: L10nText(
          ko: '퇴직 여부',
          en: 'Still employed?',
          zh: '离职与否',
          vi: 'Đã nghỉ việc chưa',
          uz: "Hali ham ishlayapsizmi?",
        ),
        type: FormFieldType.segmented,
        tag: FillTag.auto,
        options: [
          FormFieldOption(
            value: 'resigned',
            label: L10nText(
              ko: '퇴직',
              en: 'Resigned',
              zh: '离职',
              vi: 'Đã nghỉ',
              uz: "Ishdan boʻshatilgan",
            ),
          ),
          FormFieldOption(
            value: 'working',
            label: L10nText(
              ko: '재직',
              en: 'Still employed',
              zh: '在职',
              vi: 'Đang làm',
              uz: "Hali ham ishlayapti",
            ),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'duty',
        label: L10nText(
          ko: '업무 내용 · 임금 지급일',
          en: 'Job duties · payday',
          zh: '工作内容·发薪日',
          vi: 'Công việc · ngày trả lương',
          uz: "Ish vazifalari · ish haqi toʻlanadigan kun",
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: 주방 보조 · 매월 10일',
          en: 'e.g. Kitchen assistant · 10th of each month',
          zh: '例：厨房助理·每月10日',
          vi: 'VD: Phụ bếp · ngày 10 hằng tháng',
          uz: "Masalan, Oshxona yordamchisi · har oyning 10-kuni",
        ),
      ),
      FormFieldSpec(
        key: 'contractform',
        label: L10nText(
          ko: '근로계약 방법',
          en: 'Contract form',
          zh: '劳动合同方式',
          vi: 'Hình thức hợp đồng',
          uz: "Shartnoma shakli",
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'written',
            label: L10nText(
              ko: '서면',
              en: 'Written',
              zh: '书面',
              vi: 'Văn bản',
              uz: "Yozma",
            ),
          ),
          FormFieldOption(
            value: 'verbal',
            label: L10nText(
              ko: '구두',
              en: 'Verbal',
              zh: '口头',
              vi: 'Miệng',
              uz: "Ogʻzaki",
            ),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'unpaidtotal',
        label: L10nText(
          ko: '체불임금 총액',
          en: 'Total unpaid wages',
          zh: '欠薪总额',
          vi: 'Tổng tiền nợ lương',
          uz: "Toʻlanmagan ish haqi jami",
        ),
        type: FormFieldType.number,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '직접 입력해주세요',
          en: 'Enter it yourself',
          zh: '请自行填写',
          vi: 'Vui lòng tự nhập',
          uz: "Oʻzingiz kiriting",
        ),
        hint: L10nText(
          ko: '계산기 결과는 참고용일 뿐 자동으로 넘어오지 않습니다 — 확정 금액은 근로감독관 조사에서 정해집니다',
          en: "The calculator result is a reference only and isn't carried over automatically — the confirmed amount is set during the labor inspector's investigation",
          zh: '计算器结果仅供参考，不会自动带入 — 确定金额由劳动监督官调查核定',
          vi: 'Kết quả máy tính chỉ để tham khảo, không tự động chuyển sang — số tiền chính thức do thanh tra lao động xác định',
          uz: "Kalkulyator natijasi faqat maʼlumot uchun va avtomatik ravishda oʻtkazilmaydi — tasdiqlangan summa mehnat inspektorining tekshiruvi davomida belgilanadi",
        ),
      ),
      FormFieldSpec(
        key: 'unpaidsever',
        label: L10nText(
          ko: '체불 퇴직금 · 기타',
          en: 'Unpaid severance · other',
          zh: '欠付退职金·其他',
          vi: 'Trợ cấp thôi việc · khác',
          uz: "Toʻlanmagan ishdan boʻshatish nafaqasi · boshqa",
        ),
        type: FormFieldType.number,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '직접 입력해주세요',
          en: 'Enter it yourself',
          zh: '请自行填写',
          vi: 'Vui lòng tự nhập',
          uz: "Oʻzingiz kiriting",
        ),
      ),
      FormFieldSpec(
        key: 'content',
        label: L10nText(
          ko: '내용 (진정 취지 및 이유)',
          en: 'Statement of claim',
          zh: '内容（申诉主旨及理由）',
          vi: 'Nội dung và lý do',
          uz: "Daʼvo arizasi",
        ),
        type: FormFieldType.textarea,
        tag: FillTag.raw,
        hint: L10nText(
          ko: '이전 단계에서 적은 경위가 그대로 들어갑니다',
          en: 'Carried over verbatim from what you wrote in the earlier step',
          zh: '将原样带入上一步所写的经过',
          vi: 'Được chuyển nguyên văn từ nội dung bạn đã viết ở bước trước',
          uz: "Avvalgi bosqichda yozganlaringizdan soʻzma-soʻz koʻchirilgan",
        ),
      ),
      FormFieldSpec(
        key: 'attach',
        label: L10nText(
          ko: '파일 첨부',
          en: 'Attachments',
          zh: '文件附件',
          vi: 'Tệp đính kèm',
          uz: "Ilovlar",
        ),
        type: FormFieldType.readonly,
        tag: FillTag.auto,
        placeholder: L10nText(
          ko: '불러오기 버튼으로 가져온 자료가 여기 표시됩니다',
          en: 'Items imported via the buttons above will show here',
          zh: '通过导入按钮获取的资料将显示在此',
          vi: 'Các mục đã tải qua nút bên trên sẽ hiện ở đây',
          uz: "Yuqoridagi tugmalar orqali import qilingan narsalar shu yerda koʻrsatiladi",
        ),
      ),
      FormFieldSpec(
        key: 'lawarticles',
        label: L10nText(
          ko: '위반 법조항',
          en: 'Articles violated',
          zh: '违反法条',
          vi: 'Điều luật vi phạm',
          uz: "Buzilgan moddalar",
        ),
        type: FormFieldType.readonly,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '근로감독관이 판단합니다',
          en: 'The labor inspector determines this',
          zh: '由劳动监督官判定',
          vi: 'Do thanh tra lao động xác định',
          uz: "Buni mehnat inspektori aniqlaydi",
        ),
      ),
    ],
  ),
];
