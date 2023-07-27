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

  String? _statusCode = "";
  String get statusCode => _statusCode!;
  late bool _isLoading = false;
  late bool _isLoadBack = false;
  bool get isLoading => _isLoading;
  bool get isLoadBack => _isLoadBack;
  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;
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

  Future<void> setAudioFile(AudioFile audioFiles) async {
    _audioList.add(audioFiles);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setIsLoadBack(bool isLoadBack) {
    _isLoadBack = isLoadBack;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

// ? notes tap
  Future<List> loadNotesConversation() async {
    List<NoteModel> noteList = [];
    _statusCode = "";
    var allNotes = await ServiceApis.getNotes();

    if (allNotes[0] != 401) {
      for (var note in allNotes) {
        NoteModel n = NoteModel.fromDynamic(note);
        noteList.add(n);
      }
      _noteFuture = Future.value(noteList);
      _notes = noteList;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return allNotes;
    } else {
      _statusCode = allNotes[0].toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      return allNotes;
    }
  }

// ? insights tap
  Future<List> loadInsightsConversation() async {
    List<InsightsConversationModel> conversationList = [];
    _statusCode = "";
    var todoNotesData = await ServiceApis.getNotes();
    List<String> conversationName = ['Todo', 'Business', 'Health'];

    if (todoNotesData[0] != 401) {
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
      _insightsconversationFuture = Future.value(conversationList);
      _insightsconversation = conversationList;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return todoNotesData;
    } else {
      _statusCode = todoNotesData[0].toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return todoNotesData;
    }
  }

  void addAudioRecord(AudioRecord audioRecord) {
    _updatedAudioRecords.add(audioRecord);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
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

  void showNewInsightsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInsightsDialog(
          onCreate: createNewInsights,
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> deleteNote(NoteModel note) async {
    await ServiceApis.deleteNote(note.id);
    _notes.removeWhere((n) => n.id == note.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> deleteNoteAudio(NoteModel note, String fileId) async {
    await ServiceApis.deleteNoteAudio(note.id, fileId);
    _notes.removeWhere((n) => n.files[0].fileId == fileId);
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
    setIsLoading(false);
    await ServiceApis.editNote(editedNote);
    setIsLoading(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
