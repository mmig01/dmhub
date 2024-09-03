class LionUserModel {
  final String? name;
  final String? description, mbti, track, image, email;

  LionUserModel(this.image, this.email,
      {required this.name,
      required this.description,
      required this.mbti,
      required this.track});
  LionUserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        mbti = json['mbti'],
        track = json['track'],
        image = json['image'],
        email = json['email'];
}
