import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';
import 'package:identa/widgets/chat/chat_item.dart';

class InboxPage extends StatelessWidget {
  final List<ChatModel> chats = [
    ChatModel(
      imageUrl: 'path_to_image',
      title: 'Business',
      lastMessage: 'Hello, how are you?',
      time: '10:30 AM',
      messageCount: '3',
      icon: Icons.business_center_rounded,
    ),
    // Add more chat models as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          ChatModel chat = chats[index];
          return ChatItem(
            chatModel: chat,
          );
        },
      ),
    );
  }
}
