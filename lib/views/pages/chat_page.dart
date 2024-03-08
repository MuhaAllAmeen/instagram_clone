import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/services/firestore/firestore_methods.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  final Map<String, dynamic> reciever;
  const ChatView(
      {super.key,
      required this.reciever,
      required this.currentUser,
      });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  final FireStoreMethods fireStoreMethods = FireStoreMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await fireStoreMethods.sendMessage(
          widget.currentUser, widget.reciever, messageController.text);
      messageController.clear();
    }
  }

  Widget buildMessageItem(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == widget.currentUser['uid'];
    context
        .read<ChatProvider>()
        .saveLastMessage(data['message'], data['chatID']);

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isCurrentUser
            ? Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        data['message'],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      )),
                  Text(DateFormat.jm().format(data['timestamp'].toDate()))
                ],
              )
            : Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(data['message'],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18))),
                  Text(DateFormat.jm().format(data['timestamp'].toDate()))
                ],
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_outlined)),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.reciever['photoUrl']),
              radius: 16,
            ),
          ],
        ),
        title: Text(widget.reciever['username']),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: fireStoreMethods.getMessages(
                widget.currentUser, widget.reciever),
            builder: (context, snapshot) {
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
                return ListView(
                  children: snapshot.data!.docs
                      .map((e) => buildMessageItem(e))
                      .toList(),
                );
              }
            },
          )),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    hintText: 'Enter Message',
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10))),
              )),
              IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: const Icon(
                    Icons.send,
                    size: 40,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
