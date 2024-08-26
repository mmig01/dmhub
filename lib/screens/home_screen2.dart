import 'package:flutter/material.dart';
import 'package:phomu/screens/login_screen.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with SingleTickerProviderStateMixin {
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  bool _logoVisible = false;
  bool _scrollVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _logoVisible = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        _scrollVisible = true;
      });
    });
    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션의 총 지속 시간 설정
      vsync: this, // 애니메이션의 상태를 관리하는 TickerProvider
    );

    // 위치 애니메이션 설정: 아래에서 위로 이동
    _animation = Tween<double>(
      begin: 100.0, // 시작 위치 (아래쪽)
      end: 0.0, // 종료 위치 (위쪽)
    ).animate(
      CurvedAnimation(
        parent: _controller, // 애니메이션 컨트롤러
        curve: Curves.easeInOut, // 부드럽게 시작하고 종료되는 커브
      ),
    );

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 자원 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // 위로 슬라이드할 때 다음 화면으로 전환
        if (details.primaryDelta! < -10) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Login(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // 페이드 애니메이션 설정
                const fadeBegin = 0.0;
                const fadeEnd = 1.0;
                final fadeTween = Tween(begin: fadeBegin, end: fadeEnd);
                final fadeAnimation = animation.drive(fadeTween);

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1), // 전환 애니메이션 지속 시간
              fullscreenDialog: true,
            ),
          );
        }
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        height: 30,
                        child: Hero(tag: logo, child: Image.asset(logo)),
                      )
                    ],
                  ),
                ],
              ),
              AnimatedOpacity(
                opacity: _logoVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: Hero(
                  tag: mainPicture,
                  child: Image.asset(
                    mainPicture,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _scrollVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedBuilder(
                          animation: _animation, // 위치 애니메이션
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _animation.value), // y축으로 이동
                              child: const Icon(
                                Icons.keyboard_double_arrow_up_rounded,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
