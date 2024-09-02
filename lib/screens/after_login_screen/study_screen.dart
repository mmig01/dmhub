import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});
  final String logo = 'assets/images/dk_logo.png';
  final String img = 'assets/images/acho.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TotalAppBar(logo: logo),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "sorry, It's in development.",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )),
    );
  }
}
