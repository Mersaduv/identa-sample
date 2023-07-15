import 'package:flutter/material.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/audios/voice_message.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesContent extends StatefulWidget {
  final NoteModel? note;

  const NotesContent({Key? key, this.note}) : super(key: key);
  @override
  NotesContentState createState() => NotesContentState();
}

class NotesContentState extends State<NotesContent>
    with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late NoteProvider noteProvider;
  late FocusNode _detailsFocusNode;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  VoiceMessage? _voiceMessage;

  @override
  void initState() {
    super.initState();
    noteProvider = context.read<NoteProvider>();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    _voiceMessage = VoiceMessage();
    resetVoiceMessage();
    _titleController.text = '';
    _detailsController.text = '';
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _detailsController.text = widget.note!.details;
    }

    _detailsFocusNode = FocusNode();
  }

  void resetVoiceMessage() {
    setState(() {
      _voiceMessage = const VoiceMessage();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    final String title = _titleController.text.trim();
    final String details = _detailsController.text.trim();

    if (widget.note == null) {
      final int defaultNoteCount = noteProvider.notes
          .where((note) => note.title.startsWith('New Note'))
          .length;
      if (title.isEmpty && details.isNotEmpty) {
        final String defaultTitle = defaultNoteCount > 0
            ? 'New Note ${defaultNoteCount + 1}'
            : 'New Note';
        _titleController.text = defaultTitle;
      }
      noteProvider.saveConversation(NoteModel(
        id: "0",
        title: _titleController.text,
        details: _detailsController.text,
        date: DateFormat('dd MMM, hh:mm a').format(DateTime.now()),
      ));
      noteProvider.setIsLoading(false);
    } else {
      NoteModel editedNote = NoteModel(
        id: widget.note!.id,
        title: _titleController.text,
        details: _detailsController.text,
        date: widget.note!.date,
      );
      await noteProvider.editConversation(editedNote);
    }
    noteProvider.setIsLoadBack(true);

    noteProvider.loadNotesConversation();

    _titleController.dispose();
    _detailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            noteProvider.setIsLoadBack(false);
            Navigator.of(context).pop();
          },
        ),
        title: 'New note',
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Activate the text field or hide the keyboard
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B5563),
                      ),
                      onTap: () {
                        // Activate the text field or hide the keyboard
                      },
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_detailsFocusNode);
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _detailsController,
                      decoration: const InputDecoration(
                        hintText: 'Start typing or recording ...  ',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none, // Remove the bottom line
                      ),
                      maxLines: null,
                      onTap: () {
                        // Activate the text field or hide the keyboard
                      },
                      focusNode: _detailsFocusNode,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: VoiceMessage(),
          ),
        ],
      ),
    );
  }
}
