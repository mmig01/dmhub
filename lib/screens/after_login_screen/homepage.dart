import 'package:dmhub/models/lion_user.dart';
import 'package:dmhub/screens/after_login_screen/my_page_screen.dart';
import 'package:dmhub/screens/before_login_screen/login_screen.dart';
import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  User? _user;
  LionUser? lionUser;
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
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
      setLionUser();
    });
  }

  Future<void> setLionUser() async {
    DataSnapshot snapshot =
        await _realtime.ref("users").child(_user!.email!.split('@')[0]).get();
    Map<String, dynamic> toMap = snapshot.value as Map<String, dynamic>;
    setState(() {
      lionUser = LionUser.fromJson(toMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TotalAppBar(logo: logo),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 90,
                    child: Image.asset(mainPicture),
                  ),
                  Text(
                    lionUser != null
                        ? (lionUser!.name != null
                            ? lionUser!.name!
                            : "anonymous lion")
                        : "anonymous lion",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Outfit-Bold',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    lionUser != null
                        ? (lionUser!.description != null
                            ? lionUser!.description!
                            : "no description")
                        : "no description",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer 아이템들
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Homepage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration:
                        const Duration(milliseconds: 500), // 애니메이션의 길이 설정
                    reverseTransitionDuration:
                        const Duration(milliseconds: 500),
                    fullscreenDialog: false,
                  )),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'My Page',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                if (mounted) {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MyPageScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration:
                            const Duration(milliseconds: 500), // 애니메이션의 길이 설정
                        reverseTransitionDuration:
                            const Duration(milliseconds: 500),
                        fullscreenDialog: false,
                      ));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                _handleSignOut();
              },
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(),
      ),
    );
  }

  Future<CircularProgressIndicator> _handleSignOut() async {
    try {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(), // 로딩 스피너 표시
            );
          },
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop(); // 로딩 화면 닫기
        }
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Login(
                isFirstNavigatedSocialLoginButton: true,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration:
                  const Duration(milliseconds: 500), // 애니메이션의 길이 설정
              reverseTransitionDuration: const Duration(milliseconds: 500),
              fullscreenDialog: false,
            ),
            (Route<dynamic> route) => false, // 모든 이전 화면을 제거
          );
        }
      }
    } catch (e) {
      print('Sign out error: $e');
    }
    return const CircularProgressIndicator();
  }
}
