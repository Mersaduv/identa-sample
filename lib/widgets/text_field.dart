import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final bool isEnabled;
  final String hint;

  const ChatTextField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    this.isEnabled = true,
    this.hint = 'Type your message...',
  }) : super(key: key);

  @override
  ChatTextFieldState createState() => ChatTextFieldState();
}

class ChatTextFieldState extends State<ChatTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation1 = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );
    _animation2 = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0),
        reverseCurve: Curves.easeInOut,
      ),
    );
    _animation3 = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0),
        reverseCurve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              enabled: widget.isEnabled,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: widget.onSubmitted,
              autofocus: true,
            ),
          ),
          if (!widget.isEnabled)
            SizedBox(
              width: 30,
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, _animation1.value),
                        child: Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(right: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, _animation2.value),
                        child: Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(right: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, _animation3.value),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          if (widget.isEnabled)
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
