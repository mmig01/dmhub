import 'package:flutter/material.dart';
import 'package:dmhub/screens/before_login_screen/login_screen.dart';
import 'package:dmhub/widgets/go_to_first_screen_widget.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _logoVisible = true;
        });
      }
    });

    // 3초 후에 자동으로 다음 페이지로 이동
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Login(
              isFirstNavigatedSocialLoginButton: true,
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
          ),
        );
      }
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
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        height: 30,
                        child: Hero(
                            tag: logo,
                            child: GoToFirstScreenWidget(logo: logo)),
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
              const Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
