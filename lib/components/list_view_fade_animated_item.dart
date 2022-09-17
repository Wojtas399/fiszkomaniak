import 'package:flutter/material.dart';

class ListViewFadeAnimatedItem extends StatefulWidget {
  final Widget child;

  const ListViewFadeAnimatedItem({super.key, required this.child});

  @override
  State<ListViewFadeAnimatedItem> createState() =>
      _ListViewFadeAnimatedItemState();
}

class _ListViewFadeAnimatedItemState extends State<ListViewFadeAnimatedItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
    );
  }
}
