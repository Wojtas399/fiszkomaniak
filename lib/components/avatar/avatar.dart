import 'dart:ui';
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
    final AvatarImageType? imageType = this.imageType;
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(200.0),
          ),
          child: imageType != null
              ? _AvatarImage(imageType: imageType)
              : _AvatarIcon(size: size * 0.6),
        ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final AvatarImageType imageType;

  const _AvatarImage({required this.imageType});

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? imageProvider = _getImageProvider();
    final Widget? imageWidget = _getImageWidget();
    if (imageProvider != null && imageWidget != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: imageWidget,
          ),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.error),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    final AvatarImageType imageType = this.imageType;
    if (imageType is AvatarImageTypeUrl) {
      return CachedNetworkImageProvider(imageType.url);
    } else if (imageType is AvatarImageTypeFile) {
      return FileImage(imageType.file);
    }
    return null;
  }

  Widget? _getImageWidget() {
    final AvatarImageType imageType = this.imageType;
    if (imageType is AvatarImageTypeUrl) {
      return _UrlImage(url: imageType.url);
    } else if (imageType is AvatarImageTypeFile) {
      return Image.file(imageType.file);
    }
    return null;
  }
}

class _UrlImage extends StatelessWidget {
  final String url;

  const _UrlImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
    );
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
        size: size,
        color: Colors.black.withOpacity(0.2),
      ),
    );
  }
}
