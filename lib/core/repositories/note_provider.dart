import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:identa/core/models/model_core/insights_conversation_model.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/insights_new.dart';

class NoteProvider extends ChangeNotifier {
  NoteModel? _note;
  NoteModel? get note => _note;

  late bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  List<InsightsConversationModel> _insightsconversation = [];
  List<InsightsConversationModel> get insightsconversation =>
      _insightsconversation;

  void setNote(NoteModel? note) {
    _note = note;
    notifyListeners();
  }

  void setIsLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }

// ? notes tap
  void loadNotesConversation() async {
    List<NoteModel> noteList = [];
    var allNotes = await ServiceApis.getNotes();
// print("type 1 ${allNotes}");
    for (var note in allNotes) {
      NoteModel n = NoteModel.fromDynamic(note);
      noteList.add(n);
    }
// print("type 2 ${noteList}");
    _notes = noteList;
    _isLoading = false;
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
    _isLoading = false;
    notifyListeners();
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
