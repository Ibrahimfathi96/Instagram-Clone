import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirebaseFireStoreMethods {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //upload Post to firebase fireStore
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String userName,
    String profileImage,
  ) async {
    String res = "some errors occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        "posts",
        file,
        true,
      );
      String postId = Uuid().v1();
      PostMd postMd = PostMd(
        description: description,
        uid: uid,
        postId: postId,
        userName: userName,
        dataPublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _fireStore.collection("posts").doc(postId).set(
            postMd.toJson(),
          );
      res = "success";
    } catch (errors) {
      res = errors.toString();
      debugPrint("Uploading Posts Error $res");
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      debugPrint("like posts errors ${error.toString()}");
    }
  }
}
