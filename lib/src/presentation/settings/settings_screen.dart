import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../providers.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeControllerProvider);
    final translationsAsync = ref.watch(translationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share App'),
            onTap: () {
              Share.share(
                'Check out AFC StudyMate!',
                subject: 'AFC StudyMate',
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Bible Translations'),
          ),
          translationsAsync.when(
            data: (translations) => Column(
              children: [
                for (final translation in translations)
                  ListTile(
                    leading: const Icon(Icons.translate_outlined),
                    title: Text(translation.name),
                    subtitle: Text(
                      '${translation.languageName} · ${translation.language.toUpperCase()}\nVersion ${translation.version}\n${translation.copyright}',
                    ),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(
                        translation.language.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Failed to load translations: $error'),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Theme Mode'),
          ),
          themeModeAsync.when(
            data: (mode) => Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System default'),
                  value: ThemeMode.system,
                  groupValue: mode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeControllerProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: mode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeControllerProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: mode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeControllerProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Failed to load theme: $error'),
            ),
          ),
        ],
      ),
    );
  }
}
