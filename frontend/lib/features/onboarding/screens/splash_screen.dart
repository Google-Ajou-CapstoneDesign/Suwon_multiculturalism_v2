import 'package:flutter/material.dart';

/// 앱 최초 진입 시 잠깐 보이는 로딩 화면. AppEntryFlow가 표시 시간과 페이드아웃을 관리하고,
/// 이 위젯 자체는 순수하게 시각적인 부분(로고·태그라인·진행 바)만 맡는다.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();
  late final _fadeIn = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.35, curve: Curves.easeOut),
  );
  late final _barFill = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.15, 1, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.4, -1),
          end: Alignment(0.4, 1),
          colors: [Color(0xFF0D47A1), Color(0xFF0D47A1), Color(0xFF0D47A1)],
          stops: [0, 0.62, 1],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeIn,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'img/Logo.png',
                    width: 132,
                    height: 132,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeIn,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 44),
                  child: Text(
                    '외국인 근로자와 유학생의\n안전한 한국 생활',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xB890CAF9),
                      height: 1.7,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AnimatedBuilder(
                animation: _barFill,
                builder: (context, child) {
                  return Container(
                    width: 132,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.3 + _barFill.value * 0.7,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF90CAF9)],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const Positioned(
            bottom: 26,
            child: Text(
              'EQ LAB',
              style: TextStyle(
                fontSize: 9.5,
                letterSpacing: 3,
                color: Color(0x8C90CAF9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
