import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snap['profImage']),

                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snap['username'],style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )
                ),
                IconButton(onPressed:() {
                  showDialog(context: context, builder:(context) {
                    return Dialog(child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        'Delete'
                      ].map((e) => InkWell(
                        onTap: () {
                          
                        },
                        child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                        child: Text(e),
                      ),
                      )
                      ).toList(),
                    ),
                    );
                  },);
                }, icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(snap['postUrl'],fit: BoxFit.cover,),
          ),
          Row(
            children: [
              IconButton(onPressed:() {
                
              }, icon: const Icon(Icons.favorite,color: Colors.red,)),
              IconButton(onPressed:() {
                
              }, icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed:() {
                
              }, icon: Icon(Icons.send)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(onPressed:() {
                    
                  }, icon: const Icon(Icons.bookmark_add_outlined)),
                )
                )
            ],
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w800), child: Text("${snap['likes'].length} likes",style: Theme.of(context).textTheme.bodySmall,)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "  ${snap['description']}",
                    ),
                  ]
                )),
              ),
              InkWell(
                onTap:() {
                  
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('view all comments',style: TextStyle(fontSize: 16,color: secondaryColor),),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(DateFormat.yMMMMd().format(snap['datePublished'].toDate()),style: TextStyle(fontSize: 16,color: secondaryColor),),
                ),
              ],
          ),)
        ],
      ),
    );
  }
}