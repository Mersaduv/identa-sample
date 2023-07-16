import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/widgets/dismissible_background.dart';
import 'package:identa/widgets/loading/cardSkeleton.dart';
import 'package:identa/modules/taps_page/notes_tap/note_content.dart';
import 'package:provider/provider.dart';
import 'package:identa/core/models/model_core/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var noteProvider = context.read<NoteProvider>();
      noteProvider.setIsLoading(true); // Check the value of isLoadBack here
      int delay = noteProvider.isLoadBack ? 0 : 600;
      Future.delayed(Duration(milliseconds: delay), () {
        noteProvider.setIsLoadBack(false);
        noteProvider.setIsLoading(false);
      });

      noteProvider.loadNotesConversation();
    });
  }

  @override
  Widget build(BuildContext context) {
    var noteProvider = context.watch<NoteProvider>();
    var notes = noteProvider.notes;
    var loading = noteProvider;
    return Scaffold(
      body: loading.isLoading
          ? Padding(
              padding: const EdgeInsets.all(18),
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const CardSkelton(),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(height: defaultPadding),
                ),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[notes.length - index - 1];

                return Dismissible(
                  key: Key(note.title),
                  direction: DismissDirection.endToStart,
                  background: const DismissibleBackground(),
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
                  onDismissed: (_) {
                    noteProvider.deleteNote(note);
                    context.notify = 'note dismissed';
                  },
                  child: GestureDetector(
                    onTap: () async {
                      if (note.title.isEmpty) {
                        final defaultNote = NoteModel(
                          id: note.id,
                          title: 'New Note',
                          details: note.details,
                          date: note.date,
                        );
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesContent(note: note),
                          ),
                        );
                      } else {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesContent(note: note),
                          ),
                        );
                      }
                      noteProvider.setIsLoadBack(true);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(13.0),
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                color: const Color(0xFF2993CF),
                                child: Center(
                                  child: Text(
                                    note.title.split(" ").length == 1 ||
                                            note.title.length == 1
                                        ? note.title
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : note.title
                                            .split(" ")
                                            .take(2)
                                            .map((w) => w[0].toUpperCase())
                                            .join(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              note.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      note.details,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyles.small
                                          .copyWith(color: Color(0xFF4B5563)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              note.date,
                              style: MyTextStyles.small,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: Transform.scale(
          scale: 1.1, // Adjust the scale value as needed
          child: FloatingActionButton(
            onPressed: () {
              // noteProvider.setIsLoadBack(true);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotesContent(),
                ),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: const Color(0xFF2993CF),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
