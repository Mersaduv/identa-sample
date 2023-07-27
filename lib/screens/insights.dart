import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/models/model_core/insights_conversation_model.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/taps_page/insights_tap/insights_content.dart';
import 'package:identa/widgets/loading/cardSkeleton.dart';
import 'package:provider/provider.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen> {
  Future<List<InsightsConversationModel>>? _futureNotes;
  late NoteProvider noteProvider;

  @override
  void initState() {
    super.initState();
    noteProvider = context.read<NoteProvider>();
    noteProvider.loadInsightsConversation();
  }

  @override
  Widget build(BuildContext context) {
    var noteProviderHandle = context.read<NoteProvider>();
    var insightFuture =
        context.watch<NoteProvider>().insightsconversationFurure;
    var statusNote = context.watch<NoteProvider>().statusCode;
    var isLoading = context.watch<NoteProvider>().isLoading;
    var setIsLoading = context.read<NoteProvider>();
    _futureNotes = insightFuture;
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: Transform.scale(
          scale: 1.1, // Adjust the scale value as needed
          child: FloatingActionButton(
            onPressed: () {
              noteProviderHandle.showNewInsightsDialog(context);
            },
            child: const Icon(Icons.add),
            backgroundColor: const Color(0xFF2993CF),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder<List<InsightsConversationModel>>(
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
                InsightsConversationModel conversation = snapshot.data![index];
                String lastNote = conversation.notes.isNotEmpty
                    ? conversation.notes.last.title
                    : "No note available";
                return GestureDetector(
                  onTap: () async {
                    setIsLoading.setIsLoading(true);

                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InsightsContent(),
                        ));
                    noteProviderHandle.setIsLoading(true);
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
                              color: MyColors.primaryColor,
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
                                radius: 13,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  137,
                                  215,
                                  139,
                                ),
                                child: Text(
                                  conversation.notes.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
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
            );
          } else {
            return const Center(child: Text('Empty Notes'));
          }
        },
      ),
    );
  }
}
