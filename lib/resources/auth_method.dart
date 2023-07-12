import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/my_user.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //user signing up
  Future<String> userSignUp({
    required String email,
    required String password,
    required String userName,
    required String bio,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        //register
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file!, false);
        //add user to our database
        MyUser myUser = MyUser(
          email: email,
          uid: credential.user!.uid,
          photoUrl: photoUrl,
          userName: userName,
          bio: bio,
          followers: [],
          following: [],
        );
        await _fireStore.collection("user").doc(credential.user!.uid).set(
              myUser.toJson(),
            );
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> userLogin(
      {required String email, required String password}) async {
    String res = 'something went wrong';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "successfully logged in";
      } else {
        res = "all Fields are required";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}