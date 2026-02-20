import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/enums.dart';
import '../../widgets/design_system_widgets.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const String routeName = 'onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final pageController = usePageController();
    final currentPage = useState(0);

    ref.listen(onboardingControllerProvider, (previous, next) {
      if (next.completed && context.mounted) {
        context.go('/home/today');
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => currentPage.value = index,
                children: [
                  _OnboardingStep(
                    title: 'Welcome to\nStudyMate',
                    subtitle:
                        'Your companion for Sunday School and daily devotion.',
                    child: Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 160,
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                  _OnboardingStep(
                    title: 'Personalize\nYour Profile',
                    subtitle: 'Help us tailor the content for your journey.',
                    child: Column(
                      children: [
                        _DropdownCard<Role>(
                          label: 'Who are you?',
                          value: state.role,
                          items: Role.values,
                          labelBuilder: (role) => _formatRoleName(role.name),
                          onChanged: (val) => controller.updateRole(val!),
                        ),
                        const SizedBox(height: 16),
                        _DropdownCard<Track>(
                          label: 'Select your class',
                          value: state.track,
                          items: Track.values
                              .where(
                                (t) =>
                                    t != Track.discovery && t != Track.daybreak,
                              )
                              .toList(),
                          labelBuilder: _trackLabel,
                          onChanged: (val) => controller.updateTrack(val!),
                        ),
                      ],
                    ),
                  ),
                  _OnboardingStep(
                    title: 'Bible\nPreferences',
                    subtitle: 'Choose your default translation for lookups.',
                    child: _DropdownCard<Translation>(
                      label: 'Preferred Translation',
                      value: state.translation,
                      items: Translation.values,
                      labelBuilder: (t) =>
                          t == Translation.kjv ? 'King James Version' : 'Shona',
                      onChanged: (val) => controller.updateTranslation(val!),
                    ),
                  ),
                  _OnboardingStep(
                    title: 'Notifications',
                    subtitle: 'Stay consistent with gentle reminders.',
                    child: AppCard(
                      child: Column(
                        children: [
                          _ReminderSwitch(
                            title: 'Daily Daybreak',
                            subtitle: 'Devotion reminder at 06:00',
                            value: state.dailyReminder,
                            onChanged: controller.toggleDaily,
                          ),
                          const Divider(height: 32),
                          _ReminderSwitch(
                            title: 'Sunday School',
                            subtitle: 'Lesson reminder at 08:00',
                            value: state.sundayReminder,
                            onChanged: controller.toggleSunday,
                          ),
                          const Divider(height: 32),
                          _ReminderSwitch(
                            title: 'Discovery',
                            subtitle: 'Mid-week unlock reminder',
                            value: state.discoveryReminder,
                            onChanged: controller.toggleDiscovery,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                children: [
                  _PageIndicator(count: 4, current: currentPage.value),
                  const Spacer(),
                  if (currentPage.value < 3)
                    AppButton(
                      label: 'Next',
                      isFullWidth: false,
                      onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutExpo,
                      ),
                    )
                  else
                    AppButton(
                      label: 'Get Started',
                      isFullWidth: false,
                      icon: Icons.explore_rounded,
                      onPressed: () => controller.complete(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _trackLabel(Track track) {
    switch (track) {
      case Track.beginners:
        return 'Beginners (Ages 2–5)';
      case Track.primaryPals:
        return 'Primary Pals (1st–3rd)';
      case Track.answer:
        return 'Answer (4th–8th)';
      case Track.search:
        return 'Search (High School–Adults)';
      default:
        return track.name;
    }
  }

  String _formatRoleName(String name) {
    return name
        .replaceAllMapped(RegExp('([A-Z])'), (match) => ' ${match[0]}')
        .trim();
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            title,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onBackground,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 48),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DropdownCard<T> extends StatelessWidget {
  const _DropdownCard({
    required this.label,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(labelBuilder(item)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ReminderSwitch extends StatelessWidget {
  const _ReminderSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Switch.adaptive(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(count, (index) {
        final active = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          height: 8,
          width: active ? 24 : 8,
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
