import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dmhub/screens/home_screen.dart';

class AuthStateScreen extends StatefulWidget {
  const AuthStateScreen({super.key});

  @override
  AuthStateScreenState createState() => AuthStateScreenState();
}

class AuthStateScreenState extends State<AuthStateScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    // 사용자의 로그인 상태를 실시간으로 감지
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('User is logged in as ${_user!.email}'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text('Sign In with Google'),
              ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 로그인 취소

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print('Sign In Error: $error');
    }
  }

  Future<CircularProgressIndicator> _handleSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // 로그아웃 후 HomeScreen으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                    isFirstNavigated: true,
                  )),
          (Route<dynamic> route) => false, // 모든 이전 화면을 제거
        );
      }
    } catch (e) {
      print('Sign out error: $e');
    }
    return const CircularProgressIndicator();
  }
}
