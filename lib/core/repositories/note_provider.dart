import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:identa/core/models/audio_recorder/audio_files.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/models/model_core/insights_conversation_model.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/insights_new.dart';
import 'dart:async';

class NoteProvider extends ChangeNotifier {
  String _note = "";
  String get note => _note;

  late bool _isLoading = false;
  late bool _isLoadBack = false;
  bool get isLoading => _isLoading;
  bool get isLoadBack => _isLoadBack;
  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  List<AudioFile> _audioList = [];
  List<AudioFile> get audioList => _audioList;

  List<AudioRecord> _updatedAudioRecords = [];

  List<AudioRecord> get updatedAudioRecords => _updatedAudioRecords;

  List<InsightsConversationModel> _insightsconversation = [];
  List<InsightsConversationModel> get insightsconversation =>
      _insightsconversation;

  Future<void> setAudioFile(AudioFile audioFiles) async {
    _audioList.add(audioFiles);
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setIsLoadBack(bool isLoadBack) {
    _isLoadBack = isLoadBack;
    notifyListeners();
  }

// ? notes tap
  void loadNotesConversation() async {
    List<NoteModel> noteList = [];

    var allNotes = await ServiceApis.getNotes();

    for (var note in allNotes) {
      NoteModel n = NoteModel.fromDynamic(note);
      noteList.add(n);
    }
    _notes = noteList;
    // _isLoading = false;
    notifyListeners();
  }

// ? insights tap
  Future<void> loadInsightsConversation() async {
    List<InsightsConversationModel> conversationList = [];

    var todoNotesData = await ServiceApis.getNotes();
    List<String> conversationName = ['Todo', 'Business', 'Health'];

    for (int i = 0; i < conversationName.length; i++) {
      List<NoteModel> todoNotes = [];
      for (var note in todoNotesData) {
        NoteModel n = NoteModel.fromDynamic(note);
        todoNotes.add(n);
      }

      InsightsConversationModel conversation = InsightsConversationModel(
        name: conversationName[i],
        notes: todoNotes,
        icon: Icons.pending_actions,
      );
      conversationList.add(conversation);
    }
    _insightsconversation = conversationList;
    //  _isLoading = false;
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
    notifyListeners();
  }

  void showNewInsightsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInsightsDialog(
          onCreate: createNewInsights,
        );
      },
    );
    notifyListeners();
  }

  Future<void> deleteNote(NoteModel note) async {
    await ServiceApis.deleteNote(note.id);
    _notes.removeWhere((n) => n.id == note.id);
    notifyListeners();
  }

  Future<void> saveConversation(NoteModel note) async {
    if (note.title.isNotEmpty) {
      await ServiceApis.createNote(note);
      loadNotesConversation();
    }
  }

  Future<void> editConversation(NoteModel editedNote) async {
    await ServiceApis.editNote(editedNote);
  }
}
