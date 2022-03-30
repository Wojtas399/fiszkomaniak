import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/components/select_item.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_group_info.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupCreator extends StatelessWidget {
  const GroupCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(label: 'Nowa grupa'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: OnTapFocusLoseArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SelectItem(
                      icon: MdiIcons.archiveOutline,
                      label: 'Kurs',
                      value: 'Język angielski',
                      options: const [
                        'Język angielski',
                        'Język hiszpański',
                        'Język polski',
                        'Matematyka',
                        'Medycyna',
                        'Informatyka',
                      ],
                      onOptionSelected: (String option) {
                        print(option);
                      },
                    ),
                    const SizedBox(height: 24),
                    const GroupCreatorGroupInfo(),
                  ],
                ),
                Button(
                  label: 'Utwórz',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
