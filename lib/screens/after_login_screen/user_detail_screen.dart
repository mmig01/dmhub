import 'package:dmhub/models/lion_user_model.dart';
import 'package:dmhub/widgets/total_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen(
      {super.key, required this.user, required this.mainPicture});
  final LionUserModel user;
  final String mainPicture;
  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final String logo = 'assets/images/dk_logo.png';

  late SharedPreferences prefs;
  bool isLiked = false;

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
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TotalAppBar(
        logo: logo,
      ),

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
                          Hero(
                            tag: widget.user.name!,
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                            image: NetworkImage(widget
                                                .user.image!), // 배경 이미지 경로
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            widget.user.mbti != null
                                ? widget.user.mbti!
                                : "no mbti",
                            style: TextStyle(
                                fontFamily: 'Sunflower-Light',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: const Color.fromARGB(255, 233, 113, 153)
                                    .withOpacity(0.9)),
                          ),
                          const SizedBox(
                            height: 10,
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
