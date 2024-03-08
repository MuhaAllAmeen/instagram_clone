import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  final String username;
  final String profilePic;
  final void Function()? onTap;
  final String chatRoomID;
  const UserTile({super.key, required this.username, this.onTap, required this.profilePic, required this.chatRoomID});

  @override
  State<UserTile> createState() => _UserTileState();
}


class _UserTileState extends State<UserTile> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String message;
    try{
      message = context.watch<ChatProvider>().getMessage![widget.chatRoomID].toString();
      if(message == 'null'){
        message = 'Start a conversation!';
      }
    }catch(e){
      message = 'Start a conversation!';
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: mobileSearchColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePic),
              radius: 24,
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.username,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text(message,style: TextStyle(color: message=='Start a conversation!' ? Colors.grey : Colors.white),)      
              ],
            )
          ],
        ),
      ),
    );
  }
}