import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const ChatTextField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: widget.onSubmitted,
              autofocus: true, // Added autofocus property
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              widget.onSubmitted(widget.controller.text.trim());
              widget.controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
