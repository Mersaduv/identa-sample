import 'package:flutter/material.dart';
import 'package:identa/core/repositories/file_picker_privider.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/core/repositories/notification_provider.dart';
import 'package:identa/modules/audios/audioRecorder/recorder_button.dart';
import 'package:identa/screens/chat.dart'; // import chat screen
import 'package:identa/screens/insights.dart';
import 'package:identa/screens/notes.dart'; // import notes screen
import 'package:identa/widgets/tap_app_bar.dart';
import 'package:identa/widgets/settings/view.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/repositories/permission_repository.dart';

Future<void> main() async {
  await NotificationController.initializeLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<PermissionRepositoryInterface>(
          lazy: true,
          create: (_) => const PermissionRepository(),
        ),
        ChangeNotifierProvider<NoteProvider>(
          create: (_) => NoteProvider(),
        ),
        ChangeNotifierProvider<RecorderButton>(
          create: (_) => RecorderButton(),
        ),
        ChangeNotifierProvider<FilePickerProvider>(
          create: (context) => FilePickerProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        home: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late NoteProvider noteProvider;

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
    noteProvider = context.read<NoteProvider>();
    noteProvider.loadNotesConversation();
    noteProvider.loadInsightsConversation();
    _tabController = TabController(length: 3, vsync: this);
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40.0),
        child: CustomTapAppBar(
          tabController: _tabController,
          openDrawer: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const Settings(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChatScreen(),
          InsightsScreen(),
          NotesScreen(),
        ],
      ),
    );
  }
}
