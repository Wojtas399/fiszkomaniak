import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'avatar_image_type.dart';

class Avatar extends StatelessWidget {
  final AvatarImageType? imageType;
  final double size;
  final VoidCallback? onPressed;

  const Avatar({
    super.key,
    required this.imageType,
    required this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? imageProvider = _getImageProvider();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ]),
      child: GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: Colors.white,
          child:
              imageProvider == null ? _AvatarIcon(size: size) : const Text(''),
        ),
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    final AvatarImageType? imageType = this.imageType;
    if (imageType is AvatarImageTypeUrl) {
      return CachedNetworkImageProvider(imageType.url);
    } else if (imageType is AvatarImageTypeFile) {
      return FileImage(imageType.file);
    }
    return null;
  }
}

class _AvatarIcon extends StatelessWidget {
  final double size;

  const _AvatarIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        MdiIcons.account,
        size: 0.75 * size,
        color: Colors.black.withOpacity(0.2),
      ),
    );
  }
}
