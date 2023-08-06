import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:identa/core/models/audio_recorder/audio_files.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/models/model_core/insights_conversation_model.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/services/apis/api.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class NoteProvider extends ChangeNotifier {
  String _note = "";
  String get note => _note;

  String? _statusCode = "";
  String get statusCode => _statusCode!;
  late bool _isLoading = false;
  late bool _isLoadBack = false;
  bool get isLoading => _isLoading;
  bool get isLoadBack => _isLoadBack;
  List<NoteModel>? _notes = null;
  List<NoteModel>? get notes => _notes;
  Future<List<NoteModel>>? _noteFuture;
  Future<List<NoteModel>>? get noteFurure => _noteFuture;
  Future<List<InsightsConversationModel>>? _insightsconversationFuture;
  Future<List<InsightsConversationModel>>? get insightsconversationFurure =>
      _insightsconversationFuture;
  List<AudioFile> _audioList = [];
  List<AudioFile> get audioList => _audioList;

  List<AudioRecord> _updatedAudioRecords = [];

  List<AudioRecord> get updatedAudioRecords => _updatedAudioRecords;

  List<InsightsConversationModel> _insightsconversation = [];
  List<InsightsConversationModel> get insightsconversation =>
      _insightsconversation;

  File? _coverImage;

  File? get coverImage => _coverImage;

  setCoverImage(File? newCoverImage) {
    _coverImage = newCoverImage;
    notifyListeners();
  }

  Future<void> downloadProfilePicture() async {
    var response = await ServiceApis.getProfilePicture();

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String fileName = 'profile_picture.jpg';
      String directory = (await getApplicationDocumentsDirectory()).path;
      String filePath = '$directory/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(bytes);
      _coverImage = file;
      print('Profile picture downloaded successfully! $filePath');
      notifyListeners();
    } else {
      print(
          'Failed to download profile picture. Status code: ${response.statusCode}');
    }
  }

  Future<void> uploadProfilePicture(File file) async {
    _coverImage = null;
    var response = await ServiceApis.sendProfilePicture(file.path);

    if (response.statusCode == 200) {
      print('Profile picture uploaded successfully!');
      notifyListeners();
    } else {
      print(
          'Failed to upload profile picture. Status code: ${response.statusCode}');
    }
  }

  Future<void> setAudioFile(AudioFile audioFiles) async {
    _audioList.add(audioFiles);
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> setIsLoadBack(bool isLoadBack) async {
    _isLoadBack = isLoadBack;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void loadNotesConversation() async {
    List<NoteModel> noteList = [];

    var allNotes = await ServiceApis.getNotes();
    for (var note in allNotes) {
      NoteModel n = NoteModel.fromDynamic(note);
      noteList.add(n);
    }
    _notes = noteList;
    notifyListeners();
  }

  void addAudioRecord(AudioRecord audioRecord) {
    _updatedAudioRecords.add(audioRecord);
    notifyListeners();
  }

  void addAudioText(String? textBody) {
    _note = textBody ?? "";
  }

  void createNewInsights(String insightsName) {
    InsightsConversationModel newInsights = InsightsConversationModel(
      name: insightsName,
      notes: [],
      icon: Icons.lightbulb_outline,
    );
    _insightsconversation.add(newInsights);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> deleteNote(NoteModel note) async {
    await ServiceApis.deleteNote(note.id);
    _notes?.removeWhere((n) => n.id == note.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> deleteNoteAudio(NoteModel note, String fileId) async {
    await ServiceApis.deleteNoteAudio(note.id, fileId);
    _notes?.removeWhere((n) => n.files[0].fileId == fileId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> saveConversation(NoteModel note) async {
    setIsLoading(false);
    if (note.title.isNotEmpty) {
      await ServiceApis.createNote(note);
      setIsLoading(false);

      loadNotesConversation();
    }
  }

  Future<void> editConversation(NoteModel editedNote) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ServiceApis.editNote(editedNote);
      loadNotesConversation();
      notifyListeners();
    });
  }
}
