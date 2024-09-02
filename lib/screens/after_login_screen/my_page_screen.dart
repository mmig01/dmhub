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
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  User? _user;
  LionUser? lionUser;
  ChooseMethod chooseMethodView = ChooseMethod.name;

  String buttonLabel = "change name";
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;
  final TextEditingController _controller = TextEditingController();

  String _currentSelect = "name";

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 200,
                      child: Image.asset(mainPicture),
                    ),
                    Text(
                      lionUser != null ? lionUser!.name : "",
                      style: const TextStyle(
                        fontFamily: 'Outfit-Bold',
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      lionUser != null
                          ? (lionUser!.description != null
                              ? lionUser!.description!
                              : "no description")
                          : "no description",
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
                          : "no track",
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.blue.withOpacity(0.7)),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      lionUser != null
                          ? (lionUser!.mbti != null
                              ? lionUser!.mbti!
                              : "no mbti")
                          : "no mbti",
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.pink.withOpacity(0.7)),
                    ),
                    const SizedBox(
                      height: 60,
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
                          onSelectionChanged: (Set<ChooseMethod> newSelection) {
                            setState(() {
                              _controller.text = "";
                              _currentSelect =
                                  newSelection.first.toString().split('.')[1];
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
                      width: 180,
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
          ],
        ),
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
