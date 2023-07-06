import 'package:flutter/material.dart';
import 'package:identa/core/models/model_core/bot.dart';
import 'package:identa/core/models/model_core/message.dart';
import 'package:identa/core/models/model_core/user.dart';
import 'package:identa/modules/taps_page/chat/chat_bubble.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  User user = User(name: '');
  Bot bot = Bot();
  List<Message> messages = [];
  bool isLoggedIn = false;
  bool isBotTyping = false;

  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  void sendMessage(String message) {
    setState(() {
      messages.add(Message(sender: user.name, message: message));
      isBotTyping = true;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
    ServiceApis.chatResponse(message).then((botResponse) {
      if (botResponse != null) {
        setState(() {
          messages.add(Message(sender: bot.name, message: botResponse));
          isBotTyping = false;
        });
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var future = _authService.signInWithAutoCodeExchange();
    future.then((result) {
      setState(() {
        isLoggedIn = result;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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
        backgroundColor: const Color.fromARGB(255, 241, 245, 255),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: messages
                      .map((message) => ChatBubble(
                            content: message.message,
                            isMe: message.sender == user.name,
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 4.0), // Adjust the right padding as needed
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: Theme.of(context).textTheme.copyWith(
                                    subtitle1: TextStyle(
                                      color: Color(
                                          0xFF9CA3AF), // Set the hint text color to #9CA3AF
                                    ),
                                  ),
                            ),
                            child: ChatTextField(
                              controller: _messageController,
                              isEnabled: !isBotTyping,
                              hint: isBotTyping
                                  ? 'is typing...'
                                  : 'Type a message',
                              onSubmitted: (value) {
                                String messageContent = value.trim();
                                if (messageContent.isNotEmpty) {
                                  sendMessage(messageContent);
                                  _messageController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
