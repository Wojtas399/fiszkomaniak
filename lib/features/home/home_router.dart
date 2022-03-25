import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/home/home_view.dart';
import 'package:fiszkomaniak/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class HomeRouter extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';

  static const String settings = '/settings';

  static const String courseCreator = '/course-creator';

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
      default:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: routeSettings,
        );
    }
  }
}
