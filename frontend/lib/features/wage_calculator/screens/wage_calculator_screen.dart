import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/wage_diagnosis.dart';
import '../widgets/wage_form_widgets.dart';
import '../widgets/wage_help.dart';
import '../widgets/wage_result_card.dart';

/// 정밀 임금·체불 계산기 (5단계 위저드 + 결과). 프론트엔드_계산기_최종.html(v6)을
/// 그대로 옮겼다 — STEP1(확인기간+임금+비자+사업장) → STEP2(근무시간) →
/// STEP3(재직기간) → STEP4(세금·숙식비) → STEP5(실입금액) → 결과.
///
/// v6는 "이 단독 파일엔 근무기록장·OCR 모듈이 없다"는 이유로 두 불러오기 버튼과
/// 결과 화면의 진정서·기관찾기 버튼을 데모/비활성으로 남겨둔다. 이 앱은 그 모듈이
/// 실제로 있으므로: 근무기록장 불러오기는 데모 값 채우기로 동작시키고, 결과 화면의
/// 진정서 자동매핑·기관찾기 버튼은 실제 네비게이션으로 살려둔다(WageResultCard 참고).
/// OCR(임금명세서 자동 인식)만 실제 이미지 인식 파이프라인이 없어 준비 중 안내로 남긴다.
class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key});

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

class _S {
  const _S(this.ko, this.en, this.zh, this.vi);
  final String ko;
  final String en;
  final String zh;
  final String vi;

  L10nText get t => L10nText(ko: ko, en: en, zh: zh, vi: vi);
  String of(AppLanguage lang) => t.of(lang);
}

const _appBarTitle = _S(
  '정밀 임금계산기',
  'Precise Wage Calculator',
  '精确工资计算器',
  'Máy tính lương chính xác',
);
const _importWorklog = _S(
  '📁 근무기록장 불러오기',
  '📁 Import work log',
  '📁 导入工作日志',
  '📁 Nhập nhật ký làm việc',
);
const _importPayslip = _S(
  '📄 임금명세서 불러오기',
  '📄 Import payslip',
  '📄 导入工资单',
  '📄 Nhập phiếu lương',
);
const _worklogSnack = _S(
  '근무기록장 연동은 준비 중이라 예시 데이터로 채워드렸어요.',
  'Work log integration is coming soon, so we filled in sample data for you.',
  '工作日志联动功能正在准备中，已为您填入示例数据。',
  'Tính năng liên kết nhật ký làm việc đang được chuẩn bị nên chúng tôi đã điền dữ liệu mẫu cho bạn.',
);
const _payslipSnack = _S(
  '임금명세서 자동 인식(OCR)은 준비 중이에요. 값을 직접 입력해 주세요.',
  'Automatic payslip recognition (OCR) is coming soon. Please enter the values manually.',
  '工资单自动识别（OCR）功能正在准备中。请直接输入数值。',
  'Tính năng nhận dạng phiếu lương tự động (OCR) đang được chuẩn bị. Vui lòng nhập giá trị trực tiếp.',
);
const _findOrgsSnack = _S(
  '관할 지방고용노동청과 외국인노동자지원센터 위치·연락처를 보여드립니다. (준비 중)',
  'We will show the location and contact info of your local labor office and migrant worker support center. (Coming soon)',
  '为您显示管辖地方劳动厅和外国劳动者支援中心的位置及联系方式。（准备中）',
  'Chúng tôi sẽ hiển thị vị trí và thông tin liên hệ của Sở Lao động địa phương và Trung tâm hỗ trợ lao động nước ngoài. (Đang chuẩn bị)',
);
const _calcLabel = _S('계산하기', 'Calculate', '计算', 'Tính toán');
const _nextLabel = _S('다음', 'Next', '下一步', 'Tiếp theo');
const _prevLabel = _S('이전', 'Back', '上一步', 'Quay lại');
const _editValuesLabel = _S(
  '✏️ 입력값 수정하기',
  '✏️ Edit values',
  '✏️ 修改输入值',
  '✏️ Chỉnh sửa giá trị',
);
const _resultBadge = _S('RESULT', 'RESULT', '结果', 'KẾT QUẢ');
const _stepWord = _S('STEP', 'STEP', '步骤', 'BƯỚC');

