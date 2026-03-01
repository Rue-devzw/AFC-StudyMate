import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/notification_service.dart';
import '../../widgets/design_system_widgets.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final _reminderEnabledProvider = StateProvider<bool>((ref) => false);
final _reminderHourProvider = StateProvider<int>((ref) => 7);
final _reminderMinuteProvider = StateProvider<int>((ref) => 0);

// ─── SettingsScreen ───────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = 'settings';

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedPrefs();
  }

  Future<void> _loadSavedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('reminder_enabled') ?? false;
    final hour = prefs.getInt('reminder_hour') ?? 7;
    final minute = prefs.getInt('reminder_minute') ?? 0;

    ref.read(_reminderEnabledProvider.notifier).state = enabled;
    ref.read(_reminderHourProvider.notifier).state = hour;
    ref.read(_reminderMinuteProvider.notifier).state = minute;
  }

  Future<void> _savePrefs({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', enabled);
    await prefs.setInt('reminder_hour', hour);
    await prefs.setInt('reminder_minute', minute);
  }

  Future<void> _onToggleReminder(bool enabled) async {
    final svc = ref.read(notificationServiceProvider);
    ref.read(_reminderEnabledProvider.notifier).state = enabled;

    if (enabled) {
      // Request permission first
      final granted = await svc.requestPermission();
      if (!granted) {
        ref.read(_reminderEnabledProvider.notifier).state = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission denied. Please enable in system settings.',
              ),
            ),
          );
        }
        return;
      }
      final hour = ref.read(_reminderHourProvider);
      final minute = ref.read(_reminderMinuteProvider);
      await svc.scheduleDaily(hour: hour, minute: minute);
      await _savePrefs(enabled: true, hour: hour, minute: minute);
    } else {
      await svc.cancelAll();
      await _savePrefs(
        enabled: false,
        hour: ref.read(_reminderHourProvider),
        minute: ref.read(_reminderMinuteProvider),
      );
    }
  }

  Future<void> _onPickTime() async {
    final hour = ref.read(_reminderHourProvider);
    final minute = ref.read(_reminderMinuteProvider);

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );

    if (picked != null) {
      ref.read(_reminderHourProvider.notifier).state = picked.hour;
      ref.read(_reminderMinuteProvider.notifier).state = picked.minute;

      final enabled = ref.read(_reminderEnabledProvider);
      if (enabled) {
        // Reschedule with the new time
        final svc = ref.read(notificationServiceProvider);
        await svc.scheduleDaily(hour: picked.hour, minute: picked.minute);
      }
      await _savePrefs(
        enabled: enabled,
        hour: picked.hour,
        minute: picked.minute,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder ${enabled ? 'rescheduled' : 'set'} for ${picked.format(context)}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderEnabled = ref.watch(_reminderEnabledProvider);
    final reminderHour = ref.watch(_reminderHourProvider);
    final reminderMinute = ref.watch(_reminderMinuteProvider);
    final timeStr = TimeOfDay(
      hour: reminderHour,
      minute: reminderMinute,
    ).format(context);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // ── NOTIFICATIONS ─────────────────────────────────────────────
            _settingSectionLabel(context, 'NOTIFICATIONS'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: reminderEnabled,
                    onChanged: _onToggleReminder,
                    secondary: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Daily Reminders',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      reminderEnabled
                          ? 'Reminds you daily at $timeStr'
                          : 'Tap to enable daily study reminders',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    activeColor: const Color(0xFF2C1B5E),
                    activeTrackColor: const Color(0xFFD4A017),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    enabled: reminderEnabled,
                    leading: const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Reminder Time',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      timeStr,
                      style: TextStyle(
                        color: reminderEnabled
                            ? const Color(0xFFD4A017)
                            : Colors.white24,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: reminderEnabled ? _onPickTime : null,
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (_) {},
                    secondary: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Sunday School Reminder',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Coming soon',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    activeColor: const Color(0xFF2C1B5E),
                    activeTrackColor: const Color(0xFFD4A017),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── APPEARANCE ────────────────────────────────────────────────
            _settingSectionLabel(context, 'APPEARANCE'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (_) {},
                    secondary: const Icon(
                      Icons.dark_mode_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Dark Theme',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Matches system appearance',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    activeColor: const Color(0xFF2C1B5E),
                    activeTrackColor: const Color(0xFFD4A017),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  const ListTile(
                    leading: Icon(
                      Icons.language_rounded,
                      color: Colors.white70,
                    ),
                    title: Text(
                      'Verse Language',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      'English & Shona',
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── DATA ──────────────────────────────────────────────────────
            _settingSectionLabel(context, 'DATA'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(
                      Icons.download_rounded,
                      color: Colors.white70,
                    ),
                    title: Text(
                      'Offline Data',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'All lessons stored securely on device',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    trailing: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _settingSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.white70,
        letterSpacing: 1.5,
      ),
    );
  }
}
