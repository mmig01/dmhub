import 'package:dmhub/models/lion_user_model.dart';
import 'package:dmhub/screens/after_login_screen/user_detail_screen.dart';
import 'package:flutter/material.dart';

class LionUserInfo extends StatelessWidget {
  const LionUserInfo({
    super.key,
    required this.user,
    required this.mainPicture,
  });

  final LionUserModel user;
  final String mainPicture;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                UserDetailScreen(
              user: user,
              mainPicture: mainPicture,
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
          )),
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
                    tag: user.name!,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        height: 200,
                        child: user.image != null
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(user.image!), // 배경 이미지 경로
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Image.asset(mainPicture)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    user.name != null ? user.name! : "anonymous lion",
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
                      user.description != null
                          ? user.description!
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
                    user.track != null ? user.track! : "no track",
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
                    user.mbti != null ? user.mbti! : "no mbti",
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
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
