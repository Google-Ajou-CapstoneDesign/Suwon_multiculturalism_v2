import 'package:flutter/material.dart';
import '../features/ai_guide/widgets/ai_chat_sheet.dart';
import '../features/encyclopedia/screens/encyclopedia_home_screen.dart';
import '../features/settings/screens/settings_home_screen.dart';
import '../features/wage_calculator/screens/wage_calculator_screen.dart';
import '../features/worklog/screens/accident_navigator_screen.dart';
import '../features/worklog/screens/wage_navigator_screen.dart';
import '../features/worklog/widgets/work_log_sheet.dart';
import '../theme/app_colors.dart';

/// 하단 탭 셸. 백과사전 · 임금계산기 · 설정 3개는 각자 Navigator를 가진 일반 탭이다.
/// 가운데 "오늘"(캘린더)은 근무기록장 시트를, "내비게이터"는 임금체불/산재 두
/// 갈래로 갈라지는 작은 팝업 패널을 띄운다 — 전부 하단 탭바를 가리지 않는
/// 오버레이 방식이다(프론트엔드_구상_확장.html의 설계 의도).
/// AI 가이드는 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

enum _NavAction { page, worklogToggle, navigatorPanel }

class _TabSpec {
  const _TabSpec({required this.label, this.icon, this.activeIcon, required this.action, this.pageIndex});
  final String label;
  final IconData? icon;
  final IconData? activeIcon;
  final _NavAction action;

  /// action == page 일 때만 사용 — _rootScreens/_navigatorKeys 인덱스.
  final int? pageIndex;
}

class _MainShellState extends State<MainShell> {
  int _activeIndex = 0;
  bool _worklogOpen = false;
  bool _aiChatOpen = false;
  bool _navPanelOpen = false;

  final _tabs = const [
    _TabSpec(label: '백과사전', icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, action: _NavAction.page, pageIndex: 0),
    _TabSpec(label: '임금계산기', icon: Icons.calculate_outlined, activeIcon: Icons.calculate, action: _NavAction.page, pageIndex: 1),
    _TabSpec(label: '오늘', action: _NavAction.worklogToggle),
    _TabSpec(label: '내비게이터', icon: Icons.explore_outlined, activeIcon: Icons.explore, action: _NavAction.navigatorPanel),
    _TabSpec(label: '설정', icon: Icons.settings_outlined, activeIcon: Icons.settings, action: _NavAction.page, pageIndex: 2),
  ];

  final _navigatorKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  static const _rootScreens = [
    EncyclopediaHomeScreen(),
    WageCalculatorScreen(),
    SettingsHomeScreen(),
  ];

  bool get _anyOverlayOpen => _worklogOpen || _aiChatOpen || _navPanelOpen;

