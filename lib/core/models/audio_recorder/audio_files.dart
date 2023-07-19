class AudioFile {
  final String fileId;

  AudioFile({required this.fileId});

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      fileId: json['fileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
    };
  }
}