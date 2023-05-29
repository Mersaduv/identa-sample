import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:identa/widgets/note_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NoteModel> notes = [];
  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  void deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? noteJsonList = prefs.getStringList('notes');

    if (noteJsonList != null) {
      noteJsonList.removeAt(index);
      await prefs.setStringList('notes', noteJsonList);
    }

    setState(() {
      notes.removeAt(index);
    });

    loadConversations();
  }

  Future<void> loadConversations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? noteJsonList = prefs.getStringList('notes');
    List<NoteModel> loadedConversations = [];

    if (noteJsonList != null) {
      for (String noteJson in noteJsonList) {
        Map<String, dynamic> noteMap = jsonDecode(noteJson);
        NoteModel note = NoteModel.fromJson(noteMap);
        loadedConversations.add(note);
      }
    }

    setState(() {
      notes = loadedConversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotesContent(loadConversations: loadConversations),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xFF2993CF),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'New note',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1.0,
                    ),
                  ],
                ),
              ),
            );
          }

          final note = notes[index - 1];

          return Dismissible(
            key: Key(note.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Note'),
                    content: const Text(
                        'Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (_) => deleteNote(index - 1),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesContent(
                        note: note, loadConversations: loadConversations),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                            Text(
                              note.date,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
