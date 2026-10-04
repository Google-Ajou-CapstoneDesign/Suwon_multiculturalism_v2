import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/app_language.dart';
import '../controllers/form_values_controller.dart';
import '../models/form_field_spec.dart';
import 'shaped_pdf_text.dart';

/// 언어별 폰트 파일 — 기본 PDF 내장 폰트엔 한글/중국어/베트남어 성조 글리프가 없어
/// 반드시 번들 폰트를 로드해야 한다. ko→Noto Sans KR, zh→Noto Sans SC,
/// en/vi/uz→Noto Sans(라틴 확장 및 우즈베크어 문자 지원).
String _fontAssetFor(AppLanguage lang) => switch (lang) {
  AppLanguage.ko => 'assets/fonts/NotoSansKR.ttf',
  AppLanguage.zh => 'assets/fonts/NotoSansSC.ttf',
  AppLanguage.ne => 'assets/fonts/NotoSansDevanagari-400.ttf',
  _ => 'assets/fonts/NotoSans.ttf',
};

final Map<String, pw.Font> _fontCache = {};

Future<pw.Font> _loadFont(String asset) async {
  final cached = _fontCache[asset];
  if (cached != null) return cached;
  final data = await rootBundle.load(asset);
  final font = pw.Font.ttf(data);
  _fontCache[asset] = font;
  return font;
}

String _displayValue(
  FormFieldSpec field,
  FormValuesController values,
  AppLanguage lang,
) {
  final raw = values.valueOf(field.key);
  if (raw.isEmpty) return '';
  if (field.type == FormFieldType.segmented) {
    final opt = field.options.where((o) => o.value == raw).firstOrNull;
    return opt?.label.of(lang) ?? raw;
  }
  return raw;
}

/// sections+values 하나로 다운로드용 PDF와 미리보기(PdfPreview)가 동일한 결과를
/// 그리도록 하는 단일 빌더. lang만 바꿔 "한국어 PDF"/"내 언어 PDF"를 만든다.
Future<Uint8List> buildComplaintPdf({
  required L10nText documentTitle,
  required List<FormSection> sections,
  required FormValuesController values,
  required AppLanguage lang,
  required PdfPageFormat format,
}) async {
  final hasShapedInput = sections.any(
    (section) => section.fields.any(
      (field) => ShapedPdfText.needsShaping(_displayValue(field, values, lang)),
    ),
  );
  if (lang.requiresPdfShaping || hasShapedInput) {
    return _buildShapedComplaintPdf(
      documentTitle: documentTitle,
      sections: sections,
      values: values,
      lang: lang,
      format: format,
    );
  }
  final font = await _loadFont(_fontAssetFor(lang));
  final fallbackFonts = await Future.wait([
    _loadFont('assets/fonts/NotoSans.ttf'),
    _loadFont('assets/fonts/NotoSansKR.ttf'),
    _loadFont('assets/fonts/NotoSansSC.ttf'),
  ]);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(
      base: font,
      bold: font,
      fontFallback: fallbackFonts,
    ),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => [
        pw.Text(
          documentTitle.of(lang),
          style: const pw.TextStyle(fontSize: 18),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          'Local Bridge · ${DateTime.now().toIso8601String().split('T').first}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 14),
        for (final section in sections) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            margin: const pw.EdgeInsets.only(top: 10, bottom: 2),
            color: PdfColors.grey200,
            child: pw.Text(
              section.title.of(lang),
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          for (final field in section.fields)
            _buildFieldRow(field, values, lang),
        ],
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            _disclaimer(lang),
            style: const pw.TextStyle(
              fontSize: 8.5,
              color: PdfColors.grey700,
              lineSpacing: 2,
            ),
          ),
        ),
      ],
    ),
  );

  return doc.save();
}

