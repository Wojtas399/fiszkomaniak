import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final bool? displayDividerAtTheBottom;

  const Section({
    Key? key,
    required this.title,
    required this.child,
    this.trailing,
    this.displayDividerAtTheBottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: title,
          trailing: trailing,
        ),
        const SizedBox(height: 8),
        child,
        displayDividerAtTheBottom == true
            ? const Divider(thickness: 1, height: 32)
            : const SizedBox(height: 8),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _Header({Key? key, required this.title, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          flex: 2,
          child: trailing ?? const SizedBox(),
        ),
      ],
    );
  }
}
