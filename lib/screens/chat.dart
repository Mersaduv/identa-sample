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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final FlutterAppAuth _appAuth = const FlutterAppAuth();

  User user = User(name: 'John');
  Bot bot = Bot();
  List<Message> messages = [];
  String accessToken = '';

  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  void sendMessage(String message) {
    setState(() {
      messages.add(Message(sender: user.name, message: message));
    });
    ServiceApis.chatResponse(accessToken, message).then((botResponse) {
      if (botResponse != null) {
        setState(() {
          messages.add(Message(sender: bot.name, message: botResponse));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    var future = _authService.signInWithAutoCodeExchange();
    future.then((result) {
      if (result != null) {
        setState(() {
          accessToken = result.accessToken!;
        });
      }
    });
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
        appBar: const CustomAppBar(),
        backgroundColor: const Color.fromARGB(255, 216, 227, 253),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = messages[index];
                  return ChatBubble(
                    sender: message.sender,
                    content: message.message,
                    isMe: message.sender == user.name,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
