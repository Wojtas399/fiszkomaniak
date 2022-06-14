import 'dart:async';
import 'dart:io';
import 'package:fiszkomaniak/firebase/fire_references.dart';

class FireAvatarService {
  Future<String> loadLoggedUserAvatarUrl() async {
    return await FireReferences.avatarRef.getDownloadURL();
  }

  Future<void> saveNewLoggedUserAvatar(String fullPath) async {
    try {
      await removeLoggedUserAvatar();
      final File imageFile = File(fullPath);
      await FireReferences.avatarRef.putFile(imageFile);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeLoggedUserAvatar() async {
    try {
      if (await doesLoggedUserAvatarExist()) {
        await FireReferences.avatarRef.delete();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> doesLoggedUserAvatarExist() async {
    try {
      await FireReferences.avatarRef.getDownloadURL();
      return true;
    } catch (error) {
      return false;
    }
  }
}
