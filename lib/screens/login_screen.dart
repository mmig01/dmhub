import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phomu/screens/test.dart';
import 'signup_screen.dart';
import 'package:phomu/widgets/go_to_first_screen_widget.dart';
import 'package:phomu/widgets/total_login_widget.dart';
import 'package:phomu/widgets/orange_rounded_text.dart';
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

  // 이메일 및 비밀번호 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  // Firebase 로그인 메서드
  Future<void> _loginWithEmailAndPassword() async {
    late String email;
    late String password;

    setState(() {
      email = _emailController.text;
      password = _passwordController.text;
    });

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (mounted && credential.user != null) {
        // 로딩 화면을 잠깐 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(), // 로딩 스피너 표시
            );
          },
        );

        // 약간의 지연을 주고 페이지를 이동
        await Future.delayed(const Duration(seconds: 2));

        // 로딩 화면을 닫고 새 페이지로 이동
        if (mounted) {
          Navigator.of(context).pop(); // 로딩 화면 닫기
        }

        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AuthStateScreen(),
              transitionDuration: const Duration(seconds: 1), // 애니메이션의 길이 설정
              fullscreenDialog: true,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('해당 유저를 찾을 수 없습니다.')),
          );
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('잘못된 패스워드 입니다.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유저를 찾을 수 없습니다. 다시 입력해주세요.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login Form",
                        style: TextStyle(
                          fontFamily: 'Outfit-Bold',
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBoxWidget(
                        labelText: "email",
                        obscureText: false,
                        controller: _emailController, // 컨트롤러 전달
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBoxWidget(
                        labelText: "password",
                        obscureText: true,
                        controller: _passwordController, // 컨트롤러 전달
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
                        color: Colors.orange.withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    child: OrangeRoundedText(
                      text: "Log in",
                      heroTag: "login_tag",
                      method: _loginWithEmailAndPassword,
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
