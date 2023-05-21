import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:identa/constants/config.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/screens/ChatPage.dart';
import 'package:identa/services/auth/auth_service.dart';

import 'setting_item.widget.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 15),
            ),
            SettingItemWidget(
              onTapped: () {},
              title: 'Message List',
              onPressed: () => Get.to(ChatPage()),
            ),
            SettingItemWidget(
              onPressed: () async {
                try {
                  await _authService.logOut();
                } catch (e) {
                  print(e.toString()); // print the error message to console
                }
              },
              onTapped: () {},
              title: 'LogOut',
              isInRed: true,
              prefixIcon: Icons.exit_to_app_rounded,
            ),
            SettingItemWidget(
              onTapped: () {},
              title: 'Privacy Policy',
              onPressed: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
