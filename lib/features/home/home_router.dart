import 'package:flutter/material.dart';
import '../../features/course_creator/course_creator_screen.dart';
import '../../features/course_creator/course_creator_mode.dart';
import '../../features/course_groups_preview/course_groups_preview_screen.dart';
import '../../features/flashcard_preview/flashcard_preview_screen.dart';
import '../../features/flashcards_editor/flashcards_editor_screen.dart';
import '../../features/group_flashcards_preview/group_flashcards_preview_screen.dart';
import '../../features/group_selection/group_selection_screen.dart';
import '../../features/group_creator/group_creator_screen.dart';
import '../../features/group_preview/group_preview_screen.dart';
import '../../features/home/home.dart';
import '../../features/home/home_view.dart';
import '../../features/session_creator/bloc/session_creator_mode.dart';
import '../../features/session_creator/session_creator_screen.dart';
import '../../features/session_preview/bloc/session_preview_mode.dart';
import '../../features/session_preview/session_preview_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../config/routes.dart';
import '../group_creator/group_creator_mode.dart';
import '../learning_process/learning_process_screen.dart';
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
          builder: (_) => const HomeView(),
          settings: routeSettings,
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case Routes.courseCreator:
        return MaterialPageRoute(
          builder: (_) => CourseCreatorScreen(
            mode: routeSettings.arguments as CourseCreatorMode,
          ),
        );
      case Routes.groupCreator:
        return MaterialPageRoute(
          builder: (_) => GroupCreatorScreen(
            mode: routeSettings.arguments as GroupCreatorMode,
          ),
        );
      case Routes.sessionCreator:
        return MaterialPageRoute(
          builder: (_) => SessionCreatorScreen(
            mode: routeSettings.arguments as SessionCreatorMode,
          ),
        );
      case Routes.groupSelection:
        return MaterialPageRoute(
          builder: (_) => const GroupSelectionScreen(),
        );
      case Routes.flashcardsEditor:
        return MaterialPageRoute(
          builder: (_) => FlashcardsEditorScreen(
            groupId: routeSettings.arguments as String,
          ),
        );
      case Routes.courseGroupsPreview:
        return MaterialPageRoute(
          builder: (_) => CourseGroupsPreviewScreen(
            courseId: routeSettings.arguments as String,
          ),
        );
      case Routes.groupFlashcardsPreview:
        return MaterialPageRoute(
          builder: (_) => GroupFlashcardsPreviewScreen(
            groupId: routeSettings.arguments as String,
          ),
        );
      case Routes.groupPreview:
        return MaterialPageRoute(
          builder: (_) => GroupPreviewScreen(
            groupId: routeSettings.arguments as String,
          ),
        );
      case Routes.flashcardPreview:
        return MaterialPageRoute(
          builder: (_) => FlashcardPreviewScreen(
            arguments:
                routeSettings.arguments as FlashcardPreviewScreenArguments,
          ),
        );
      case Routes.sessionPreview:
        return MaterialPageRoute(
          builder: (_) => SessionPreviewScreen(
            mode: routeSettings.arguments as SessionPreviewMode,
          ),
        );
      case Routes.session:
        return MaterialPageRoute(
          builder: (_) => LearningProcessScreen(
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
