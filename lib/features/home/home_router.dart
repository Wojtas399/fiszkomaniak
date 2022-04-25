import 'package:fiszkomaniak/features/course_creator/course_creator.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/course_groups_preview/course_groups_preview.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/group_flashcards_preview.dart';
import 'package:fiszkomaniak/features/group_selection/group_selection.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/group_creator_page.dart';
import 'package:fiszkomaniak/features/group_preview/group_preview_page.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/home/home_view.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_creator/session_creator.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/features/session_preview/session_preview.dart';
import 'package:fiszkomaniak/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class HomeRouter extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';

  static const String settings = '/settings';

  static const String courseCreator = '/course-creator';

  static const String groupCreator = '/group-creator';

  static const String sessionCreator = '/session-creator';

  static const String groupSelection = '/group-selection';

  static const String flashcardsEditor = '/flashcards-editor';

  static const String courseGroupsPreview = '/course-groups-preview';

  static const String groupFlashcardsPreview = '/group-flashcards-preview';

  static const String groupPreview = '/group-preview';

  static const String flashcardPreview = '/flashcard-preview';

  static const String sessionPreview = '/session-preview';

  const HomeRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: home,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
          settings: routeSettings,
        );
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case courseCreator:
        return MaterialPageRoute(
          builder: (_) => CourseCreator(
            mode: routeSettings.arguments as CourseCreatorMode,
          ),
        );
      case groupCreator:
        return MaterialPageRoute(
          builder: (_) => GroupCreator(
            mode: routeSettings.arguments as GroupCreatorMode,
          ),
        );
      case sessionCreator:
        return MaterialPageRoute(
          builder: (_) => SessionCreator(
            mode: routeSettings.arguments as SessionCreatorMode,
          ),
        );
      case groupSelection:
        return MaterialPageRoute(
          builder: (_) => GroupSelection(),
        );
      case flashcardsEditor:
        return MaterialPageRoute(
          builder: (_) => FlashcardsEditor(
            groupId: routeSettings.arguments as String,
          ),
        );
      case courseGroupsPreview:
        return MaterialPageRoute(
          builder: (_) => CourseGroupsPreview(
            courseId: routeSettings.arguments as String,
          ),
        );
      case groupFlashcardsPreview:
        return MaterialPageRoute(
          builder: (_) => GroupFlashcardsPreview(
            groupId: routeSettings.arguments as String,
          ),
        );
      case groupPreview:
        return MaterialPageRoute(
          builder: (_) => GroupPreview(
            groupId: routeSettings.arguments as String,
          ),
        );
      case flashcardPreview:
        return MaterialPageRoute(
          builder: (_) => FlashcardPreview(
            flashcardId: routeSettings.arguments as String,
          ),
        );
      case sessionPreview:
        return MaterialPageRoute(
          builder: (_) => SessionPreview(
            mode: routeSettings.arguments as SessionPreviewMode,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: routeSettings,
        );
    }
  }
}
