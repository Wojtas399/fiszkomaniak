import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/learning_progress_chart/learning_progress_chart_day.dart';
import '../../../components/learning_progress_chart/learning_progress_chart.dart';
import '../../../components/section.dart';
import '../../../models/date_model.dart';
import '../../../domain/entities/day.dart';
import '../bloc/profile_bloc.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Statystyki',
      displayDividerAtTheBottom: true,
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          IntrinsicHeight(
            child: Row(
              children: const [
                Expanded(
                  child: _DaysInARow(),
                ),
                VerticalDivider(thickness: 1),
                Expanded(
                  child: _AmountOfFlashcards(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const _Chart(),
        ],
      ),
    );
  }
}

class _DaysInARow extends StatelessWidget {
  const _DaysInARow();

  @override
  Widget build(BuildContext context) {
    final int daysInARow = context.select(
      (ProfileBloc bloc) => bloc.state.daysStreak,
    );
    return _NumberInfo(
      icon: MdiIcons.medalOutline,
      label: 'Dni nauki z rzędu',
      value: daysInARow,
    );
  }
}

class _AmountOfFlashcards extends StatelessWidget {
  const _AmountOfFlashcards();

  @override
  Widget build(BuildContext context) {
    final int amount = context.select(
      (ProfileBloc bloc) => bloc.state.amountOfRememberedFlashcards,
    );
    return _NumberInfo(
      icon: MdiIcons.cardsOutline,
      label: 'Nauczone fiszki',
      value: amount,
    );
  }
}

class _NumberInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _NumberInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(label, textAlign: TextAlign.center),
            const SizedBox(height: 4.0),
            Text(
              '$value',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    final List<Day>? days = context.select(
      (ProfileBloc bloc) => bloc.state.user?.days,
    );
    return LearningProgressChart(
      chartDays: _convertUserDaysToChartDays(days),
      initialDateOfWeek: Date.now(),
    );
  }

  List<ChartDay> _convertUserDaysToChartDays(List<Day>? days) {
    if (days == null) {
      return [];
    }
    return days
        .map(
          (Day day) => ChartDay(
            date: day.date,
            rememberedFlashcardsAmount: day.amountOfRememberedFlashcards,
          ),
        )
        .toList();
  }
}
