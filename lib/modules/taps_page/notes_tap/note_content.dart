import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:identa/classes/language_constants.dart';
import 'package:identa/core/models/audio_recorder/audio_files.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:identa/modules/audios/audioRecorder/audio_recorder_logic.dart';
import 'package:identa/modules/audios/voice_message.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/modules/taps_page/notes_tap/bottom_navigation.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  bool _keyboardVisible = false;
  final updatedAudioRecords = <AudioRecord>[];
  String? previousText;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _keyboardVisible = visible;
      });
    });
    noteProvider = context.read<NoteProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      noteProvider.addAudioText(null);
    });

    _titleController = TextEditingController();
    _detailsController = TextEditingController();

    _titleController.text = '';
    _detailsController.text = '';
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _detailsController.text = widget.note!.details;
      loadFilesContent();
    }
    _detailsFocusNode = FocusNode();
  }

  void loadFilesContent() {
    final audioRecordsProvider =
        Provider.of<NoteProvider>(context, listen: false);

    const kFormattedDateKey = 'formatted_date';
    const kAudioPathKey = 'audio_path';

    Map<String, String> toJson(AudioRecord value) {
      return <String, String>{
        kFormattedDateKey: value.formattedDate,
        kAudioPathKey: value.audioPath,
      };
    }

    for (var n in widget.note!.files) {
      ServiceApis.downloadAudio(n.fileId).then((response) {
        final audioRecord = AudioRecord(
            formattedDate: DateTime.now().toString(),
            audioPath: response.toString(),
            length: n.length);
        audioRecordsProvider.addAudioRecord(audioRecord);
        print("audios ${n.fileId}");
      });
    }
  }

  @override
  void dispose() async {
    final String title = _titleController.text.trim();
    final String details = _detailsController.text.trim();
    List<AudioFile> audioFiles = [];
    for (var audio in noteProvider.audioList) {
      audioFiles.add(AudioFile(fileId: audio.fileId, length: audio.length));
    }
    for (var audio in noteProvider.audioList) {
      print("Response voice: ${audio.fileId} SECEND");
    }

    if (widget.note == null) {
      noteProvider.setIsLoadBack(true);

      final defaultNoteCount = noteProvider.notes!
          .where((note) => note.title.startsWith('New Note'))
          .length;
      if (title.isEmpty && details.isNotEmpty) {
        final String defaultTitle = defaultNoteCount > 0
            ? 'New Note ${defaultNoteCount + 1}'
            : 'New Note';
        _titleController.text = defaultTitle.trim();
      }
      noteProvider.saveConversation(NoteModel(
        id: "0",
        title: _titleController.text.trim(),
        details: _detailsController.text.trim(),
        date: intl.DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
        files: audioFiles,
      ));
      noteProvider.setIsLoading(true);
      noteProvider.loadNotesConversation();
      noteProvider.audioList.clear();
      noteProvider.updatedAudioRecords.clear();
      audioFiles.clear();
      _titleController.dispose();
      _detailsController.dispose();
      super.dispose();
    } else {
      noteProvider.setIsLoadBack(true);

      final defaultNoteCount = noteProvider.notes!
          .where((note) => note.title.startsWith('New Note'))
          .length;
      if (title.isEmpty && details.isNotEmpty) {
        final String defaultTitle = defaultNoteCount > 0
            ? 'New Note ${defaultNoteCount + 1}'
            : 'New Note';
        _titleController.text = defaultTitle.trim();
      }
      for (var audio in noteProvider.audioList) {
        widget.note!.files
            .add(AudioFile(fileId: audio.fileId, length: audio.length));
      }
      for (var audio in noteProvider.audioList) {
        print("Response voice: ${audio.fileId} SECEND");
      }
      NoteModel editedNote = NoteModel(
        id: widget.note!.id,
        title: _titleController.text,
        details: _detailsController.text,
        date: widget.note!.date,
        files: widget.note!.files,
      );
      // noteProvider.setIsLoading(true);
      noteProvider.editConversation(editedNote);
      noteProvider.loadNotesConversation();
      noteProvider.audioList.clear();
      noteProvider.updatedAudioRecords.clear();
      audioFiles.clear();
      _titleController.dispose();
      _detailsController.dispose();

      super.dispose();
    }
    try {
      Provider.of<NoteProvider>(context, listen: false).addAudioText(null);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? newText = context.watch<NoteProvider>().note;
    if (previousText != newText) {
      final lastCursorPosition = _detailsController.selection.baseOffset;

      _detailsController.text = _detailsController.text! + newText;

      _detailsController.selection =
          TextSelection.fromPosition(TextPosition(offset: lastCursorPosition));

      context.read<NoteProvider>().addAudioText('');
    }

    final ValueNotifier<TextDirection> _titleTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _detailsTextDir =
        ValueNotifier(TextDirection.ltr);

    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>(
          create: (context) => AudioRecorderLogic(
            permissionRepository: context.read<PermissionRepositoryInterface>(),
          ),
          dispose: (_, logic) => logic.onDispose(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () async {
              context.read<NoteProvider>().loadNotesConversation();
              Navigator.of(context).pop();
              await noteProvider.setIsLoadBack(true);
            },
          ),
          title: translation(context).newNote,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16.0),
                          ValueListenableBuilder<TextDirection>(
                            valueListenable: _titleTextDir,
                            builder: (context, value, child) {
                              return TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: translation(context).title,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
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
                                textDirection: _titleTextDir.value,
                                onChanged: (input) {
                                  final isRTL =
                                      intl.Bidi.detectRtlDirectionality(input);
                                  if (isRTL) {
                                    _titleTextDir.value = TextDirection.rtl;
                                  } else {
                                    _titleTextDir.value = TextDirection.ltr;
                                  }
                                },
                                onSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_detailsFocusNode);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 8.0),
                          ValueListenableBuilder<TextDirection>(
                            valueListenable: _detailsTextDir,
                            builder: (context, value, child) {
                              return TextField(
                                controller: _detailsController,
                                decoration: InputDecoration(
                                  hintText: translation(context)
                                      .startTypingOrRecording,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder
                                      .none, // Remove the bottom line
                                ),
                                maxLines: null,
                                onTap: () {
                                  // Activate the text field or hide the keyboard
                                },
                                textDirection: _detailsTextDir.value,
                                onChanged: (input) {
                                  final isRTL =
                                      intl.Bidi.detectRtlDirectionality(input);
                                  if (isRTL) {
                                    _detailsTextDir.value = TextDirection.rtl;
                                  } else {
                                    _detailsTextDir.value = TextDirection.ltr;
                                  }
                                },
                                focusNode: _detailsFocusNode,
                                style: const TextStyle(
                                  color: Color(0xFF4B5563),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ),
                  VoiceMessage(note: widget.note),
                  const SizedBox(height: 100.0)
                ],
              )),
        ),
        floatingActionButton:
            !_keyboardVisible ? const BottomNavigation() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
