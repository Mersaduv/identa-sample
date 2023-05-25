import 'package:flutter/material.dart';
import 'package:identa/models/message.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar.dart';
import 'package:identa/widgets/chat_bubble.dart';
import 'package:identa/models/user.dart';
import 'package:identa/models/bot.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
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
        appBar: const CustomAppBar(),
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
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
              padding: const EdgeInsets.only(top: 4.0), // Add padding here
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ChatTextField(
                          controller: _messageController,
                          isEnabled: !isBotTyping,
                          hint: isBotTyping ? 'is typing...' : 'Type a message',
                          onSubmitted: (value) {
                            String messageContent = value.trim();
                            if (messageContent.isNotEmpty) {
                              sendMessage(messageContent);
                              _messageController.clear();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                          onPressed: () async {},
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
