import 'dart:async';
import 'dart:typed_data';
import 'package:dmhub/models/lion_user_model.dart';
import 'package:dmhub/widgets/orange_rounded_button.dart';
import 'package:dmhub/widgets/textbox_widget.dart';
import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

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

  final storageRef = FirebaseStorage.instance.ref(); // Storage 참조
  User? _user;
  LionUserModel? lionUserModel;

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
        setLionUserModel();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Firebase Auth 리스너 정리
    _controller.dispose(); // 텍스트 컨트롤러 정리
    super.dispose();
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

  Future<void> _pickAndUploadImage() async {
    if (_user != null && _user!.email != null) {
      try {
        // 지정된 사용자 디렉토리의 참조를 가져옵니다.
        final userImagesRef = storageRef.child('images/${_user!.email}');

        // 해당 디렉토리 내의 모든 파일을 가져옵니다.
        final listResult = await userImagesRef.listAll();

        // 모든 파일을 반복하면서 삭제합니다.
        for (var item in listResult.items) {
          await item.delete();
        }
        // 이미지를 선택합니다.
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

        // 파일을 Firebase Storage에 업로드
        String fileName =
            'images/${_user!.email}/${DateTime.now().millisecondsSinceEpoch}.png';
        final uploadTask = storageRef.child(fileName).putData(bytesFromPicker!);

        final snapshot = await uploadTask;
        final downloadURL = await snapshot.ref.getDownloadURL();

        // Realtime Database에 URL 저장
        await _realtime
            .ref("users")
            .child(_user!.email!.split('@')[0])
            .update({'image': downloadURL});
        if (mounted) {
          setState(() {
            setLionUserModel();
          });
        }
      } catch (e) {
        print(e);
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
        setLionUserModel();
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
        setLionUserModel();
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
        setLionUserModel();
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
        setLionUserModel();
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
      body: SingleChildScrollView(
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
                        borderRadius: BorderRadius.circular(8.0), // 테두리 모서리 둥글게
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            height: 200,
                            child: lionUserModel != null
                                ? lionUserModel!.image != null
                                    ? Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(lionUserModel!
                                                .image!), // 배경 이미지 경로
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Image.asset(mainPicture)
                                : Image.asset(mainPicture),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            lionUserModel != null
                                ? (lionUserModel!.name != null
                                    ? lionUserModel!.name!
                                    : "anonymous lion")
                                : "",
                            style: const TextStyle(
                              fontFamily: 'Sunflower-Bold',
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              lionUserModel != null
                                  ? (lionUserModel!.description != null
                                      ? lionUserModel!.description!
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
                            lionUserModel != null
                                ? (lionUserModel!.track != null
                                    ? lionUserModel!.track!
                                    : "no track")
                                : "",
                            style: TextStyle(
                                fontFamily: 'Sunflower-Light',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.withOpacity(0.9)),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            lionUserModel != null
                                ? (lionUserModel!.mbti != null
                                    ? lionUserModel!.mbti!
                                    : "no mbti")
                                : "",
                            style: TextStyle(
                                fontFamily: 'Sunflower-Light',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: const Color.fromARGB(255, 233, 113, 153)
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 96,
                        ),
                        ChangeButtonWidget(
                          nameController: _controller,
                          labelText: buttonLabel,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OrangeRoundedButton(
                                  text: "📸",
                                  heroTag: "photo",
                                  method: _pickAndUploadImage)
                            ],
                          ),
                        )
                      ],
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
                            ),
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
