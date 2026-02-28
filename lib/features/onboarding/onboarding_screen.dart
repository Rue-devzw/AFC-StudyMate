import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final bgImages = [
      'assets/images/onboard_1.png',
      'assets/images/onboard_2.png',
      'assets/images/onboard_3.png',
      'assets/images/onboard_4.png',
    ];
    final bgImage = bgImages[currentPage.value];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                bgImage,
                key: ValueKey<int>(currentPage.value),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Subtle Dark Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            SafeArea(
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
                          child: const SizedBox.shrink(),
                        ),
                        _OnboardingStep(
                          title: 'Personalize\nYour Profile',
                          subtitle:
                              'Help us tailor the content for your journey.',
                          child: Column(
                            children: [
                              PremiumTextField(
                                label: 'What is your name?',
                                value: state.name,
                                onChanged: (val) => controller.updateName(val),
                                hint: 'e.g. Brother John',
                              ),
                              const SizedBox(height: 16),
                              _DropdownCard<Role>(
                                label: 'Who are you?',
                                value: state.role,
                                items: Role.values,
                                labelBuilder: (role) =>
                                    _formatRoleName(role.name),
                                onChanged: (Role? val) =>
                                    controller.updateRole(val!),
                              ),
                              const SizedBox(height: 16),
                              _DropdownCard<Track>(
                                label: 'Select your class',
                                value: state.track,
                                items: Track.values
                                    .where(
                                      (t) =>
                                          t != Track.discovery &&
                                          t != Track.daybreak,
                                    )
                                    .toList(),
                                labelBuilder: _trackLabel,
                                onChanged: (val) =>
                                    controller.updateTrack(val!),
                              ),
                            ],
                          ),
                        ),
                        _OnboardingStep(
                          title: 'Bible\nPreferences',
                          subtitle:
                              'Choose your default translation for lookups.',
                          child: _DropdownCard<Translation>(
                            label: 'Preferred Translation',
                            value: state.translation,
                            items: Translation.values,
                            labelBuilder: (t) => t == Translation.kjv
                                ? 'King James Version'
                                : 'Shona',
                            onChanged: (val) =>
                                controller.updateTranslation(val!),
                          ),
                        ),
                        _OnboardingStep(
                          title: 'Stay\nConsistent',
                          subtitle:
                              'Enable gentle reminders for your devotion and lessons.',
                          child: _GlassCard(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ReminderSwitch(
                                  title: 'Daily Daybreak',
                                  subtitle: 'Devotion reminder at 06:00',
                                  value: state.dailyReminder,
                                  onChanged: controller.toggleDaily,
                                ),
                                Divider(height: 24, color: Colors.white24),
                                _ReminderSwitch(
                                  title: 'Sunday School',
                                  subtitle: 'Lesson reminder at 08:00',
                                  value: state.sundayReminder,
                                  onChanged: controller.toggleSunday,
                                ),
                                Divider(height: 24, color: Colors.white24),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Row(
                      children: [
                        _PageIndicator(count: 4, current: currentPage.value),
                        const Spacer(),
                        if (currentPage.value < 3)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            onPressed: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.fastOutSlowIn,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            icon: const Icon(Icons.explore_rounded),
                            label: const Text(
                              'Get Started',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => controller.complete(),
                          ),
                      ],
                    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.85),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: child,
        ),
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
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 1.2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF2C2C2E),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveThumbColor: Colors.white54,
          inactiveTrackColor: Colors.white.withOpacity(0.2),
        ),
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
    return Row(
      children: List.generate(count, (index) {
        final active = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          height: 6,
          width: active ? 24 : 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
