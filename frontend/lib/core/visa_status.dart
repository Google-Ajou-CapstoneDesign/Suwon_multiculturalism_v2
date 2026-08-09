/// 온보딩에서 고르는 체류자격(비자). MVP 대표 4개로 한정한다.
enum VisaStatus {
  d2('D-2', '유학'),
  e9('E-9', '비전문취업'),
  e7('E-7', '특정활동'),
  h2('H-2', '방문취업');

  const VisaStatus(this.code, this.label);

  final String code;
  final String label;

  String get fullLabel => '$code · $label';
}
