import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../bloc/initial_home_bloc.dart';

class InitialHomeAnimatedFormCard extends StatelessWidget {
  final Widget child;

  const InitialHomeAnimatedFormCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return _AnimatedCard(
          isKeyboardVisible: isKeyboardVisible,
          child: _AnimatedPadding(
            isKeyboardVisible: isKeyboardVisible,
            child: child,
          ),
        );
      },
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final Widget child;
  final bool isKeyboardVisible;

  const _AnimatedCard({
    required this.child,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    final InitialHomeMode mode = context.select(
      (InitialHomeBloc bloc) => bloc.state.mode,
    );
    double screenHeight = MediaQuery.of(context).size.height;
    double heightInLoginMode = screenHeight * 0.6;
    double heightInRegisterMode = screenHeight * 0.72;
    double height = mode == InitialHomeMode.login
        ? heightInLoginMode
        : heightInRegisterMode;
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
    required this.child,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    final InitialHomeMode mode = context.select(
      (InitialHomeBloc bloc) => bloc.state.mode,
    );
    final double screenWidth = MediaQuery.of(context).size.width;
    final double loginModeTopPadding = screenWidth * 0.30;
    final double registerModeTopPadding = screenWidth * 0.15;
    final double topPadding = mode == InitialHomeMode.login
        ? loginModeTopPadding
        : registerModeTopPadding;
    return AnimatedPadding(
      padding: EdgeInsets.only(
        top: isKeyboardVisible ? topPadding : 32,
        left: 32,
        right: 32,
        bottom: 56,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: child,
    );
  }
}
