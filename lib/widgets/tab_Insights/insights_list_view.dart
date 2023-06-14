import 'package:flutter/material.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/models/note_model.dart';

class InsightsListView extends StatefulWidget {
  final List<NoteModel> notes;
  late List<TextEditingController> textControllers;
 // final Function(dynamic audioFilesIndex) editNote;
  InsightsListView({
    Key? key,
    required this.notes,
    required this.textControllers,
   // required this.editNote,
  }) : super(key: key);
  @override
  InsightsListViewState createState() => InsightsListViewState();
}

class InsightsListViewState extends State<InsightsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes[index];
        final controller = widget.textControllers[index];

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
                        style: MyTextStyles.secondTextFieldNote,
                        maxLines: null,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          setState(() {
                            note.title = value;
                          });
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
    );
  }
}
