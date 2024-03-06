import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;
  final List following;
  final List followers;

  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.userName,
      required this.bio,
      required this.following,
      required this.followers});

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'following': following,
        'followers': followers
      };

  static User? fromSnap(DocumentSnapshot snap) {
    if (snap.data() != null) {
      var snapshot = snap.data() as Map<String, dynamic>;
      return User(
        userName: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        photoUrl: snapshot['photoUrl'],
        bio: snapshot['bio'],
        following: snapshot['following'],
        followers: snapshot['followers'],
      );
    } else {
      return null;
    }
  }
}
