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
import '../utils/days_streak_utils.dart';

class FirebaseProvider {
  static AchievementsInterface provideAchievementsInterface() {
    return AchievementsRepository(
      fireAchievementsService: FireAchievementsService(),
    );
  }

  static AppearanceSettingsInterface provideAppearanceSettingsInterface() {
    return AppearanceSettingsRepository(
      fireAppearanceSettingsService: FireAppearanceSettingsService(),
    );
  }

  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(),
    );
  }

  static CoursesInterface provideCoursesInterface() {
    return CoursesRepository(fireCoursesService: FireCoursesService());
  }

  static GroupsInterface provideGroupsInterface() {
    return GroupsRepository(
      fireGroupsService: FireGroupsService(),
      fireFlashcardsService: FireFlashcardsService(),
    );
  }

  static NotificationsSettingsInterface
      provideNotificationsSettingsInterface() {
    return NotificationsSettingsRepository(
      fireNotificationsSettingsService: FireNotificationsSettingsService(),
    );
  }

  static SessionsInterface provideSessionsInterface() {
    return SessionsRepository(fireSessionsService: FireSessionsService());
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: FireUserService(),
      fireAvatarService: FireAvatarService(),
      fireDaysService: FireDaysService(),
      daysStreakUtils: DaysStreakUtils(),
    );
  }
}
