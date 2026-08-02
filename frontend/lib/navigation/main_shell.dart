import 'package:flutter/material.dart';
import '../features/ai_guide/screens/chat_screen.dart';
import '../features/encyclopedia/screens/encyclopedia_home_screen.dart';
import '../features/settings/screens/settings_home_screen.dart';
import '../features/worklog/screens/daily_hook_screen.dart';
import '../theme/app_colors.dart';

/// 하단 탭 4개(백과사전 · AI가이드 · 근무기록 · 설정) 루트 셸.
/// 각 탭은 Navigator를 하나씩 가져 탭을 전환해도 화면 히스토리가 유지된다.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _activeIndex = 0;

  final _tabs = const [
    _TabSpec(label: '백과사전', icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book),
    _TabSpec(label: 'AI가이드', icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble),
    _TabSpec(label: '근무기록', icon: Icons.access_time_outlined, activeIcon: Icons.access_time_filled),
    _TabSpec(label: '설정', icon: Icons.settings_outlined, activeIcon: Icons.settings),
  ];

  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  static const _rootScreens = [
    EncyclopediaHomeScreen(),
    ChatScreen(),
    DailyHookScreen(),
    SettingsHomeScreen(),
  ];

  void _onTabTap(int index) {
    if (index == _activeIndex) {
      // 같은 탭을 다시 누르면 해당 탭의 첫 화면으로 되돌아간다.
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _activeIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = _navigatorKeys[_activeIndex].currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
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
        bottomNavigationBar: _BottomTabBar(
          tabs: _tabs,
          activeIndex: _activeIndex,
          onTap: _onTabTap,
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({required this.label, required this.icon, required this.activeIcon});
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({required this.tabs, required this.activeIndex, required this.onTap});

  final List<_TabSpec> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final isActive = i == activeIndex;
              final tab = tabs[i];
              final color = isActive ? AppColors.primary : AppColors.textMuted;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isActive ? tab.activeIcon : tab.icon, size: 22, color: color),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
