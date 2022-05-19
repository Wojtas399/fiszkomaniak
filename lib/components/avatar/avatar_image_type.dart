import 'dart:io';

abstract class AvatarImageType {}

class AvatarImageTypeUrl extends AvatarImageType {
  final String url;

  AvatarImageTypeUrl({required this.url});
}

class AvatarImageTypeFile extends AvatarImageType {
  final File file;

  AvatarImageTypeFile({required this.file});
}
