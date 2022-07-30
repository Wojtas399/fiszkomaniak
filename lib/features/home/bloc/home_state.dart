part of 'home_bloc.dart';

class HomeState extends Equatable {
  final BlocStatus status;
  final String loggedUserAvatarUrl;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final int daysStreak;

  const HomeState({
    required this.status,
    required this.loggedUserAvatarUrl,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.daysStreak,
  });

  @override
  List<Object> get props => [
        status,
        loggedUserAvatarUrl,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        daysStreak,
      ];

  HomeState copyWith({
    BlocStatus? status,
    String? loggedUserAvatarUrl,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    int? daysStreak,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      loggedUserAvatarUrl: loggedUserAvatarUrl ?? this.loggedUserAvatarUrl,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      daysStreak: daysStreak ?? this.daysStreak,
    );
  }
}

class HomeStateListenedParams extends Equatable {
  final String? loggedUserAvatarUrl;
  final AppearanceSettings appearanceSettings;
  final int daysStreak;

  const HomeStateListenedParams({
    required this.loggedUserAvatarUrl,
    required this.appearanceSettings,
    required this.daysStreak,
  });

  @override
  List<Object> get props => [
        loggedUserAvatarUrl ?? '',
        appearanceSettings,
        daysStreak,
      ];
}
