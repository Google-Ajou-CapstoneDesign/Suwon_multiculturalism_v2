import '../../../core/app_language.dart';
import 'flow_block.dart';

/// 진정서/신청서 편집 서식 한 필드의 입력 방식.
enum FormFieldType { text, textarea, number, date, segmented, readonly }

class FormFieldOption {
  const FormFieldOption({required this.value, required this.label});
  final String value;
  final L10nText label;
}

/// 서식 필드 한 개. tag는 FillTag(auto/raw/blank)를 그대로 재사용한다 —
/// auto는 이 앱에 실제 데이터가 있는 값에만 붙이고(예: 계산기에 입력된 입사일),
/// 나머지는 blank(직접입력)로 정직하게 표기한다.
class FormFieldSpec {
  const FormFieldSpec({
    required this.key,
    required this.label,
    required this.type,
    required this.tag,
    this.placeholder,
    this.options = const [],
    this.hint,
  });

  final String key;
  final L10nText label;
  final FormFieldType type;
  final FillTag tag;
  final L10nText? placeholder;

  /// FormFieldType.segmented 전용 — 선택지 목록.
  final List<FormFieldOption> options;

  /// 참고용 힌트(예: "계산기 결과 342,000원") — 값을 자동으로 채우지 않고
  /// 사용자가 직접 입력하도록 보여주기만 한다.
  final L10nText? hint;
}

class FormSection {
  const FormSection({required this.title, required this.fields});
  final L10nText title;
  final List<FormFieldSpec> fields;
}
