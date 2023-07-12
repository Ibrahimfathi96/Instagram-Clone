import 'package:flutter/material.dart';
import 'package:instagram_clone/model/my_user.dart';
import 'package:instagram_clone/resources/auth_method.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _user;

  final AuthMethods _authMethods = AuthMethods();

  MyUser get getUser => _user!;

  Future<void> refreshUser() async {
    MyUser user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}