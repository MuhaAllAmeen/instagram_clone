import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/auth/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User? get getUser => _user;
  Future<void> refreshUser() async {
    User? user = await _authMethods.getUserDetails();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}

class ChatProvider with ChangeNotifier{
  String message = '';
  String chatID = '';
  Map<String,String> messageUid = {};
  Map<String,String>? get getMessage => messageUid;
  Future<void> saveLastMessage(String latestMessage,String chatID) async{
    await Future.delayed(const Duration(milliseconds: 100));
    print(latestMessage);
    print(chatID);
    message = latestMessage;
    chatID = chatID;
    messageUid.addEntries({chatID:message}.entries);
    print(messageUid);
    notifyListeners();
  }
}
