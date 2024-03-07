import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/constants/colors.dart';

class UserTile extends StatelessWidget {
  final String username;
  final String profilePic;
  final void Function()? onTap;
  const UserTile({super.key, required this.username, this.onTap, required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
        decoration: BoxDecoration(
          color: mobileSearchColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
              radius: 16,
            ),
            const SizedBox(width: 10,),
            Text(username)
          ],
        ),
      ),
    );
  }
}