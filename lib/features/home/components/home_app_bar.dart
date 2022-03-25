import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int displayingPageNumber;
  final List<String> _pageNames = ['Nauka', 'Sesje', 'Kursy', 'Profil'];

  HomeAppBar({Key? key, required this.displayingPageNumber}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GlobalTheme.lightTheme,
      child: AppBar(
        title: Text(_pageNames[displayingPageNumber]),
        centerTitle: true,
        leadingWidth: 200,
        leading: const _AvatarAndDays(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(MdiIcons.bell),
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigation.navigateToSettings();
            },
            icon: const Icon(MdiIcons.cog),
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
}

class _AvatarAndDays extends StatelessWidget {
  const _AvatarAndDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(MdiIcons.medal),
          Text(
            '24',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
