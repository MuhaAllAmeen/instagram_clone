import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/services/firestore/firestore_methods.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/views/pages/chat_page.dart';
import 'package:instagram_clone/widgets/user_tile.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool isShowUser = false;
  final TextEditingController searchController = TextEditingController();
  final FireStoreMethods fireStoreMethods = FireStoreMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildUserListItem(
      User currentUser, Map<String, dynamic> userData, BuildContext context) {
    List<String> id = [currentUser.uid, userData['uid']];
    id.sort();
    String chatRoomID = id.join('_');
    return UserTile(
      username: userData['username'],
      profilePic: userData['photoUrl'],
      chatRoomID: chatRoomID,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatView(
            currentUser: currentUser.toJson(),
            reciever: userData,
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
          title: TextFormField(
        controller: searchController,
        decoration: const InputDecoration(labelText: 'Search for a user'),
        onFieldSubmitted: (value) {
          setState(() {
            isShowUser = true;
          });
        },
      )),
      body: StreamBuilder(
        stream: fireStoreMethods.getUserStream(user.uid),
        builder: (context, snapshot) {
          // print(snapshot);
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListView(
                children: snapshot.data!
                    .map<Widget>(
                        (userData) => _buildUserListItem(user, userData, context))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
