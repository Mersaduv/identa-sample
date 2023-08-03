import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:identa/classes/language_constants.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/models/model_core/bot.dart';
import 'package:identa/core/models/model_core/message.dart';
import 'package:identa/core/models/model_core/user.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/taps_page/chat/chat_bubble.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool isLoggedIn = false;
  User user = User(name: '');
  Bot bot = Bot();
  List<Message> messages = [];
  bool isBotTyping = false;
  bool isKeyboardVisible = false;
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
        Future.delayed(const Duration(milliseconds: 1)).then((_) {
          _scrollDown(); // Scroll to the latest message
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 1)).then((_) {
      _scrollDown(); // Scroll to the latest message
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
    context.read<NoteProvider>().loadNotesConversation();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 245, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: isKeyboardVisible ? 300 : 0),
                  child: _buildChatScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: _buildList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _buildInput(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    var messagesList = messages.reversed.toList();
    return ListView.builder(
      controller: _scrollController,
      itemCount: messagesList.length,
      reverse: true,
      itemBuilder: (context, index) {
        var message = messagesList[index];
        return ChatBubble(
          content: message.message,
          isMe: message.sender == user.name,
        );
      },
    );
  }

  Expanded _buildInput() {
    // final isRTL = intl.Bidi.detectRtlDirectionality(_messageController.text);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 4.0), // Adjust the right padding as needed
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                  titleMedium: const TextStyle(
                    color:
                        Color(0xFF9CA3AF), // Set the hint text color to #9CA3AF
                  ),
                ),
          ),
          child: ChatTextField(
            controller: _messageController,
            isEnabled: !isBotTyping,
            hint: isBotTyping
                ? translation(context).isTypings
                : translation(context).typeMessage,
            onSubmitted: (value) {
              String messageContent = value.trim();
              if (messageContent.isNotEmpty) {
                _scrollDown();
                sendMessage(messageContent);
                _messageController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
