part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String loggedUserAvatarUrl;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final HomeStatus status;

  const HomeState({
    this.loggedUserAvatarUrl = '',
    this.isDarkModeOn = false,
    this.isDarkModeCompatibilityWithSystemOn = false,
    this.status = const HomeStatusInitial(),
  });

  @override
  List<Object> get props => [
        loggedUserAvatarUrl,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        status,
      ];

  HomeState copyWith({
    String? loggedUserAvatarUrl,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    HomeStatus? status,
  }) {
    return HomeState(
      loggedUserAvatarUrl: loggedUserAvatarUrl ?? this.loggedUserAvatarUrl,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      status: status ?? HomeStatusLoaded(),
    );
  }
}
