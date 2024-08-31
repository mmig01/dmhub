import 'package:flutter/material.dart';
import 'package:dmhub/screens/home_screen.dart';

class GoToFirstScreenWidget extends StatelessWidget {
  const GoToFirstScreenWidget({
    super.key,
    required this.logo,
  });

  final String logo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomeScreen(
                isFirstNavigated: false,
              ),
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
        child: Image.asset(logo));
  }
}
