import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/providers/user_providers.dart';
import 'widgets/premium_bottom_bar.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final isTeacher = profile.role == Role.teacher;

        final navItems = <PremiumNavItem>[
          const PremiumNavItem(
            label: 'Today',
            icon: Icons.wb_sunny_outlined,
            activeIcon: Icons.wb_sunny,
          ),
          PremiumNavItem(
            label: isTeacher ? 'Teaching' : 'Lessons',
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
          ),
          PremiumNavItem(
            label: isTeacher ? 'Class Notes' : 'Journal',
            icon: Icons.auto_stories_outlined,
            activeIcon: Icons.auto_stories,
          ),
          const PremiumNavItem(
            label: 'Bible',
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
          ),
          const PremiumNavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ];

        return Scaffold(
          extendBody: true, // Allow content to flow behind the glass bar
          body: shell,
          bottomNavigationBar: PremiumBottomBar(
            shell: shell,
            items: navItems,
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
