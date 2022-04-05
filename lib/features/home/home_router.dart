import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/course_groups_preview/course_groups_preview.dart';
import 'package:fiszkomaniak/features/flashcards_creator/flashcards_creator.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/group_creator_page.dart';
import 'package:fiszkomaniak/features/group_preview/group_preview_page.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/home/home_view.dart';
import 'package:fiszkomaniak/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class HomeRouter extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';

  static const String settings = '/settings';

  static const String courseCreator = '/course-creator';

  static const String groupCreator = '/group-creator';

  static const String flashcardsCreator = '/flashcards-creator';

  static const String courseGroupsPreview = '/course-groups-preview';

  static const String groupPreview = '/group-preview';

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
        return SlideUpRouteAnimation(page: const SettingsPage());
      case courseCreator:
        return SlideUpRouteAnimation(
          page: CourseCreator(
            mode: routeSettings.arguments as CourseCreatorMode,
          ),
        );
      case groupCreator:
        return SlideUpRouteAnimation(
          page: GroupCreator(
            mode: routeSettings.arguments as GroupCreatorMode,
          ),
        );
      case flashcardsCreator:
        return SlideUpRouteAnimation(
          page: const FlashcardsCreator(),
        );
      case courseGroupsPreview:
        return SlideUpRouteAnimation(
          page: CourseGroupsPreview(
            courseId: routeSettings.arguments as String,
          ),
        );
      case groupPreview:
        return SlideUpRouteAnimation(
          page: GroupPreview(groupId: routeSettings.arguments as String),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: routeSettings,
        );
    }
  }
}