Future<Uint8List> _buildShapedComplaintPdf({
  required L10nText documentTitle,
  required List<FormSection> sections,
  required FormValuesController values,
  required AppLanguage lang,
  required PdfPageFormat format,
}) async {
  final renderer = ShapedPdfText(language: lang);
  final width = format.width - 56;
  final content = <pw.Widget>[
    ...await renderer.lines(documentTitle.of(lang), width: width, size: 18),
    ...await renderer.lines(
      'Local Bridge · ${DateTime.now().toIso8601String().split('T').first}',
      width: width,
      size: 9,
    ),
    pw.SizedBox(height: 14),
  ];
  for (final section in sections) {
    content.add(
      pw.Container(
        width: width,
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        margin: const pw.EdgeInsets.only(top: 10, bottom: 2),
        color: PdfColors.grey200,
        child: pw.Column(
          children: await renderer.lines(
            section.title.of(lang),
            width: width - 12,
            size: 11,
          ),
        ),
      ),
    );
    for (final field in section.fields) {
      final labels = await renderer.lines(
        field.label.of(lang),
        width: 130,
        size: 9.5,
      );
      final display = _displayValue(field, values, lang);
      final lines = display.isEmpty
          ? <pw.Widget>[
              pw.Container(
                height: 10,
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.7),
                  ),
                ),
              ),
            ]
          : await renderer.lines(display, width: width - 140);
      final count = labels.length > lines.length ? labels.length : lines.length;
      content.add(pw.SizedBox(height: 6));
      // Keep the same label/value columns and let long values span pages.
      for (var i = 0; i < count; i++) {
        content.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 130,
                child: i < labels.length ? labels[i] : pw.SizedBox(),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(child: i < lines.length ? lines[i] : pw.SizedBox()),
            ],
          ),
        );
      }
      content.add(pw.SizedBox(height: 6));
      content.add(
        pw.Divider(height: 0.5, thickness: 0.5, color: PdfColors.grey300),
      );
    }
  }
  content.add(pw.SizedBox(height: 16));
  content.add(
    pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: await renderer.lines(
          _disclaimer(lang),
          width: width - 20,
          size: 8.5,
        ),
      ),
    ),
  );
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(28),
      maxPages: 200,
      build: (_) => content,
    ),
  );
  return doc.save();
}

pw.Widget _buildFieldRow(
  FormFieldSpec field,
  FormValuesController values,
  AppLanguage lang,
) {
  final display = _displayValue(field, values, lang);
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 130,
          child: pw.Text(
            field.label.of(lang),
            style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey700),
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: display.isEmpty
              // 빈 칸은 안내 문구 대신 밑줄만 그어 실제 서류의 "직접 채우세요" 관례를 따른다.
              ? pw.Container(
                  height: 10,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey400,
                        width: 0.7,
                      ),
                    ),
                  ),
                )
              : pw.Text(display, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
}

