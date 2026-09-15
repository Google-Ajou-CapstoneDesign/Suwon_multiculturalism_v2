import 'package:flutter/material.dart';
import '../core/app_language.dart';
import '../core/user_profile_controller.dart';
import '../features/ai_guide/widgets/ai_chat_sheet.dart';
import '../features/home/screens/home_screen.dart';
import '../features/onboarding/models/app_tour_step.dart';
import '../features/onboarding/widgets/spotlight_tour_overlay.dart';
import '../features/settings/screens/settings_home_screen.dart';
import '../features/wage_calculator/screens/wage_calculator_screen.dart';
import '../features/worklog/controllers/work_log_controller.dart';
import '../features/worklog/screens/navigator_home_screen.dart';
import '../features/worklog/widgets/calendar_login_gate.dart';
import '../features/worklog/widgets/work_log_sheet.dart';
import '../theme/app_colors.dart';

/// 하단 탭 셸. 홈 · 임금계산기 · 네비게이터 · 설정 4개는 각자 Navigator를 가진 일반
/// 탭이다. 가운데 "캘린더"는 근무기록장 시트를 띄운다 — 하단 탭바를 가리지 않는
/// 오버레이 방식이다(프론트엔드_구상_확장.html의 설계 의도). "네비게이터" 탭은
/// 임금체불/산재 중 하나를 고르면 해당 내비게이터로 이동하는 선택 화면이다
/// (같은 진입은 홈 화면의 바로가기 카드에서도 가능). 원래 이 자리에 있던
/// 백과사전은 features/encyclopedia에 코드/데이터 그대로 남아 있으나 메인
/// 탭에서는 더 이상 연결되지 않는다.
/// AI 가이드는 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다.
///
/// 이 앱에서 로그인이 실제로 필요한 곳은 캘린더뿐이라, 캘린더를 처음 열 때
/// (로그인하지 않았고 이번 세션에 데모도 아직 선택 안 했다면) 근무기록장 대신
/// CalendarLoginGate를 먼저 보여준다 — 로그인하거나 데모를 선택하면 그제서야
/// 실제 캘린더가 열린다.
///
/// 초기 앱 실행마다(온보딩과 같은 주기) SpotlightTourOverlay가 하단 탭 4개와
/// AI 버블을 실제 위치에서 순서대로 짚어주는 코치마크 투어를 한 번 띄운다 —
/// html_files/frontend_설명서.html의 스포트라이트 투어 형식을 그대로 옮긴 것.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

/// 앱 첫 실행 스포트라이트 투어 문구 — html_files/frontend_설명서.html의
/// 코치마크 카드 내용(제목·본문·"왜 중요한지" 팁)을 이 앱의 실제 5개 진입점
/// (하단 탭 4개 + AI 버블)에 맞게 다시 쓴 것이다.
class _TourStrings {
  _TourStrings._();

  static const homeTitle = L10nText(
    ko: '🏠 홈',
    en: '🏠 Home',
    zh: '🏠 首页',
    vi: '🏠 Trang chủ',
    uz: "🏠 Bosh sahifa",
  );
  static const homeBody = L10nText(
    ko: '오늘 날씨, 비자 정보, 출퇴근 상태를 한눈에 볼 수 있어요. 앱을 열면 항상 여기서 시작해요.',
    en: "See today's weather, your visa info, and clock-in status at a glance. This is always where the app starts.",
    zh: '在这里可以一目了然地查看今天的天气、签证信息和上下班状态。打开应用后总是从这里开始。',
    vi: 'Xem thời tiết hôm nay, thông tin visa và trạng thái chấm công trong nháy mắt. Ứng dụng luôn bắt đầu từ đây.',
    uz: "Bugungi ob-havo, viza maʼlumotlaringiz va ishga kirish/chiqish holatini bir qarashda koʻring. Ilova har doim shu yerdan boshlanadi.",
  );

