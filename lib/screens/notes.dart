import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/audio_recorder/audio_files.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/widgets/dismissible_background.dart';
import 'package:identa/widgets/loading/cardSkeleton.dart';
import 'package:identa/modules/taps_page/notes_tap/note_content.dart';
import 'package:identa/widgets/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:identa/core/models/model_core/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  Future<List<NoteModel>>? _futureNotes;
  late NoteProvider noteProvider;

  @override
  void initState() {
    super.initState();

    noteProvider = context.read<NoteProvider>();
  }

  @override
  Widget build(BuildContext context) {
    var noteFuture = context.watch<NoteProvider>().noteFurure;
    var statusNote = context.watch<NoteProvider>().statusCode;
    var isLoading = context.watch<NoteProvider>().isLoading;
    var setIsLoading = context.read<NoteProvider>();
    _futureNotes = noteFuture;
    return Scaffold(
      body: FutureBuilder<List<NoteModel>>(
        future: _futureNotes,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return (Padding(
              padding: const EdgeInsets.all(18),
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const CardSkelton(),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(height: defaultPadding),
                ),
              ),
            ));
          } else if (statusNote != "") {
            return const Text("You are not authenticated");
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Dismissible(
                  key: Key(note.title),
                  direction: DismissDirection.endToStart,
                  background: const DismissibleBackground(),
                  confirmDismiss: (_) async {
                    return await ShowCustomDialog.show(
                      context,
                      'Delete Note',
                      'Are you sure you want to delete this note?',
                    );
                  },
                  onDismissed: (_) {
                    context.read<NoteProvider>().deleteNote(note);
                    context.notify = 'Note dismissed';
                  },
                  child: GestureDetector(
                    onTap: () async {
                      setIsLoading.setIsLoading(true);
                      context.read<NoteProvider>().audioList.clear();
                      context.read<NoteProvider>().updatedAudioRecords.clear();
                      if (note.title.isEmpty) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesContent(
                              note: note,
                            ),
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
                                            .trim()
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
            );
          } else {
            return Center(child: Text('Empty Notes'));
          }
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: Transform.scale(
          scale: 1.1, // Adjust the scale value as needed
          child: FloatingActionButton(
            onPressed: () {
              noteProvider.setIsLoading(true);
              noteProvider.audioList.clear();
              noteProvider.updatedAudioRecords.clear();
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
