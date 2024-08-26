import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  final String logo = 'assets/images/dk_logo.png';
  final String mainPicture = "assets/images/dm_hub.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    height: 30,
                    child: Hero(
                      tag: logo,
                      child: Image.asset(logo),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Hero(
                            tag: mainPicture, child: Image.asset(mainPicture)),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login Form",
                    style: TextStyle(
                      fontFamily: 'Outfit-Bold',
                      fontSize: 33,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffd76833), // 기본 상태의 테두리 색상
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffd76833), // 포커스 상태의 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, // 오류 상태의 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "email",
                        labelStyle: TextStyle(
                          fontFamily: 'Outfit-Regular',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffd76833), // 기본 상태의 테두리 색상
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffd76833), // 포커스 상태의 테두리 색상
                            width: 1.8, // 테두리 두께
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, // 오류 상태의 테두리 색상
                            width: 1.8, // 테두리 두께
                          ),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "password",
                        labelStyle: TextStyle(
                          fontFamily: 'Outfit-Regular',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // here

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 1.0, // 구분선의 높이 (두께)
                    width: 100,
                    color: Colors.grey.withOpacity(0.3), // 구분선 색상
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  const Text(
                    "or",
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
                  ),
                  Container(
                    height: 1.0, // 구분선의 높이 (두께)
                    width: 100,
                    color: Colors.grey.withOpacity(0.3), // 구분선 색상
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2), // 테두리 색 설정
                    width: 1.0, // 테두리 두께 설정
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: 'kakao_logo',
                  backgroundColor: const Color(0xfffedc3f),
                  elevation: 3,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Transform.scale(
                          scale: 0.6,
                          child: Image.asset('assets/images/kakao_logo.png')),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Continue with Kakao',
                        style: TextStyle(
                            color: Color(0xff392929),
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // duplicate,,
              Container(
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(1), // 테두리 색 설정
                    width: 1.0, // 테두리 두께 설정
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: 3,
                  backgroundColor: Colors.black,
                  splashColor: Colors.white.withOpacity(0.2),
                  elevation: 2,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Transform.scale(
                          scale: 0.6,
                          child: Image.asset('assets/images/github_logo.png')),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Continue with Github',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
