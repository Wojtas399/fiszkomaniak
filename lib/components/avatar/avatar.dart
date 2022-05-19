import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiszkomaniak/components/avatar/avatar_image_type.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    final AvatarImageType? type = imageType;
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
          child: type != null
              ? _AvatarImage(imageType: type)
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
    final AvatarImageType type = imageType;
    ImageProvider<Object>? imageProvider;
    Widget? image;
    if (type is AvatarImageTypeUrl) {
      imageProvider = CachedNetworkImageProvider(type.url);
      image = _UrlImage(url: type.url);
    } else if (type is AvatarImageTypeFile) {
      imageProvider = FileImage(type.file);
      image = Image.file(type.file);
    }
    if (imageProvider != null && image != null) {
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
            child: image,
          ),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.error),
    );
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
