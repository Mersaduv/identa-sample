import 'package:flutter/material.dart';
import 'package:identa/widgets/note_model.dart';

class ConversationModel {
  String name;
  List<NoteModel> notes;
  IconData icon;

  ConversationModel({
    required this.name,
    required this.notes,
    required this.icon,
  });
}
