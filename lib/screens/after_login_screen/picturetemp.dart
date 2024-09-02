import 'dart:io';
import 'dart:typed_data';
import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<Test> {
  final String logo = 'assets/images/dk_logo.png';
  File? _image;
  Uint8List? _selectedImage;
  final databaseRef = FirebaseDatabase.instance.ref(); // Realtime Database 참조
  final storageRef = FirebaseStorage.instance.ref(); // Storage 참조
  User? _user;
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;

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

  Future<void> _pickAndUploadImage() async {
    // 이미지를 선택합니다.
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    setState(() {
      _selectedImage = bytesFromPicker;
    });

    // 파일을 Firebase Storage에 업로드
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
    final uploadTask = storageRef.child(fileName).putData(bytesFromPicker!);

    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();

    // Realtime Database에 URL 저장
    await databaseRef.child('images').push().set({'url': downloadURL});

    print('Image uploaded and URL saved to Realtime Database.');
  }

  Future<void> test() async {
    await _realtime.ref().child("test").set({
      "testId": 123,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TotalAppBar(logo: logo),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           _user?.displayName != null
      //               ? '${_user!.displayName}'
      //               : 'anonymous lion',
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? SizedBox(
                    height: 100,
                    child: Image.memory(_selectedImage!),
                  ) // 선택한 이미지 미리보기
                : const Text('No image selected.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text('Pick and Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
