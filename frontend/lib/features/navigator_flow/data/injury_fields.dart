import '../../../core/app_language.dart';
import '../models/flow_block.dart';
import '../models/form_field_spec.dart';

/// 요양급여신청서(근로복지공단 별지 제2호 서식) 항목 — html_files/산재처리네비게이터.html의
/// INJURY_FIELDS를 이 앱의 실제 데이터 상황에 맞게 재태깅했다. wage_fields.dart와 같은
/// 원칙: 이 앱에 실제로 없는 개인정보·사업장 정보는 "auto"로 위장하지 않고 blank(직접입력)로
/// 정직하게 표기한다. 입사일(hiredate)만 임금계산기 입력값을 재사용할 수 있어 진짜 auto다.
const injuryFields = <FormSection>[
  FormSection(
    title: L10nText(
      ko: '1. 재해자(본인) 기본 정보',
      en: '1. Injured worker · basic details',
      zh: '1. 受灾者（本人）基本信息',
      vi: '1. Thông tin cơ bản người bị nạn',
    ),
    fields: [
      FormFieldSpec(
        key: 'name',
        label: L10nText(
          ko: '성명(영문 대문자)',
          en: 'Name (capital letters)',
          zh: '姓名（英文大写）',
          vi: 'Họ tên (chữ hoa)',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '외국인등록증상 성명',
          en: 'Name as on your Alien Registration Card',
          zh: '外国人登录证上的姓名',
          vi: 'Họ tên trên Thẻ đăng ký người nước ngoài',
        ),
      ),
      FormFieldSpec(
        key: 'arc',
        label: L10nText(
          ko: '외국인등록번호',
          en: 'ARC number',
          zh: '外国人登录号',
          vi: 'Số thẻ ARC',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'address',
        label: L10nText(
          ko: '한국 내 거주지 주소',
          en: 'Address in Korea',
          zh: '在韩居住地址',
          vi: 'Địa chỉ cư trú tại Hàn Quốc',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'phone',
        label: L10nText(
          ko: '휴대전화 · 비상 연락처',
          en: 'Mobile · emergency contact',
          zh: '手机·紧急联系方式',
          vi: 'Di động · liên hệ khẩn cấp',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'hiredate',
        label: L10nText(
          ko: '채용일자',
          en: 'Hire date',
          zh: '聘用日期',
          vi: 'Ngày tuyển dụng',
        ),
        type: FormFieldType.date,
        tag: FillTag.auto,
        hint: L10nText(
          ko: '임금계산기에 입력한 입사일을 불러옵니다',
          en: 'Loaded from the hire date you entered in the wage calculator',
          zh: '从工资计算器中输入的入职日导入',
          vi: 'Lấy từ ngày vào làm bạn đã nhập trong máy tính lương',
        ),
      ),
      FormFieldSpec(
        key: 'jobtype',
        label: L10nText(
          ko: '직종',
          en: 'Job type',
          zh: '职种',
          vi: 'Loại công việc',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'construction',
            label: L10nText(
              ko: '건설',
              en: 'Construction',
              zh: '建筑',
              vi: 'Xây dựng',
            ),
          ),
          FormFieldOption(
            value: 'manufacturing',
            label: L10nText(
              ko: '제조',
              en: 'Manufacturing',
              zh: '制造',
              vi: 'Sản xuất',
            ),
          ),
          FormFieldOption(
            value: 'farming',
            label: L10nText(
              ko: '농축산',
              en: 'Farming · livestock',
              zh: '农畜产',
              vi: 'Nông nghiệp · chăn nuôi',
            ),
          ),
          FormFieldOption(
            value: 'service',
            label: L10nText(ko: '서비스', en: 'Service', zh: '服务', vi: 'Dịch vụ'),
          ),
          FormFieldOption(
            value: 'logistics',
            label: L10nText(
              ko: '물류',
              en: 'Logistics',
              zh: '物流',
              vi: 'Logistics',
            ),
          ),
          FormFieldOption(
            value: 'other',
            label: L10nText(ko: '기타', en: 'Other', zh: '其他', vi: 'Khác'),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'workertype',
        label: L10nText(
          ko: '근로자 유형',
          en: 'Worker type',
          zh: '劳动者类型',
          vi: 'Loại người lao động',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'general',
            label: L10nText(
              ko: '일반 근로자',
              en: 'Employee',
              zh: '一般劳动者',
              vi: 'Lao động thông thường',
            ),
          ),
          FormFieldOption(
            value: 'platform',
            label: L10nText(
              ko: '노무제공자',
              en: 'Platform · gig worker',
              zh: '劳务提供者',
              vi: 'Người cung cấp lao động',
            ),
          ),
          FormFieldOption(
            value: 'trainee',
            label: L10nText(
              ko: '현장실습생',
              en: 'On-site trainee',
              zh: '现场实习生',
              vi: 'Thực tập sinh',
            ),
          ),
          FormFieldOption(
            value: 'other',
            label: L10nText(ko: '기타', en: 'Other', zh: '其他', vi: 'Khác'),
          ),
        ],
      ),
    ],
  ),
  FormSection(
    title: L10nText(
      ko: '2. 사업장(회사) 정보',
      en: '2. Workplace information',
      zh: '2. 单位信息',
      vi: '2. Thông tin nơi làm việc',
    ),
    fields: [
      FormFieldSpec(
        key: 'bizname',
        label: L10nText(
          ko: '사업장명(회사 이름)',
          en: 'Workplace name',
          zh: '单位名称',
          vi: 'Tên nơi làm việc',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: ○○산업',
          en: 'e.g. ○○ Industries',
          zh: '例：○○产业',
          vi: 'VD: Công ty ○○',
        ),
      ),
      FormFieldSpec(
        key: 'ceoname',
        label: L10nText(
          ko: '대표자 성명',
          en: "Employer's name",
          zh: '代表者姓名',
          vi: 'Tên chủ sử dụng lao động',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'bizno',
        label: L10nText(
          ko: '사업자등록번호(산재보험가입번호)',
          en: 'Business registration no. (insurance no.)',
          zh: '营业执照登记号（工伤保险号）',
          vi: 'Số đăng ký kinh doanh (số bảo hiểm)',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '모르면 공란 가능',
          en: 'Leave blank if unknown',
          zh: '不清楚可留空',
          vi: 'Có thể để trống nếu không rõ',
        ),
      ),
      FormFieldSpec(
        key: 'bizaddrtel',
        label: L10nText(
          ko: '사업장 주소 · 대표 전화번호',
          en: 'Workplace address · phone',
          zh: '单位地址·代表电话',
          vi: 'Địa chỉ · số điện thoại nơi làm việc',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
      ),
      FormFieldSpec(
        key: 'relation',
        label: L10nText(
          ko: '사업주와의 관계',
          en: 'Relationship to employer',
          zh: '与雇主的关系',
          vi: 'Quan hệ với chủ sử dụng lao động',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'none',
            label: L10nText(ko: '해당 없음', en: 'None', zh: '无', vi: 'Không có'),
          ),
          FormFieldOption(
            value: 'family',
            label: L10nText(
              ko: '친인척(배우자·부모·자녀 등)',
              en: 'Family (spouse, parent, child, etc.)',
              zh: '亲属（配偶·父母·子女等）',
              vi: 'Người thân (vợ/chồng, cha mẹ, con, v.v.)',
            ),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'subcontract',
        label: L10nText(
          ko: '하수급 사업주 여부',
          en: 'Is your employer a subcontractor?',
          zh: '是否为分包业主',
          vi: 'Chủ sử dụng lao động có phải nhà thầu phụ không?',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'no',
            label: L10nText(
              ko: '아니오(원청)',
              en: 'No (main contractor)',
              zh: '否（原承包商）',
              vi: 'Không (nhà thầu chính)',
            ),
          ),
          FormFieldOption(
            value: 'yes',
            label: L10nText(
              ko: '예(하도급 업체)',
              en: 'Yes (subcontractor)',
              zh: '是（分包商）',
              vi: 'Có (nhà thầu phụ)',
            ),
          ),
        ],
      ),
    ],
  ),
  FormSection(
    title: L10nText(
      ko: '3. 재해 발생 경위(5W1H)',
      en: '3. How the injury happened',
      zh: '3. 灾害发生经过',
      vi: '3. Diễn biến xảy ra tai nạn',
    ),
    fields: [
      FormFieldSpec(
        key: 'injdate',
        label: L10nText(
          ko: '재해 발생 일시(분 단위까지)',
          en: 'Date and time of injury',
          zh: '灾害发生日期时间',
          vi: 'Thời gian xảy ra tai nạn',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: 2026-08-10 14:30',
          en: 'e.g. 2026-08-10 14:30',
          zh: '例：2026-08-10 14:30',
          vi: 'VD: 2026-08-10 14:30',
        ),
      ),
      FormFieldSpec(
        key: 'clockin',
        label: L10nText(
          ko: '평소 출근 시각',
          en: 'Usual clock-in time',
          zh: '平时上班时间',
          vi: 'Giờ vào làm thường lệ',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: 08:00',
          en: 'e.g. 08:00',
          zh: '例：08:00',
          vi: 'VD: 08:00',
        ),
      ),
      FormFieldSpec(
        key: 'clockout',
        label: L10nText(
          ko: '평소 퇴근 시각',
          en: 'Usual clock-out time',
          zh: '平时下班时间',
          vi: 'Giờ tan làm thường lệ',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: 17:00',
          en: 'e.g. 17:00',
          zh: '例：17:00',
          vi: 'VD: 17:00',
        ),
      ),
      FormFieldSpec(
        key: 'injplace',
        label: L10nText(
          ko: '재해 발생 장소',
          en: 'Place of the injury',
          zh: '灾害发生地点',
          vi: 'Địa điểm xảy ra tai nạn',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '예: ○○공장 2층 프레스 작업장',
          en: 'e.g. Press workshop, 2F, ○○ factory',
          zh: '例：○○工厂2楼冲压车间',
          vi: 'VD: Xưởng máy ép, tầng 2, nhà máy ○○',
        ),
      ),
      FormFieldSpec(
        key: 'injcontent',
        label: L10nText(
          ko: '재해 원인 및 내용(원문 그대로 출력)',
          en: 'How it happened (printed exactly as written)',
          zh: '灾害原因及内容（原文照录）',
          vi: 'Nguyên nhân và nội dung (in nguyên văn)',
        ),
        type: FormFieldType.textarea,
        tag: FillTag.raw,
        placeholder: L10nText(
          ko: '예: 2026년 8월 10일 14:30경 프레스 기계 부품 교체 작업 중 오른손이 끼여 다쳤습니다. 옆에서 작업하던 동료 ○○○이 목격했습니다.',
          en: 'Example: Around 14:30 on August 10, 2026, my right hand was caught while replacing press machine parts. My coworker ○○○, who was working nearby, saw it happen.',
          zh: '例：2026年8月10日14:30左右，在更换冲压机零件时右手被夹伤。旁边作业的同事○○○目击了此事。',
          vi: 'Ví dụ: Khoảng 14:30 ngày 10/8/2026, trong lúc thay linh kiện máy ép, tay phải tôi bị kẹt. Đồng nghiệp ○○○ làm việc gần đó đã chứng kiến.',
        ),
        hint: L10nText(
          ko: '여기 적은 내용은 고치지 않고 그대로 서류에 들어갑니다',
          en: 'What you write here goes into the document exactly as written',
          zh: '在这里写的内容将原封不动地录入文件',
          vi: 'Nội dung bạn viết ở đây sẽ được đưa nguyên văn vào hồ sơ',
        ),
      ),
      FormFieldSpec(
        key: 'witness',
        label: L10nText(
          ko: '목격자 성명 · 연락처(없으면 공란)',
          en: 'Witness name · contact',
          zh: '目击者姓名·联系方式（无则留空）',
          vi: 'Tên · liên hệ nhân chứng (nếu có)',
        ),
        type: FormFieldType.text,
        tag: FillTag.blank,
        placeholder: L10nText(
          ko: '없으면 공란',
          en: 'Leave blank if none',
          zh: '没有可留空',
          vi: 'Để trống nếu không có',
        ),
      ),
    ],
  ),
  FormSection(
    title: L10nText(
      ko: '4. 부속 서류 자동 판별',
      en: '4. Auto-linked attachments',
      zh: '4. 附属文件自动判别',
      vi: '4. Giấy tờ đính kèm tự động',
    ),
    fields: [
      FormFieldSpec(
        key: 'commute',
        label: L10nText(
          ko: '출퇴근재해 여부',
          en: 'Did this happen while commuting?',
          zh: '是否为通勤灾害',
          vi: 'Có phải tai nạn khi đi làm không?',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'no',
            label: L10nText(ko: '아니오', en: 'No', zh: '否', vi: 'Không'),
          ),
          FormFieldOption(
            value: 'yes',
            label: L10nText(
              ko: '예 — 출퇴근재해 발생신고서 자동 연동',
              en: 'Yes — links the commuting-accident report',
              zh: '是 — 自动联动通勤灾害发生申报书',
              vi: 'Có — tự liên kết báo cáo tai nạn khi đi làm',
            ),
          ),
        ],
      ),
      FormFieldSpec(
        key: 'thirdparty',
        label: L10nText(
          ko: '제3자 행위 재해 여부',
          en: 'Third-party involved?',
          zh: '是否为第三方行为灾害',
          vi: 'Có liên quan bên thứ ba không?',
        ),
        type: FormFieldType.segmented,
        tag: FillTag.blank,
        options: [
          FormFieldOption(
            value: 'no',
            label: L10nText(ko: '아니오', en: 'No', zh: '否', vi: 'Không'),
          ),
          FormFieldOption(
            value: 'yes',
            label: L10nText(
              ko: '예 — 제3자 행위재해신고서 자동 연동',
              en: 'Yes — links the third-party accident report',
              zh: '是 — 自动联动第三方行为灾害申报书',
              vi: 'Có — tự liên kết báo cáo tai nạn bên thứ ba',
            ),
          ),
        ],
      ),
    ],
  ),
];
