import 'package:identa/Data/chat/chatData.dart';
import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar.dart';
import 'package:identa/widgets/chat/chat_item.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> chatModels = ChatData.getChatModels();
    AuthService _authService = AuthService();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView.builder(
        itemCount: chatModels.length,
        itemBuilder: (context, index) {
          ChatModel chatModel = chatModels[index];
          return ChatItem(chatModel: chatModel);
        },
      ),
    );
  }
}
