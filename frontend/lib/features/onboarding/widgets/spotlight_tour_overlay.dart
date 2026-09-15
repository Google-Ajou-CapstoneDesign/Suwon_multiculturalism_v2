import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/app_tour_step.dart';

/// [SpotlightTourOverlay]의 진행 상태. MainShell이 하나 만들어 갖고 있다가
/// 앱 첫 실행 시 [start]를 한 번 호출한다.
class AppTourController extends ChangeNotifier {
  List<AppTourStep> _steps = const [];
  int _index = 0;
  bool _active = false;

  bool get active => _active;
  int get index => _index;
  int get stepCount => _steps.length;
  bool get isFirst => _index == 0;
  bool get isLast => _index >= _steps.length - 1;
  AppTourStep get currentStep => _steps[_index];

  void start(List<AppTourStep> steps) {
    if (steps.isEmpty) return;
    _steps = steps;
    _index = 0;
    _active = true;
    notifyListeners();
  }

  void next() {
    if (!_active) return;
    if (isLast) {
      stop();
    } else {
      _index++;
      notifyListeners();
    }
  }

  void prev() {
    if (!_active || isFirst) return;
    _index--;
    notifyListeners();
  }

  void stop() {
    if (!_active) return;
    _active = false;
    notifyListeners();
  }
}

class _S {
  _S._();

  static const skip = L10nText(
    ko: '가이드 종료',
    en: 'Skip guide',
    zh: '结束引导',
    vi: 'Bỏ qua hướng dẫn',
    uz: "Qoʻllanmani oʻtkazib yuborish",
  );
  static const next = L10nText(
    ko: '다음',
    en: 'Next',
    zh: '下一步',
    vi: 'Tiếp',
    uz: "Keyingi",
  );
  static const prev = L10nText(
    ko: '이전',
    en: 'Back',
    zh: '上一步',
    vi: 'Trước',
    uz: "Orqaga",
  );
  static const done = L10nText(
    ko: '시작하기',
    en: 'Got it',
    zh: '开始使用',
    vi: 'Bắt đầu',
    uz: "Tushundim",
  );
}

/// 앱 첫 실행 시 주요 화면 요소를 실제 위치에서 그대로 스포트라이트로 짚어가며
/// 소개하는 오버레이 — html_files/frontend_설명서.html의 코치마크 투어 형식을
/// 그대로 구현했다(딤 처리된 배경 + 대상만 뚫린 스포트라이트 홀 + 제목·본문·팁·
/// 단계 점·이전/다음 버튼을 담은 카드). [controller]가 비활성 상태면 아무 공간도
/// 차지하지 않는다(SizedBox.shrink) — 그래서 MainShell의 Scaffold 전체를 덮는
/// Stack의 맨 위에 항상 넣어둬도 평소엔 터치를 가로채지 않는다.
class SpotlightTourOverlay extends StatefulWidget {
  const SpotlightTourOverlay({super.key, required this.controller});

  final AppTourController controller;

  @override
  State<SpotlightTourOverlay> createState() => _SpotlightTourOverlayState();
}

