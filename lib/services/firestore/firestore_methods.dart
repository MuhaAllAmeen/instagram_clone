import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/message_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/storage/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String userName, String profImage) async {
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          likes: [],
          description: description,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          uid: uid,
          userName: userName);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('exception $e');
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String userName, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': userName,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('no text');
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<Map<String, dynamic>>> getUserStream(String currentUser) {
    return _firestore.collection('users').snapshots().map((snapshot) {
    List<dynamic> followingList = snapshot.docs
        .firstWhere((doc) => doc.id == currentUser)
        .data()['following'];

    return snapshot.docs
        .where((doc) => followingList.contains(doc.id))
        .map((doc) => doc.data())
        .toList();
  });
  }

  Future<void> sendMessage(Map<String, dynamic> currentUser,
      Map<String, dynamic> reciever, String text) async {
    final DateTime timeStamp = DateTime.timestamp();
    List<String> id = [currentUser['uid'], reciever['uid']];
    id.sort();
    String chatRoomID = id.join('_');
    Message newMessage = Message(
        senderID: currentUser['uid'],
        recieverID: reciever['uid'],
        timeStamp: timeStamp,
        message: text,
        chatID: chatRoomID
        );
    
    await _firestore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(
      Map<String, dynamic> currentUser, Map<String, dynamic> reciever) {
    List<String> id = [currentUser['uid'], reciever['uid']];
    id.sort();
    String chatRoomID = id.join('_');

    return _firestore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
