import '../domain/repositories/achievements_repository.dart';
import '../domain/repositories/appearance_settings_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/courses_repository.dart';
import '../domain/repositories/groups_repository.dart';
import '../domain/repositories/notifications_settings_repository.dart';
import '../domain/repositories/sessions_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../firebase/services/fire_achievements_service.dart';
import '../firebase/services/fire_appearance_settings_service.dart';
import '../firebase/services/fire_auth_service.dart';
import '../firebase/services/fire_avatar_service.dart';
import '../firebase/services/fire_courses_service.dart';
import '../firebase/services/fire_days_service.dart';
import '../firebase/services/fire_flashcards_service.dart';
import '../firebase/services/fire_groups_service.dart';
import '../firebase/services/fire_notifications_settings_service.dart';
import '../firebase/services/fire_sessions_service.dart';
import '../firebase/services/fire_user_service.dart';
import '../interfaces/achievements_interface.dart';
import '../interfaces/appearance_settings_interface.dart';
import '../interfaces/auth_interface.dart';
import '../interfaces/courses_interface.dart';
import '../interfaces/groups_interface.dart';
import '../interfaces/notifications_settings_interface.dart';
import '../interfaces/sessions_interface.dart';
import '../interfaces/user_interface.dart';

class FirebaseProvider {
  static final _fireAchievementsService = FireAchievementsService();
  static final _fireAppearanceSettingsService = FireAppearanceSettingsService();
  static final _fireAuthService = FireAuthService();
  static final _fireAvatarService = FireAvatarService();
  static final _fireCoursesService = FireCoursesService();
  static final _fireDaysService = FireDaysService();
  static final _fireFlashcardsService = FireFlashcardsService();
  static final _fireGroupsService = FireGroupsService();
  static final _fireNotificationsSettingsService =
      FireNotificationsSettingsService();
  static final _fireSessionsService = FireSessionsService();
  static final _fireUserService = FireUserService();

  static AchievementsInterface provideAchievementsInterface() {
    return AchievementsRepository(
      fireAchievementsService: _fireAchievementsService,
    );
  }

  static AppearanceSettingsInterface provideAppearanceSettingsInterface() {
    return AppearanceSettingsRepository(
      fireAppearanceSettingsService: _fireAppearanceSettingsService,
    );
  }

  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: _fireAuthService,
    );
  }

  static CoursesInterface provideCoursesInterface() {
    return CoursesRepository(fireCoursesService: _fireCoursesService);
  }

  static GroupsInterface provideGroupsInterface() {
    return GroupsRepository(
      fireGroupsService: _fireGroupsService,
      fireFlashcardsService: _fireFlashcardsService,
    );
  }

  static NotificationsSettingsInterface
      provideNotificationsSettingsInterface() {
    return NotificationsSettingsRepository(
      fireNotificationsSettingsService: _fireNotificationsSettingsService,
    );
  }

  static SessionsInterface provideSessionsInterface() {
    return SessionsRepository(fireSessionsService: _fireSessionsService);
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: _fireUserService,
      fireAvatarService: _fireAvatarService,
    );
  }
}
