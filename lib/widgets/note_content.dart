import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/apis/api.dart';
import 'note_model.dart';

typedef LoadConversationsCallback = Future<void> Function();

class NotesContent extends StatefulWidget {
  final NoteModel? note;
  // final bool? isLoading;
  final LoadConversationsCallback? loadConversations;
  const NotesContent({Key? key, this.note, required this.loadConversations})
      : super(key: key);
  @override
  NotesContentState createState() => NotesContentState();
}

class NotesContentState extends State<NotesContent> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late FocusNode _detailsFocusNode;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _detailsController = TextEditingController();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _detailsController.text = widget.note!.details;
    }

    _detailsFocusNode = FocusNode();
  }

  @override
  void dispose() async {
    if (widget.note == null) {
      saveConversation(NoteModel(
        id: "0",
        title: _titleController.text,
        details: _detailsController.text,
        date: DateFormat('dd MMM, hh:mm a').format(DateTime.now()),
      ));
    }

    widget.loadConversations!();

    _titleController.dispose();
    _detailsController.dispose();
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
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_detailsFocusNode);
                  },
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    hintText: 'Details note , Start typing or recording ... ',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Remove the bottom line
                  ),
                  maxLines: null,
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                  focusNode: _detailsFocusNode,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
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
    widget.loadConversations!();
    if (_titleController.text.isNotEmpty) {
      ServiceApis.storeNote(note);

      widget.loadConversations!();
    }
  }
}
