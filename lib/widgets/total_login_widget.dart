import 'package:flutter/material.dart';
import 'package:dmhub/widgets/social_login_widgets/github_login_button.dart';
import 'package:dmhub/widgets/social_login_widgets/google_login_button.dart';

class TotalLoginWidget extends StatelessWidget {
  const TotalLoginWidget({
    super.key,
    required bool socialLoginColumnVisible,
  }) : _socialLoginColumnVisible = socialLoginColumnVisible;

  final bool _socialLoginColumnVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _socialLoginColumnVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Column(
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
            height: 40,
          ),
          const GoogleLoginButton(),
          const SizedBox(
            height: 15,
          ),

          // duplicate,,
          const GithubLoginButton(),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
