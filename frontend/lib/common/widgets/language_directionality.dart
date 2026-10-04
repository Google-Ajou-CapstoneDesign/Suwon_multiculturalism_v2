import 'package:flutter/widgets.dart';
import '../../core/user_profile_controller.dart';

/// Keep every route and modal in sync with the selected app language.
class LanguageDirectionality extends StatelessWidget {
  const LanguageDirectionality({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final language = UserProfileScope.of(context).language;
    return Directionality(
      textDirection: language.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
