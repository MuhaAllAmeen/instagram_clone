import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String postId;
  final String userName;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({required this.likes,required this.description,required this.postId,required this.datePublished,required this.postUrl,required this.profImage, required this.uid, required this.userName});

  Map<String,dynamic> toJson() => {
    'description':description,
    'uid':uid,    
    'postId': postId,
    'username':userName,
    'datePublished':datePublished,
    'postUrl':postUrl,
    'profImage':profImage,
    'likes':likes
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return Post(
      userName: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
