import 'dart:async';

import 'package:dmhub/models/lion_user.dart';
import 'package:dmhub/widgets/orange_rounded_button.dart';
import 'package:dmhub/widgets/textbox_widget.dart';
import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

enum ChooseMethod { name, description, track, mbti }

class _MyPageScreenState extends State<MyPageScreen> {
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;
  StreamSubscription<User?>? _authSubscription; // StreamSubscription 변수 추가
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  final String tempimage = "assets/images/myback.jpeg";
  User? _user;
  LionUser? lionUser;

  String buttonLabel = "change name";

  final TextEditingController _controller = TextEditingController();
  ChooseMethod chooseMethodView = ChooseMethod.name;
  String _currentSelect = "name";

  @override
  void initState() {
    super.initState();
    // 사용자의 로그인 상태를 실시간으로 감지
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
        setLionUser();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Firebase Auth 리스너 정리
    _controller.dispose(); // 텍스트 컨트롤러 정리
    super.dispose();
  }

  Future<void> setLionUser() async {
    if (_user != null && _user!.email != null) {
      try {
        DataSnapshot snapshot = await _realtime
            .ref("users")
            .child(_user!.email!.split('@')[0])
            .get();

        if (snapshot.value != null) {
          Map<String, dynamic> toMap = snapshot.value as Map<String, dynamic>;
          setState(() {
            lionUser = LionUser.fromJson(toMap);
          });
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    }
  }

  Future<void> changeInfo() async {
    late String info;
    setState(() {
      info = _controller.text;
    });
    if (_currentSelect == "name") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('success!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      await _realtime
          .ref("users")
          .child(_user!.email!.split('@')[0])
          .update({"name": info});
      setState(() {
        setLionUser();
      });
    } else if (_currentSelect == "description") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'success!',
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
      await _realtime
          .ref("users")
          .child(_user!.email!.split('@')[0])
          .update({"description": info});
      setState(() {
        setLionUser();
      });
    } else if (_currentSelect == "track") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('success!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      await _realtime
          .ref("users")
          .child(_user!.email!.split('@')[0])
          .update({"track": info});
      setState(() {
        setLionUser();
      });
    } else if (_currentSelect == "mbti") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('success!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      await _realtime
          .ref("users")
          .child(_user!.email!.split('@')[0])
          .update({"mbti": info});
      setState(() {
        setLionUser();
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('input again!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TotalAppBar(logo: logo),
      extendBodyBehindAppBar: true, // AppBar 뒤로 내용 연장,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(tempimage), // 배경 이미지 경로
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor, // 배경색
                            borderRadius:
                                BorderRadius.circular(8.0), // 테두리 모서리 둥글게
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                                color: Colors.black.withOpacity(0.3),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 200,
                                child: Image.asset(mainPicture),
                              ),
                              Text(
                                lionUser != null
                                    ? (lionUser!.name != null
                                        ? lionUser!.name!
                                        : "anonymous lion")
                                    : "",
                                style: const TextStyle(
                                  fontFamily: 'Sunflower-Bold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  lionUser != null
                                      ? (lionUser!.description != null
                                          ? lionUser!.description!
                                          : "no description")
                                      : "",
                                  style: const TextStyle(
                                    fontFamily: 'Sunflower-Light',
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                lionUser != null
                                    ? (lionUser!.track != null
                                        ? lionUser!.track!
                                        : "no track")
                                    : "",
                                style: TextStyle(
                                    fontFamily: 'Sunflower-Light',
                                    fontSize: 15,
                                    color: Colors.blue.withOpacity(0.9)),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                lionUser != null
                                    ? (lionUser!.mbti != null
                                        ? lionUser!.mbti!
                                        : "no mbti")
                                    : "",
                                style: TextStyle(
                                    fontFamily: 'Sunflower-Light',
                                    fontSize: 15,
                                    color:
                                        const Color.fromARGB(255, 233, 113, 153)
                                            .withOpacity(0.9)),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ChangeButtonWidget(
                          nameController: _controller,
                          labelText: buttonLabel,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            SegmentedButton<ChooseMethod>(
                              style: SegmentedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                selectedForegroundColor: Colors.white,
                                selectedBackgroundColor: Colors.orange,
                                elevation: 3,
                                shadowColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              segments: const <ButtonSegment<ChooseMethod>>[
                                ButtonSegment<ChooseMethod>(
                                  value: ChooseMethod.name,
                                  label: Text("name"),
                                ),
                                ButtonSegment<ChooseMethod>(
                                  value: ChooseMethod.description,
                                  label: Text("description"),
                                ),
                                ButtonSegment<ChooseMethod>(
                                  value: ChooseMethod.track,
                                  label: Text("track"),
                                ),
                                ButtonSegment<ChooseMethod>(
                                  value: ChooseMethod.mbti,
                                  label: Text("mbti"),
                                )
                              ],
                              selected: <ChooseMethod>{chooseMethodView},
                              onSelectionChanged:
                                  (Set<ChooseMethod> newSelection) {
                                setState(() {
                                  _controller.text = "";
                                  _currentSelect = newSelection.first
                                      .toString()
                                      .split('.')[1];
                                  buttonLabel = "change $_currentSelect";
                                  chooseMethodView = newSelection.first;
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
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
                          child: OrangeRoundedButton(
                            text: "change!",
                            heroTag: "change!",
                            method: changeInfo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OrangeRoundedButton(
                          text: "📸", heroTag: "photo", method: () {})
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeButtonWidget extends StatelessWidget {
  const ChangeButtonWidget({
    super.key,
    required TextEditingController nameController,
    required this.labelText,
  }) : _nameController = nameController;

  final TextEditingController _nameController;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return TextBoxWidget(
      labelText: labelText,
      obscureText: false,
      controller: _nameController,
    );
  }
}
