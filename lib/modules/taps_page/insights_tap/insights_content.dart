import 'package:flutter/material.dart';
import 'package:identa/services/apis/api.dart';
import '../../../core/models/model_core/note_model.dart';
import 'package:flutter/rendering.dart';

typedef LoadConversationsCallback = Future<void> Function();

class InsightsContent extends StatefulWidget {
  final List<NoteModel> notes;
  const InsightsContent({Key? key, required this.notes}) : super(key: key);
  @override
  InsightsContentState createState() => InsightsContentState();
}

class InsightsContentState extends State<InsightsContent> {
  late List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _textControllers = List.generate(
      widget.notes.length,
      (index) => TextEditingController(
        text: widget.notes[index].title + widget.notes[index].details,
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop(widget.notes);
  }

  //! Api edit
//   void editNote(int index) async {
//   final note = notes[index];

//   await ServiceApis.editNote(
//     note.id,
//     title: note.title,
//     details: note.details,
//   );
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: _goBack,
        ),
        title: const Text(
          'ToDo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2993CF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            final note = widget.notes[index];
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
                              final RegExp regExp = RegExp(r'^(.*?)([\s\S]*)$');
                              final RegExpMatch? match =
                                  regExp.firstMatch(value);

                              if (match != null) {
                                final title = match.group(1);
                                final details = match.group(2);

                                setState(() {
                                  note.title = title ?? '';
                                  note.details = details ?? '';
                                });
                                //! editNote(index);
                              }
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2993CF),
        child: const Icon(
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
