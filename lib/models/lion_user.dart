class LionUser {
  final String name;
  final String? description, mbti, track, photo, background;

  LionUser(this.photo, this.background,
      {required this.name,
      required this.description,
      required this.mbti,
      required this.track});
  LionUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        mbti = json['mbti'],
        track = json['track'],
        photo = json['photo'],
        background = json['background'];
}
