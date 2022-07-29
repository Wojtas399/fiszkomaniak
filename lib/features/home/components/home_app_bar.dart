import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/avatar/avatar.dart';
import '../../../components/avatar/avatar_image_type.dart';
import '../../../config/navigation.dart';
import '../../../config/theme/global_theme.dart';
import '../bloc/home_bloc.dart';
import '../home.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GlobalTheme.lightTheme,
      child: AppBar(
        title: const _Title(),
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

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final pageNumber = context.watch<HomePageController>().pageNumber;
    return Text(_getPageTitle(pageNumber));
  }

  String _getPageTitle(int pageNumber) {
    switch (pageNumber) {
      case 0:
        return 'Nauka';
      case 1:
        return 'Sesje';
      case 2:
        return 'Kursy';
      case 3:
        return 'Profil';
      default:
        return '';
    }
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
      (HomeBloc bloc) => bloc.state.loggedUserAvatarUrl,
    );
    return Avatar(
      imageType: avatarUrl != null && avatarUrl.isNotEmpty
          ? AvatarImageTypeUrl(url: avatarUrl)
          : null,
      size: 42.0,
    );
  }
}

class _DaysInARow extends StatelessWidget {
  const _DaysInARow();

  @override
  Widget build(BuildContext context) {
    // final int daysStreak = context.select(
    //   (AchievementsBloc bloc) => bloc.state.daysStreak,
    // );
    return Text(
      _convertStreakToString(0),
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