const _step1Title1 = _S(
  '확인하실 기간을 먼저 골라주세요',
  'First, choose the period you want to check',
  '请先选择您要确认的期间',
  'Trước tiên, hãy chọn khoảng thời gian bạn muốn kiểm tra',
);
const _step1Lead1 = _S(
  '이번 달 급여만 확인하실지, 여러 달 동안 밀린 급여를 확인하실지 고르세요.',
  'Choose whether to check only this month\'s pay or unpaid wages over several months.',
  '请选择是仅确认本月工资，还是确认多个月的拖欠工资。',
  'Hãy chọn xem bạn muốn kiểm tra lương tháng này hay lương chưa trả trong nhiều tháng.',
);
const _segMonthOnly = _S('이번달만', 'This month only', '仅本月', 'Chỉ tháng này');
const _segMultiUnpaid = _S(
  '여러달 체불',
  'Multiple unpaid months',
  '多月拖欠',
  'Nhiều tháng chưa trả',
);
const _segRangeCustom = _S(
  '기간 직접 지정',
  'Custom period',
  '自定义期间',
  'Khoảng thời gian tùy chỉnh',
);
const _unpaidMonthsLabel = _S(
  '못 받은 개월 수',
  'Number of unpaid months',
  '未收到工资的月数',
  'Số tháng chưa nhận lương',
);
const _monthUnit = _S('개월', 'months', '个月', 'tháng');
const _rangeTitle = _S(
  '체불 시작월 ~ 종료월',
  'Unpaid period: start ~ end month',
  '拖欠开始月 ~ 结束月',
  'Tháng bắt đầu ~ kết thúc nợ lương',
);
const _startMonthLabel = _S('시작월', 'Start month', '开始月', 'Tháng bắt đầu');
const _endMonthLabel = _S('종료월', 'End month', '结束月', 'Tháng kết thúc');
const _step1Title2 = _S(
  '임금과 사업장 조건을 알려주세요',
  'Tell us about your wage and workplace conditions',
  '请告诉我们工资和工作场所的情况',
  'Hãy cho chúng tôi biết về lương và điều kiện nơi làm việc',
);
const _step1Lead2 = _S(
  '계약서에 적힌 방식 그대로 골라주세요.',
  'Please choose exactly as written in your contract.',
  '请按照合同上记载的方式选择。',
  'Vui lòng chọn đúng như trong hợp đồng.',
);
const _visaLabel = _S(
  '체류자격 (비자)',
  'Residence status (visa)',
  '居留资格（签证）',
  'Tình trạng cư trú (visa)',
);
const _visaCustomLabel = _S(
  '비자 직접입력',
  'Enter visa manually',
  '手动输入签证',
  'Nhập visa thủ công',
);
const _payMethodLabel = _S(
  '임금 지급 방식',
  'Wage payment method',
  '工资支付方式',
  'Hình thức trả lương',
);
const _hourLabel = _S('시급', 'Hourly', '时薪', 'Theo giờ');
const _dayLabel = _S('일급', 'Daily', '日薪', 'Theo ngày');
const _weekLabel = _S('주급', 'Weekly', '周薪', 'Theo tuần');
const _monthLabel = _S('월급', 'Monthly', '月薪', 'Theo tháng');
const _yearLabel = _S('연봉', 'Annual', '年薪', 'Theo năm');
const _monthPretaxLabel = _S(
  '월급 (세전)',
  'Monthly (pre-tax)',
  '月薪（税前）',
  'Theo tháng (trước thuế)',
);
const _yearPretaxLabel = _S(
  '연봉 (세전)',
  'Annual (pre-tax)',
  '年薪（税前）',
  'Theo năm (trước thuế)',
);
const _wonUnit = _S('원', 'KRW', '韩元', 'KRW');
const _dailyHoursLabel = _S(
  '하루 약정 근무시간',
  'Contracted daily hours',
  '每日约定工作时间',
  'Giờ làm việc theo hợp đồng mỗi ngày',
);
const _hourUnit = _S('시간', 'hours', '小时', 'giờ');
const _totalWorkDaysLabel = _S(
  '기간 전체 근무일수',
  'Total work days in the period',
  '期间总工作天数',
  'Tổng số ngày làm việc trong kỳ',
);
const _dayUnit = _S('일', 'days', '天', 'ngày');
const _belowMinTitle = _S(
  '⚠ 최저임금보다 낮습니다',
  '⚠ Below minimum wage',
  '⚠ 低于最低工资',
  '⚠ Thấp hơn lương tối thiểu',
);
const _bizSizeLabel = _S(
  '사업장 규모',
  'Business size',
  '企业规模',
  'Quy mô doanh nghiệp',
);
const _over5Label = _S(
  '상시 5인 이상',
  '5 or more regular employees',
  '常驻员工5人以上',
  'Từ 5 nhân viên thường xuyên trở lên',
);
const _under5Label = _S('5인 미만', 'Fewer than 5', '不足5人', 'Dưới 5 người');
const _unknownLabel = _S('잘 모르겠어요', 'Not sure', '不清楚', 'Không chắc chắn');
const _selectPlaceholder = _S('선택', 'Select', '选择', 'Chọn');

