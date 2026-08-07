import 'package:flutter/material.dart';
import '../features/ai_guide/widgets/ai_chat_sheet.dart';
import '../features/encyclopedia/screens/encyclopedia_home_screen.dart';
import '../features/settings/screens/settings_home_screen.dart';
import '../features/wage_calculator/screens/wage_calculator_screen.dart';
import '../features/worklog/screens/daily_hook_screen.dart';
import '../features/worklog/widgets/work_log_sheet.dart';
import '../theme/app_colors.dart';

/// 하단 탭 셸. 백과사전 · 임금계산기 · 근무기록 · 설정 4개는 각자 Navigator를 가진
/// 일반 탭이고, 가운데 "오늘"(캘린더) 버튼은 탭 전환이 아니라 현재 탭 위로
/// 근무기록장 시트를 슬라이드업 시킨다 — 하단 탭바는 항상 보이게 남겨 다시
/// 눌러서 닫을 수 있게 한다(프론트엔드_구상_확장.html의 설계 의도).
/// AI 가이드는 더 이상 탭이 아니라 우측 하단 AI 버블 → 같은 방식의 슬라이드업
/// 시트로 진입한다.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

enum _NavAction { page, worklogToggle }

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

  final _tabs = const [
    _TabSpec(label: '백과사전', icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, action: _NavAction.page, pageIndex: 0),
    _TabSpec(label: '임금계산기', icon: Icons.calculate_outlined, activeIcon: Icons.calculate, action: _NavAction.page, pageIndex: 1),
    _TabSpec(label: '오늘', action: _NavAction.worklogToggle),
    _TabSpec(label: '근무기록', icon: Icons.access_time_outlined, activeIcon: Icons.access_time_filled, action: _NavAction.page, pageIndex: 2),
    _TabSpec(label: '설정', icon: Icons.settings_outlined, activeIcon: Icons.settings, action: _NavAction.page, pageIndex: 3),
  ];

  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  static const _rootScreens = [
    EncyclopediaHomeScreen(),
    WageCalculatorScreen(),
    DailyHookScreen(),
    SettingsHomeScreen(),
  ];

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];

    if (tab.action == _NavAction.worklogToggle) {
      setState(() {
        _worklogOpen = !_worklogOpen;
        if (_worklogOpen) _aiChatOpen = false;
      });
      return;
    }

    final pageIndex = tab.pageIndex!;
    final wasOverlayOpen = _worklogOpen || _aiChatOpen;

    if (pageIndex == _activeIndex && !wasOverlayOpen) {
      // 같은 탭을 다시 누르면 해당 탭의 첫 화면으로 되돌아간다.
      _navigatorKeys[pageIndex].currentState?.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      _worklogOpen = false;
      _aiChatOpen = false;
      _activeIndex = pageIndex;
    });
  }

  void _toggleAiChat() {
    setState(() {
      _aiChatOpen = !_aiChatOpen;
      if (_aiChatOpen) _worklogOpen = false;
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
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => _rootScreens[i],
                  ),
                );
              }),
            ),
            // 오버레이 시트가 열리면(z순서상 이 뒤에 그려짐) 버블 위를 그대로 덮는다.
            Positioned(
              right: 11,
              bottom: 12,
              child: _AiBubble(onTap: _toggleAiChat),
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
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF12A594), Color(0xFF0B7267)]),
          boxShadow: [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: const Text('AI', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({required this.tabs, required this.activeIndex, required this.worklogOpen, required this.onTap});

  final List<_TabSpec> tabs;
  final int activeIndex;
  final bool worklogOpen;
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

                  final isActive = !worklogOpen && i != centerIndex && tab.pageIndex == activeIndex;
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
