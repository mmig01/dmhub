import 'dart:async'; // StreamSubscription을 사용하기 위해 추가
import 'package:dmhub/models/lion_user_model.dart';
import 'package:dmhub/screens/after_login_screen/my_page_screen.dart';
import 'package:dmhub/screens/before_login_screen/login_screen.dart';
import 'package:dmhub/widgets/lion_user_info.dart';
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
  LionUserModel? lionUserModel;
  Future<List<LionUserModel>>? users;

  final FirebaseDatabase _realtime = FirebaseDatabase.instance;
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  StreamSubscription<User?>? _authSubscription; // StreamSubscription 변수 추가
  // ScrollController 추가
  final ScrollController _scrollController = ScrollController();
  double _sliderValue = 0;
  @override
  void initState() {
    super.initState();
    // 사용자의 로그인 상태를 실시간으로 감지
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user;
          users = setUsers();
          setLionUserModel();
        });
      }
    });

    // ScrollController의 변화에 따른 Slider 값 업데이트
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final double maxScrollExtent =
            _scrollController.position.maxScrollExtent;
        final double currentScrollPosition = _scrollController.position.pixels;

        setState(() {
          _sliderValue = (currentScrollPosition / maxScrollExtent) * 100;
        });
      }
    });
  }

// Slider 값이 변경될 때 호출되는 함수
  void _onSliderChanged(double value) {
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;

    // Slider의 값을 스크롤 위치로 변환하여 스크롤
    _scrollController.jumpTo(
      (value / 100) * maxScrollExtent,
    );
  }

  Future<List<LionUserModel>> setUsers() async {
    DataSnapshot snapshot = await _realtime.ref("users").get();

    if (snapshot.value != null) {
      DataSnapshot snapshot0 = await _realtime.ref("users").get();
      Map<dynamic, dynamic> toMap = snapshot0.value as Map<dynamic, dynamic>;
      List<LionUserModel> data =
          toMap.values.map((e) => LionUserModel.fromJson(e)).toList();
      return data;
    }
    return [];
  }

  Future<void> setLionUserModel() async {
    if (_user != null && _user!.email != null) {
      try {
        DataSnapshot snapshot = await _realtime
            .ref("users")
            .child(_user!.email!.split('@')[0])
            .get();

        if (snapshot.value != null) {
          Map<String, dynamic> toMap = snapshot.value as Map<String, dynamic>;
          setState(() {
            lionUserModel = LionUserModel.fromJson(toMap);
          });
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    }
  }

  @override
  void dispose() {
    // StreamSubscription 해제
    _authSubscription?.cancel();
    _scrollController.dispose(); // ScrollController 해제
    super.dispose();
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
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 80,
                      child: lionUserModel != null
                          ? lionUserModel!.image != null
                              ? Image.network(lionUserModel!.image!,
                                  fit: BoxFit.cover)
                              : Image.asset(mainPicture)
                          : Image.asset(mainPicture),
                    ),
                    Text(
                      lionUserModel != null
                          ? (lionUserModel!.name != null
                              ? lionUserModel!.name!
                              : "anonymous lion")
                          : "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Sunflower-Bold',
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      lionUserModel != null
                          ? (lionUserModel!.description != null
                              ? lionUserModel!.description!
                              : "no description")
                          : "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Sunflower-Light',
                      ),
                      overflow: TextOverflow.ellipsis,
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
                    fontFamily: 'Sunflower-Light',
                    color: Colors.black,
                    fontSize: 18,
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
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'My Page',
                  style: TextStyle(
                    fontFamily: 'Sunflower-Light',
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
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
                      ),
                      (Route<dynamic> route) => false, // 모든 이전 화면을 제거
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Sunflower-Light',
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _handleSignOut();
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(child: userInfoList(snapshot)), // 하단에 Slider 추가
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Slider(
                      value: _sliderValue,
                      thumbColor: Colors.orange,
                      activeColor: Colors.orange.withOpacity(0.5),
                      min: 0,
                      max: 100,
                      label: _sliderValue.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        _onSliderChanged(value);
                      },
                    ),
                  ),
                  // 끝으로 이동하는 버튼 추가
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  ListView userInfoList(AsyncSnapshot<List<LionUserModel>> snapshot) {
    return ListView.separated(
      controller: _scrollController, // ScrollController 추가
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        var user = snapshot.data![index];
        return LionUserInfo(user: user, mainPicture: mainPicture);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 50,
      ),
    );
  }

  Future<CircularProgressIndicator> _handleSignOut() async {
    try {
      if (mounted) {
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
        }

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop(); // 로딩 화면 닫기
          await FirebaseAuth.instance.signOut();
        }

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
