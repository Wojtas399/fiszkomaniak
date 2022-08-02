import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../home.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _LeftPart(),
            SizedBox(width: 90),
            _RightPart(),
          ],
        ),
      ),
    );
  }
}

class _LeftPart extends StatelessWidget {
  const _LeftPart();

  @override
  Widget build(BuildContext context) {
    final homePageController = context.watch<HomePageController>();
    return Expanded(
      child: Row(
        children: [
          _BottomBarItem(
            icon: MdiIcons.school,
            label: 'Nauka',
            selected: homePageController.pageNumber == 0,
            onPressed: () => homePageController.moveToPage(0),
          ),
          _BottomBarItem(
            icon: MdiIcons.calendarCheck,
            label: 'Sesje',
            selected: homePageController.pageNumber == 1,
            onPressed: () => homePageController.moveToPage(1),
          ),
        ],
      ),
    );
  }
}

class _RightPart extends StatelessWidget {
  const _RightPart();

  @override
  Widget build(BuildContext context) {
    final homePageController = context.watch<HomePageController>();
    return Expanded(
      child: Row(
        children: [
          _BottomBarItem(
            icon: MdiIcons.library,
            label: 'Kursy',
            selected: homePageController.pageNumber == 2,
            onPressed: () => homePageController.moveToPage(2),
          ),
          _BottomBarItem(
            icon: MdiIcons.account,
            label: 'Profil',
            selected: homePageController.pageNumber == 3,
            onPressed: () => homePageController.moveToPage(3),
          ),
        ],
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.black.withOpacity(selected ? 1 : 0.4);
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
