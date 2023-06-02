import 'package:flutter/material.dart';
import 'package:identa/services/auth/auth_service.dart';

import 'setting_item.widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(right: BorderSide(width: .1))),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30, top: 15),
              ),
              SettingItemWidget(
                onPressed: () async {
                  try {
                    await _authService.signOut();
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
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
