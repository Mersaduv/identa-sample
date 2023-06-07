class NoteModel {
  final String id;
  String _title;
  String details;
  final String date;

  NoteModel({
    required this.id,
    required String title,
    required this.details,
    required this.date,
  }) : _title = title;

  // getter setter
  String get title => _title;
  set title(String value) {
    _title = value;
  }

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
      id: n['id'].toString(),
      title: n['title'],
      details: n['details'],
      date: n['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'date': date,
    };
  }
}
