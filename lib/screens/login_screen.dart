import 'package:flutter/material.dart';

import 'package:phomu/screens/signup_screen.dart';
import 'package:phomu/widgets/go_to_first_screen_widget.dart';
import 'package:phomu/widgets/total_login_widget.dart';
import 'package:phomu/widgets/orange_button.dart';
import 'package:phomu/widgets/textbox_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.isFirstNavigatedSocialLoginButton});

  final bool isFirstNavigatedSocialLoginButton;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  bool _loginColumnVisible = false;
  bool _socialLoginColumnVisible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _loginColumnVisible = true;
      });
    });
    if (widget.isFirstNavigatedSocialLoginButton) {
      Future.delayed(const Duration(milliseconds: 1300), () {
        setState(() {
          _socialLoginColumnVisible = true;
        });
      });
    } else {
      _socialLoginColumnVisible = true;
    }
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
                  height: 50,
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
                        child: GoToFirstScreenWidget(logo: logo),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Hero(
                              tag: mainPicture,
                              child: Image.asset(mainPicture)),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: _loginColumnVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: Column(
                children: [
                  // here
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login Form",
                        style: TextStyle(
                          fontFamily: 'Outfit-Bold',
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextBoxWidget(
                        labelText: "email",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextBoxWidget(
                        labelText: "password",
                        obscureText: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Need an account?",
                        style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignUp(
                                isFirstNavigatedSocialLoginButton: false,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = 0.0;
                                const end = 1.0;
                                final opacityTween =
                                    Tween(begin: begin, end: end);
                                final opacityAnimation =
                                    animation.drive(opacityTween);
                                return FadeTransition(
                                  opacity: opacityAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(seconds: 1), // 애니메이션의 길이 설정

                              fullscreenDialog: true,
                            )),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.1), // 테두리 색 설정
                        width: 1.0, // 테두리 두께 설정
                      ),
                    ),
                    child: const OrangeButton(
                      text: "Log in",
                      heroTag: "login_tag",
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
            TotalLoginWidget(
                socialLoginColumnVisible: _socialLoginColumnVisible),
          ],
        ),
      ),
    );
  }
}
