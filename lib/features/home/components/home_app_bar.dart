import 'package:fiszkomaniak/components/avatar/avatar.dart';
import 'package:fiszkomaniak/components/avatar/avatar_image_type.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              context.read<Navigation>().navigateToSettings();
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
          const _LoggedUserAvatar(),
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

class _LoggedUserAvatar extends StatelessWidget {
  const _LoggedUserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = context.select(
      (UserBloc bloc) => bloc.state.loggedUser?.avatarUrl,
    );
    return Avatar(
      imageType: avatarUrl != null ? AvatarImageTypeUrl(url: avatarUrl) : null,
      size: 42.0,
    );
  }
}
