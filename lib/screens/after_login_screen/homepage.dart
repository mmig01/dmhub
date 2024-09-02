import 'package:dmhub/screens/before_login_screen/home_screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  User? _user;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset(logo),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Study',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'etc',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
                  SizedBox(
                    height: 100,
                    child: Image.asset(mainPicture),
                  ),
                  Text(
                    '${_user?.email}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Outfit-Bold',
                      fontWeight: FontWeight.w100,
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
              onTap: () {
                Navigator.pop(context);
                // 원하는 페이지로 이동
              },
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
                Navigator.pop(context);
                // 원하는 페이지로 이동
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
        // 로그아웃 후 HomeScreen으로 이동
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen2()),
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
