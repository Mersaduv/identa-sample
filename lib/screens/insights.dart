import 'package:flutter/material.dart';
import 'package:identa/constants.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/skeleton.dart';
import 'package:identa/widgets/insights_content.dart';
import 'package:identa/widgets/note_content.dart';
import '../widgets/note_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen> {
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

    for (var note in allNotes) {
      NoteModel n = NoteModel.fromDynamic(note);
      noteList.add(n);
    }

    setState(() {
      notes = noteList;
      isLoading = false;
    });
  }

  Future<void> _navigateToInsightsContent() async {
    final updatedNotes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsightsContent(
          notes: notes,
        ),
      ),
    );
    if (updatedNotes != null) {
      setState(() {
        notes = updatedNotes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NoteModel lastNote;
    String lastNoteDetails = "No note available";
    if (notes.isNotEmpty) {
      lastNote = notes.last;
      lastNoteDetails = lastNote.details;
    }

    return Scaffold(
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.all(18),
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(height: defaultPadding),
                ),
              ),
            )
          : GestureDetector(
              onTap: _navigateToInsightsContent,
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
                          color: const Color(0xFF2D9CDB),
                          child: const Icon(Icons.pending_actions,
                              color: Colors.white, size: 35.0),
                        ),
                      ),
                      title: const Row(
                        children: [
                          Text(
                            "ToDo",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Color.fromARGB(255, 137, 215, 139),
                            child: Text(
                              "5",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastNoteDetails,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 10),
                ],
              )),
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Skeleton(height: 90, width: 90),
        SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 2),
              Skeleton(),
              SizedBox(height: defaultPadding / 2),
              Skeleton(),
              SizedBox(height: defaultPadding / 2),
            ],
          ),
        )
      ],
    );
  }
}
