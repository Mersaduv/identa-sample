import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:identa/models/note_model.dart';
import 'package:identa/widgets/tab_Insights/insights_list_view.dart';

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
        text: widget.notes[index].title,
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
        backgroundColor: MyColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InsightsListView(
          notes: widget.notes,
          textControllers: _textControllers,
        ),
      ),
    );
  }
}
