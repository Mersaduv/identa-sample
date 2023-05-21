import 'package:flutter/material.dart';

class ChatModel {
  final String title;
  final String imageUrl;
  final String lastMessage;
  final String time;
  final String messageCount;
  final IconData icon;

  ChatModel({
    required this.title,
    required this.imageUrl,
    required this.lastMessage,
    required this.time,
    required this.messageCount,
    required this.icon,
  });
}