class _SpotlightTourOverlayState extends State<SpotlightTourOverlay> {
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    if (widget.controller.active) _scheduleMeasure();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    // 활성/비활성 전환은 물론 같은 활성 상태에서 단계만 넘어갈 때도(next/prev)
    // 반드시 여기서 다시 빌드해야 한다 — 그래야 카드의 제목·본문이 새 단계
    // 내용으로 즉시 바뀐다. 위치(_targetRect)는 새 대상의 실제 크기를 알아야
    // 하니 프레임이 한 번 그려진 뒤 _measure()가 뒤늦게 갱신한다(그동안은
    // 이전 위치에 카드가 잠깐 떠 있다가 제자리로 애니메이션한다 — 어색하지 않다).
    setState(() {
      if (!widget.controller.active) _targetRect = null;
    });
    if (widget.controller.active) _scheduleMeasure();
  }

  void _scheduleMeasure() {
    // 탭 전환 등으로 대상 위젯이 막 빌드된 직후일 수 있으니 한 프레임 그려진
    // 뒤에 실제 렌더 박스 크기를 읽는다.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted || !widget.controller.active) return;
    final overlayObject = context.findRenderObject();
    final targetObject = widget.controller.currentStep.targetKey.currentContext
        ?.findRenderObject();
    if (overlayObject is! RenderBox ||
        targetObject is! RenderBox ||
        !overlayObject.attached ||
        !targetObject.attached) {
      setState(() => _targetRect = null);
      return;
    }
    final topLeft = overlayObject.globalToLocal(
      targetObject.localToGlobal(Offset.zero),
    );
    final rect = topLeft & targetObject.size;
    if (rect != _targetRect) setState(() => _targetRect = rect);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (!controller.active) return const SizedBox.shrink();

    final lang = UserProfileScope.of(context).language;
    final step = controller.currentStep;
    final screenSize = MediaQuery.sizeOf(context);
    final rect = _targetRect;
    // 대상이 화면 위쪽 절반에 있으면 카드는 아래쪽에, 아래쪽 절반(하단
    // 탭바·AI 버블 등)에 있으면 카드는 위쪽에 배치해 서로 가리지 않게 한다.
    final dockCardBelow =
        rect == null || rect.center.dy < screenSize.height / 2;

    // 호출부(MainShell)가 Positioned.fill로 감싸 쓰는 다른 오버레이들
    // (WorkLogSheet 등)과 같은 관례를 따른다 — 여기서 직접 Positioned를
    // 반환하지 않는다.
    return SizedBox.expand(
      child: Stack(
        children: [
          // 딤 처리된 배경 — 카드와 형제 관계로 둬서(카드를 감싸지 않음)
          // 카드 안 버튼 탭이 이 스크림의 onTap과 경합할 일 자체가 없게 한다.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // 배경을 눌러도 아무 일도 일어나지 않게만 막는다.
              child: IgnorePointer(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _SpotlightPainter(hole: rect),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            left: 18,
            right: 18,
            // dockCardBelow가 false면 rect==null이 아니었다는 뜻이라(위
            // 정의 참고) 이 분기에서는 rect가 항상 값이 있다.
            top: dockCardBelow
                ? (rect != null ? rect.bottom + 16 : null)
                : null,
            bottom: dockCardBelow ? null : screenSize.height - rect.top + 16,
            child: _CoachmarkCard(
              controller: controller,
              step: step,
              lang: lang,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({required this.hole});

  final Rect? hole;

  @override
  void paint(Canvas canvas, Size size) {
    final scrimPaint = Paint()..color = const Color(0xCC0F172A);
    final screen = Rect.fromLTWH(0, 0, size.width, size.height);

    if (hole == null) {
      canvas.drawRect(screen, scrimPaint);
      return;
    }

    final holeRect = hole!.inflate(6);
    final holeRRect = RRect.fromRectAndRadius(
      holeRect,
      const Radius.circular(18),
    );
    final scrimPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(screen),
      Path()..addRRect(holeRRect),
    );
    canvas.drawPath(scrimPath, scrimPaint);
    canvas.drawRRect(
      holeRRect,
      Paint()
        ..color = const Color(0xFF60A5FA)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole;
}

class _CoachmarkCard extends StatelessWidget {
  const _CoachmarkCard({
    required this.controller,
    required this.step,
    required this.lang,
  });

  final AppTourController controller;
  final AppTourStep step;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.index + 1} / ${controller.stepCount}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.stop,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _S.skip.of(lang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              step.title.of(lang),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              step.body.of(lang),
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            if (step.tip != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.blueBg,
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 3),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  '💡 ${step.tip!.of(lang)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1E3A8A),
                    height: 1.45,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            // 점 인디케이터를 버튼과 한 줄에 욱여넣으면(특히 5단계라 점이 많고
            // 카드 폭은 좁을 때) "다음" 버튼이 남는 폭만큼만 눌려서 잘려 보이는
            // 문제가 있었다 — 점은 위에 따로 두고, 버튼은 Expanded로 카드
            // 너비에 꽉 맞게 펼친다.
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(controller.stepCount, (i) {
                  final active = i == controller.index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!controller.isFirst) ...[
                  Expanded(
                    child: _PillButton(
                      label: _S.prev.of(lang),
                      onTap: controller.prev,
                      filled: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  flex: controller.isFirst ? 1 : 2,
                  child: _PillButton(
                    label: controller.isLast
                        ? _S.done.of(lang)
                        : _S.next.of(lang),
                    onTap: controller.next,
                    filled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: filled ? AppColors.primary : const Color(0xFFF1F5F9),
        foregroundColor: filled ? Colors.white : AppColors.textSecondary,
        // Expanded가 넘겨주는 너비를 그대로 채우도록 minimumSize를 무한대로
        // 열어둔다 — 그래야 부모가 준 폭만큼 버튼이 꽉 차고, 글자가 눌려
        // 잘려 보이지 않는다.
        minimumSize: const Size(double.infinity, 44),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
