import 'package:cloud_firestore/cloud_firestore.dart';

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

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return MyUser(
      email: snapShot["email"],
      uid: snapShot["uid"],
      photoUrl: snapShot["photoUrl"],
      userName: snapShot["userName"],
      bio: snapShot["bio"],
      followers: snapShot["followers"],
      following: snapShot["following"],
    );
  }
}
