import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/use_cases/achievements/get_all_flashcards_achieved_condition_use_case.dart';
import '../../domain/use_cases/achievements/get_finished_sessions_achieved_condition_use_case.dart';
import '../../domain/use_cases/achievements/get_remembered_flashcards_achieved_condition_use_case.dart';
import '../../interfaces/achievements_interface.dart';
import 'listeners/achievements_listener.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;

  const HomeListeners({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final AchievementsListener achievementsListener = AchievementsListener(
      getAllFlashcardsAchievedConditionUseCase:
          GetAllFlashcardsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
      getRememberedFlashcardsAchievedConditionUseCase:
          GetRememberedFlashcardsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
      getFinishedSessionsAchievedConditionUseCase:
          GetFinishedSessionsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
    );
    achievementsListener.initialize();
    return Provider(
      create: (_) => achievementsListener,
      dispose: (_, AchievementsListener listener) => listener.dispose(),
      child: child,
    );
  }
}
