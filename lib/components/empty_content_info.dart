import 'package:flutter/material.dart';

class EmptyContentInfo extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;

  const EmptyContentInfo({
    Key? key,
    this.icon,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.3)
        : Colors.black.withOpacity(0.3);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon != null ? Icon(icon, size: 48, color: color) : const SizedBox(),
        SizedBox(height: icon != null ? 16 : 0),
        title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
        SizedBox(height: title != null ? 8 : 0),
        subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  letterSpacing: 0.15,
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
      ],
    );
  }
}
