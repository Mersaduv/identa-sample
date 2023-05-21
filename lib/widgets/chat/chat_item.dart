import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';

class ChatItem extends StatelessWidget {
  final ChatModel chatModel;

  const ChatItem({required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(13.0), //or 15.0
            child: Container(
              height: 50.0,
              width: 50.0,
              color: Color.fromARGB(255, 22, 144, 250),
              child: Icon(chatModel.icon, color: Colors.white, size: 35.0),
            ),
          ),
          title: Text(
            chatModel.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              SizedBox(width: 5),
              Text(
                chatModel.lastMessage,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          trailing: Column(
            children: [
              Text(
                chatModel.time,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                child: Text(
                  chatModel.messageCount,
                  style: TextStyle(color: Colors.white),
                ),
                radius: 10,
                backgroundColor: Color.fromARGB(255, 137, 215, 139),
              )
            ],
          ),
          onTap: () {
            // Handle group selection
          },
        ),
        Divider(
          height: 10,
        ),
      ],
    );
  }
}
