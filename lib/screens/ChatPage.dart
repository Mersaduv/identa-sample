import 'package:identa/Data/chat/chatData.dart';
import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar.dart';
import 'package:identa/widgets/chat/chat_item.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  AuthService _authService = AuthService();
  String? accessToken;

  @override
  void initState() {
    super.initState();
    var future = _authService.signInWithAutoCodeExchange();
    future.then((result) {
      if (result != null) {
        setState(() {
          accessToken = result.accessToken!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChatModel> chatModels = ChatData.getChatModels();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView.builder(
        itemCount: chatModels.length,
        itemBuilder: (context, index) {
          ChatModel chatModel = chatModels[index];
          return ChatItem(
            chatModel: chatModel,
          );
        },
      ),
    );
  }
}
