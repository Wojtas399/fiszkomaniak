import 'package:flutter/material.dart';

import 'profile_account_options.dart';
import 'profile_avatar.dart';
import 'profile_stats.dart';
import 'profile_user_data.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: const [
            ProfileAvatar(),
            SizedBox(height: 24.0),
            ProfileUserData(),
            ProfileStats(),
            ProfileAccountOptions(),
            SizedBox(height: 148.0),
          ],
        ),
      ),
    );
  }
}
