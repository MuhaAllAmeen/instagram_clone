import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/ic_instagram.svg',height: 32,),
        actions: [
          IconButton(onPressed:() {
            
          }, icon: Icon(Icons.messenger))
        ],
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').snapshots(), 
        builder:(context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          switch(snapshot.connectionState){
            
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index) {
                return Container(
                  child: PostCard(
                    snap: snapshot.data!.docs[index]
                  ),
                );
              },);
         }
      },),
    );
  }
}