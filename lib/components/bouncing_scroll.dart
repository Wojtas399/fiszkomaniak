import 'package:flutter/material.dart';

class BouncingScroll extends StatelessWidget {
  final Widget child;

  const BouncingScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
