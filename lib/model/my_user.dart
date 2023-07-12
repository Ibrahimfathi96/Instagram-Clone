class MyUser {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  const MyUser(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.userName,
      required this.bio,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "uid": uid,
      "photoUrl": photoUrl,
      "userName": userName,
      "bio": bio,
      "followers": followers,
      "following": following,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      email: json["email"],
      uid: json["uid"],
      photoUrl: json["photoUrl"],
      userName: json["userName"],
      bio: json["bio"],
      followers: List.of(json["followers"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
      following: List.of(json["following"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
    );
  }
//
}
