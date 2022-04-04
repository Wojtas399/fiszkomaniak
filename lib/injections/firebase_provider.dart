import 'package:fiszkomaniak/firebase/repositories/fire_courses_repository.dart';
import 'package:fiszkomaniak/firebase/repositories/fire_settings_repository.dart';
import 'package:fiszkomaniak/firebase/repositories/groups_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_settings_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import '../firebase/repositories/fire_auth_repository.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return FireAuthRepository(
      fireAuthService: FireAuthService(fireUserService: FireUserService()),
    );
  }

  static SettingsInterface provideSettingsInterface() {
    return FireSettingsRepository(
      fireSettingsService: FireSettingsService(),
    );
  }

  static CoursesInterface provideCoursesInterface() {
    return FireCoursesRepository(
      fireCoursesService: FireCoursesService(),
    );
  }

  static GroupsInterface provideGroupsInterface() {
    return GroupsRepository(
      fireGroupsService: FireGroupsService(),
    );
  }
}
