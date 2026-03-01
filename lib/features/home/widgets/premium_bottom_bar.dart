import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/design_system_widgets.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/providers/user_providers.dart';

class PremiumBottomBar extends ConsumerWidget {
  const PremiumBottomBar({
    required this.shell,
    required this.items,
    super.key,
  });

  final StatefulNavigationShell shell;
  final List<PremiumNavItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) => _buildBar(context, theme, profile),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _buildBar(context, theme, null),
    );
  }

  Widget _buildBar(
    BuildContext context,
    ThemeData theme,
    UserProfile? profile,
  ) {
    final activeColor = profile?.targetTrack.color ?? theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 72,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: activeColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: activeColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = shell.currentIndex == index;

                return _BarItem(
                  item: item,
                  isActive: isActive,
                  activeColor: activeColor,
                  onTap: () {
                    if (!isActive) {
                      HapticFeedback.selectionClick();
                      shell.goBranch(index);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final PremiumNavItem item;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                color: isActive
                    ? activeColor
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? activeColor
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumNavItem {
  const PremiumNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
