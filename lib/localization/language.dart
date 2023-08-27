/// Dil seçeneklerini temsil eden [Language] sınıfı, uygulamanın farklı
/// dillerde sunulan metinleri desteklemesi için kullanılır.
class Language {
  /// [id] - Dil seçeneğinin benzersiz kimliği.
  /// [name] - Dil seçeneğinin adı.
  /// [languageCode] - Dil kodu.

  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  /// Desteklenen dil seçeneklerini içeren bir liste döndürür.
  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "en"),
      Language(2, "Türkçe", "tr"),
    ];
  }
}
