import 'package:flutter/material.dart';

class DaysStreakDialog extends StatelessWidget {
  final int daysStreak;

  const DaysStreakDialog({super.key, required this.daysStreak});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dni nauki z rzędu'),
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Właśnie ukończyłeś'),
          const SizedBox(height: 16.0),
          Text(
            '$daysStreak',
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16.0),
          const Text('dni nauki z rzędu. Gratulacje!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Zamknij'),
        ),
      ],
    );
  }
}
