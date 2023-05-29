class NoteModel {
  final String title;
  final String date;

  NoteModel({
    required this.title,
    required this.date,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
    };
  }
}
