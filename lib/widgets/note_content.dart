import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

typedef LoadConversationsCallback = Future<void> Function();

class NotesContent extends StatefulWidget {
  final NoteModel? note;
  final LoadConversationsCallback? loadConversations;
  const NotesContent({Key? key, this.note, required this.loadConversations})
      : super(key: key);
  @override
  _NotesContentState createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  late TextEditingController _titleController;
  // String conversationId = uuid.v4();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
  }

  @override
  Future<void> dispose() async {
    saveConversation(NoteModel(
      title: _titleController.text,
      date: DateTime.now().toString(),
    ));
    widget.loadConversations!();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'New note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2993CF),
      ),
      body: GestureDetector(
        onTap: () {
          // Activate the text field or hide the keyboard
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                ),
                const SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Start typing or recording ...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Remove the bottom line
                  ),
                  maxLines: null,
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2993CF),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
        ),
        onPressed: () {
          // Start audio recording
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void saveConversation(NoteModel note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];

    String noteJson = jsonEncode(note.toJson());
    notes.add(noteJson);
    print(notes);
    await prefs.setStringList('notes', notes);
    widget.loadConversations!();
  }
}
