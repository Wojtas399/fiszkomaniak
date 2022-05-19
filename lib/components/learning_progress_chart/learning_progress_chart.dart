import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/learning_progress_chart/learning_progress_cubit.dart';
import 'package:fiszkomaniak/converters/date_converters.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LearningProgressChart extends StatelessWidget {
  final List<Day>? daysFromUser;
  final DateTime initialDateOfWeek;

  const LearningProgressChart({
    Key? key,
    required this.daysFromUser,
    required this.initialDateOfWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      daysFromUser: daysFromUser,
      initialDateOfWeek: initialDateOfWeek,
      child: Center(
        child: Column(
          children: const [
            _Header(),
            SizedBox(height: 8.0),
            _Chart(),
          ],
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final List<Day>? daysFromUser;
  final DateTime initialDateOfWeek;
  final Widget child;

  const _CubitProvider({
    Key? key,
    required this.daysFromUser,
    required this.initialDateOfWeek,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearningProgressCubit(
        initialDateOfWeek: initialDateOfWeek,
      ),
      child: Builder(
        builder: (BuildContext context) {
          context.read<LearningProgressCubit>().updateDaysFromUser(
                daysFromUser,
              );
          return child;
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = context.select(
      (LearningProgressCubit cubit) => cubit.onlyDates,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          icon: MdiIcons.chevronLeft,
          onPressed: () => _previousWeek(context),
        ),
        Text(
          _convertWeekToStr(dates),
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomIconButton(
          icon: MdiIcons.chevronRight,
          onPressed: () => _nextWeek(context),
        ),
      ],
    );
  }

  String _convertWeekToStr(List<DateTime> dates) {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    if (dates.contains(now)) {
      return 'Obecny tydzień';
    }
    final String firstDate = convertDateToViewFormat(dates.first);
    final String lastDate = convertDateToViewFormat(dates.last);
    return '$firstDate - $lastDate';
  }

  void _previousWeek(BuildContext context) {
    context.read<LearningProgressCubit>().switchToPreviousWeek();
  }

  void _nextWeek(BuildContext context) {
    context.read<LearningProgressCubit>().switchToNextWeek();
  }
}

class _Chart extends StatelessWidget {
  const _Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.select(
      (ThemeProvider provider) => provider.isDarkMode,
    );
    final Color linesColor = isDarkMode
        ? Colors.white.withOpacity(0.4)
        : Colors.black.withOpacity(0.4);
    final List<ChartDay> days = context.select(
      (LearningProgressCubit cubit) => cubit.state,
    );
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: AxisLine(color: linesColor),
        majorTickLines: const MajorTickLines(width: 0.0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(color: linesColor),
        axisLine: const AxisLine(width: 0.0),
        majorTickLines: const MajorTickLines(size: 0.0),
      ),
      plotAreaBorderWidth: 0.0,
      series: <LineSeries<ChartDay, String>>[
        LineSeries<ChartDay, String>(
          color: Theme.of(context).colorScheme.primary,
          dataSource: days,
          xValueMapper: (ChartDay day, _) => convertDateToWeekDayShortName(
            day.date,
          ),
          yValueMapper: (ChartDay day, _) => day.amountOfRememberedFlashcards,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Theme.of(context).colorScheme.primary,
          ),
          animationDuration: 600,
        ),
      ],
    );
  }
}

class SalesData {
  final String word;
  final int num;

  SalesData({required this.word, required this.num});
}
