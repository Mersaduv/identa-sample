import 'package:flutter/material.dart';
import 'package:identa_app/models/message.dart';
import 'package:identa_app/widgets/app_bar.dart';
import 'package:identa_app/widgets/chat_bubble.dart';
import 'package:identa_app/models/user.dart';
import 'package:identa_app/models/bot.dart';
import 'package:identa_app/services/apis/api.dart';
import 'package:identa_app/services/apis/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:identa_app/widgets/text_field.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User user = User(name: 'John');
  Bot bot = Bot();
  List<Message> messages = [];

  TextEditingController _messageController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();

  void sendMessage(String content) {
    setState(() {
      messages.add(Message(sender: user.name, content: content));
    });
    ServiceApis.aiResponse(content).then((botResponse) {
      if (botResponse != null) {
        setState(() {
          messages.add(Message(sender: bot.name, content: botResponse));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initial messages
    messages.add(
        Message(sender: bot.name, content: bot.respondToMessage('Hello!')));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Color.fromARGB(255, 216, 227, 253),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = messages[index];
                  return ChatBubble(
                    sender: message.sender,
                    content: message.content,
                    isMe: message.sender == user.name,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ChatTextField(
                controller: _messageController,
                onSubmitted: (value) {
                  String messageContent = value.trim();
                  if (messageContent.isNotEmpty) {
                    sendMessage(messageContent);
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
