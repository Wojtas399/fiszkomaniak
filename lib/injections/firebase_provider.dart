import 'package:fiszkomaniak/firebase/services/fire_achievements_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_days_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/repositories/achievements_repository.dart';
import 'package:fiszkomaniak/domain/repositories/courses_repository.dart';
import 'package:fiszkomaniak/repositories/sessions_repository.dart';
import 'package:fiszkomaniak/repositories/settings_repository.dart';
import 'package:fiszkomaniak/repositories/flashcards_repository.dart';
import 'package:fiszkomaniak/domain/repositories/groups_repository.dart';
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
import '../domain/repositories/courses_repository.dart';

class FirebaseProvider {
  static final _fireUserService = FireUserService();
  static final _fireAvatarService = FireAvatarService();
  static final _fireAuthService = FireAuthService(
    fireUserService: _fireUserService,
    fireAvatarService: _fireAvatarService,
  );
  static final _fireSettingsService = FireSettingsService();
  static final _fireCoursesService = FireCoursesService();
  static final _fireGroupsService = FireGroupsService();
  static final _fireFlashcardsService = FireFlashcardsService();
  static final _fireDaysService = FireDaysService();
  static final _fireSessionsService = FireSessionsService();
  static final _fireAchievementsService = FireAchievementsService();

  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: _fireAuthService,
      userInterface: provideUserInterface(),
      achievementsInterface: provideAchievementsInterface(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: _fireUserService,
      fireAvatarService: _fireAvatarService,
    );
  }

  static SettingsInterface provideSettingsInterface() {
    return SettingsRepository(fireSettingsService: _fireSettingsService);
  }

  static CoursesInterface provideCoursesInterface() {
    return CoursesRepository(fireCoursesService: _fireCoursesService);
  }

  static GroupsInterface provideGroupsInterface() {
    return GroupsRepository(fireGroupsService: _fireGroupsService);
  }

  static FlashcardsInterface provideFlashcardsInterface({
    required GroupsInterface groupsInterface,
  }) {
    return FlashcardsRepository(
      groupsInterface: groupsInterface,
      fireFlashcardsService: _fireFlashcardsService,
      fireDaysService: _fireDaysService,
    );
  }

  static SessionsInterface provideSessionsInterface() {
    return SessionsRepository(fireSessionsService: _fireSessionsService);
  }

  static AchievementsInterface provideAchievementsInterface() {
    return AchievementsRepository(
      fireAchievementsService: _fireAchievementsService,
    );
  }
}
