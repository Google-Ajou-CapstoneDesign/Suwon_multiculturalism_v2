import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/country.dart';

const _title = L10nText(
  ko: '국적 선택',
  en: 'Choose your nationality',
  tr: "Uyruğunuzu seçin",
  tg: "Миллати худро интихоб кунед",
  fil: "Piliin ang iyong nasyonalidad",
  ur: "اپنی قومیت منتخب کریں",
  th: "เลือกสัญชาติของคุณ",
  ky: "Улутуңузду тандаңыз",
  km: "ជ្រើសរើសសញ្ជាតិរបស់អ្នក។",
  id: "Pilih kebangsaan Anda",
  si: "ඔබගේ ජාතිකත්වය තෝරන්න",
  bn: "আপনার জাতীয়তা নির্বাচন করুন",
  my: "သင်၏ နိုင်ငံသားကို ရွေးချယ်ပါ",
  mn: "Иргэншлээ сонгоно уу",
  lo: "ເລືອກສັນຊາດຂອງທ່ານ",
  tet: "Hili Ita-nia nasaun",
  ne: "आफ्नो राष्ट्रियता छान्नुहोस्",
  zh: '选择国籍',
  vi: 'Chọn quốc tịch',
  uz: "Millatingizni tanlang",
);
const _searchHint = L10nText(
  ko: '국가 이름으로 검색',
  en: 'Search by country name',
  tr: "Ülke adına göre ara",
  tg: "Аз рӯи номи кишвар ҷустуҷӯ кунед",
  fil: "Maghanap ayon sa pangalan ng bansa",
  ur: "ملک کے نام سے تلاش کریں",
  th: "ค้นหาตามชื่อประเทศ",
  ky: "Өлкөнүн аты боюнча издөө",
  km: "ស្វែងរកតាមឈ្មោះប្រទេស",
  id: "Cari berdasarkan nama negara",
  si: "රටේ නම අනුව සොයන්න",
  bn: "দেশের নাম অনুসারে অনুসন্ধান করুন",
  my: "နိုင်ငံအမည်ဖြင့် ရှာဖွေပါ",
  mn: "Улсын нэрээр хайх",
  lo: "ຄົ້ນຫາຕາມຊື່ປະເທດ",
  tet: "Buka tuir naran nasaun",
  ne: "देशको नामबाट खोज्नुहोस्",
  zh: '按国家名称搜索',
  vi: 'Tìm theo tên quốc gia',
  uz: "Davlat nomi boʻyicha qidirish",
);

Future<void> showCountrySheet(
  BuildContext context, {
  required AppLanguage language,
  String? current,
  required ValueChanged<Country> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _CountrySheetBody(
            language: language,
            current: current,
            scrollController: scrollController,
            onSelect: (country) {
              onSelect(country);
              Navigator.of(context).pop();
            },
          );
        },
      );
    },
  );
}

class _CountrySheetBody extends StatefulWidget {
  const _CountrySheetBody({
    required this.language,
    required this.current,
    required this.scrollController,
    required this.onSelect,
  });

  final AppLanguage language;
  final String? current;
  final ScrollController scrollController;
  final ValueChanged<Country> onSelect;

  @override
  State<_CountrySheetBody> createState() => _CountrySheetBodyState();
}

class _CountrySheetBodyState extends State<_CountrySheetBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final lang = widget.language;
    final filtered = _query.isEmpty
        ? countries
        : countries
              .where(
                (c) => c.name
                    .of(lang)
                    .toLowerCase()
                    .contains(_query.toLowerCase()),
              )
              .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title.of(lang),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              hintText: _searchHint.of(lang),
              prefixIcon: const Icon(Icons.search, size: 18),
              filled: true,
              fillColor: const Color(0xFFFBFDFF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final country = filtered[i];
                final selected = country.code == widget.current;
                return InkWell(
                  onTap: () => widget.onSelect(country),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.blueBg : Colors.white,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            country.name.of(lang),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
