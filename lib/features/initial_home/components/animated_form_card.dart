import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../../../providers/initial_home_mode_provider.dart';

class AnimatedFormCard extends StatelessWidget {
  final Widget child;

  const AnimatedFormCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return _AnimatedCard(
          child: _AnimatedPadding(
            child: child,
            isKeyboardVisible: isKeyboardVisible,
          ),
          isKeyboardVisible: isKeyboardVisible,
        );
      },
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final Widget child;
  final bool isKeyboardVisible;

  const _AnimatedCard({
    Key? key,
    required this.child,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    double height = initialHomeModeProvider.isLoginMode ? 510 : 580;
    double screenHeight = MediaQuery.of(context).size.height;
    double borderRadius = isKeyboardVisible ? 0 : 40;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: isKeyboardVisible ? screenHeight : height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

class _AnimatedPadding extends StatelessWidget {
  final Widget child;
  final bool isKeyboardVisible;

  const _AnimatedPadding({
    Key? key,
    required this.child,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double loginModeTopPadding = screenWidth * 0.22;
    final double registerModeTopPadding = screenWidth * 0.07;
    final double topPadding = initialHomeModeProvider.isLoginMode
        ? loginModeTopPadding
        : registerModeTopPadding;
    return AnimatedPadding(
      padding: EdgeInsets.only(top: isKeyboardVisible ? topPadding : 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: child,
    );
  }
}
