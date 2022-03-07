import 'package:flutter/material.dart';

class AnimatedForm extends StatelessWidget {
  final Widget form;
  final bool isVisible;

  const AnimatedForm({
    Key? key,
    required this.form,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: isVisible ? 1 : 0,
        child: form,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      transform: Matrix4.translationValues(0, isVisible ? 0 : 700, 0),
    );
  }
}
