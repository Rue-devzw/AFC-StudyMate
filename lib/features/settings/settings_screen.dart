import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          SwitchListTile.adaptive(
            title: const Text('Dark theme'),
            subtitle: const Text('Match system appearance'),
            value: MediaQuery.of(context).platformBrightness == Brightness.dark,
            onChanged: (_) {},
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Verse language'),
            subtitle: Text('English & Shona'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Reminders'),
            subtitle: const Text('Daily at 06:00'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Offline data'),
            subtitle: const Text('All lessons stored securely on device'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
