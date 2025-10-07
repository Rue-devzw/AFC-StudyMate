import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/enums.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const String routeName = 'onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    ref.listen(onboardingControllerProvider, (previous, next) {
      if (next.completed && context.mounted) {
        context.go('/home/today');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to AFC StudyMate')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Let us tailor your learning journey.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<Role>(
              value: state.role,
              decoration: const InputDecoration(labelText: 'Who are you?'),
              onChanged: (Role? value) => controller.updateRole(value ?? state.role),
              items: Role.values
                  .map(
                    (role) => DropdownMenuItem<Role>(
                      value: role,
                      child: Text(_formatRoleName(role.name)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Track>(
              value: state.track,
              decoration: const InputDecoration(labelText: 'Select your class'),
              onChanged: (Track? value) => controller.updateTrack(value ?? state.track),
              items: Track.values
                  .where((track) => track != Track.discovery && track != Track.daybreak)
                  .map((track) => DropdownMenuItem<Track>(
                        value: track,
                        child: Text(_trackLabel(track)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Translation>(
              value: state.translation,
              decoration: const InputDecoration(labelText: 'Preferred Bible translation'),
              onChanged: (Translation? value) => controller.updateTranslation(value ?? state.translation),
              items: Translation.values
                  .map((translation) => DropdownMenuItem<Translation>(
                        value: translation,
                        child: Text(translation == Translation.kjv ? 'King James Version' : 'Shona'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            SwitchListTile.adaptive(
              title: const Text('Daily Daybreak reminder at 06:00'),
              value: state.dailyReminder,
              onChanged: controller.toggleDaily,
            ),
            SwitchListTile.adaptive(
              title: const Text('Sunday lesson reminder at 08:00'),
              value: state.sundayReminder,
              onChanged: controller.toggleSunday,
            ),
            SwitchListTile.adaptive(
              title: const Text('Discovery unlock reminder on Wednesday'),
              value: state.discoveryReminder,
              onChanged: controller.toggleDiscovery,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await controller.complete();
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              child: const Text('Start exploring'),
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
    // Insert space before each uppercase letter except the first character
    return name.replaceAllMapped(RegExp('([A-Z])'), (match) => ' ${match[0]}').trim();
  }
}
