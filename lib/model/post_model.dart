import 'package:cloud_firestore/cloud_firestore.dart';

class PostMd {
  final String description;
  final String uid;
  final String postId;
  final String userName;
  final dataPublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const PostMd(
      {required this.description,
        required this.uid,
        required this.postId,
        required this.userName,
        required this.dataPublished,
        required this.postUrl,
        required this.profileImage,
        required this.likes,});

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "uid": uid,
      "postId": postId,
      "userName": userName,
      "dataPublished": dataPublished,
      "postUrl": postUrl,
      "profileImage": profileImage,
      "likes": likes,
    };
  }

  static PostMd fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return PostMd(
      description: snapShot["description"],
      uid: snapShot["uid"],
      postId: snapShot["postId"],
      userName: snapShot["userName"],
      dataPublished: snapShot["dataPublished"],
      postUrl: snapShot["postUrl"],
      profileImage: snapShot["profileImage"],
      likes: snapShot["likes"],
    );
  }
}
