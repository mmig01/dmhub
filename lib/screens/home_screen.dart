import 'package:flutter/material.dart';
import 'package:phomu/screens/home_screen2.dart';

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
        setState(() {
          _logoVisible = true;
        });
      });
    } else {
      _logoVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
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
          )),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
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