  void _closeAllOverlays() {
    _worklogOpen = false;
    _aiChatOpen = false;
    _navPanelOpen = false;
  }

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];

    if (tab.action == _NavAction.worklogToggle) {
      final opening = !_worklogOpen;
      setState(() {
        _closeAllOverlays();
        _worklogOpen = opening;
      });
      return;
    }

    if (tab.action == _NavAction.navigatorPanel) {
      final opening = !_navPanelOpen;
      setState(() {
        _closeAllOverlays();
        _navPanelOpen = opening;
      });
      return;
    }

    final pageIndex = tab.pageIndex!;
    if (pageIndex == _activeIndex && !_anyOverlayOpen) {
      // 같은 탭을 다시 누르면 해당 탭의 첫 화면으로 되돌아간다.
      _navigatorKeys[pageIndex].currentState?.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      _closeAllOverlays();
      _activeIndex = pageIndex;
    });
  }

  void _toggleAiChat() {
    final opening = !_aiChatOpen;
    setState(() {
      _closeAllOverlays();
      _aiChatOpen = opening;
    });
  }

  void _openWageFlow() {
    setState(() => _navPanelOpen = false);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen()));
  }

  void _openInjuryFlow() {
    setState(() => _navPanelOpen = false);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final naviTabIndex = _tabs.indexWhere((t) => t.action == _NavAction.navigatorPanel);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_navPanelOpen) {
          setState(() => _navPanelOpen = false);
          return;
        }
        if (_aiChatOpen) {
          setState(() => _aiChatOpen = false);
          return;
        }
        if (_worklogOpen) {
          setState(() => _worklogOpen = false);
          return;
        }
        final navigator = _navigatorKeys[_activeIndex].currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            // WebCenteredFrame이 웹/데스크톱 넓은 화면에서 내용을 좁게 가운데 정렬하지만
            // MediaQuery는 그대로 브라우저 창 전체 폭을 보고하므로, 패널 위치 계산에는
            // 반드시 이 위젯이 실제로 그려지는 폭(constraints.maxWidth)을 써야 한다.
            final bodyWidth = constraints.maxWidth;
            return Stack(
              children: [
                IndexedStack(
                  index: _activeIndex,
                  children: List.generate(3, (i) {
                    return Navigator(
                      key: _navigatorKeys[i],
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (_) => _rootScreens[i],
                      ),
                    );
                  }),
                ),
                // 다른 오버레이가 하나라도 열리면 버블은 숨긴다(html의 openPanel()과 동일한 규칙).
                Positioned(
                  right: 11,
                  bottom: 12,
                  child: IgnorePointer(
                    ignoring: _anyOverlayOpen,
                    child: AnimatedOpacity(
                      opacity: _anyOverlayOpen ? 0 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: _AiBubble(onTap: _toggleAiChat),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _NavigatorScrim(
                    isOpen: _navPanelOpen,
                    onTap: () => setState(() => _navPanelOpen = false),
                  ),
                ),
                _NavigatorPanel(
                  isOpen: _navPanelOpen,
                  screenWidth: bodyWidth,
                  tabCount: _tabs.length,
                  tabIndex: naviTabIndex,
                  onWageTap: _openWageFlow,
                  onInjuryTap: _openInjuryFlow,
                ),
                Positioned.fill(
                  child: WorkLogSheet(
                    isOpen: _worklogOpen,
                    onClose: () => setState(() => _worklogOpen = false),
                  ),
                ),
                Positioned.fill(
                  child: AiChatSheet(
                    isOpen: _aiChatOpen,
                    onClose: () => setState(() => _aiChatOpen = false),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: _BottomTabBar(
          tabs: _tabs,
          activeIndex: _activeIndex,
          worklogOpen: _worklogOpen,
          navPanelOpen: _navPanelOpen,
          onTap: _onTabTap,
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 47,
        height: 47,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF12A594), Color(0xFF0B7267)]),
          boxShadow: [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: const Text('AI', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _NavigatorScrim extends StatelessWidget {
  const _NavigatorScrim({required this.isOpen, required this.onTap});
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedOpacity(
        opacity: isOpen ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        child: GestureDetector(
          onTap: onTap,
          child: Container(color: const Color(0x47091020)),
        ),
      ),
    );
  }
}

class _NavigatorPanel extends StatelessWidget {
  const _NavigatorPanel({
    required this.isOpen,
    required this.screenWidth,
    required this.tabCount,
    required this.tabIndex,
    required this.onWageTap,
    required this.onInjuryTap,
  });

  final bool isOpen;
  final double screenWidth;
  final int tabCount;
  final int tabIndex;
  final VoidCallback onWageTap;
  final VoidCallback onInjuryTap;

  static const _panelWidth = 128.0;

  @override
  Widget build(BuildContext context) {
    if (tabIndex == -1) return const SizedBox.shrink();

    final slotWidth = screenWidth / tabCount;
    final rawRight = ((tabCount - tabIndex - 0.5) * slotWidth) - (_panelWidth / 2);
    final rightOffset = rawRight.clamp(8.0, screenWidth - _panelWidth - 8.0);

    return Positioned(
      right: rightOffset,
      bottom: 12,
      width: _panelWidth,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: AnimatedSlide(
          offset: isOpen ? Offset.zero : const Offset(0, 0.15),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: isOpen ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NaviPanelItem(
                  gradient: const [Color(0xFFE08A1E), Color(0xFFB45309)],
                  emoji: '💸',
                  label: '임금체불',
                  onTap: onWageTap,
                ),
                const SizedBox(height: 8),
                _NaviPanelItem(
                  gradient: const [Color(0xFF12A594), Color(0xFF0B7267)],
                  emoji: '⛑️',
                  label: '산업재해',
                  onTap: onInjuryTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NaviPanelItem extends StatelessWidget {
  const _NaviPanelItem({required this.gradient, required this.emoji, required this.label, required this.onTap});
  final List<Color> gradient;
  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 5))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 19)),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({
    required this.tabs,
    required this.activeIndex,
    required this.worklogOpen,
    required this.navPanelOpen,
    required this.onTap,
  });

  final List<_TabSpec> tabs;
  final int activeIndex;
  final bool worklogOpen;
  final bool navPanelOpen;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final centerIndex = tabs.indexWhere((t) => t.action == _NavAction.worklogToggle);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 60,
              child: Row(
                children: List.generate(tabs.length, (i) {
                  final tab = tabs[i];

                  if (tab.action == _NavAction.worklogToggle) {
                    final isActive = worklogOpen;
                    return Expanded(
                      child: InkWell(
                        onTap: () => onTap(i),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final isActive = tab.action == _NavAction.navigatorPanel
                      ? navPanelOpen
                      : (!worklogOpen && !navPanelOpen && tab.pageIndex == activeIndex);
                  final color = isActive ? AppColors.primary : AppColors.textMuted;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isActive ? tab.activeIcon : tab.icon, size: 22, color: color),
                          const SizedBox(height: 2),
                          Text(tab.label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        if (centerIndex != -1)
          Positioned(
            left: 0,
            right: 0,
            top: -16,
            child: Center(
              child: _CalendarBubble(
                isActive: worklogOpen,
                onTap: () => onTap(centerIndex),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarBubble extends StatelessWidget {
  const _CalendarBubble({required this.isActive, required this.onTap});
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B4E8C), Color(0xFF152C52)],
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF152C52).withValues(alpha: 0.45), blurRadius: 14, offset: const Offset(0, 5)),
            const BoxShadow(color: Colors.white, blurRadius: 0, spreadRadius: 4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${now.month}월', style: const TextStyle(fontSize: 7.5, color: Color(0xFFE8C88A), fontWeight: FontWeight.w700)),
            Text(
              '${now.day}',
              style: const TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w800, height: 1.05),
            ),
          ],
        ),
      ),
    );
  }
}
