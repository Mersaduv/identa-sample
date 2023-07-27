import 'package:flutter/material.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

typedef LoadConversationsCallback = Future<void> Function();

class InsightsContent extends StatefulWidget {
  const InsightsContent({Key? key}) : super(key: key);
  @override
  InsightsContentState createState() => InsightsContentState();
}

class InsightsContentState extends State<InsightsContent> {
  late List<TextEditingController> _textControllers;
  late NoteProvider noteProvider;

  @override
  void initState() {
    super.initState();
    noteProvider = context.read<NoteProvider>();

    _textControllers = List.generate(
      noteProvider.notes.length,
      (index) => TextEditingController(
        text:
            noteProvider.notes[index].title + noteProvider.notes[index].details,
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await noteProvider.loadInsightsConversation();
    noteProvider.setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    var notes = context.watch<NoteProvider>().notes;
    return Scaffold(
      appBar: CustomAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: 'ToDo'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            final controller = _textControllers[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox(
                            width: 7,
                            height: 7,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            maxLines: null,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.top,
                            onChanged: (value) {
                              note.title = value;
                              //! editNote(index);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
