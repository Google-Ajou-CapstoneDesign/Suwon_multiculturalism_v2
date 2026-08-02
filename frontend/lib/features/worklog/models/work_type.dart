enum WorkType { manufacturing, serving, delivery, other }

enum IncidentType { normal, overtime, accident }

extension WorkTypeLabel on WorkType {
  String get label => switch (this) {
        WorkType.manufacturing => '제조',
        WorkType.serving => '서빙',
        WorkType.delivery => '배달',
        WorkType.other => '기타',
      };
}

extension IncidentTypeLabel on IncidentType {
  String get label => switch (this) {
        IncidentType.normal => '정상근무',
        IncidentType.overtime => '연장근무',
        IncidentType.accident => '사고·부상',
      };
}
