import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/empty_content_info.dart';
import '../components/sessions_list_item.dart';
import '../sessions_list_cubit.dart';

class SessionsListContent extends StatelessWidget {
  const SessionsListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SessionItemParams> sessionsItemsParams = context.select(
      (SessionsListCubit cubit) => cubit.state,
    );
    if (sessionsItemsParams.isEmpty) {
      return const _InfoAboutLackOfSessions();
    }
    return BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: 32,
            left: 16,
          ),
          child: Column(
            children: sessionsItemsParams
                .map((params) => SessionsListItem(params: params))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _InfoAboutLackOfSessions extends StatelessWidget {
  const _InfoAboutLackOfSessions();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: EmptyContentInfo(
        icon: MdiIcons.calendarCheck,
        title: 'Brak sesji',
        subtitle:
            'Naciśnij fioletowy przycisk u dołu ekranu aby utworzyć nowe sesje',
      ),
    );
  }
}
