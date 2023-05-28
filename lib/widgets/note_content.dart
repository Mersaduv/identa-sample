import 'package:flutter/material.dart';
import 'package:identa/screens/notes.dart' show NoteModel;
import 'note_model.dart';

class NotesContent extends StatefulWidget {
  const NotesContent({Key? key, required this.note}) : super(key: key);

  final NoteModel note;

  @override
  _NotesContentState createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'New note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2993CF),
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
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Start typing or recording ...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Remove the bottom line
                  ),
                  maxLines: null,
                  onTap: () {
                    // Activate the text field or hide the keyboard
                  },
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF2993CF),
        child: Icon(
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
}
