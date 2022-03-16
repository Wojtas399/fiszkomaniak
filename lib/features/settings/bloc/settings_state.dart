class SettingsState {
  final bool isDarkMode;
  final bool isTimerHidden;
  final bool areAllNotifications;
  final bool arePlannedSessionsNotifications;
  final bool areDefaultSessionsNotifications;
  final bool areAchievementsNotifications;
  final bool areDaysNotifications;

  SettingsState({
    this.isDarkMode = false,
    this.isTimerHidden = false,
    this.areAllNotifications = false,
    this.arePlannedSessionsNotifications = false,
    this.areDefaultSessionsNotifications = false,
    this.areAchievementsNotifications = false,
    this.areDaysNotifications = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? isTimerHidden,
    bool? areAllNotifications,
    bool? arePlannedSessionsNotifications,
    bool? areDefaultSessionsNotifications,
    bool? areAchievementsNotifications,
    bool? areDaysNotifications,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isTimerHidden: isTimerHidden ?? this.isTimerHidden,
      areAllNotifications: areAllNotifications ?? this.areAllNotifications,
      arePlannedSessionsNotifications: arePlannedSessionsNotifications ??
          this.arePlannedSessionsNotifications,
      areDefaultSessionsNotifications: areDefaultSessionsNotifications ??
          this.areDefaultSessionsNotifications,
      areAchievementsNotifications:
          areAchievementsNotifications ?? this.areAchievementsNotifications,
      areDaysNotifications: areDaysNotifications ?? this.areDaysNotifications,
    );
  }
}
