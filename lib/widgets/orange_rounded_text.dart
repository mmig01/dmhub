import 'package:flutter/material.dart';

class OrangeRoundedText extends StatelessWidget {
  const OrangeRoundedText({
    super.key,
    required this.text,
    required this.heroTag,
    required this.method,
  });

  final String text;
  final String heroTag;
  final void Function() method;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: const Color(0xffd76833),
      splashColor: Colors.white.withOpacity(0.2),
      elevation: 2,
      onPressed: method,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Outfit-Bold',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
