import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String sender;
  final String content;
  final bool isMe;

  const ChatBubble({super.key, required this.sender, required this.content, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4.0),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe ? const Radius.circular(16.0) : Radius.zero,
              topRight: isMe ? Radius.zero : const Radius.circular(16.0),
              bottomLeft: const Radius.circular(16.0),
              bottomRight: const Radius.circular(16.0),
            ),
            elevation: 2.0,
            color: isMe ? const Color(0xFF2D9CDB) : Colors.grey[300],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 46, 44, 44).withOpacity(0.2),
                    blurRadius: 16.0,
                    offset: const Offset(0, 8.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
