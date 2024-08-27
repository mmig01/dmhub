import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  const TextBoxWidget({
    super.key,
    required this.labelText,
    required this.obscureText,
  });

  final String labelText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // 배경색
        borderRadius: BorderRadius.circular(8.0), // 테두리 모서리 둥글게
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상
            spreadRadius: 1, // 그림자 확산 정도
            blurRadius: 2, // 그림자 흐림 정도
            offset: const Offset(0, 1), // 그림자 위치 (x, y)
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffd76833), // 기본 상태의 테두리 색상
              width: 1.2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffd76833), // 포커스 상태의 테두리 색상
              width: 2.0, // 테두리 두께
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // 오류 상태의 테두리 색상
              width: 2.0, // 테두리 두께
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Outfit-Regular',
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
