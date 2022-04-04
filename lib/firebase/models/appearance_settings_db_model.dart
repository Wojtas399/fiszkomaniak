class AppearanceSettingsDbModel {
  final bool? isDarkModeOn;
  final bool? isDarkModeCompatibilityWithSystemOn;
  final bool? isSessionTimerInvisibilityOn;

  AppearanceSettingsDbModel({
    this.isDarkModeOn,
    this.isDarkModeCompatibilityWithSystemOn,
    this.isSessionTimerInvisibilityOn,
  });

  AppearanceSettingsDbModel.fromJson(Map<String, Object?> json)
      : this(
          isDarkModeOn: json['isDarkModeOn']! as bool,
          isDarkModeCompatibilityWithSystemOn:
              json['isDarkModeCompatibilityWithSystemOn']! as bool,
          isSessionTimerInvisibilityOn:
              json['isSessionTimerInvisibilityOn']! as bool,
        );

  Map<String, bool?> toJson() {
    return {
      'isDarkModeOn': isDarkModeOn,
      'isDarkModeCompatibilityWithSystemOn':
          isDarkModeCompatibilityWithSystemOn,
      'isSessionTimerInvisibilityOn': isSessionTimerInvisibilityOn,
    }..removeWhere((key, value) => value == null);
  }
}
