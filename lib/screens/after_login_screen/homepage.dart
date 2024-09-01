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
              Row(
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Outfit-Bold',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Docs',
                        style: TextStyle(
                          fontFamily: 'Outfit-Bold',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'API',
                        style: TextStyle(
                          fontFamily: 'Outfit-Bold',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
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
                    ),
                  ),
                ],
              ),
            ),
            // Drawer 아이템들
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // 원하는 페이지로 이동
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // 원하는 페이지로 이동
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Outfit-Regular'),
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
