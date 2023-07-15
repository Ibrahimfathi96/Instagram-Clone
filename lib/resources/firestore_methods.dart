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
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "something went wrong.";
    try {
      if (likes.contains(uid)) {
        //if the likes list contains the user uid, we need to remove it(dislike)
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        //otherwise we need ti add uid to the likes list (like)
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = 'success';
    } catch (error) {
      res = error.toString();
      debugPrint("like posts errors $res");
    }
    return res;
  }

  //Post Comments
  Future<String> postComment(
    String postId,
    String commentContent,
    String uid,
    String profileImage,
    String userName,
  ) async {
    String res = 'something went wrong';
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
        res = "success";
      } else {
        res = "Please enter a text";
        debugPrint("Text is Empty.");
      }
    } catch (error) {
      res = error.toString();
      debugPrint("Post Comment Error $res");
    }
    return res;
  }

  //Deleting Post
  Future<String> deletePost(
    String postId,
  ) async {
    String res = 'something went wrong';
    try {
      await _fireStore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (error) {
      res = error.toString();
      debugPrint("deleting posts error $res");
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _fireStore.collection('user').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _fireStore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _fireStore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _fireStore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _fireStore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (error) {
      debugPrint("followUserError${error.toString()}");
    }
  }
}
