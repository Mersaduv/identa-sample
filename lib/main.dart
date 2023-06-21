import 'package:flutter/material.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/core/repositories/storage_repository.dart';
import 'package:identa/screens/chat.dart'; // import chat screen
import 'package:identa/screens/insights.dart';
import 'package:identa/screens/notes.dart'; // import notes screen
import 'package:identa/widgets/tap_app_bar.dart';
import 'package:identa/widgets/settings/view.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/repositories/permission_repository.dart';

void main() {
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
        Provider<StorageRepositoryInterface>(
          lazy: true,
          create: (_) => StorageRepository(),
          dispose: (_, repository) => repository.onDispose(),
        ),
        ChangeNotifierProvider<NoteProvider>(
          create: (_) => NoteProvider(),
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
  @override
  void initState() {
    super.initState();
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
