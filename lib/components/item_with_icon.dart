import 'package:flutter/material.dart';

class ItemWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final VoidCallback? onTap;

  const ItemWithIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.label,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.paddingLeft = 16.0,
    this.paddingRight = 16.0,
    this.paddingTop = 16.0,
    this.paddingBottom = 16.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Container(
          padding: EdgeInsets.only(
            left: paddingLeft,
            right: paddingRight,
            top: paddingTop,
            bottom: paddingBottom,
          ),
          width: double.infinity,
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                flex: 10,
                child: label != null
                    ? _TextWithLabel(
                        label: label ?? '',
                        text: text,
                        textColor: textColor,
                      )
                    : _OnlyText(text: text, textColor: textColor),
              ),
              Expanded(
                flex: 2,
                child: trailing ?? const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnlyText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const _OnlyText({
    Key? key,
    required this.text,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16.0,
        letterSpacing: 0.15,
      ),
    );
  }
}

class _TextWithLabel extends StatelessWidget {
  final String label;
  final String text;
  final Color? textColor;

  const _TextWithLabel({
    Key? key,
    required this.label,
    required this.text,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.caption),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.0,
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }
}