  static const navigatorTitle = L10nText(
    ko: '🧭 네비게이터',
    en: '🧭 Navigator',
    zh: '🧭 导航',
    vi: '🧭 Điều hướng',
    uz: "🧭 Navigator",
  );
  static const navigatorBody = L10nText(
    ko: '임금체불·산재 처리 중 무엇이 필요한지 고르면 신고·신청까지 단계별로 안내해드려요.',
    en: 'Choose whether you need help with unpaid wages or a workplace injury, and get step-by-step guidance all the way to filing.',
    zh: '选择您需要处理欠薪还是工伤，我们会逐步引导您完成申诉或申请。',
    vi: 'Chọn bạn cần hỗ trợ về nợ lương hay tai nạn lao động, chúng tôi sẽ hướng dẫn từng bước đến khi nộp đơn.',
    uz: "Toʻlanmagan ish haqi yoki ish joyidagi jarohat boʻyicha yordam kerakligini tanlang va arizani topshirishgacha boʻlgan bosqichma-bosqich koʻrsatmalarni oling.",
  );

  static const calendarTitle = L10nText(
    ko: '📅 근무기록장(캘린더)',
    en: '📅 Work Log (Calendar)',
    zh: '📅 工作记录本（日历）',
    vi: '📅 Nhật ký làm việc (Lịch)',
    uz: "📅 Ish jurnali (Kalendar)",
  );
  static const calendarBody = L10nText(
    ko: '출퇴근 시각과 위치 인증을 매일 기록해두는 곳이에요. 로그인하면 서버에 안전하게 저장되고, 로그인 없이도 데모로 먼저 체험할 수 있어요.',
    en: "Record your clock-in/out times and location verification here every day. Logging in saves them safely on the server, but you can also try a demo without logging in.",
    zh: '在这里每天记录上下班时间和位置认证。登录后会安全保存在服务器上，不登录也可以先体验演示版。',
    vi: 'Nơi ghi lại giờ vào/ra ca và xác minh vị trí mỗi ngày. Đăng nhập sẽ lưu an toàn lên máy chủ, hoặc bạn có thể dùng thử bản demo mà không cần đăng nhập.',
    uz: "Har kuni ishga kirish/chiqish vaqtlaringizni va joylashuvni tasdiqlashni shu yerda qayd eting. Kirish ularni serverda xavfsiz saqlaydi, lekin siz tizimga kirmasdan ham demo versiyasini sinab koʻrishingiz mumkin.",
  );
  static const calendarTip = L10nText(
    ko: '매일의 출퇴근·위치 기록은 나중에 임금체불·산재를 신고할 때 가장 확실한 증거가 됩니다.',
    en: 'Your daily clock-in/out and location records become the strongest evidence if you ever need to file an unpaid-wage or workplace-injury claim.',
    zh: '每天的上下班和位置记录，日后申诉欠薪或工伤时将成为最确凿的证据。',
    vi: 'Bản ghi giờ vào/ra ca và vị trí hằng ngày sẽ là bằng chứng chắc chắn nhất khi bạn cần khiếu nại nợ lương hoặc tai nạn lao động.',
    uz: "Sizning kundalik ishga kirish/chiqish va joylashuv yozuvlaringiz, agar sizga toʻlanmagan ish haqi yoki ish joyidagi jarohat boʻyicha daʼvo qilish kerak boʻlsa, eng kuchli dalilga aylanadi.",
  );

