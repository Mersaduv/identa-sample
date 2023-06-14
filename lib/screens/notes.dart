import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/loading/cardSkeleton.dart';
import 'package:identa/widgets/tap_notes/note_content.dart';
import '../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  List<NoteModel> notes = [];
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    loadConversations();
  }

  void deleteNote(int index) async {
    await ServiceApis.deleteNote(notes[index].id);

    loadConversations();
  }

  Future<void> loadConversations() async {
    List<NoteModel> noteList = [];
    var allNotes = await ServiceApis.getNotes();
    // print("type 1 ${allNotes}");
    for (var note in allNotes) {
      NoteModel n = NoteModel.fromDynamic(note);
      noteList.add(n);
    }
    // print("type 2 ${noteList}");
    setState(() {
      notes = noteList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
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
              itemCount: notes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 1.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesContent(
                              loadConversations: loadConversations,
                            ),
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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesContent(
                              note: note,
                              loadConversations: loadConversations,
                            ),
                          ),
                        );
                        loadConversations();
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(13.0), //or 15.0
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  color: MyColors.primaryColor,
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
                                        color: Colors.white, fontSize: 20),
                                  )),
                                ),
                              ),
                              title: Text(
                                note.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      note.details,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyles.small,
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
                      )),
                );
              },
            ),
    );
  }
}
