import 'package:identa/core/models/audio_recorder/audio_files.dart';

class NoteModel {
  final String id;
  String _title;
  String details;
  final String date;
  List<AudioFile> files;

  NoteModel({
    required this.id,
    required String title,
    required this.details,
    required this.date,
    required this.files,
  }) : _title = title;

  // getter setter
  String get title => _title;
  set title(String value) {
    _title = value;
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    var list = json['files'] as List;
    List<AudioFile> filesList = list.map((i) => AudioFile.fromJson(i)).toList();

    return NoteModel(
      id: "0",
      title: json['title'],
      details: json['details'],
      date: json['date'],
      files: filesList,
    );
  }

  factory NoteModel.fromDynamic(dynamic n) {
    var list = n['files'] as List;
    List<AudioFile> filesList = list.map((i) => AudioFile.fromJson(i)).toList();

    return NoteModel(
      id: n['id'].toString(),
      title: n['title'],
      details: n['details'],
      date: n['date'],
      files: filesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'date': date,
      'files': files.map((file) => file.toJson()).toList(),
    };
  }
}
