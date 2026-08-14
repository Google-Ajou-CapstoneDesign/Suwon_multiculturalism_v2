import '../../../core/app_language.dart';

/// 회원가입 국적 선택 목록. 고용허가제(EPS) 16개 협약국을 상단에 두고, 그 외
/// 유학·특정활동·방문취업 비자에서 자주 나오는 국적을 이어 붙였다 — 전체
/// ISO 국가 목록(약 200개)을 다 넣는 대신, 이 앱의 실제 이용자층에 맞춰 범위를
/// 좁혔다. 목록에 없으면 "기타"를 고르면 된다.
class Country {
  const Country({required this.code, required this.name});

  /// ISO 3166-1 alpha-2 코드.
  final String code;
  final L10nText name;
}

const countries = <Country>[
  // --- 고용허가제(EPS) 16개 협약국 ---
  Country(
    code: 'PH',
    name: L10nText(ko: '필리핀', en: 'Philippines', zh: '菲律宾', vi: 'Philippines'),
  ),
  Country(
    code: 'MN',
    name: L10nText(ko: '몽골', en: 'Mongolia', zh: '蒙古', vi: 'Mông Cổ'),
  ),
  Country(
    code: 'LK',
    name: L10nText(ko: '스리랑카', en: 'Sri Lanka', zh: '斯里兰卡', vi: 'Sri Lanka'),
  ),
  Country(
    code: 'VN',
    name: L10nText(ko: '베트남', en: 'Vietnam', zh: '越南', vi: 'Việt Nam'),
  ),
  Country(
    code: 'TH',
    name: L10nText(ko: '태국', en: 'Thailand', zh: '泰国', vi: 'Thái Lan'),
  ),
  Country(
    code: 'ID',
    name: L10nText(ko: '인도네시아', en: 'Indonesia', zh: '印度尼西亚', vi: 'Indonesia'),
  ),
  Country(
    code: 'UZ',
    name: L10nText(
      ko: '우즈베키스탄',
      en: 'Uzbekistan',
      zh: '乌兹别克斯坦',
      vi: 'Uzbekistan',
    ),
  ),
  Country(
    code: 'PK',
    name: L10nText(ko: '파키스탄', en: 'Pakistan', zh: '巴基斯坦', vi: 'Pakistan'),
  ),
  Country(
    code: 'KH',
    name: L10nText(ko: '캄보디아', en: 'Cambodia', zh: '柬埔寨', vi: 'Campuchia'),
  ),
  Country(
    code: 'BD',
    name: L10nText(ko: '방글라데시', en: 'Bangladesh', zh: '孟加拉国', vi: 'Bangladesh'),
  ),
  Country(
    code: 'NP',
    name: L10nText(ko: '네팔', en: 'Nepal', zh: '尼泊尔', vi: 'Nepal'),
  ),
  Country(
    code: 'MM',
    name: L10nText(ko: '미얀마', en: 'Myanmar', zh: '缅甸', vi: 'Myanmar'),
  ),
  Country(
    code: 'KG',
    name: L10nText(
      ko: '키르기스스탄',
      en: 'Kyrgyzstan',
      zh: '吉尔吉斯斯坦',
      vi: 'Kyrgyzstan',
    ),
  ),
  Country(
    code: 'TL',
    name: L10nText(ko: '동티모르', en: 'Timor-Leste', zh: '东帝汶', vi: 'Đông Timor'),
  ),
  Country(
    code: 'LA',
    name: L10nText(ko: '라오스', en: 'Laos', zh: '老挝', vi: 'Lào'),
  ),
  Country(
    code: 'PG',
    name: L10nText(
      ko: '파푸아뉴기니',
      en: 'Papua New Guinea',
      zh: '巴布亚新几内亚',
      vi: 'Papua New Guinea',
    ),
  ),
  // --- 그 외 자주 나오는 국적(유학·특정활동·방문취업 등) ---
  Country(
    code: 'CN',
    name: L10nText(ko: '중국', en: 'China', zh: '中国', vi: 'Trung Quốc'),
  ),
  Country(
    code: 'TW',
    name: L10nText(ko: '대만', en: 'Taiwan', zh: '台湾', vi: 'Đài Loan'),
  ),
  Country(
    code: 'JP',
    name: L10nText(ko: '일본', en: 'Japan', zh: '日本', vi: 'Nhật Bản'),
  ),
  Country(
    code: 'IN',
    name: L10nText(ko: '인도', en: 'India', zh: '印度', vi: 'Ấn Độ'),
  ),
  Country(
    code: 'KZ',
    name: L10nText(
      ko: '카자흐스탄',
      en: 'Kazakhstan',
      zh: '哈萨克斯坦',
      vi: 'Kazakhstan',
    ),
  ),
  Country(
    code: 'RU',
    name: L10nText(ko: '러시아', en: 'Russia', zh: '俄罗斯', vi: 'Nga'),
  ),
  Country(
    code: 'US',
    name: L10nText(ko: '미국', en: 'United States', zh: '美国', vi: 'Hoa Kỳ'),
  ),
  Country(
    code: 'CA',
    name: L10nText(ko: '캐나다', en: 'Canada', zh: '加拿大', vi: 'Canada'),
  ),
  Country(
    code: 'AU',
    name: L10nText(ko: '호주', en: 'Australia', zh: '澳大利亚', vi: 'Úc'),
  ),
  Country(
    code: 'GB',
    name: L10nText(ko: '영국', en: 'United Kingdom', zh: '英国', vi: 'Anh'),
  ),
  Country(
    code: 'FR',
    name: L10nText(ko: '프랑스', en: 'France', zh: '法国', vi: 'Pháp'),
  ),
  Country(
    code: 'DE',
    name: L10nText(ko: '독일', en: 'Germany', zh: '德国', vi: 'Đức'),
  ),
  // --- 목록에 없을 때 ---
  Country(
    code: 'ETC',
    name: L10nText(ko: '기타', en: 'Other', zh: '其他', vi: 'Khác'),
  ),
];
