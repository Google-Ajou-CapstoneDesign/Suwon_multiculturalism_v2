import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';

/// 서버의 관련도 순서를 유지해 상위 두 기관을 나란히 표시한다.
class RecommendedOrgCard extends StatelessWidget {
  const RecommendedOrgCard({
    super.key,
    required this.orgs,
    required this.language,
  });

  final List<Org> orgs;
  final AppLanguage language;

  static const _title = L10nText(
    ko: '추천 기관',
    en: 'Recommended organizations',
    tr: "Önerilen kuruluşlar",
    tg: "Ташкилотҳои тавсияшуда",
    fil: "Mga Inirerekomendang Organisasyon",
    ur: "تجویز کردہ تنظیمیں",
    th: "องค์กรที่แนะนำ",
    ky: "Сунушталган уюмдар",
    km: "អង្គការដែលបានណែនាំ",
    id: "Organisasi yang direkomendasikan",
    si: "නිර්දේශිත සංවිධාන",
    bn: "প্রস্তাবিত সংস্থাগুলি",
    my: "အကြံပြုထားသော အဖွဲ့အစည်းများ",
    mn: "Санал болгож буй байгууллагууд",
    lo: "ອົງການທີ່ແນະນຳ",
    tet: "Organizasaun sira ne’ebé rekomenda",
    ne: "सिफारिस गरिएका संस्थाहरू",
    zh: '推荐机构',
    vi: 'Cơ quan được đề xuất',
    uz: 'Tavsiya etilgan tashkilotlar',
  );
  static const _address = L10nText(
    ko: '주소',
    en: 'Address',
    tr: "Adres",
    tg: "Суроға",
    fil: "Address",
    ur: "پتہ",
    th: "ที่อยู่",
    ky: "Дарек",
    km: "អាសយដ្ឋាន",
    id: "Alamat",
    si: "ලිපිනය",
    bn: "ঠিকানা",
    my: "လိပ်စာ",
    mn: "Хаяг",
    lo: "ທີ່ຢູ່",
    tet: "Adresu",
    ne: "ठेगाना",
    zh: '地址',
    vi: 'Địa chỉ',
    uz: 'Manzil',
  );
  static const _phone = L10nText(
    ko: '전화번호',
    en: 'Phone',
    tr: "Telefon",
    tg: "Телефон",
    fil: "Telepono",
    ur: "فون",
    th: "โทรศัพท์",
    ky: "Телефон",
    km: "ទូរស័ព្ទ",
    id: "Telepon",
    si: "දුරකථන",
    bn: "ফোন",
    my: "ဖုန်း",
    mn: "Утас",
    lo: "ເບີໂທລະສັບ",
    tet: "Telefone",
    ne: "फोन",
    zh: '电话',
    vi: 'Điện thoại',
    uz: 'Telefon',
  );
  static const _hours = L10nText(
    ko: '이용가능시간',
    en: 'Opening hours',
    tr: "Çalışma saatleri",
    tg: "Соатҳои корӣ",
    fil: "Mga Oras ng Operasyon",
    ur: "کام کے اوقات",
    th: "เวลาทำการ",
    ky: "Иштөө убактысы",
    km: "ម៉ោងធ្វើការ",
    id: "Jam kerja",
    si: "වැඩ කරන වේලාවන්",
    bn: "কাজের সময়",
    my: "ဖွင့်ချိန်",
    mn: "Ажлын цаг",
    lo: "ຊົ່ວໂມງເຮັດວຽກ",
    tet: "Oras servisu",
    ne: "कार्य घण्टा",
    zh: '开放时间',
    vi: 'Giờ hoạt động',
    uz: 'Ish vaqti',
  );
  static const _distance = L10nText(
    ko: '거리',
    en: 'Distance',
    tr: "Mesafe",
    tg: "Масофа",
    fil: "Distansya",
    ur: "فاصلہ",
    th: "ระยะทาง",
    ky: "Аралык",
    km: "ចម្ងាយ",
    id: "Jarak",
    si: "දුර",
    bn: "দূরত্ব",
    my: "အကွာအဝေး",
    mn: "Зай",
    lo: "ໄລຍະທາງ",
    tet: "Distánsia",
    ne: "दूरी",
    zh: '距离',
    vi: 'Khoảng cách',
    uz: 'Masofa',
  );
  static const _unknown = L10nText(
    ko: '정보 없음',
    en: 'Not available',
    tr: "Mevcut değil",
    tg: "Дастрас нест",
    fil: "Hindi magagamit",
    ur: "دستیاب نہیں",
    th: "ไม่พร้อมใช้งาน",
    ky: "Жок",
    km: "មិនមាន",
    id: "Tidak tersedia",
    si: "නොමැත",
    bn: "উপলব্ধ নেই",
    my: "မရရှိနိုင်ပါ",
    mn: "Боломжгүй",
    lo: "ບໍ່ມີ",
    tet: "La iha",
    ne: "उपलब्ध छैन",
    zh: '暂无信息',
    vi: 'Chưa có thông tin',
    uz: 'Maʼlumot yoʻq',
  );
  static const _distanceUnavailable = L10nText(
    ko: '거리 정보 없음',
    en: 'Distance unavailable',
    tr: "Mesafe mevcut değil",
    tg: "Масофа дастрас нест",
    fil: "Hindi magagamit ang distansya",
    ur: "فاصلہ دستیاب نہیں",
    th: "ไม่สามารถระบุระยะทางได้",
    ky: "Аралык жок",
    km: "មិនមានចម្ងាយ",
    id: "Jarak tidak tersedia",
    si: "දුර නොමැත",
    bn: "দূরত্ব উপলব্ধ নেই",
    my: "အကွာအဝေး မရရှိနိုင်ပါ",
    mn: "Зай боломжгүй",
    lo: "ບໍ່ມີໄລຍະທາງ",
    tet: "Distánsia la iha",
    ne: "दूरी उपलब्ध छैन",
    zh: '无距离信息',
    vi: 'Không có khoảng cách',
    uz: "Masofa mavjud emas",
  );

  String _distanceLabel(Org org) {
    final distance = org.distanceKm;
    if (distance == null) return _distanceUnavailable.of(language);
    if (distance < 0.1) return '<0.1km';
    return '${distance.toStringAsFixed(1)}km';
  }

  @override
  Widget build(BuildContext context) {
    if (orgs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title.of(language),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final selected = orgs.take(2).toList();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < selected.length; index++) ...[
                    if (index > 0) const SizedBox(width: 12),
                    Expanded(child: _orgTile(selected[index], index + 1)),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _orgTile(Org org, int rank) => Container(
    key: ValueKey('recommended-org-$rank'),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.blueBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$rank. ${org.name}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _detail(Icons.location_on_outlined, _address, org.address),
        _detail(Icons.phone_outlined, _phone, org.phoneNumber),
        _detail(Icons.schedule, _hours, org.businessHours),
        _detail(Icons.near_me_outlined, _distance, _distanceLabel(org)),
      ],
    ),
  );

  Widget _detail(IconData icon, L10nText label, String? value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.of(language),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value == null || value.trim().isEmpty
                    ? _unknown.of(language)
                    : value,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
