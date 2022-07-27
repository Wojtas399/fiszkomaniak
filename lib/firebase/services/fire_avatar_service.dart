import 'dart:async';
import 'dart:io';
import '../fire_references.dart';

class FireAvatarService {
  Future<String?> loadLoggedUserAvatarUrl() async {
    if (await _doesLoggedUserAvatarExist()) {
      return await FireReferences.avatarRef.getDownloadURL();
    }
    return null;
  }

  Future<void> saveNewLoggedUserAvatar(String fullPath) async {
    await removeLoggedUserAvatar();
    final File imageFile = File(fullPath);
    await FireReferences.avatarRef.putFile(imageFile);
  }

  Future<void> removeLoggedUserAvatar() async {
    if (await _doesLoggedUserAvatarExist()) {
      await FireReferences.avatarRef.delete();
    }
  }

  Future<bool> _doesLoggedUserAvatarExist() async {
    try {
      await FireReferences.avatarRef.getDownloadURL();
      return true;
    } catch (error) {
      return false;
    }
  }
}