  static const wageCalcTitle = L10nText(
    ko: '🧮 임금계산기',
    en: '🧮 Wage Calculator',
    zh: '🧮 工资计算器',
    vi: '🧮 Máy tính lương',
    uz: "🧮 Ish haqi kalkulyatori",
  );
  static const wageCalcBody = L10nText(
    ko: '시급과 근무시간을 입력하면 최저임금 위반이나 미지급 여부를 스스로 확인할 수 있어요.',
    en: 'Enter your hourly wage and hours worked to check for minimum-wage violations or unpaid amounts yourself.',
    zh: '输入时薪和工作时间，即可自行确认是否违反最低工资或存在未付工资。',
    vi: 'Nhập mức lương theo giờ và số giờ làm để tự kiểm tra vi phạm lương tối thiểu hoặc khoản chưa được trả.',
    uz: "Minimal ish haqi buzilishlari yoki toʻlanmagan summalarni oʻzingiz tekshirish uchun soatlik ish haqingizni va ishlagan soatlaringizni kiriting.",
  );

  static const aiTitle = L10nText(
    ko: '💬 AI 가이드',
    en: '💬 AI Guide',
    zh: '💬 AI 助手',
    vi: '💬 Trợ lý AI',
    uz: "💬 AI Yordamchi",
  );
  static const aiBody = L10nText(
    ko: '임금체불·산재·근로계약 등 궁금한 점을 언제든 물어보세요. 필요하면 가까운 지원기관도 추천해드려요.',
    en: 'Ask anything about unpaid wages, workplace injuries, employment contracts, and more, any time. It can also recommend nearby support organizations if needed.',
    zh: '随时可以咨询拖欠工资、工伤、劳动合同等问题，需要时还会推荐附近的支援机构。',
    vi: 'Hãy hỏi bất cứ lúc nào về nợ lương, tai nạn lao động, hợp đồng lao động và hơn thế nữa. Khi cần, trợ lý cũng sẽ gợi ý các cơ quan hỗ trợ gần bạn.',
    uz: "Toʻlanmagan ish haqi, ish joyidagi jarohatlar, mehnat shartnomalari va boshqalar haqida istalgan vaqtda soʻrang. Agar kerak boʻlsa, yaqin atrofdagi qoʻllab-quvvatlash tashkilotlarini ham tavsiya qilishi mumkin.",
  );
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

  /// 로그인이 필요한 탭은 캘린더뿐이다 — 앱을 열자마자 로그인부터 강제하는
  /// 대신, 캘린더를 켤 때만 이 게이트를 보여준다.
  bool _calendarLoginGateOpen = false;

  /// 이번 세션에서 "로그인 없이 이용하기(데모)"를 이미 골랐는지 — 한 번
  /// 고르면 앱을 다시 켤 때까지는 캘린더를 열 때마다 다시 묻지 않는다.
  bool _calendarDemoChosen = false;

  /// 홈 화면의 "오늘의 근무" 위젯과 근무기록장 시트가 같은 인스턴스를 공유한다.
  final _workLogController = WorkLogController();
  bool? _lastSignedIn;

