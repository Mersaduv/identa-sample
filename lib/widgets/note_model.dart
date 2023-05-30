class NoteModel {
  final String title;
  final String details; 
  final String date;

  NoteModel({
    required this.title,
    required this.details,
    required this.date,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      details: json['details'], 
      date: json['date'],
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
