import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phomu/screens/test.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  GoogleLoginButtonState createState() => GoogleLoginButtonState();
}

class GoogleLoginButtonState extends State<GoogleLoginButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user; // Firebase User 객체

  StreamSubscription<User?>? _authSubscription; // authStateChanges 구독 취소를 위해 추가

  @override
  void initState() {
    super.initState();
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  // dispose에서 authStateChanges 구독을 취소하여 메모리 누수를 방지
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // 로그인 취소
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (error) {
      print('Sign In Error: $error');
    }

    if (mounted && _user != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AuthStateScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 50,
      child: FloatingActionButton(
        heroTag: 'google_logo',
        backgroundColor: Colors.white,
        elevation: 2,
        onPressed: _handleSignIn,
        child: Row(
          children: [
            Transform.scale(
                scale: 0.6,
                child: Image.asset('assets/images/google_logo.png')),
            const Text(
              'Continue with Google',
              style: TextStyle(
                  color: Colors.blue,
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
