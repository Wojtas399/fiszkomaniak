import 'dart:async';
import 'dart:io';
import 'package:fiszkomaniak/firebase/fire_references.dart';

class FireAvatarService {
  final StreamController<String?> _loggedUserAvatarUrl = StreamController();

  Stream<String?> getLoggedUserAvatarSnapshots() {
    _loadLoggedUserAvatarUrl();
    return _loggedUserAvatarUrl.stream;
  }

  Future<void> _loadLoggedUserAvatarUrl() async {
    try {
      final String url = await FireReferences.avatarRef.getDownloadURL();
      _loggedUserAvatarUrl.add(url);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveNewLoggedUserAvatar(String fullPath) async {
    try {
      await removeLoggedUserAvatar();
      final File imageFile = File(fullPath);
      await FireReferences.avatarRef.putFile(imageFile);
      final String url = await FireReferences.avatarRef.getDownloadURL();
      _loggedUserAvatarUrl.add(url);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeLoggedUserAvatar() async {
    try {
      if (await _doesLoggedUserAvatarExist()) {
        await FireReferences.avatarRef.delete();
      }
      _loggedUserAvatarUrl.add(null);
    } catch (error) {
      rethrow;
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
