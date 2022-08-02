import 'package:flutter/material.dart';
import '../../../components/bouncing_scroll.dart';
import 'profile_avatar.dart';
import 'profile_user_data.dart';
import 'profile_stats.dart';
import 'profile_account_options.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BouncingScroll(
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