  /// 앱 첫 실행 시 주요 화면 요소를 실제 위치에서 짚어주는 스포트라이트 투어.
  /// _tabs 순서(홈·네비게이터·캘린더·임금계산기·설정)와 1:1로 대응하는 키 —
  /// 캘린더 항목은 _CalendarBubble(원형 버튼)에, 나머지는 하단 탭 InkWell에 단다.
  final _tourController = AppTourController();
  final _tabKeys = List.generate(5, (_) => GlobalKey());
  final _aiBubbleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 스플래시·온보딩이 이 위(AppEntryFlow의 Stack)를 덮고 있는 동안 미리
    // 투어를 시작해둔다 — MainShell은 앱 시작부터 계속 마운트돼 있으므로
    // (didChangeDependencies의 코멘트 참고) initState는 프로세스당 한 번만
    // 실행되고, 그 시점에 이미 하단 탭·AI 버블 레이아웃도 끝나 있다. 온보딩이
    // 사라지는 순간 투어가 그 자리에서 바로 눈에 보이게 된다 — 로그인 여부와
    // 무관하게 "초기 앱 실행"마다 한 번씩만 뜬다(온보딩과 동일한 주기).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tourController.start(_buildTourSteps());
    });
  }

  List<AppTourStep> _buildTourSteps() => [
    AppTourStep(
      targetKey: _tabKeys[0],
      title: _TourStrings.homeTitle,
      body: _TourStrings.homeBody,
    ),
    AppTourStep(
      targetKey: _tabKeys[1],
      title: _TourStrings.navigatorTitle,
      body: _TourStrings.navigatorBody,
    ),
    AppTourStep(
      targetKey: _tabKeys[2],
      title: _TourStrings.calendarTitle,
      body: _TourStrings.calendarBody,
      tip: _TourStrings.calendarTip,
    ),
    AppTourStep(
      targetKey: _tabKeys[3],
      title: _TourStrings.wageCalcTitle,
      body: _TourStrings.wageCalcBody,
    ),
    AppTourStep(
      targetKey: _aiBubbleKey,
      title: _TourStrings.aiTitle,
      body: _TourStrings.aiBody,
    ),
  ];

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
    _tourController.dispose();
    super.dispose();
  }

  final _tabs = const [
    _TabSpec(
      label: L10nText(
        ko: '홈',
        en: 'Home',
        zh: '首页',
        vi: 'Trang chủ',
        uz: "Bosh sahifa",
      ),
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      action: _NavAction.page,
      pageIndex: 0,
    ),
    _TabSpec(
      label: L10nText(
        ko: '네비게이터',
        en: 'Navigator',
        zh: '导航',
        vi: 'Điều hướng',
        uz: "Navigator",
      ),
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      action: _NavAction.page,
      pageIndex: 2,
    ),
    _TabSpec(
      label: L10nText(
        ko: '캘린더',
        en: 'Calendar',
        zh: '日历',
        vi: 'Lịch',
        uz: "Kalendar",
      ),
      action: _NavAction.worklogToggle,
    ),
    _TabSpec(
      label: L10nText(
        ko: '임금계산기',
        en: 'Wage calc.',
        zh: '工资计算',
        vi: 'Tính lương',
        uz: "Ish haqi hisob.",
      ),
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate,
      action: _NavAction.page,
      pageIndex: 1,
    ),
    _TabSpec(
      label: L10nText(
        ko: '설정',
        en: 'Settings',
        zh: '设置',
        vi: 'Cài đặt',
        uz: "Sozlamalar",
      ),
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
      onOpenWageCalculator: () => _switchToTab(1),
      onOpenNavigator: () => _switchToTab(2),
    ),
    const WageCalculatorScreen(),
    const NavigatorHomeScreen(),
    SettingsHomeScreen(onOpenAiChat: _toggleAiChat),
  ];

  /// 홈 화면의 빠른 접근 그리드에서 다른 탭으로 바로 이동할 때 쓴다 —
  /// _onTabTap과 동일하게 열려 있는 오버레이부터 닫는다.
  void _switchToTab(int pageIndex) {
    setState(() {
      _closeAllOverlays();
      _activeIndex = pageIndex;
    });
  }

  bool get _anyOverlayOpen =>
      _worklogOpen || _aiChatOpen || _calendarLoginGateOpen;

  /// 캘린더를 열려는 모든 진입점(하단 탭, 홈 화면 바로가기 버튼)이 공통으로
  /// 거치는 곳 — 로그인했거나 이번 세션에 이미 데모를 선택했다면 바로
  /// 근무기록장을 열고, 아니라면 로그인 게이트부터 보여준다.
  void _openCalendar() {
    final signedIn = UserProfileScope.of(context).isSignedIn;
    setState(() {
      _closeAllOverlays();
      if (signedIn || _calendarDemoChosen) {
        _worklogOpen = true;
      } else {
        _calendarLoginGateOpen = true;
      }
    });
  }

  /// 홈 화면 "오늘의 근무" 카드의 캘린더 바로가기 버튼.
  void _openWorkLog() => _openCalendar();

  void _closeAllOverlays() {
    _worklogOpen = false;
    _aiChatOpen = false;
    _calendarLoginGateOpen = false;
  }

  void _onCalendarLoginSuccess() {
    setState(() {
      _calendarLoginGateOpen = false;
      _worklogOpen = true;
    });
  }

  void _onCalendarContinueAsDemo() {
    setState(() {
      _calendarDemoChosen = true;
      _calendarLoginGateOpen = false;
      _worklogOpen = true;
    });
  }

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];

    if (tab.action == _NavAction.worklogToggle) {
      if (_worklogOpen || _calendarLoginGateOpen) {
        // 게이트든 실제 캘린더든 이미 열려 있으면 다시 눌러 닫는다.
        setState(() => _closeAllOverlays());
        return;
      }
      _openCalendar();
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
        if (_tourController.active) {
          _tourController.stop();
          return;
        }
        if (_aiChatOpen) {
          setState(() => _aiChatOpen = false);
          return;
        }
        if (_calendarLoginGateOpen) {
          setState(() => _calendarLoginGateOpen = false);
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
      child: Stack(
        children: [
          Scaffold(
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
                      child: _AiBubble(
                        key: _aiBubbleKey,
                        language: UserProfileScope.of(context).language,
                        onTap: _toggleAiChat,
                      ),
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
                  child: CalendarLoginGate(
                    isOpen: _calendarLoginGateOpen,
                    onClose: () =>
                        setState(() => _calendarLoginGateOpen = false),
                    onContinueAsDemo: _onCalendarContinueAsDemo,
                    onLoginSuccess: _onCalendarLoginSuccess,
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
              tabKeys: _tabKeys,
              activeIndex: _activeIndex,
              worklogOpen: _worklogOpen || _calendarLoginGateOpen,
              onTap: _onTabTap,
            ),
          ),
          // 하단 탭바까지 전부 덮어야 해서(Scaffold.bottomNavigationBar는
          // body의 Stack 밖에 있다) 이 Scaffold 전체를 감싸는 바깥 Stack에
          // 얹는다 — 비활성 상태면 크기를 차지하지 않아 평소엔 아무 영향이 없다.
          Positioned.fill(
            child: SpotlightTourOverlay(controller: _tourController),
          ),
        ],
      ),
    );
  }
}

