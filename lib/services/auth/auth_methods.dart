import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/services/storage/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User?> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap) ?? null;
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String userName,
      required String bio,
      required Uint8List file,
      required Function complete}) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            email: email,
            uid: userCredential.user!.uid,
            photoUrl: photoUrl,
            userName: userName,
            bio: bio,
            following: [],
            followers: []);
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        complete();
        return 'success';
      } else {
        return 'Fill the form';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid_email') {
        return 'invalid email';
      } else if (e.code == 'email-already-in-use') {
        return 'email already in use';
      } else if (e.code == 'weak-password') {
        return 'weak password';
      }
      print('exception $e');
      return e.toString();
    }
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return 'success';
      } else {
        return 'Fill the form';
      }
    } catch (e) {
      print('exception 2 $e');
      return 'error';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
