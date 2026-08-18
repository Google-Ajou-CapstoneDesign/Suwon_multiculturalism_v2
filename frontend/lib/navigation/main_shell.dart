import 'package:flutter/material.dart';
import '../core/app_language.dart';
import '../core/user_profile_controller.dart';
import '../features/ai_guide/widgets/ai_chat_sheet.dart';
import '../features/encyclopedia/screens/encyclopedia_home_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/settings/screens/settings_home_screen.dart';
import '../features/wage_calculator/screens/wage_calculator_screen.dart';
import '../features/worklog/controllers/work_log_controller.dart';
import '../features/worklog/widgets/work_log_sheet.dart';
import '../theme/app_colors.dart';

/// 하단 탭 셸. 홈 · 임금계산기 · 백과사전 · 설정 4개는 각자 Navigator를 가진 일반
/// 탭이다. 가운데 "캘린더"는 근무기록장 시트를 띄운다 — 하단 탭바를 가리지 않는
/// 오버레이 방식이다(프론트엔드_구상_확장.html의 설계 의도). 임금체불/산재 내비게이터로의
/// 진입은 홈 화면의 바로가기 카드에서 이뤄진다.
/// AI 가이드는 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

enum _NavAction { page, worklogToggle }

class _TabSpec {
  const _TabSpec({
    required this.label,
    this.icon,
    this.activeIcon,
    required this.action,
    this.pageIndex,
  });
  final L10nText label;
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

  /// 홈 화면의 "오늘의 근무" 위젯과 근무기록장 시트가 같은 인스턴스를 공유한다.
  final _workLogController = WorkLogController();
  bool? _lastSignedIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final signedIn = UserProfileScope.of(context).isSignedIn;
    if (_lastSignedIn != signedIn) {
      _lastSignedIn = signedIn;
      _workLogController.setSignedIn(signedIn);
    }
  }

  @override
  void dispose() {
    _workLogController.dispose();
    super.dispose();
  }

  final _tabs = const [
    _TabSpec(
      label: L10nText(ko: '홈', en: 'Home', zh: '首页', vi: 'Trang chủ'),
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      action: _NavAction.page,
      pageIndex: 0,
    ),
    _TabSpec(
      label: L10nText(
        ko: '백과사전',
        en: 'Encyclopedia',
        zh: '百科全书',
        vi: 'Cẩm nang',
      ),
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      action: _NavAction.page,
      pageIndex: 2,
    ),
    _TabSpec(
      label: L10nText(ko: '캘린더', en: 'Calendar', zh: '日历', vi: 'Lịch'),
      action: _NavAction.worklogToggle,
    ),
    _TabSpec(
      label: L10nText(
        ko: '임금계산기',
        en: 'Wage calc.',
        zh: '工资计算',
        vi: 'Tính lương',
      ),
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate,
      action: _NavAction.page,
      pageIndex: 1,
    ),
    _TabSpec(
      label: L10nText(ko: '설정', en: 'Settings', zh: '设置', vi: 'Cài đặt'),
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      action: _NavAction.page,
      pageIndex: 3,
    ),
  ];

  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  List<Widget> get _rootScreens => [
    HomeScreen(
      workLogController: _workLogController,
      onOpenWorkLog: _openWorkLog,
    ),
    const WageCalculatorScreen(),
    const EncyclopediaHomeScreen(),
    const SettingsHomeScreen(),
  ];

  bool get _anyOverlayOpen => _worklogOpen || _aiChatOpen;

  void _openWorkLog() {
    setState(() {
      _closeAllOverlays();
      _worklogOpen = true;
    });
  }

  void _closeAllOverlays() {
    _worklogOpen = false;
    _aiChatOpen = false;
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

    final pageIndex = tab.pageIndex!;
    if (pageIndex == _activeIndex && !_anyOverlayOpen) {
      // 같은 탭을 다시 누르면 해당 탭의 첫 화면으로 되돌아간다.
      _navigatorKeys[pageIndex].currentState?.popUntil(
        (route) => route.isFirst,
      );
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
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
        body: Stack(
          children: [
            IndexedStack(
              index: _activeIndex,
              children: List.generate(4, (i) {
                return Navigator(
                  key: _navigatorKeys[i],
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (_) => _rootScreens[i]),
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
              child: WorkLogSheet(
                isOpen: _worklogOpen,
                onClose: () => setState(() => _worklogOpen = false),
                controller: _workLogController,
              ),
            ),
            Positioned.fill(
              child: AiChatSheet(
                isOpen: _aiChatOpen,
                onClose: () => setState(() => _aiChatOpen = false),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomTabBar(
          tabs: _tabs,
          activeIndex: _activeIndex,
          worklogOpen: _worklogOpen,
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Text(
          'AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
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
    required this.onTap,
  });

  final List<_TabSpec> tabs;
  final int activeIndex;
  final bool worklogOpen;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    final centerIndex = tabs.indexWhere(
      (t) => t.action == _NavAction.worklogToggle,
    );

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
                                tab.label.of(lang),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final isActive = !worklogOpen && tab.pageIndex == activeIndex;
                  final color = isActive
                      ? AppColors.primary
                      : AppColors.textMuted;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            size: 22,
                            color: color,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.label.of(lang),
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
            colors: [Color(0xFF0D47A1), Color(0xFF0D47A1)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D47A1).withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 0,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${now.month}월',
              style: const TextStyle(
                fontSize: 7.5,
                color: Color(0xFF90CAF9),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${now.day}',
              style: const TextStyle(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
