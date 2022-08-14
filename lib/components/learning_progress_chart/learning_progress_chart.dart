import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/date_model.dart';
import '../../providers/theme_provider.dart';
import '../../ui_extensions/ui_date_extensions.dart';
import '../../utils/date_utils.dart' as date_utils;
import '../custom_icon_button.dart';
import 'learning_progress_chart_day.dart';
import 'learning_progress_chart_cubit.dart';

class LearningProgressChart extends StatelessWidget {
  final List<ChartDay>? chartDays;
  final Date initialDateOfWeek;

  const LearningProgressChart({
    super.key,
    required this.chartDays,
    required this.initialDateOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      days: chartDays,
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
  final List<ChartDay>? days;
  final Date initialDateOfWeek;
  final Widget child;

  const _CubitProvider({
    required this.days,
    required this.initialDateOfWeek,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearningProgressCubit(
        initialDateOfWeek: initialDateOfWeek,
        dateUtils: date_utils.DateUtils(),
      ),
      child: Builder(
        builder: (BuildContext context) {
          context.read<LearningProgressCubit>().updateChartDays(days);
          return child;
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final List<Date> dates = context.select(
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

  String _convertWeekToStr(List<Date> dates) {
    Date now = Date.now();
    if (dates.isEmpty) {
      return '';
    }
    if (dates.contains(now)) {
      return 'Obecny tydzień';
    }
    final String firstDate = dates.first.toUIFormat();
    final String lastDate = dates.last.toUIFormat();
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
  const _Chart();

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
          xValueMapper: (ChartDay day, _) => day.date.toWeekDayShortName(),
          yValueMapper: (ChartDay day, _) => day.rememberedFlashcardsAmount,
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
