import 'package:flutter/material.dart';

class BouncingScroll extends StatelessWidget {
  final Widget child;

  const BouncingScroll({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
