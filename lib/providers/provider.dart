import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/auth/auth_methods.dart';
class UserProvider with ChangeNotifier{
  User? _user;
  User get getUser => _user!;
  final AuthMethods _authMethods = AuthMethods();
  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}