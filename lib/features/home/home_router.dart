import 'package:fiszkomaniak/features/course_creator/course_creator.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/course_groups_preview/course_groups_preview.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
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
import '../../config/routes.dart';
import '../flashcard_preview/bloc/flashcard_preview_bloc.dart';
import '../learning_process/learning_process.dart';
import '../learning_process/learning_process_data.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  State<HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: Routes.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
          settings: routeSettings,
        );
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case Routes.courseCreator:
        return MaterialPageRoute(
          builder: (_) => CourseCreator(
            mode: routeSettings.arguments as CourseCreatorMode,
          ),
        );
      case Routes.groupCreator:
        return MaterialPageRoute(
          builder: (_) => GroupCreator(
            mode: routeSettings.arguments as GroupCreatorMode,
          ),
        );
      case Routes.sessionCreator:
        return MaterialPageRoute(
          builder: (_) => SessionCreator(
            mode: routeSettings.arguments as SessionCreatorMode,
          ),
        );
      case Routes.groupSelection:
        return MaterialPageRoute(
          builder: (_) => GroupSelection(),
        );
      case Routes.flashcardsEditor:
        return MaterialPageRoute(
          builder: (_) => FlashcardsEditor(
            mode: routeSettings.arguments as FlashcardsEditorMode,
          ),
        );
      case Routes.courseGroupsPreview:
        return MaterialPageRoute(
          builder: (_) => CourseGroupsPreview(
            courseId: routeSettings.arguments as String,
          ),
        );
      case Routes.groupFlashcardsPreview:
        return MaterialPageRoute(
          builder: (_) => GroupFlashcardsPreview(
            groupId: routeSettings.arguments as String,
          ),
        );
      case Routes.groupPreview:
        return MaterialPageRoute(
          builder: (_) => GroupPreview(
            groupId: routeSettings.arguments as String,
          ),
        );
      case Routes.flashcardPreview:
        return MaterialPageRoute(
          builder: (_) => FlashcardPreview(
            params: routeSettings.arguments as FlashcardPreviewParams,
          ),
        );
      case Routes.sessionPreview:
        return MaterialPageRoute(
          builder: (_) => SessionPreview(
            mode: routeSettings.arguments as SessionPreviewMode,
          ),
        );
      case Routes.session:
        return MaterialPageRoute(
          builder: (_) => LearningProcess(
            data: routeSettings.arguments as LearningProcessData,
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
