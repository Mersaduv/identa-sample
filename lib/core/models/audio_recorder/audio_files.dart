class AudioFile {
  final String fileId;
  final int length; 
  AudioFile({required this.fileId, required this.length}); // اضافه کردن length به constructor

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      fileId: json['fileId'],
      length: json['length'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'length': length,
    };
  }
}
