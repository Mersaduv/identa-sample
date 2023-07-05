import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:open_settings/open_settings.dart';

import 'setting_item.widget.dart';
import 'package:identa/screens/profile.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final AuthService _authService = AuthService();

  static ReceivedAction? initialAction;

  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    //? display notification content
    // if (!isAllowed) isAllowed = await displayNotificationRationale();

    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      isAllowed = await AwesomeNotifications().isNotificationAllowed();
    }

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Business today',
            body: "identa: A most important rule",
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  //? display notification content
  // static Future<bool> displayNotificationRationale() async { };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: const Border(right: BorderSide(width: .1)),
      ),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Settings',
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
            children: [
              const SizedBox(height: 15), // Add space at the top
              SettingItemWidget(
                onTapped: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                title: 'Profile',
                prefixIcon: Icons.person,
                onPressed: () async {},
              ),
              const Expanded(child: SizedBox()),
              const ElevatedButton(
                  onPressed: createNewNotification,
                  child: Text("Notification!")),
              const Expanded(child: SizedBox()), // Fill remaining space
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
