import 'package:flutter/material.dart';
import 'package:identa/classes/language.dart';
import 'package:identa/classes/language_constants.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/core/repositories/notification_provider.dart';
import 'package:identa/main.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:identa/widgets/app_bar_content.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'setting_item.widget.dart';
import 'package:identa/screens/profile.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final AuthService _authService = AuthService();
  late NoteProvider noteProvider;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    var future = _authService.signInWithAutoCodeExchange();
    future.then((result) {
      setState(() {
        isLoggedIn = result;
      });
    });
    noteProvider = context.read<NoteProvider>();
    noteProvider.getProfileData();
    noteProvider.downloadProfilePicture();
  }

  void _openLanguagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translation(context).selectYourLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: LanguageList.languageList().length,
            itemBuilder: (context, index) {
              final language = LanguageList.languageList()[index];
              return _buildDialogItem(language);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDialogItem(LanguageList languageList) {
    return Column(
      children: [
        ListTile(
          title: Text(
            languageList.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          trailing: Text(languageList.flag),
          onTap: () async {
            if (languageList != null) {
              Locale _locale = await setLocale(languageList.languageCode);
              MyApp.setLocale(context, _locale);
            }
            Navigator.pop(context); // Close the dialog after selection
          },
        ),
        const Divider(height: 5, thickness: 1.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // var profileProvider = context.read<NoteProvider>();
    var profileProviderDisplay = context.watch<NoteProvider>();
    var profileData = profileProviderDisplay.profileData;
    // print("dataProf ${profileProviderDisplay.profileData!['firstName']}");
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: const Border(right: BorderSide(width: .1)),
      ),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Scaffold(
        appBar: CustomAppBar(
          title: translation(context).settings,
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
                onTapped: () async {
                  await noteProvider.getProfileData();
                  noteProvider.downloadProfilePicture();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(profileData)),
                  );
                },
                title: translation(context).profile,
                prefixIcon: Icons.person,
                onPressed: () async {},
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () async {
                    await NotificationController.createNewNotification();
                  },
                  child: Text("Notification!")),
              const Expanded(child: SizedBox()),
              SettingItemWidget(
                onTapped: _openLanguagePickerDialog,
                title: translation(context).languages,
                prefixIcon: Icons.language,
                onPressed: () {
                  return null;
                },
              ),

              // Fill remaining space
              SettingItemWidget(
                onTapped: () async {
                  try {
                    await _authService.signOut();
                  } catch (e) {
                    print(e.toString()); // print the error message to console
                  }
                },
                onPressed: () {
                  return null;
                },
                title: translation(context).logout,
                isInRed: true,
                prefixIcon: Icons.exit_to_app_rounded,
              ),
              SettingItemWidget(
                onTapped: () {},
                title: translation(context).privacyPolicy,
                prefixIcon: Icons.lock,
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
