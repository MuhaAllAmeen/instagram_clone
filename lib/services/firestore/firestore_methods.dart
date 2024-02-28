import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/storage/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,String userName, String profImage) async{
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      
      String postId = const Uuid().v1();
      Post post = Post(likes: [], description: description, postId: postId, datePublished: DateTime.now(), postUrl: photoUrl, profImage: profImage, uid: uid, userName: userName);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return 'success';
    }catch(e){
      return 'error';
    }
  }
}