String _disclaimer(AppLanguage lang) => switch (lang) {
  AppLanguage.ko =>
    '본 문서는 입력하신 사실관계를 양식에 옮긴 것이며, 법적 주장이나 판단을 포함하지 않습니다. 작성 내용에 대한 법적 책임은 이용자 본인에게 있습니다.',
  AppLanguage.uz =>
    "Ushbu hujjat siz kiritgan maʼlumotlarni shaklga oʻtkazadi va hech qanday huquqiy dalil yoki hukm oʻz ichiga olmaydi. Kiritgan maʼlumotlaringiz uchun siz javobgarsiz.",
  AppLanguage.en =>
    'This document transfers the facts you entered into the form and contains no legal argument or judgement. You are responsible for the content you enter.',
  AppLanguage.tr =>
    "Bu belge, forma girdiğiniz bilgileri aktarır ve herhangi bir hukuki argüman veya yargı içermez. Girdiğiniz içerikten siz sorumlusunuz.",
  AppLanguage.tg =>
    "Ин ҳуҷҷат маълумотеро, ки шумо ба варақа ворид кардаед, интиқол медиҳад ва ҳеҷ гуна далели ҳуқуқӣ ё ҳукмро дар бар намегирад. Шумо барои мундариҷаи воридкардаи худ масъул ҳастед.",
  AppLanguage.fil =>
    "Ang dokumentong ito ay naglilipat ng impormasyong inilagay mo sa form at hindi naglalaman ng anumang legal na argumento o paghatol. Ikaw ang responsable para sa nilalamang inilagay mo.",
  AppLanguage.ur =>
    "یہ دستاویز آپ کی طرف سے فارم میں درج کردہ معلومات کو منتقل کرتی ہے اور اس میں کوئی قانونی دلیل یا فیصلہ شامل نہیں ہے۔ آپ درج کردہ مواد کے ذمہ دار ہیں۔",
  AppLanguage.th =>
    "เอกสารนี้จะส่งข้อมูลที่คุณป้อนในแบบฟอร์ม และไม่มีข้อโต้แย้งทางกฎหมายหรือการตัดสินใดๆ คุณเป็นผู้รับผิดชอบเนื้อหาที่คุณป้อน",
  AppLanguage.ky =>
    "Бул документ сиз формага киргизген маалыматты өткөрүп берет жана эч кандай юридикалык аргументтерди же сот чечимдерин камтыбайт. Киргизген мазмунуңуз үчүн сиз жооптуусуз.",
  AppLanguage.km =>
    "ឯកសារនេះបញ្ជូនព័ត៌មានដែលអ្នកបានបញ្ចូលទៅក្នុងទម្រង់ ហើយមិនមានអំណះអំណាងផ្លូវច្បាប់ ឬការវិនិច្ឆ័យណាមួយឡើយ។ អ្នកទទួលខុសត្រូវចំពោះខ្លឹមសារដែលអ្នកបានបញ្ចូល។",
  AppLanguage.id =>
    "Dokumen ini menyampaikan informasi yang Anda masukkan ke dalam formulir dan tidak mengandung argumen hukum atau penilaian apa pun. Anda bertanggung jawab atas konten yang Anda masukkan.",
  AppLanguage.si =>
    "මෙම ලේඛනය ඔබ පෝරමයට ඇතුළත් කළ තොරතුරු සම්ප්‍රේෂණය කරන අතර කිසිදු නීතිමය තර්කයක් හෝ විනිශ්චයක් අඩංගු නොවේ. ඔබ ඇතුළත් කළ අන්තර්ගතය සඳහා ඔබ වගකිව යුතුය.",
  AppLanguage.bn =>
    "এই নথিটি আপনার ফর্মে প্রবেশ করা তথ্য স্থানান্তর করে এবং এতে কোনো আইনি যুক্তি বা বিচার অন্তর্ভুক্ত নয়। আপনি প্রবেশ করা বিষয়বস্তুর জন্য দায়ী।",
  AppLanguage.my =>
    "ဤစာရွက်စာတမ်းသည် သင်ပုံစံတွင် ထည့်သွင်းထားသော အချက်အလက်များကို ထုတ်လွှင့်ပေးပြီး မည်သည့်တရားရေးဆိုင်ရာ အငြင်းပွားမှု သို့မဟုတ် စီရင်ချက်မျှ မပါဝင်ပါ။ သင်ထည့်သွင်းထားသော အကြောင်းအရာအတွက် သင်ကိုယ်တိုင် တာဝန်ရှိပါသည်။",
  AppLanguage.mn =>
    "Энэхүү баримт бичиг нь таны маягтад оруулсан мэдээллийг дамжуулах бөгөөд хууль эрх зүйн маргаан эсвэл дүгнэлт агуулаагүй болно. Та оруулсан агуулгынхаа төлөө хариуцлага хүлээнэ.",
  AppLanguage.lo =>
    "ເອກະສານນີ້ຖ່າຍທອດຂໍ້ມູນທີ່ທ່ານປ້ອນເຂົ້າໃນແບບຟອມ ແລະ ບໍ່ມີການໂຕ້ຖຽງທາງກົດໝາຍ ຫຼື ການຕັດສິນໃດໆ. ທ່ານເປັນຜູ້ຮັບຜິດຊອບຕໍ່ເນື້ອໃນທີ່ທ່ານປ້ອນເຂົ້າ.",
  AppLanguage.tet =>
    "Dokumentu ne'e transmite informasaun ne'ebé imi hatama iha formuláriu no la inklui argumentu legál ka julgamentu ida. Imi mak responsável ba konteúdu ne'ebé imi hatama.",
  AppLanguage.ne =>
    "यो कागजातले तपाईंले फारममा प्रविष्ट गर्नुभएको जानकारीलाई हस्तान्तरण गर्दछ र यसमा कुनै कानुनी तर्क वा निर्णय समावेश छैन। तपाईंले प्रविष्ट गर्नुभएको सामग्रीको लागि तपाईं जिम्मेवार हुनुहुन्छ।",
  AppLanguage.zh => '本文件仅将您填写的事实转录至表格，不含法律主张或判断。填写内容的法律责任由使用者本人承担。',
  AppLanguage.vi =>
    'Tài liệu này chỉ chuyển các sự việc bạn nhập vào mẫu, không chứa lập luận hay phán đoán pháp lý. Bạn chịu trách nhiệm về nội dung đã nhập.',
};
