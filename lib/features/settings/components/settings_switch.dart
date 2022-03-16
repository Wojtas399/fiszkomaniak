import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsSwitch extends StatelessWidget {
  final bool? isSwitched;
  final Function(bool isSwitched)? onSwitchChanged;
  final _isSwitched = BehaviorSubject<bool>.seeded(false);

  SettingsSwitch({
    Key? key,
    this.isSwitched,
    this.onSwitchChanged,
  }) : super(key: key) {
    _isSwitched.add(isSwitched ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _isSwitched,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        bool isSwitched = snapshot.data ?? false;
        return SizedBox(
          height: 24,
          width: 45,
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isSwitched,
            onChanged: (bool value) {
              _isSwitched.add(value);
              onSwitchChanged!(value);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
