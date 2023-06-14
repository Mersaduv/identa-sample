import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/models/note_model.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/tap_notes/notes_microphone.dart';
import 'package:identa/widgets/tap_notes/play_list_view.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart'
    as AS;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

typedef LoadConversationsCallback = Future<void> Function();
typedef _Fn = void Function();
const theSource = AS.AudioSource.voice_communication;

class NotesContent extends StatefulWidget {
  final NoteModel? note;
  final LoadConversationsCallback? loadConversations;
  const NotesContent({Key? key, this.note, required this.loadConversations})
      : super(key: key);
  @override
  NotesContentState createState() => NotesContentState();
}

class NotesContentState extends State<NotesContent>
    with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;

  late FocusNode _detailsFocusNode;
  final Codec _codec = Codec.aacMP4;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String _recordingTime = '00:00:00';
  String _playerTime = '00:00:00';
  bool _isCircleVisible = true;
  late AnimationController animationController;
  late AnimationController _animationController2;
  late Animation<double> scaleAnimation;
  StreamSubscription? _playerSubscription1;

  String? _mPath;
  List<String> audioFiles = [];
  int? currentPlayingIndex;

  Future<String> get _getApplicationDocumentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  void initState() {
    initializeDateFormatting();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(animationController);

    //?
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isCircleVisible = false;
          });
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _isCircleVisible = true;
          });
        }
      });
    _animationController2.repeat();
    //?
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });

    super.initState();
    _initPath();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _detailsController.text = widget.note!.details;
    }

    _detailsFocusNode = FocusNode();
  }

  void _initPath() async {
    _mPath = await _getApplicationDocumentsPath;
  }

  @override
  void dispose() async {
    cancelPlayerSubscriptions1();
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;

    _animationController2.dispose();
    super.dispose();

    if (widget.note == null) {
      saveConversation(NoteModel(
        id: "0",
        title: _titleController.text,
        details: _detailsController.text,
        date: DateFormat('dd MMM, hh:mm a').format(DateTime.now()),
      ));
    } else {
      NoteModel editedNote = NoteModel(
        id: widget.note!.id,
        title: _titleController.text,
        details: _detailsController.text,
        date: widget.note!.date,
      );
      await editConversation(editedNote);
    }

    widget.loadConversations!();

    _titleController.dispose();
    _detailsController.dispose();
  }

  Future<void> editConversation(NoteModel editedNote) async {
    await ServiceApis.editNote(editedNote);
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _mRecorder!.openRecorder();
    _mRecorder?.setSubscriptionDuration(const Duration(milliseconds: 100));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------
  void record() async {
    _recordingTime = '00:00:00';
    _playerTime = '00:00:00';
    String fileName = 'tau_file_${DateTime.now().millisecondsSinceEpoch}.aac';
    String filePath = '$_mPath/$fileName';

    _mRecorder!
        .startRecorder(
      //  toFile: _mPath,
      toFile: filePath,
      codec: _codec,
      sampleRate: 44100,
      bitRate: 128000,
      numChannels: 1,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
    _mRecorder?.onProgress?.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_US').format(date);
      setState(() {
        _recordingTime = txt.substring(0, 8);
      });
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        _mplaybackReady = true;
        audioFiles.add(value!);
      });
    });
  }

  void play(audioFilesIndex) async {
    await _mPlayer?.setVolume(1.0);
    print("type -- 3------------------ ${audioFilesIndex}--");
    await _mPlayer!.setSubscriptionDuration(const Duration(milliseconds: 100));
    //  _addListener1();
    await _mPlayer!.startPlayer(
        fromURI: audioFilesIndex,
        codec: Codec.mp3,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
    _playerTime = '00:00:00';
    _mPlayer?.onProgress?.listen((e) {
      // debugPrint(" Position ${e.position} Duration ${e.duration}");

      var date = DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_US').format(date);
      setState(() {
        _playerTime = txt.substring(0, 8);
      });
    });
  }

  void cancelPlayerSubscriptions1() {
    if (_playerSubscription1 != null) {
      _playerSubscription1!.cancel();
      _playerSubscription1 = null;
    }
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null && !_mPlayer!.isStopped) {
      await _mPlayer!.pausePlayer();
    }
    setState(() {});
  }

  Future<void> pause() async {
    if (_mPlayer != null) {
      await _mPlayer!.pausePlayer();
    }
    setState(() {});
  }

  Future<void> resume() async {
    if (_mPlayer != null) {
      await _mPlayer!.resumePlayer();
    }
    setState(() {});
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getPlaybackFn(audioFilesIndex) {
    if (!_mPlayerIsInited || !_mplaybackReady) {
      return null;
    }
    return _mPlayer!.isStopped
        ? () => play(audioFilesIndex)
        : () {
            stopPlayer().then((value) => setState(() {}));
          };
  }

  _Fn? getPauseResumeFn1() {
    if (!_mPlayerIsInited || _mPlayer!.isStopped) {
      return null;
    }
    return _mPlayer!.isPaused ? resume : pause;
  }

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  void animateButton() {
    animationController.forward();
  }

  void playRecording(String filePath) async {
    if (!_mPlayerIsInited) return;

    if (_mPlayer!.isPlaying) {
      await _mPlayer!.stopPlayer();
    }

    await _mPlayer!.startPlayer(fromURI: filePath);
    _mPlayer!.setSubscriptionDuration(const Duration(milliseconds: 100));

    _mPlayer!.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_US').format(date);
      setState(() {
        _playerTime = txt.substring(0, 8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'New note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        children: [
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
                      style: MyTextStyles.textFieldNote,
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
                          hintText:
                              'Details note , Start typing or recording ...  ',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, // Remove the bottom line
                        ),
                        maxLines: null,
                        onTap: () {
                          // Activate the text field or hide the keyboard
                        },
                        focusNode: _detailsFocusNode,
                        style: MyTextStyles.secondTextFieldNote),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PlayListView(
                audioFiles: audioFiles,
                mPlayer: _mPlayer,
                playerTime: _playerTime,
                getPlaybackFn1: getPlaybackFn,
                getPauseResumeFn1: getPauseResumeFn1),
          ),
        ],
      ),
      floatingActionButton: NoteMicrophone(
        mRecorder: _mRecorder,
        getRecorderFn: getRecorderFn,
        isCircleVisible: _isCircleVisible,
        recordingTime: _recordingTime,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void saveConversation(NoteModel note) async {
    widget.loadConversations!();
    if (_titleController.text.isNotEmpty) {
      ServiceApis.createNote(note);

      widget.loadConversations!();
    }
  }
}
