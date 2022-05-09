import 'package:fiszkomaniak/components/avatar.dart';
import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingScroll(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Avatar(
              size: 250.0,
              onTap: () {
                //TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}
