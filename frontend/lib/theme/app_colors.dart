import 'package:flutter/material.dart';

/// design_files/App_Design.html의 :root 팔레트를 그대로 옮긴 것 — 상수 이름은
/// 기존 그대로 유지해 화면 코드(42개 파일)를 건드리지 않고 값만 새 디자인으로
/// 바꾼다.
class AppColors {
  AppColors._();

  // Blue palette — 시안의 --blue/--blue-dark를 tier 이름에 맞춰 옮겼다.
  static const blue50 = Color(0xFFEDF4FF); // --pale
  static const blue200 = Color(0xFFB9D2FB); // 시안엔 없는 중간톤(보더/아웃라인용)
  static const blue500 = Color(0xFF1665EC); // --blue
  static const blue900 = Color(0xFF104FC2); // --blue-dark

  // Green palette — 시안의 --green을 옮겼다.
  static const green50 = Color(0xFFE8F7F2);
  static const green200 = Color(0xFF7FCBB4);
  static const green500 = Color(0xFF12856D); // --green
  static const green900 = Color(0xFF0D6350);

  static const primary = blue500;
  static const secondary = green500;

  /// 별표·진행중 표시 등 강조용 — primary와 구분되도록 --blue-dark를 쓴다.
  static const accent = blue900;

  /// 화면 전체 배경 — 시안의 --bg(연한 회청색). 카드/배너 배경(blueBg=--pale)과는
  /// 다른 톤이다 — 예전엔 둘이 같은 값(blue50)이었지만 시안은 구분한다.
  static const background = Color(0xFFF4F7FB); // --bg
  static const navy = Color(0xFF162B4D); // --navy

  // 본문 텍스트 — 시안은 --text/--muted 2단계뿐이라, textSecondary는 그 사이 톤.
  static const textPrimary = Color(0xFF202B3E); // --text
  static const textSecondary = Color(0xFF4B5A72);
  static const textMuted = Color(0xFF738098); // --muted

  /// 카드·칩·탭바 등 전반에 쓰이는 옅은 보더 — 시안의 --line.
  static const border = line;

  // 안내/경고 배너 — 시안엔 별도 톤(주황 태그)이 있어 이 색으로 맞춘다.
  // (기존 값은 파란색이었는데 주석은 "amber"라고 돼 있던 불일치를 여기서 바로잡는다.)
  static const noticeBg = orangeBg;
  static const noticeBorder = Color(0xFFF4C892);
  static const noticeText = orangeFg;

  static const blueBg = pale;
  static const blueBorder = blue200;

  // ---- 시안 컴포넌트 스펙 반영용 신규 토큰 ----
  static const line = Color(0xFFE8EDF4);
  static const pale = Color(0xFFEDF4FF);
  static const orange = Color(0xFFE98626);
  static const orangeBg = Color(0xFFFFF4E8);
  static const orangeFg = Color(0xFFA65B15);
  static const greenBg = green50;
  static const greenFg = Color(0xFF179A85);
  static const purpleBg = Color(0xFFF0ECFF);
  static const purpleFg = Color(0xFF8461CC);

  /// 카드 공통 반경 — 시안 --radius(22px)의 모바일 브레이크포인트 값(19px).
  /// 이 앱은 항상 모바일 폭이라 모바일 값을 기본으로 쓴다.
  static const cardRadius = 19.0;

  /// 카드 공통 그림자 — 시안 --shadow: 0 6px 26px #18376707.
  static const cardShadow = [
    BoxShadow(color: Color(0x07183767), blurRadius: 26, offset: Offset(0, 6)),
  ];
}
