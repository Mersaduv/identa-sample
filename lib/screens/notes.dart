import 'package:flutter/material.dart';
import 'package:identa/widgets/note_content.dart';
import '../widgets/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NoteModel> notes = [
    NoteModel(
      title: 'Note 1',
      date: 'May 1, 2023',
    ),
    NoteModel(
      title: 'Note 2',
      date: 'May 2, 2023',
    ),
    NoteModel(
      title: 'Note 3',
      date: 'May 3, 2023',
    ),
    // Add more notes as needed
  ];

  void addNewNote() {
    setState(() {
      notes.insert(
        0,
        NoteModel(
          title: 'New Note',
          date: DateTime.now().toString(),
        ),
      );
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
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
                  addNewNote();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesContent(note: notes.first),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
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
                              color: Color(0xFF2993CF),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
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
                    SizedBox(height: 8.0),
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
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete Note'),
                    content: Text('Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('Yes'),
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
                    builder: (context) => NotesContent(note: note),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                            Text(
                              note.date,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
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
