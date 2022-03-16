import 'package:flutter/material.dart';

class ItemWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;
  final Widget? trailing;

  const ItemWithIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.label,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      width: double.infinity,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            flex: 10,
            child: label != null
                ? _TextWithLabel(
                    label: label ?? '',
                    text: text,
                  )
                : _OnlyText(text: text),
          ),
          Expanded(
            flex: 2,
            child: trailing ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _OnlyText extends StatelessWidget {
  final String text;

  const _OnlyText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.subtitle1);
  }
}

class _TextWithLabel extends StatelessWidget {
  final String label;
  final String text;

  const _TextWithLabel({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.caption),
        const SizedBox(height: 4),
        Text(text, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