const _aiBubbleLabel = L10nText(
  ko: 'AI 가이드',
  en: 'AI Guide',
  zh: 'AI引导',
  vi: 'Trợ lý AI',
  uz: "AI Yordamchi",
);

/// design_files/App_Design.html의 .ai-fab(알약형, navy 배경, "AI" 배지) 스펙.
class _AiBubble extends StatelessWidget {
  const _AiBubble({super.key, required this.language, required this.onTap});
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF3C536F),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'AI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFFCFE0F9),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _aiBubbleLabel.of(language),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// design_files/App_Design.html의 .mobile-nav button 비활성 색(#99a4b4).
const _inactiveTabColor = Color(0xFF99A4B4);

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({
    required this.tabs,
    required this.tabKeys,
    required this.activeIndex,
    required this.worklogOpen,
    required this.onTap,
  });

  final List<_TabSpec> tabs;

  /// tabs와 1:1 대응 — 스포트라이트 투어가 각 탭의 실제 위치를 찾는 데 쓴다.
  /// 캘린더 항목(worklogToggle)의 키는 여기 InkWell이 아니라 아래 원형
  /// _CalendarBubble에 단다 — 사용자 눈에 실제로 도드라져 보이는 쪽이라서다.
  final List<GlobalKey> tabKeys;
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
                                      : _inactiveTabColor,
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
                      : _inactiveTabColor;
                  return Expanded(
                    child: InkWell(
                      key: tabKeys[i],
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
                key: tabKeys[centerIndex],
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
  const _CalendarBubble({
    super.key,
    required this.isActive,
    required this.onTap,
  });
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
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
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
              style: TextStyle(
                fontSize: 7.5,
                color: Colors.white.withValues(alpha: 0.7),
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
