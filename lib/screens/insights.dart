import 'package:flutter/material.dart';
import 'package:identa/constants.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/loading/cardSkeleton.dart';
import 'package:identa/widgets/conversation_model.dart';
import 'package:identa/widgets/insights_content.dart';
import '../widgets/note_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen> {
  List<NoteModel> notes = [];
  List<ConversationModel> conversations = [];
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
    await ServiceApis.deleteNote(
      conversations[index].notes.last.id,
    );

    loadConversations();
  }

  Future<void> loadConversations() async {
    List<ConversationModel> conversationList = [];
    var todoNotesData = await ServiceApis.getNotes();
    List<String> conversationName = ['Todo', 'Business', 'Health'];

    for (int i = 0; i < conversationName.length; i++) {
      List<NoteModel> todoNotes = [];
      for (var note in todoNotesData) {
        NoteModel n = NoteModel.fromDynamic(note);
        todoNotes.add(n);
      }

      ConversationModel conversation = ConversationModel(
        name: conversationName[i],
        notes: todoNotes,
        icon: Icons.pending_actions,
      );
      conversationList.add(conversation);
    }

    setState(() {
      conversations = conversationList;
      isLoading = false;
    });
  }

  Future<void> _navigateToInsightsContent(int index) async {
    final updatedNotes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsightsContent(
          notes: conversations[index].notes,
        ),
      ),
    );
    if (updatedNotes != null) {
      setState(() {
        conversations[index].notes = updatedNotes;
      });
    }
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
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                ConversationModel conversation = conversations[index];
                String lastNote = conversation.notes.isNotEmpty
                    ? conversation.notes.last.title
                    : "No note available";
                return GestureDetector(
                  onTap: () {
                    _navigateToInsightsContent(index);
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
                              color: const Color(0xFF2D9CDB),
                              child: Icon(
                                conversation.icon,
                                color: Colors.white,
                                size: 35.0,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                conversation.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  137,
                                  215,
                                  139,
                                ),
                                child: Text(
                                  conversation.notes.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lastNote.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
