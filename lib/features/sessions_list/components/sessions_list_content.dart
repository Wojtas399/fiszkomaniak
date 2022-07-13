import 'package:fiszkomaniak/features/sessions_list/bloc/sessions_list_bloc.dart';
import 'package:fiszkomaniak/features/sessions_list/components/sessions_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/empty_content_info.dart';

class SessionsListContent extends StatelessWidget {
  const SessionsListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SessionItemParams> sessionsItemsParams = context.select(
      (SessionsListBloc bloc) => bloc.state.sessionsItemsParams,
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
