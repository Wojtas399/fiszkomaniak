import 'package:fiszkomaniak/firebase/services/fire_achievements_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/repositories/achievements_repository.dart';
import 'package:fiszkomaniak/repositories/courses_repository.dart';
import 'package:fiszkomaniak/repositories/sessions_repository.dart';
import 'package:fiszkomaniak/repositories/settings_repository.dart';
import 'package:fiszkomaniak/repositories/flashcards_repository.dart';
import 'package:fiszkomaniak/repositories/groups_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_settings_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/repositories/user_repository.dart';
import '../interfaces/user_interface.dart';
import '../repositories/auth_repository.dart';
import '../repositories/courses_repository.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(
        fireUserService: FireUserService(),
        fireAvatarService: FireAvatarService(),
      ),
      userInterface: provideUserInterface(),
      achievementsInterface: provideAchievementsInterface(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: FireUserService(),
      fireAvatarService: FireAvatarService(),
    );
  }

  static SettingsInterface provideSettingsInterface() {
    return SettingsRepository(
      fireSettingsService: FireSettingsService(),
    );
  }

  static CoursesInterface provideCoursesInterface() {
    return CoursesRepository(
      fireCoursesService: FireCoursesService(),
    );
  }

  static GroupsInterface provideGroupsInterface() {
    return GroupsRepository(
      fireGroupsService: FireGroupsService(),
    );
  }

  static FlashcardsInterface provideFlashcardsInterface() {
    return FlashcardsRepository(
      fireFlashcardsService: FireFlashcardsService(),
    );
  }

  static SessionsInterface provideSessionsInterface() {
    return SessionsRepository(
      fireSessionsService: FireSessionsService(),
    );
  }

  static AchievementsInterface provideAchievementsInterface() {
    return AchievementsRepository(
      fireAchievementsService: FireAchievementsService(),
    );
  }
}
