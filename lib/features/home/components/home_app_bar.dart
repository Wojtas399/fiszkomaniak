import 'package:fiszkomaniak/components/avatar/avatar.dart';
import 'package:fiszkomaniak/components/avatar/avatar_image_type.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int displayingPageNumber;
  final List<String> _pageNames = ['Nauka', 'Sesje', 'Kursy', 'Profil'];

  HomeAppBar({super.key, required this.displayingPageNumber});

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
            padding: const EdgeInsets.all(0),
            onPressed: () => _onSettingsPressed(context),
            icon: const Icon(MdiIcons.cog),
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }

  void _onSettingsPressed(BuildContext context) {
    context.read<Navigation>().navigateToSettings();
  }
}

class _AvatarAndDays extends StatelessWidget {
  const _AvatarAndDays();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          const _LoggedUserAvatar(),
          const SizedBox(width: 4.0),
          Expanded(
            child: Row(
              children: const [
                Icon(MdiIcons.medal),
                SizedBox(width: 2.0),
                _DaysInARow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoggedUserAvatar extends StatelessWidget {
  const _LoggedUserAvatar();

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

class _DaysInARow extends StatelessWidget {
  const _DaysInARow();

  @override
  Widget build(BuildContext context) {
    final int daysStreak = context.select(
      (AchievementsBloc bloc) => bloc.state.daysStreak,
    );
    return Text(
      _convertStreakToString(daysStreak),
      style: Theme.of(context).textTheme.subtitle1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _convertStreakToString(int value) {
    if (value >= 1000) {
      return '999+';
    }
    return '$value';
  }
}
