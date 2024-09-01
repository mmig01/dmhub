import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dmhub/screens/after_login_screen/homepage.dart';
// AuthStateScreen을 import합니다.

class GithubLoginButton extends StatefulWidget {
  const GithubLoginButton({super.key});

  @override
  GithubLoginButtonState createState() => GithubLoginButtonState();
}

class GithubLoginButtonState extends State<GithubLoginButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user; // Firebase User 객체
  StreamSubscription<User?>? _authSubscription; // authStateChanges 구독

  @override
  void initState() {
    super.initState();
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

// dispose에서 authStateChanges 구독을 취소하여 메모리 누수를 방지
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signInWithGitHub() async {
    try {
      // GitHub 인증 제공자를 만듭니다.
      GithubAuthProvider githubProvider = GithubAuthProvider();

      // 팝업을 통해 로그인 시도
      await FirebaseAuth.instance.signInWithPopup(githubProvider);

      if (mounted && _user != null) {
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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Homepage()),
            (Route<dynamic> route) => false, // 모든 이전 화면을 제거
          );
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'cancelled-popup-request') {
        print('팝업이 이미 열려 있거나 취소되었습니다.');
      } else {
        print('Sign In Error: $e');
      }
      // 추가적인 에러 처리를 여기에 할 수 있습니다. 예를 들어, 사용자에게 알림을 표시할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 50,
      child: FloatingActionButton(
        heroTag: 'github_logo',
        backgroundColor: Colors.black,
        splashColor: Colors.white.withOpacity(0.2),
        elevation: 2,
        onPressed: _signInWithGitHub,
        child: Row(
          children: [
            Transform.scale(
                scale: 0.6,
                child: Image.asset('assets/images/github_logo.png')),
            const Text(
              'Continue with GitHub',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
