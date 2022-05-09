import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Avatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const Avatar({
    Key? key,
    required this.size,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: _AvatarIcon(size: size * 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200.0),
          ),
        ),
      ),
    );
  }
}

class _AvatarIcon extends StatelessWidget {
  final double size;

  const _AvatarIcon({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        MdiIcons.account,
        size: size,
        color: Colors.black.withOpacity(0.2),
      ),
    );
  }
}
