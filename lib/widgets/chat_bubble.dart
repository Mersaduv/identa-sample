import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isMe;

  const ChatBubble({
    Key? key,
    required this.content,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: isMe ? const Radius.circular(16.0) : Radius.zero,
              topRight: isMe ? Radius.zero : const Radius.circular(16.0),
              bottomLeft: const Radius.circular(16.0),
              bottomRight: const Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(0, 4, 4, 4).withOpacity(0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 4.0),
              ),
            ],
            color: isMe
                ? const Color(0xFF2D9CDB)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
    );
  }
}
