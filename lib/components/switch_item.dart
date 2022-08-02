import 'package:flutter/material.dart';

class SwitchItem extends StatefulWidget {
  final bool? isSwitched;
  final bool? disabled;
  final Function(bool isSwitched)? onSwitchChanged;

  const SwitchItem({
    super.key,
    this.isSwitched,
    this.disabled,
    this.onSwitchChanged,
  });

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  bool _isSwitched = false;

  @override
  initState() {
    _isSwitched = widget.isSwitched ?? false;
    super.initState();
  }

  @override
  didUpdateWidget(oldWidget) {
    setState(() {
      _isSwitched = widget.isSwitched ?? false;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 45,
      child: Switch(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: _isSwitched,
        onChanged: widget.disabled == true ? null : _onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _onChanged(bool isSwitched) {
    setState(() {
      _isSwitched = isSwitched;
    });
    final onSwitchChanged = widget.onSwitchChanged;
    if (onSwitchChanged != null) {
      onSwitchChanged(isSwitched);
    }
  }
}
