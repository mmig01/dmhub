// // lib/google_sign_in_button.dart

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignInButton extends StatelessWidget {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   GoogleSignInButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () async {
//         try {
//           final GoogleSignInAccount? account = await _googleSignIn.signIn();
//           if (account != null) {
//             print('User signed in: ${account.displayName}');
//           } else {
//             print('User not signed in.');
//           }
//         } catch (error) {
//           print('Sign in failed: $error');
//         }
//       },
//       child: const Text('Sign in with Google'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  GoogleLoginButtonState createState() => GoogleLoginButtonState();
}

class GoogleLoginButtonState extends State<GoogleLoginButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user; // Firebase User 객체

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // 사용자가 로그인 취소

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
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Signed in as ${_user?.displayName ?? ''}'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _handleSignOut,
                child: const Text('Sign Out'),
              ),
            ],
          )
        : SizedBox(
            width: 230,
            height: 50,
            child: FloatingActionButton(
              heroTag: 'github_logo',
              backgroundColor: Colors.black,
              splashColor: Colors.white.withOpacity(0.2),
              elevation: 2,
              onPressed: _handleSignIn,
              child: Row(
                children: [
                  Transform.scale(
                      scale: 0.6,
                      child: Image.asset('assets/images/github_logo.png')),
                  const Text(
                    'Continue with Github',
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
