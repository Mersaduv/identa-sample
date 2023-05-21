import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:identa/screens/ChatPage.dart';
import 'package:identa/widgets/chat/inboxItem.dart';
import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';

class ChatData {
  static List<ChatModel> getChatModels() {
    return [
      ChatModel(
        imageUrl: 'assets/page-1/images/ellipse-5-bg.png',
        title: 'Business',
        lastMessage: 'Hello there!',
        time: '10:30 AM',
        messageCount: '3',
        icon: Icons.business_center_rounded,
      ),
      ChatModel(
        imageUrl: 'assets/page-1/images/ellipse-5-bg.png',
        title: 'Gaming',
        lastMessage: 'How are you?',
        time: '11:45 AM',
        messageCount: '1',
        icon: Icons.videogame_asset,
      ),
      ChatModel(
        imageUrl: 'assets/page-1/images/ellipse-5-bg.png',
        title: 'Time schedule',
        lastMessage: 'What are you up to?',
        time: '2:15 PM',
        messageCount: '5',
        icon: Icons.date_range,
      )
    ];
  }
}
