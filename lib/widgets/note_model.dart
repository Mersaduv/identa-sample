import 'dart:ffi';

class NoteModel {
  final String id;
  final String title;
  final String details;
  final String date;

  NoteModel({
    required this.id,
    required this.title,
    required this.details,
    required this.date,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: "0",
      title: json['title'],
      details: json['details'],
      date: json['date'],
    );
  }

  factory NoteModel.fromDynamic(dynamic n) {
    return NoteModel(
      id: n['timestamp'].toString(),
      title: n['title'],
      details: n['details'],
      date: n['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'date': date,
    };
  }
}
