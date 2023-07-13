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

  //Post likes
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

  //Post Comments
  Future<void> postComment(
    String postId,
    String commentContent,
    String uid,
    String profileImage,
    String userName,
  ) async {
    try {
      if (commentContent.isNotEmpty) {
        String commentId = Uuid().v1();
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "profileImage": profileImage,
          "userName": userName,
          "uid": uid,
          "commentContent": commentContent,
          "commentId": commentId,
          "datePublished": DateTime.now(),
          "likes": [],
        });
      } else {
        debugPrint("Text is Empty.");
      }
    } catch (error) {
      debugPrint("Post Comment Error ${error.toString()}");
    }
  }

  //Deleting Post
  Future<void> deletePost(
    String postId,
  ) async {
    try {
      await _fireStore.collection('posts').doc(postId).delete();
    } catch (error) {
      debugPrint("deleting posts error ${error.toString()}");
    }
  }
}
