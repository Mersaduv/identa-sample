import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:identa/constants/colors.dart';
import 'package:intl/intl.dart' as intl;

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
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
    final ValueNotifier<TextDirection> _textDir =
        ValueNotifier(TextDirection.ltr);

    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(
                0, 0), // Offset the shadow to be above the TextField
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: ValueListenableBuilder<TextDirection>(
                      valueListenable: _textDir,
                      builder: (context, value, child) {
                        return TextField(
                          controller: widget.controller,
                          enabled: widget.isEnabled,
                          style: const TextStyle(color: Color(0xFF4B5563)),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: widget.hint,
                            hintStyle: const TextStyle(
                              color: Color(
                                0xFF9CA3AF, // Set the hint text color to #9CA3AF
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          textDirection: _textDir.value,
                          onChanged: (input) {
                            final isRTL =
                                intl.Bidi.detectRtlDirectionality(input);
                            if (isRTL) {
                              _textDir.value = TextDirection.rtl;
                            } else {
                              _textDir.value = TextDirection.ltr;
                            }
                          },
                          onSubmitted: widget.onSubmitted,
                          autofocus: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (!widget.isEnabled)
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: const SpinKitThreeBounce(
                    color: MyColors.primaryColor,
                    size: 14,
                  ),
                ),
              if (widget.isEnabled)
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF4B5563),
                  ),
                  onPressed: () {
                    widget.onSubmitted(widget.controller.text.trim());
                    widget.controller.clear();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
