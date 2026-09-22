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
    name: L10nText(
      ko: '필리핀',
      en: 'Philippines',
      tr: "Filipinler",
      zh: '菲律宾',
      vi: 'Philippines',
      uz: "Filippin",
    ),
  ),
  Country(
    code: 'MN',
    name: L10nText(
      ko: '몽골',
      en: 'Mongolia',
      tr: "Moğolistan",
      zh: '蒙古',
      vi: 'Mông Cổ',
      uz: "Moʻgʻuliston",
    ),
  ),
  Country(
    code: 'LK',
    name: L10nText(
      ko: '스리랑카',
      en: 'Sri Lanka',
      tr: "Sri Lanka",
      zh: '斯里兰卡',
      vi: 'Sri Lanka',
      uz: "Shri-Lanka",
    ),
  ),
  Country(
    code: 'VN',
    name: L10nText(
      ko: '베트남',
      en: 'Vietnam',
      tr: "Vietnam",
      zh: '越南',
      vi: 'Việt Nam',
      uz: "Vyetnam",
    ),
  ),
  Country(
    code: 'TH',
    name: L10nText(
      ko: '태국',
      en: 'Thailand',
      tr: "Tayland",
      zh: '泰国',
      vi: 'Thái Lan',
      uz: "Tailand",
    ),
  ),
  Country(
    code: 'ID',
    name: L10nText(
      ko: '인도네시아',
      en: 'Indonesia',
      tr: "Endonezya",
      zh: '印度尼西亚',
      vi: 'Indonesia',
      uz: "Indoneziya",
    ),
  ),
  Country(
    code: 'UZ',
    name: L10nText(
      ko: '우즈베키스탄',
      en: 'Uzbekistan',
      tr: "Özbekistan",
      zh: '乌兹别克斯坦',
      vi: 'Uzbekistan',
      uz: "Oʻzbekiston",
    ),
  ),
  Country(
    code: 'PK',
    name: L10nText(
      ko: '파키스탄',
      en: 'Pakistan',
      tr: "Pakistan",
      zh: '巴基斯坦',
      vi: 'Pakistan',
      uz: "Pokiston",
    ),
  ),
  Country(
    code: 'KH',
    name: L10nText(
      ko: '캄보디아',
      en: 'Cambodia',
      tr: "Kamboçya",
      zh: '柬埔寨',
      vi: 'Campuchia',
      uz: "Kambodja",
    ),
  ),
  Country(
    code: 'BD',
    name: L10nText(
      ko: '방글라데시',
      en: 'Bangladesh',
      tr: "Bangladeş",
      zh: '孟加拉国',
      vi: 'Bangladesh',
      uz: "Bangladesh",
    ),
  ),
  Country(
    code: 'NP',
    name: L10nText(
      ko: '네팔',
      en: 'Nepal',
      tr: "Nepal",
      zh: '尼泊尔',
      vi: 'Nepal',
      uz: "Nepal",
    ),
  ),
  Country(
    code: 'MM',
    name: L10nText(
      ko: '미얀마',
      en: 'Myanmar',
      tr: "Myanmar",
      zh: '缅甸',
      vi: 'Myanmar',
      uz: "Myanma",
    ),
  ),
  Country(
    code: 'KG',
    name: L10nText(
      ko: '키르기스스탄',
      en: 'Kyrgyzstan',
      tr: "Kırgızistan",
      zh: '吉尔吉斯斯坦',
      vi: 'Kyrgyzstan',
      uz: "Qirgʻiziston",
    ),
  ),
  Country(
    code: 'TL',
    name: L10nText(
      ko: '동티모르',
      en: 'Timor-Leste',
      tr: "Doğu Timor",
      zh: '东帝汶',
      vi: 'Đông Timor',
      uz: "Sharqiy Timor",
    ),
  ),
  Country(
    code: 'LA',
    name: L10nText(
      ko: '라오스',
      en: 'Laos',
      tr: "Laos",
      zh: '老挝',
      vi: 'Lào',
      uz: "Laos",
    ),
  ),
  Country(
    code: 'PG',
    name: L10nText(
      ko: '파푸아뉴기니',
      en: 'Papua New Guinea',
      tr: "Papua Yeni Gine",
      zh: '巴布亚新几内亚',
      vi: 'Papua New Guinea',
      uz: "Papua Yangi Gvineyasi",
    ),
  ),
  // --- 그 외 자주 나오는 국적(유학·특정활동·방문취업 등) ---
  Country(
    code: 'CN',
    name: L10nText(
      ko: '중국',
      en: 'China',
      tr: "Çin",
      zh: '中国',
      vi: 'Trung Quốc',
      uz: "Xitoy",
    ),
  ),
  Country(
    code: 'TW',
    name: L10nText(
      ko: '대만',
      en: 'Taiwan',
      tr: "Tayvan",
      zh: '台湾',
      vi: 'Đài Loan',
      uz: "Tayvan",
    ),
  ),
  Country(
    code: 'JP',
    name: L10nText(
      ko: '일본',
      en: 'Japan',
      tr: "Japonya",
      zh: '日本',
      vi: 'Nhật Bản',
      uz: "Yaponiya",
    ),
  ),
  Country(
    code: 'IN',
    name: L10nText(
      ko: '인도',
      en: 'India',
      tr: "Hindistan",
      zh: '印度',
      vi: 'Ấn Độ',
      uz: "Hindiston",
    ),
  ),
  Country(
    code: 'KZ',
    name: L10nText(
      ko: '카자흐스탄',
      en: 'Kazakhstan',
      tr: "Kazakistan",
      zh: '哈萨克斯坦',
      vi: 'Kazakhstan',
      uz: "Qozogʻiston",
    ),
  ),
  Country(
    code: 'RU',
    name: L10nText(
      ko: '러시아',
      en: 'Russia',
      tr: "Rusya",
      zh: '俄罗斯',
      vi: 'Nga',
      uz: "Rossiya",
    ),
  ),
  Country(
    code: 'US',
    name: L10nText(
      ko: '미국',
      en: 'United States',
      tr: "Amerika Birleşik Devletleri",
      zh: '美国',
      vi: 'Hoa Kỳ',
      uz: "Amerika Qoʻshma Shtatlari",
    ),
  ),
  Country(
    code: 'CA',
    name: L10nText(
      ko: '캐나다',
      en: 'Canada',
      tr: "Kanada",
      zh: '加拿大',
      vi: 'Canada',
      uz: "Kanada",
    ),
  ),
  Country(
    code: 'AU',
    name: L10nText(
      ko: '호주',
      en: 'Australia',
      tr: "Avustralya",
      zh: '澳大利亚',
      vi: 'Úc',
      uz: "Avstraliya",
    ),
  ),
  Country(
    code: 'GB',
    name: L10nText(
      ko: '영국',
      en: 'United Kingdom',
      tr: "Birleşik Krallık",
      zh: '英国',
      vi: 'Anh',
      uz: "Birlashgan Qirollik",
    ),
  ),
  Country(
    code: 'FR',
    name: L10nText(
      ko: '프랑스',
      en: 'France',
      tr: "Fransa",
      zh: '法国',
      vi: 'Pháp',
      uz: "Fransiya",
    ),
  ),
  Country(
    code: 'DE',
    name: L10nText(
      ko: '독일',
      en: 'Germany',
      tr: "Almanya",
      zh: '德国',
      vi: 'Đức',
      uz: "Germaniya",
    ),
  ),
  // --- 목록에 없을 때 ---
  Country(
    code: 'ETC',
    name: L10nText(
      ko: '기타',
      en: 'Other',
      tr: "Diğer",
      zh: '其他',
      vi: 'Khác',
      uz: "Boshqa",
    ),
  ),
];
