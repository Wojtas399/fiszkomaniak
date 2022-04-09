import 'package:flutter/material.dart';

class ItemWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;
  final Widget? trailing;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  const ItemWithIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.label,
    this.trailing,
    this.paddingLeft = 16.0,
    this.paddingRight = 16.0,
    this.paddingTop = 16.0,
    this.paddingBottom = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: paddingLeft,
        right: paddingRight,
        top: paddingTop,
        bottom: paddingBottom,
      ),
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
