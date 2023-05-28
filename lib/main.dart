import 'package:flutter/material.dart';
import 'package:identa/screens/chat.dart'; // import chat screen
import 'package:identa/screens/insights.dart'; // import insights screen
import 'package:identa/screens/notes.dart'; // import notes screen
import 'package:identa/widgets/app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40.0),
        child: CustomAppBar(tabController: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatScreen(),
          ChatScreen(),
          NotesScreen(),
        ],
      ),
    );
  }
}
