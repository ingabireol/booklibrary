class Settings {
  bool isDarkMode;
  String sortingCriteria;

  Settings({required this.isDarkMode, required this.sortingCriteria});

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      isDarkMode: map['isDarkMode'] ?? false,
      sortingCriteria: map['sortingCriteria'] ?? 'title',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'sortingCriteria': sortingCriteria,
    };
  }
}
