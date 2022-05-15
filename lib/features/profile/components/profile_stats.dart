import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Statystyki',
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
        ],
      ),
    );
  }
}

class _DaysInARow extends StatelessWidget {
  const _DaysInARow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int daysInARow = context.select(
      (ProfileBloc bloc) => bloc.state.amountOfDaysInARow,
    );
    return _NumberInfo(
      icon: MdiIcons.medalOutline,
      label: 'Dni z rzędu',
      value: daysInARow,
    );
  }
}

class _AmountOfFlashcards extends StatelessWidget {
  const _AmountOfFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int amount = context.select(
      (ProfileBloc bloc) => bloc.state.amountOfAllFlashcards,
    );
    return _NumberInfo(
      icon: MdiIcons.cardsOutline,
      label: 'Ilość fiszek',
      value: amount,
    );
  }
}

class _NumberInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _NumberInfo({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(label),
            const SizedBox(height: 4.0),
            Text('$value'),
          ],
        ),
      ],
    );
  }
}
