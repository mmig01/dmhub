import 'package:flutter/material.dart';
import 'package:dmhub/screens/before_login_screen/home_screen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isFirstNavigated,
  });
  final bool isFirstNavigated;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final String logo = 'assets/images/dk_logo.png';
  bool _logoVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFirstNavigated) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _logoVisible = true;
          });
        }
      });
    } else {
      _logoVisible = true;
    }
    // 위젯이 완전히 빌드된 후에 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 3초 후에 자동으로 다음 페이지로 이동
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomeScreen2(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                final opacityTween = Tween(begin: begin, end: end);
                final opacityAnimation = animation.drive(opacityTween);
                return FadeTransition(
                  opacity: opacityAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1), // 애니메이션의 길이 설정

              fullscreenDialog: true,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                SizedBox(
                  height: 200,
                ),
              ],
            ),
            AnimatedOpacity(
                opacity: _logoVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Hero(tag: logo, child: Image.asset(logo))),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
