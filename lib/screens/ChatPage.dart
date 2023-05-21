import 'package:get/route_manager.dart';
import 'package:identa/Data/chat/chatData.dart';
import 'package:flutter/material.dart';
import 'package:identa/models/chat/ChatModel.dart';
import 'package:identa/screens/chat.dart';
import 'package:identa/screens/settings/setting_item.widget.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar.dart';
import 'package:identa/widgets/chat/chat_item.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    List<ChatModel> chatModels = ChatData.getChatModels();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'New chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.add_box_outlined,
              size: 40,
              color: Color(0xFF2D9CDB),
            ),
            onTap: () => Get.to(const ChatScreen()),
          ),
          Divider(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatModels.length,
              itemBuilder: (context, index) {
                ChatModel chatModel = chatModels[index];
                return ChatItem(
                  chatModel: chatModel,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
