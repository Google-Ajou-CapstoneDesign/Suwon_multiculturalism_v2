import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/app_language.dart';

/// Use Flutter's script shaping and bidi engine and embed lines at 216 dpi.
/// This supports Indic, Southeast Asian and Urdu text. Separate line
/// widgets let MultiPage paginate long text without splitting combining marks.
class ShapedPdfText {
  ShapedPdfText({this.language = AppLanguage.ne});

  final AppLanguage language;

  static bool needsShaping(String text) => RegExp(
    r'[\u0600-\u06ff\u0750-\u077f\u0900-\u09ff\u0d80-\u0dff\u0e00-\u0eff\u1000-\u109f\u1780-\u17ff\ua9e0-\ua9ff\uaa60-\uaa7f]',
  ).hasMatch(text);

  static const _scriptFonts = [
    'NotoSansDevanagari',
    'NotoSansLao',
    'NotoSansMyanmar',
    'NotoSansBengali',
    'NotoSansSinhala',
    'NotoSansKhmer',
    'NotoSansThai',
    'NotoSansArabic',
  ];
  static Future<void>? _fontsReady;
  final _cache = <(String, double, double), Future<List<pw.Widget>>>{};

  static Future<void> _loadFonts() async {
    for (final family in [
      ..._scriptFonts,
      'NotoSansKR',
      'NotoSansSC',
      'NotoSans',
    ]) {
      final loader = FontLoader(family);
      final asset = _scriptFonts.contains(family) ? '$family-400' : family;
      loader.addFont(rootBundle.load('assets/fonts/$asset.ttf'));
      await loader.load();
    }
  }

  Future<List<pw.Widget>> lines(
    String text, {
    required double width,
    double size = 10,
  }) => _cache.putIfAbsent((
    text,
    width,
    size,
  ), () => _renderLines(text, width: width, size: size));

  Future<List<pw.Widget>> _renderLines(
    String text, {
    required double width,
    double size = 10,
  }) async {
    await (_fontsReady ??= _loadFonts());
    final direction =
        language.isRtl ||
            RegExp(
              r'^[^A-Za-z\u00c0-\u052f\u0900-\u0fff\u1000-\u1fff\u3400-\u9fff\uac00-\ud7af]*[\u0600-\u06ff]',
            ).hasMatch(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
    final painter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? ' ' : text,
        style: TextStyle(
          fontFamily: language.fontFamily,
          fontFamilyFallback: const [
            'NotoSans',
            'NotoSansKR',
            'NotoSansSC',
            ..._scriptFonts,
          ],
          fontSize: size,
          color: const ui.Color(0xff1f2937),
          height: 1.4,
        ),
      ),
      textDirection: direction,
      textAlign: TextAlign.start,
    )..layout(minWidth: width, maxWidth: width);
    final widgets = <pw.Widget>[];
    try {
      for (final line in painter.computeLineMetrics()) {
        final boundary = painter.getLineBoundary(
          painter.getPositionForOffset(
            ui.Offset(
              direction == TextDirection.rtl ? width - 0.1 : 0,
              line.baseline,
            ),
          ),
        );
        final span = painter.text! as TextSpan;
        final lineText = span.text!
            .substring(boundary.start, boundary.end)
            .replaceAll('\n', '');
        // Paint just this line. Clipping a full paragraph can expose marks from
        // the previous/next line in the padding around Devanagari glyphs.
        final linePainter = TextPainter(
          text: TextSpan(
            text: lineText.isEmpty ? ' ' : lineText,
            style: span.style,
          ),
          textDirection: direction,
          textAlign: TextAlign.start,
        )..layout(minWidth: width, maxWidth: width);
        const padding = 2.0;
        final height = linePainter.height + padding * 2;
        final recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(recorder)..scale(3);
        canvas.clipRect(ui.Rect.fromLTWH(0, 0, width, height));
        linePainter.paint(canvas, const ui.Offset(0, padding));
        linePainter.dispose();
        final picture = recorder.endRecording();
        final image = await picture.toImage(
          math.max(1, (width * 3).ceil()),
          math.max(1, (height * 3).ceil()),
        );
        try {
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          if (data == null) {
            throw StateError('Unable to render shaped PDF text');
          }
          widgets.add(
            pw.Image(
              pw.MemoryImage(
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
              ),
              width: width,
              height: height,
            ),
          );
        } finally {
          image.dispose();
          picture.dispose();
        }
      }
    } finally {
      painter.dispose();
    }
    return widgets;
  }
}