const _step2Title = _S(
  '근무시간을 알려주세요',
  'Tell us your work hours',
  '请告诉我们您的工作时间',
  'Cho chúng tôi biết giờ làm việc của bạn',
);
const _step2Lead = _S(
  '약정 시간과 실제 근무 시간의 차이를 계산합니다.',
  'We calculate the difference between contracted hours and actual work hours.',
  '计算约定时间与实际工作时间的差异。',
  'Chúng tôi tính toán chênh lệch giữa giờ theo hợp đồng và giờ làm việc thực tế.',
);
const _weeklyHoursLabel = _S(
  '주당 근로시간',
  'Weekly work hours',
  '每周工作时间',
  'Giờ làm việc hàng tuần',
);
const _weeklyContractLabel = _S(
  '주당 약정 근로시간',
  'Contracted weekly hours',
  '每周约定工作时间',
  'Giờ làm việc theo hợp đồng hàng tuần',
);
const _overtimeSectionTitle = _S(
  '선택 기간 전체 초과 근무',
  'Total overtime in the selected period',
  '所选期间的总加班',
  'Tổng số giờ làm thêm trong kỳ đã chọn',
);
const _otLabel = _S('연장근로', 'Overtime work', '延长劳动', 'Làm thêm giờ');
const _nightLabel = _S(
  '야간근로 (22시~06시)',
  'Night work (22:00–06:00)',
  '夜间劳动（22点~6点）',
  'Làm việc ban đêm (22h~6h)',
);
const _holLabel = _S('휴일근로', 'Holiday work', '假日劳动', 'Làm việc ngày lễ');

const _step3Title = _S(
  '재직 기간을 알려주세요',
  'Tell us your employment period',
  '请告诉我们您的在职期间',
  'Cho chúng tôi biết thời gian làm việc của bạn',
);
const _step3Lead = _S(
  '입사일과 퇴사일을 입력해 주세요.',
  'Please enter your hire date and resignation date.',
  '请输入入职日期和离职日期。',
  'Vui lòng nhập ngày vào làm và ngày nghỉ việc.',
);
const _tenureLabel = _S('근속 기간', 'Tenure period', '在职期间', 'Thời gian làm việc');
const _hireDateLabel = _S('입사일', 'Hire date', '入职日期', 'Ngày vào làm');
const _leaveDateLabel = _S(
  '퇴사일 (해당 시)',
  'Resignation date (if applicable)',
  '离职日期（如适用）',
  'Ngày nghỉ việc (nếu có)',
);
const _absenceLabel = _S(
  '결근 여부',
  'Absence status',
  '缺勤情况',
  'Tình trạng vắng mặt',
);
const _absenceToggle = _S(
  '확인 기간 중 결근이 있습니다',
  'There was an absence during the period',
  '确认期间内有缺勤',
  'Có vắng mặt trong kỳ xác nhận',
);
const _whySeparateTitle = _S(
  '왜 체불 기간과 재직 기간을 분리하나요?',
  'Why separate the unpaid period from the employment period?',
  '为什么要将拖欠期间与在职期间分开？',
  'Tại sao lại tách riêng kỳ nợ lương và thời gian làm việc?',
);
const _whySeparateBody = _S(
  '2년을 일했지만 최근 3개월치 급여만 밀린 경우처럼 "다닌 기간"과 "못 받은 기간"이 다를 수 있습니다. 여기서 입력하는 재직 기간은 퇴직금 요건 산정에만 사용됩니다.',
  'The "employment period" and the "unpaid period" can differ — for example, working for 2 years but only the last 3 months\' pay being unpaid. The employment period entered here is used only to calculate severance pay eligibility.',
  '"在职期间"和"未收到工资的期间"可能不同，例如工作了2年但只有最近3个月的工资被拖欠。此处输入的在职期间仅用于计算退休金资格。',
  '"Thời gian làm việc" và "thời gian chưa nhận lương" có thể khác nhau, ví dụ làm việc 2 năm nhưng chỉ 3 tháng gần nhất chưa được trả lương. Thời gian làm việc nhập ở đây chỉ dùng để tính điều kiện trợ cấp thôi việc.',
);
const _severanceExtraTitle = _S(
  '퇴직금 정밀 산정용 추가 입력 (선택)',
  'Additional input for precise severance calculation (optional)',
  '用于精确计算退休金的附加输入（可选）',
  'Nhập thêm để tính chính xác trợ cấp thôi việc (không bắt buộc)',
);
const _bonus1yLabel = _S(
  '최근 1년 정기상여금 총액',
  'Total regular bonus in the last year',
  '最近1年定期奖金总额',
  'Tổng tiền thưởng định kỳ trong 1 năm gần nhất',
);
const _vacation1yLabel = _S(
  '최근 1년 미사용 연차수당',
  'Unused annual leave pay in the last year',
  '最近1年未使用年假补贴',
  'Tiền phép năm chưa sử dụng trong 1 năm gần nhất',
);

