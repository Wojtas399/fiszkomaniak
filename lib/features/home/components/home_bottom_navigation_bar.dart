import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final PageController pageController;
  final int displayingPageNumber;

  const HomeBottomNavigationBar({
    Key? key,
    required this.pageController,
    required this.displayingPageNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _LeftPart(
              displayingPageNumber: displayingPageNumber,
              onSelectPage: (int pageNumber) => _moveToPage(pageNumber),
            ),
            const SizedBox(width: 90),
            _RightPart(
              displayingPageNumber: displayingPageNumber,
              onSelectPage: (int pageNumber) => _moveToPage(pageNumber),
            ),
          ],
        ),
      ),
    );
  }

  void _moveToPage(int pageNumber) {
    pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}

class _LeftPart extends StatelessWidget {
  final int displayingPageNumber;
  final Function(int pageNumber) onSelectPage;

  const _LeftPart({
    Key? key,
    required this.displayingPageNumber,
    required this.onSelectPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _BottomBarItem(
            icon: MdiIcons.school,
            label: 'Nauka',
            selected: displayingPageNumber == 0,
            onPressed: () => onSelectPage(0),
          ),
          _BottomBarItem(
            icon: MdiIcons.calendarCheck,
            label: 'Sesje',
            selected: displayingPageNumber == 1,
            onPressed: () => onSelectPage(1),
          ),
        ],
      ),
    );
  }
}

class _RightPart extends StatelessWidget {
  final int displayingPageNumber;
  final Function(int pageNumber) onSelectPage;

  const _RightPart({
    Key? key,
    required this.displayingPageNumber,
    required this.onSelectPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _BottomBarItem(
            icon: MdiIcons.library,
            label: 'Kursy',
            selected: displayingPageNumber == 2,
            onPressed: () => onSelectPage(2),
          ),
          _BottomBarItem(
            icon: MdiIcons.account,
            label: 'Profil',
            selected: displayingPageNumber == 3,
            onPressed: () => onSelectPage(3),
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
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

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
