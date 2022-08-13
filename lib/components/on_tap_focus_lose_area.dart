import 'package:flutter/material.dart';
import '../utils/utils.dart';

class OnTapFocusLoseArea extends StatelessWidget {
  final Widget child;

  const OnTapFocusLoseArea({
    super.key,
    required this.child,
  });

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
