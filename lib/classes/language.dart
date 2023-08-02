class LanguageList {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  LanguageList(this.id, this.flag, this.name, this.languageCode);

  static List<LanguageList> languageList() {
    return <LanguageList>[
      LanguageList(2, "🇺🇸", "English", "en"),
      LanguageList(1, "🇮🇷", "فارسی", "fa"),
      LanguageList(3, "🇸🇦", "اَلْعَرَبِيَّةُ", "ar"),
      LanguageList(4, "🇮🇳", "हिंदी", "hi")
    ];
  }
}
