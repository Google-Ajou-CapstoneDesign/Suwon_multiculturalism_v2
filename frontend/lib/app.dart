import 'package:flutter/material.dart';
import 'common/widgets/web_centered_frame.dart';
import 'core/user_profile_controller.dart';
import 'features/onboarding/app_entry_flow.dart';
import 'theme/app_theme.dart';

/// TODO(backend): Firebase 초기화 후 로그인 상태를 온보딩 완료 여부와 함께 확인해야 한다.
/// 지금은 매 실행마다 스플래시→온보딩을 다시 보여준다(세션 재시작 시 초기화).
///
/// UserProfileScope는 반드시 MaterialApp(따라서 그 루트 Navigator) 위에 있어야 한다 —
/// MainShell의 탭들은 각자 자체 Navigator를 갖고 있어 그 안에서 push한 화면은
/// UserProfileScope가 그 아래(예: AppEntryFlow 안)에 있어도 문제없이 보이지만,
/// 탭 Navigator가 없는 온보딩 화면(예: 로그인/회원가입 진입)에서 push하면 루트
/// Navigator를 타게 되고, 그러면 새 라우트는 UserProfileScope 아래가 아니라
/// 형제 서브트리가 되어버려 UserProfileScope.of(context)가 실패한다.
class LocalBridgeApp extends StatefulWidget {
  const LocalBridgeApp({super.key});

  @override
  State<LocalBridgeApp> createState() => _LocalBridgeAppState();
}

class _LocalBridgeAppState extends State<LocalBridgeApp> {
  final _profile = UserProfileController();

  @override
  void dispose() {
    _profile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileScope(
      controller: _profile,
      child: MaterialApp(
        title: 'Local Bridge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // 웹처럼 뷰포트가 넓을 때 모바일 UI를 가운데 정렬해 보여준다.
        builder: (context, child) =>
            WebCenteredFrame(child: child ?? const SizedBox.shrink()),
        home: const AppEntryFlow(),
      ),
    );
  }
}
