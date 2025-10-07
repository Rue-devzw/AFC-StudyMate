import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  static const List<_NavItem> _navItems = <_NavItem>[
    _NavItem(label: 'Today', icon: Icons.wb_sunny_outlined),
    _NavItem(label: 'Sunday School', icon: Icons.school_outlined),
    _NavItem(label: 'Discovery', icon: Icons.explore_outlined),
    _NavItem(label: 'Bible', icon: Icons.menu_book_outlined),
    _NavItem(label: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: shell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: shell.goBranch,
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
