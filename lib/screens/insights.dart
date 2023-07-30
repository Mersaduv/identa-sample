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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var noteProvider = context.read<NoteProvider>();
      noteProvider.setIsLoading(true);

      noteProvider.loadInsightsConversation();
      noteProvider.setIsLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var noteProvider = context.watch<NoteProvider>();
    var noteProviderHandle = context.read<NoteProvider>();

    var insights = noteProvider.insightsconversation;
    var isLoading = noteProvider.isLoading;
    return Consumer<NoteProvider>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 16, right: 16),
            child: Transform.scale(
              scale: 1.1, // Adjust the scale value as needed
              child: FloatingActionButton(
                onPressed: () =>
                    noteProviderHandle.showNewInsightsDialog(context),
                child: const Icon(Icons.add),
                backgroundColor: const Color(0xFF2993CF),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  itemCount: insights.length,
                  itemBuilder: (context, index) {
                    InsightsConversationModel conversation = insights[index];
                    String lastNote = conversation.notes.isNotEmpty
                        ? conversation.notes.last.title
                        : "No note available";
                    return GestureDetector(
                      onTap: () async {
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
                ),
        );
      },
    );
  }
}
