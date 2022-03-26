import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';

class OnTapFocusLoseArea extends StatelessWidget {
  final Widget child;

  const OnTapFocusLoseArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocusElements(),
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