const _step4Title = _S(
  '어떻게 공제되고 있나요?',
  'How are deductions being made?',
  '扣除方式是怎样的？',
  'Các khoản khấu trừ như thế nào?',
);
const _step4Lead = _S(
  '임금명세서의 공제 항목을 참고하세요.',
  'Refer to the deduction items on your payslip.',
  '请参考工资单上的扣除项目。',
  'Hãy tham khảo các mục khấu trừ trên phiếu lương của bạn.',
);
const _taxMethodLabel = _S(
  '세금 공제 방식',
  'Tax deduction method',
  '税款扣除方式',
  'Hình thức khấu trừ thuế',
);
const _fourInsuranceLabel = _S(
  '4대보험 가입',
  'Enrolled in the 4 major insurances',
  '加入四大保险',
  'Tham gia 4 loại bảo hiểm',
);
const _bizTaxLabel = _S(
  '사업소득 3.3% 공제',
  'Business income 3.3% withholding',
  '扣除事业所得税3.3%',
  'Khấu trừ 3.3% thu nhập kinh doanh',
);
const _noTaxLabel = _S(
  '세금 미공제 (그대로 수령)',
  'No tax withheld (received as is)',
  '未扣税（原样领取）',
  'Không khấu trừ thuế (nhận nguyên)',
);
const _roomDeductLabel = _S(
  '숙식비 공제',
  'Room & board deduction',
  '食宿费扣除',
  'Khấu trừ tiền ăn ở',
);
const _roomToggle = _S(
  '숙식비를 공제하고 있습니다',
  'Room & board is being deducted',
  '正在扣除食宿费',
  'Đang khấu trừ tiền ăn ở',
);
const _roomDeductTotalLabel = _S(
  '숙식비 공제 총액',
  'Total room & board deduction',
  '食宿费扣除总额',
  'Tổng tiền khấu trừ ăn ở',
);
const _roomTypeLabel = _S(
  '숙식 제공 형태',
  'Type of room & board provided',
  '食宿提供形式',
  'Hình thức cung cấp ăn ở',
);
const _dormLabel = _S('기숙사', 'Dormitory', '宿舍', 'Ký túc xá');
const _studioLabel = _S('원룸·주택', 'Studio/House', '单间房·住宅', 'Phòng trọ/Nhà ở');
const _mealLabel = _S('식사만', 'Meals only', '仅供餐', 'Chỉ ăn');
const _roomBelowMinTitle = _S(
  '⚠ 숙식비를 빼면 최저임금 아래로 내려갑니다',
  '⚠ Falls below minimum wage after room & board deduction',
  '⚠ 扣除食宿费后低于最低工资',
  '⚠ Sau khi khấu trừ tiền ăn ở sẽ thấp hơn lương tối thiểu',
);

