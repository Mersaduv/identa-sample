import 'package:flutter/material.dart';
import 'package:identa/core/models/model_core/note_model.dart';

class InsightsConversationModel {
  String name;
  List<NoteModel> notes;
  IconData icon;

  InsightsConversationModel({
    required this.name,
    required this.notes,
    required this.icon,
  });
}
