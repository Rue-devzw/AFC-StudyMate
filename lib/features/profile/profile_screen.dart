import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Progress')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Role'),
            subtitle: Text('Learner'),
          ),
          ListTile(
            leading: Icon(Icons.local_fire_department_outlined),
            title: Text('Current streak'),
            subtitle: Text('3 days – keep going!'),
          ),
          ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('Badges'),
            subtitle: Text('Starter Star, Faithful Reader'),
          ),
        ],
      ),
    );
  }
}