const _step5Title = _S(
  '실제로 받으신 금액을 적어주세요',
  'Please enter the amount you actually received',
  '请填写您实际收到的金额',
  'Vui lòng nhập số tiền bạn đã thực nhận',
);
const _step5Lead = _S(
  '계산 결과와 실제 통장 입금액을 대조합니다.',
  'We compare the calculated result with the actual bank deposit amount.',
  '将计算结果与实际银行存款金额进行对照。',
  'Chúng tôi đối chiếu kết quả tính toán với số tiền thực nhận vào tài khoản.',
);
const _periodNoticeTitle = _S(
  '기간 대조 안내 (필독)',
  'Period comparison notice (please read)',
  '期间对照说明（必读）',
  'Lưu ý đối chiếu kỳ (vui lòng đọc)',
);
const _totalReceivedLabel = _S(
  '실제 받은 돈 총액',
  'Total amount actually received',
  '实际收到金额总计',
  'Tổng số tiền thực nhận',
);
const _zeroButtonLabel = _S(
  '0원 (전액 미지급)',
  '0 KRW (fully unpaid)',
  '0韩元（全部未支付）',
  '0 KRW (chưa trả toàn bộ)',
);

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  static const _totalSteps = 5;
  int _step = 0;
  bool _showResult = false;

  PeriodMode _periodMode = PeriodMode.month;
  VisaChoice _visa = VisaChoice.e9;
  PayType _payType = PayType.hour;
  BizSize _size = BizSize.over5;
  TaxMethod _tax = TaxMethod.four;
  RoomType _roomType = RoomType.dorm;
  bool _absent = false;
  bool _roomOn = false;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _hireDate;
  DateTime? _leaveDate;

  late final _payCtrl = TextEditingController(
    text: minWage().$1.toStringAsFixed(0),
  );
  final _fixedMonthCtrl = TextEditingController(text: '1');
  final _dailyHoursCtrl = TextEditingController(text: '8');
  final _dayCountTotalCtrl = TextEditingController(text: '22');
  final _weekHoursCtrl = TextEditingController(text: '40');
  final _otCtrl = TextEditingController(text: '0');
  final _nightCtrl = TextEditingController(text: '0');
  final _holCtrl = TextEditingController(text: '0');
  final _multiMonthsCtrl = TextEditingController(text: '3');
  final _bonus1yCtrl = TextEditingController(text: '0');
  final _vacation1yCtrl = TextEditingController(text: '0');
  final _roomAmtCtrl = TextEditingController(text: '0');
  final _receivedCtrl = TextEditingController(text: '0');
  final _visaCustomCtrl = TextEditingController(text: '');

  @override
  void dispose() {
    for (final c in [
      _payCtrl,
      _fixedMonthCtrl,
      _dailyHoursCtrl,
      _dayCountTotalCtrl,
      _weekHoursCtrl,
      _otCtrl,
      _nightCtrl,
      _holCtrl,
      _multiMonthsCtrl,
      _bonus1yCtrl,
      _vacation1yCtrl,
      _roomAmtCtrl,
      _receivedCtrl,
      _visaCustomCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text) ?? 0;

  WageCalcInput _buildInput() {
    return WageCalcInput(
      periodMode: _periodMode,
      multiMonths: _num(_multiMonthsCtrl),
      rangeStart: _rangeStart,
      rangeEnd: _rangeEnd,
      visa: _visa,
      visaCustom: _visaCustomCtrl.text,
      payType: _payType,
      pay: _num(_payCtrl),
      dailyHours: _num(_dailyHoursCtrl),
      dayCountTotal: _num(_dayCountTotalCtrl),
      weekHours: _num(_weekHoursCtrl),
      otH: _num(_otCtrl),
      nightH: _num(_nightCtrl),
      holH: _num(_holCtrl),
      hireDate: _hireDate,
      leaveDate: _leaveDate,
      absent: _absent,
      bonus1y: _num(_bonus1yCtrl),
      vacation1y: _num(_vacation1yCtrl),
      size: _size,
      tax: _tax,
      roomOn: _roomOn,
      roomAmtTotal: _num(_roomAmtCtrl),
      roomType: _roomType,
      received: _num(_receivedCtrl),
    );
  }

  void _openHelp(String key, AppLanguage lang) {
    final entry = buildHelpDict(lang)[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context), lang);
  }

  void _setPayType(PayType type) {
    setState(() {
      _payType = type;
      _payCtrl.text = switch (type) {
        PayType.hour => minWage().$1.toStringAsFixed(0),
        PayType.day => '90000',
        PayType.week => '400000',
        PayType.year => '26000000',
        PayType.month => '2200000',
      };
    });
  }

  void _importFromWorklog(AppLanguage lang) {
    setState(() {
      _payType = PayType.hour;
      _payCtrl.text = minWage().$1.toStringAsFixed(0);
      _weekHoursCtrl.text = '40';
      _otCtrl.text = '12';
      _nightCtrl.text = '6';
      _holCtrl.text = '0';
      _hireDate ??= DateTime(2024, 3, 2);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_worklogSnack.of(lang))));
  }

  void _importFromPayslip(AppLanguage lang) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_payslipSnack.of(lang))));
  }

  void _goNext() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      setState(() => _showResult = true);
    }
  }

  void _goPrev() {
    if (_showResult) {
      setState(() => _showResult = false);
    } else if (_step > 0) {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    final input = _buildInput();
    final result = _showResult ? calcWage(input) : null;

    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle.of(lang))),
      body: Column(
        children: [
          _StepHeader(
            stepIndex: _step,
            totalSteps: _totalSteps,
            resultMode: _showResult,
            language: lang,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _showResult
                  ? WageResultCard(
                      input: input,
                      result: result!,
                      language: lang,
                      onOpenWageNavigator: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WageNavigatorScreen(),
                        ),
                      ),
                      onFindNearbyOrgs: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_findOrgsSnack.of(lang))),
                          ),
                    )
                  : _buildStepBody(input, lang),
            ),
          ),
          _StepFooter(
            resultMode: _showResult,
            showPrev: _step > 0,
            nextLabel: _step == _totalSteps - 1
                ? _calcLabel.of(lang)
                : _nextLabel.of(lang),
            prevLabel: _prevLabel.of(lang),
            editValuesLabel: _editValuesLabel.of(lang),
            onPrev: _goPrev,
            onNext: _goNext,
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(WageCalcInput input, AppLanguage lang) {
    switch (_step) {
      case 0:
        return _buildStep1(lang);
      case 1:
        return _buildStep2(lang);
      case 2:
        return _buildStep3(lang);
      case 3:
        return _buildStep4(input, lang);
      default:
        return _buildStep5(input, lang);
    }
  }

  // ---------- STEP 1 · 확인 기간 및 임금/사업장 조건 ----------
  Widget _buildStep1(AppLanguage lang) {
    final belowMin =
        _payType == PayType.hour &&
        _num(_payCtrl) > 0 &&
        _num(_payCtrl) < minWage().$1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ImportButton(
              label: _importWorklog.of(lang),
              onTap: () => _importFromWorklog(lang),
            ),
            const SizedBox(width: 7),
            ImportButton(
              label: _importPayslip.of(lang),
              onTap: () => _importFromPayslip(lang),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SectionH4(title: _step1Title1.of(lang), lead: _step1Lead1.of(lang)),
        Seg<PeriodMode>(
          options: [
            (_segMonthOnly.of(lang), PeriodMode.month),
            (_segMultiUnpaid.of(lang), PeriodMode.multi),
            (_segRangeCustom.of(lang), PeriodMode.range),
          ],
          value: _periodMode,
          onChanged: (v) => setState(() => _periodMode = v),
        ),
        if (_periodMode == PeriodMode.month)
          FGroup(
            children: [
              FRow(
                label: _unpaidMonthsLabel.of(lang),
                controller: _fixedMonthCtrl,
                unit: _monthUnit.of(lang),
                readOnly: true,
                help: () => _openHelp('pm_month', lang),
              ),
            ],
          )
        else if (_periodMode == PeriodMode.multi)
          FGroup(
            children: [
              FRow(
                label: _unpaidMonthsLabel.of(lang),
                controller: _multiMonthsCtrl,
                unit: _monthUnit.of(lang),
                help: () => _openHelp('pm_multi', lang),
              ),
            ],
          )
        else
          FGroup(
            title: _rangeTitle.of(lang),
            help: () => _openHelp('pm_range', lang),
            children: [
              FDateRow(
                label: _startMonthLabel.of(lang),
                value: _rangeStart,
                monthOnly: true,
                placeholder: _selectPlaceholder.of(lang),
                onPick: (d) =>
                    setState(() => _rangeStart = DateTime(d.year, d.month, 1)),
              ),
              FDateRow(
                label: _endMonthLabel.of(lang),
                value: _rangeEnd,
                monthOnly: true,
                placeholder: _selectPlaceholder.of(lang),
                onPick: (d) =>
                    setState(() => _rangeEnd = DateTime(d.year, d.month, 1)),
              ),
            ],
          ),

        SectionH4(
          title: _step1Title2.of(lang),
          lead: _step1Lead2.of(lang),
          topGap: 4,
        ),
        FGroup(
          title: _visaLabel.of(lang),
          children: [
            Chips<VisaChoice>(
              compact: true,
              options: VisaChoice.values
                  .map((v) => (v.labelOf(lang), v))
                  .toList(),
              value: _visa,
              onChanged: (v) => setState(() => _visa = v),
            ),
            if (_visa == VisaChoice.etc) ...[
              const SizedBox(height: 6),
              FRow(
                label: _visaCustomLabel.of(lang),
                controller: _visaCustomCtrl,
              ),
            ],
          ],
        ),

        InkWell(
          onTap: () => setState(() {
            _payType = PayType.hour;
            _payCtrl.text = minWage().$1.toStringAsFixed(0);
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 11),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '⚖ $wageCalcYear ${_minWageButtonSuffix(lang)} (${formatWon(minWage().$1, lang)})',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                QMark(onTap: () => _openHelp('minw', lang)),
              ],
            ),
          ),
        ),

        FGroup(
          title: _payMethodLabel.of(lang),
          children: [
            Seg<PayType>(
              options: [
                (_hourLabel.of(lang), PayType.hour),
                (_dayLabel.of(lang), PayType.day),
                (_weekLabel.of(lang), PayType.week),
              ],
              value: _payType,
              onChanged: _setPayType,
            ),
            Seg<PayType>(
              options: [
                (_monthLabel.of(lang), PayType.month),
                (_yearLabel.of(lang), PayType.year),
              ],
              value: _payType,
              onChanged: _setPayType,
            ),
            FRow(
              label: _payAmountLabel(_payType, lang),
              controller: _payCtrl,
              unit: _wonUnit.of(lang),
            ),
            if (_payType == PayType.day) ...[
              FRow(
                label: _dailyHoursLabel.of(lang),
                controller: _dailyHoursCtrl,
                unit: _hourUnit.of(lang),
              ),
              FRow(
                label: _totalWorkDaysLabel.of(lang),
                controller: _dayCountTotalCtrl,
                unit: _dayUnit.of(lang),
              ),
            ],
          ],
        ),

        if (belowMin)
          RedNotice(title: _belowMinTitle.of(lang), body: _belowMinBody(lang)),

        FGroup(
          title: _bizSizeLabel.of(lang),
          help: () => _openHelp('biz_size', lang),
          children: [
            OptButton(
              icon: '🏢',
              title: _over5Label.of(lang),
              selected: _size == BizSize.over5,
              onTap: () => setState(() => _size = BizSize.over5),
            ),
            OptButton(
              icon: '🏠',
              title: _under5Label.of(lang),
              selected: _size == BizSize.under5,
              onTap: () => setState(() => _size = BizSize.under5),
            ),
            OptButton(
              icon: '❓',
              title: _unknownLabel.of(lang),
              selected: _size == BizSize.unknown,
              onTap: () => setState(() => _size = BizSize.unknown),
            ),
          ],
        ),
      ],
    );
  }

  String _minWageButtonSuffix(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '년 최저임금 넣기',
    AppLanguage.en => 'minimum wage',
    AppLanguage.zh => '年最低工资',
    AppLanguage.vi => 'lương tối thiểu năm',
  };

  String _belowMinBody(AppLanguage lang) {
    final pay = formatWon(_num(_payCtrl), lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko =>
        '계약된 시급 $pay이 $wageCalcYear년 최저임금 $mw보다 낮아요. 미달분은 무효이며 차액을 청구할 수 있습니다.',
      AppLanguage.en =>
        'Your contracted hourly wage of $pay is lower than the $wageCalcYear minimum wage of $mw. The shortfall is invalid and you can claim the difference.',
      AppLanguage.zh =>
        '合同约定的时薪 $pay 低于 $wageCalcYear 年最低工资 $mw。不足部分无效，您可以要求补足差额。',
      AppLanguage.vi =>
        'Lương giờ theo hợp đồng $pay thấp hơn lương tối thiểu năm $wageCalcYear là $mw. Phần thiếu không có hiệu lực và bạn có thể yêu cầu trả phần chênh lệch.',
    };
  }

  String _payAmountLabel(PayType type, AppLanguage lang) => switch (type) {
    PayType.hour => _hourLabel.of(lang),
    PayType.day => _dayLabel.of(lang),
    PayType.week => _weekLabel.of(lang),
    PayType.month => _monthPretaxLabel.of(lang),
    PayType.year => _yearPretaxLabel.of(lang),
  };

  // ---------- STEP 2 · 근무시간 ----------
  Widget _buildStep2(AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step2Title.of(lang), lead: _step2Lead.of(lang)),
        FGroup(
          title: _weeklyHoursLabel.of(lang),
          help: () => _openHelp('week_h', lang),
          children: [
            FRow(
              label: _weeklyContractLabel.of(lang),
              controller: _weekHoursCtrl,
              unit: _hourUnit.of(lang),
            ),
          ],
        ),
        FGroup(
          title: _overtimeSectionTitle.of(lang),
          children: [
            FRow(
              label: _otLabel.of(lang),
              controller: _otCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('ot_info', lang),
            ),
            FRow(
              label: _nightLabel.of(lang),
              controller: _nightCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('nt_info', lang),
            ),
            FRow(
              label: _holLabel.of(lang),
              controller: _holCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('hol_info', lang),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- STEP 3 · 재직 기간 ----------
  Widget _buildStep3(AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(
          title: _step3Title.of(lang),
          lead: _step3Lead.of(lang),
          help: () => _openHelp('tenure_info', lang),
        ),
        FGroup(
          title: _tenureLabel.of(lang),
          children: [
            FDateRow(
              label: _hireDateLabel.of(lang),
              value: _hireDate,
              placeholder: _selectPlaceholder.of(lang),
              onPick: (d) => setState(() => _hireDate = d),
            ),
            FDateRow(
              label: _leaveDateLabel.of(lang),
              value: _leaveDate,
              placeholder: _selectPlaceholder.of(lang),
              onPick: (d) => setState(() => _leaveDate = d),
            ),
          ],
        ),
        FGroup(
          title: _absenceLabel.of(lang),
          children: [
            ToggleRow(
              label: _absenceToggle.of(lang),
              value: _absent,
              onChanged: (v) => setState(() => _absent = v),
            ),
          ],
        ),
        MoreBox(
          title: _whySeparateTitle.of(lang),
          child: Text(
            _whySeparateBody.of(lang),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        MoreBox(
          title: _severanceExtraTitle.of(lang),
          help: () => _openHelp('severance_extra', lang),
          child: Column(
            children: [
              FRow(
                label: _bonus1yLabel.of(lang),
                controller: _bonus1yCtrl,
                unit: _wonUnit.of(lang),
              ),
              FRow(
                label: _vacation1yLabel.of(lang),
                controller: _vacation1yCtrl,
                unit: _wonUnit.of(lang),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- STEP 4 · 세금 및 숙식비 공제 ----------
  Widget _buildStep4(WageCalcInput input, AppLanguage lang) {
    final r = calcWage(input);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step4Title.of(lang), lead: _step4Lead.of(lang)),
        FGroup(
          title: _taxMethodLabel.of(lang),
          help: () => _openHelp('tax_info', lang),
          children: [
            OptButton(
              icon: '🛡',
              title: _fourInsuranceLabel.of(lang),
              selected: _tax == TaxMethod.four,
              onTap: () => setState(() => _tax = TaxMethod.four),
            ),
            OptButton(
              icon: '🧾',
              title: _bizTaxLabel.of(lang),
              selected: _tax == TaxMethod.biz,
              onTap: () => setState(() => _tax = TaxMethod.biz),
            ),
            OptButton(
              icon: '–',
              title: _noTaxLabel.of(lang),
              selected: _tax == TaxMethod.none,
              onTap: () => setState(() => _tax = TaxMethod.none),
            ),
            OptButton(
              icon: '❓',
              title: _unknownLabel.of(lang),
              selected: _tax == TaxMethod.unknown,
              onTap: () => setState(() => _tax = TaxMethod.unknown),
            ),
          ],
        ),
        FGroup(
          title: _roomDeductLabel.of(lang),
          children: [
            ToggleRow(
              label: _roomToggle.of(lang),
              value: _roomOn,
              onChanged: (v) => setState(() => _roomOn = v),
            ),
            if (_roomOn) ...[
              const SizedBox(height: 6),
              FRow(
                label: _roomDeductTotalLabel.of(lang),
                controller: _roomAmtCtrl,
                unit: _wonUnit.of(lang),
              ),
              const SizedBox(height: 6),
              Text(
                _roomTypeLabel.of(lang),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Chips<RoomType>(
                options: [
                  (_dormLabel.of(lang), RoomType.dorm),
                  (_studioLabel.of(lang), RoomType.studio),
                  (_mealLabel.of(lang), RoomType.meal),
                ],
                value: _roomType,
                onChanged: (v) => setState(() => _roomType = v),
              ),
            ],
          ],
        ),
        if (r.roomBelowMin)
          RedNotice(
            title: _roomBelowMinTitle.of(lang),
            body: _roomBelowMinBody(r, lang),
          ),
      ],
    );
  }

  String _roomBelowMinBody(WageCalcResult r, AppLanguage lang) {
    final after = formatWon(r.afterRoomHourly, lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko =>
        '공제 후 환산 시급 $after < 최저임금 $mw. 공제 근거와 금액을 사업주에게 서면으로 요청해 확인해 보세요.',
      AppLanguage.en =>
        'Hourly wage after deduction $after < minimum wage $mw. Request written confirmation of the deduction basis and amount from your employer.',
      AppLanguage.zh => '扣除后折算时薪 $after < 最低工资 $mw。请向雇主书面索取扣除依据及金额进行确认。',
      AppLanguage.vi =>
        'Lương giờ quy đổi sau khấu trừ $after < lương tối thiểu $mw. Hãy yêu cầu chủ sử dụng lao động xác nhận bằng văn bản về căn cứ và số tiền khấu trừ.',
    };
  }

  // ---------- STEP 5 · 통장 실입금액 ----------
  Widget _buildStep5(WageCalcInput input, AppLanguage lang) {
    final period = input.periodLabel(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step5Title.of(lang), lead: _step5Lead.of(lang)),
        MoreBox(
          title: _periodNoticeTitle.of(lang),
          initiallyOpen: true,
          child: RichNote(_periodNoticeBody(period, lang)),
        ),
        FGroup(
          title: _totalReceivedTitle(period, lang),
          children: [
            FRow(
              label: _totalReceivedLabel.of(lang),
              controller: _receivedCtrl,
              unit: _wonUnit.of(lang),
            ),
          ],
        ),
        QuickButton(
          label: _zeroButtonLabel.of(lang),
          onTap: () => setState(() => _receivedCtrl.text = '0'),
        ),
      ],
    );
  }

  String _periodNoticeBody(String period, AppLanguage lang) => switch (lang) {
    AppLanguage.ko =>
      '설정하신 확인 기간(총 <b>$period</b>) 동안 사업주로부터 통장으로 실제 전달받은 금액의 <b>전체 합계</b>를 입력하세요.',
    AppLanguage.en =>
      'Enter the <b>total sum</b> of the amount you actually received from your employer via bank transfer during the checking period (<b>$period</b>).',
    AppLanguage.zh =>
      '请输入在您设置的确认期间（共 <b>$period</b>）内，实际从雇主处收到的银行转账金额的<b>总计</b>。',
    AppLanguage.vi =>
      'Vui lòng nhập <b>tổng số tiền</b> bạn đã thực nhận qua chuyển khoản ngân hàng từ chủ sử dụng lao động trong kỳ xác nhận (<b>$period</b>).',
  };

  String _totalReceivedTitle(String period, AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '실입금액 합계 ($period)',
    AppLanguage.en => 'Total amount received ($period)',
    AppLanguage.zh => '实际入账金额总计（$period）',
    AppLanguage.vi => 'Tổng số tiền thực nhận ($period)',
  };
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepIndex,
    required this.totalSteps,
    required this.resultMode,
    required this.language,
  });
  final int stepIndex;
  final int totalSteps;
  final bool resultMode;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                resultMode
                    ? _resultBadge.of(language)
                    : '${_stepWord.of(language)} ${stepIndex + 1} / $totalSteps',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (i) {
              final done = resultMode || i < stepIndex;
              final current = !resultMode && i == stepIndex;
              final color = done
                  ? AppColors.secondary
                  : (current ? AppColors.primary : AppColors.border);
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepFooter extends StatelessWidget {
  const _StepFooter({
    required this.resultMode,
    required this.showPrev,
    required this.nextLabel,
    required this.prevLabel,
    required this.editValuesLabel,
    required this.onPrev,
    required this.onNext,
  });

  final bool resultMode;
  final bool showPrev;
  final String nextLabel;
  final String prevLabel;
  final String editValuesLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: resultMode
          ? SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPrev,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  editValuesLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                if (showPrev) ...[
                  SizedBox(
                    width: 92,
                    child: OutlinedButton(
                      onPressed: onPrev,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        prevLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: Text(
                      nextLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
