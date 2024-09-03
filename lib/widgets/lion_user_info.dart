import 'package:dmhub/models/lion_user_model.dart';
import 'package:dmhub/screens/after_login_screen/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LionUserInfo extends StatefulWidget {
  const LionUserInfo({
    super.key,
    required this.user,
    required this.mainPicture,
  });

  final LionUserModel user;
  final String mainPicture;

  @override
  State<LionUserInfo> createState() => _LionUserInfoState();
}

class _LionUserInfoState extends State<LionUserInfo> {
  late SharedPreferences prefs;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likes = prefs.getStringList('likes');
    if (likes != null) {
      if (likes.contains(widget.user.email)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likes', []);
    }
  }

  void onHeartTap() async {
    final likes = prefs.getStringList('likes');
    if (likes != null) {
      if (isLiked) {
        likes.remove(widget.user.email);
      } else {
        likes.add(widget.user.email!);
      }
      await prefs.setStringList('likes', likes);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UserDetailScreen(
                    user: widget.user,
                    mainPicture: widget.mainPicture,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration:
                      const Duration(milliseconds: 700), // 애니메이션의 길이 설정
                  reverseTransitionDuration: const Duration(milliseconds: 700),
                  fullscreenDialog: false,
                ),
                (Route<dynamic> route) => false); // 모든 이전 화면을 제
          }
        },
        child: Column(
          children: [
            Container(
              width: 250,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: const Offset(8, 8),
                    color: Colors.black.withOpacity(0.3),
                  )
                ],
              ),
              child: Container(
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
                    Hero(
                      tag: widget.user.name!,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 200,
                          child: widget.user.image != null
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.user.image!), // 배경 이미지 경로
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Image.asset(widget.mainPicture)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.user.name != null
                          ? widget.user.name!
                          : "anonymous lion",
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
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.user.description != null
                            ? widget.user.description!
                            : "no description",
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
                      widget.user.track != null
                          ? widget.user.track!
                          : "no track",
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
                      widget.user.mbti != null ? widget.user.mbti! : "no mbti",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: onHeartTap,
                            icon: Icon(isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
