import 'package:fiszkomaniak/firebase/repositories/courses_repository.dart';
import 'package:fiszkomaniak/firebase/repositories/settings_repository.dart';
import 'package:fiszkomaniak/firebase/repositories/flashcards_repository.dart';
import 'package:fiszkomaniak/firebase/repositories/groups_repository.dart';
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
import '../firebase/repositories/auth_repository.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(fireUserService: FireUserService()),
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
}
