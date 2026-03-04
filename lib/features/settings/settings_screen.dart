import 'package:afc_studymate/data/services/cloud_backup_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/theme/app_theme.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final _reminderEnabledProvider = StateProvider<bool>((ref) => false);
final _reminderHourProvider = StateProvider<int>((ref) => 7);
final _reminderMinuteProvider = StateProvider<int>((ref) => 0);
final _sundayReminderEnabledProvider = StateProvider<bool>((ref) => false);
final _sundayReminderHourProvider = StateProvider<int>((ref) => 8);
final _sundayReminderMinuteProvider = StateProvider<int>((ref) => 0);
final _packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

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
    final sundayEnabled = prefs.getBool('sunday_reminder_enabled') ?? false;
    final sundayHour = prefs.getInt('sunday_reminder_hour') ?? 8;
    final sundayMinute = prefs.getInt('sunday_reminder_minute') ?? 0;

    ref.read(_reminderEnabledProvider.notifier).state = enabled;
    ref.read(_reminderHourProvider.notifier).state = hour;
    ref.read(_reminderMinuteProvider.notifier).state = minute;
    ref.read(_sundayReminderEnabledProvider.notifier).state = sundayEnabled;
    ref.read(_sundayReminderHourProvider.notifier).state = sundayHour;
    ref.read(_sundayReminderMinuteProvider.notifier).state = sundayMinute;
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

  Future<void> _saveSundayPrefs({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sunday_reminder_enabled', enabled);
    await prefs.setInt('sunday_reminder_hour', hour);
    await prefs.setInt('sunday_reminder_minute', minute);
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
      await svc.cancelDaily();
      await _savePrefs(
        enabled: false,
        hour: ref.read(_reminderHourProvider),
        minute: ref.read(_reminderMinuteProvider),
      );
    }
  }

  Future<void> _onToggleSundayReminder(bool enabled) async {
    final svc = ref.read(notificationServiceProvider);
    ref.read(_sundayReminderEnabledProvider.notifier).state = enabled;

    if (enabled) {
      final granted = await svc.requestPermission();
      if (!granted) {
        ref.read(_sundayReminderEnabledProvider.notifier).state = false;
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
      final hour = ref.read(_sundayReminderHourProvider);
      final minute = ref.read(_sundayReminderMinuteProvider);
      await svc.scheduleWeeklySundayReminder(hour: hour, minute: minute);
      await _saveSundayPrefs(enabled: true, hour: hour, minute: minute);
    } else {
      await svc.cancelWeeklySundayReminder();
      await _saveSundayPrefs(
        enabled: false,
        hour: ref.read(_sundayReminderHourProvider),
        minute: ref.read(_sundayReminderMinuteProvider),
      );
    }
  }

  Future<void> _backupNow() async {
    try {
      await ref.read(cloudBackupServiceProvider).backupNow();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cloud backup completed.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cloud backup failed: $error')),
        );
      }
    }
  }

  Future<void> _restoreFromCloud() async {
    try {
      await ref.read(cloudBackupServiceProvider).restoreLatest();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cloud restore completed. Restart app to refresh all screens.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cloud restore failed: $error')),
        );
      }
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
    final sundayReminderEnabled = ref.watch(_sundayReminderEnabledProvider);
    final timeStr = TimeOfDay(
      hour: reminderHour,
      minute: reminderMinute,
    ).format(context);
    final sundayTime = TimeOfDay(
      hour: ref.watch(_sundayReminderHourProvider),
      minute: ref.watch(_sundayReminderMinuteProvider),
    ).format(context);
    final appThemeMode = ref.watch(appThemeModeProvider);
    final fontPack = ref.watch(appFontPackProvider);
    final backgroundMode = ref.watch(appBackgroundModeProvider);
    final lowResourceMode = ref.watch(lowResourceModeProvider);
    final cloudBackupEnabled = ref.watch(cloudBackupEnabledProvider);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
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
                    value: sundayReminderEnabled,
                    onChanged: _onToggleSundayReminder,
                    secondary: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Sunday School Reminder',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      sundayReminderEnabled
                          ? 'Weekly reminder at $sundayTime'
                          : 'Tap to enable weekly Sunday reminder',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
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
                  ListTile(
                    leading: const Icon(
                      Icons.dark_mode_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Theme',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      switch (appThemeMode) {
                        AppThemeMode.system => 'System',
                        AppThemeMode.light => 'Light',
                        AppThemeMode.dark => 'Dark',
                      },
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<AppThemeMode>(
                        value: appThemeMode,
                        dropdownColor: const Color(0xFF1C1C1E),
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: AppThemeMode.system,
                            child: Text('System'),
                          ),
                          DropdownMenuItem(
                            value: AppThemeMode.light,
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: AppThemeMode.dark,
                            child: Text('Dark'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          ref
                              .read(themeModeProvider.notifier)
                              .setAppThemeMode(value);
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.font_download_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'App Font',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      appFontPackLabel(fontPack),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<AppFontPack>(
                        value: fontPack,
                        dropdownColor: const Color(0xFF1C1C1E),
                        style: const TextStyle(color: Colors.white),
                        items: AppFontPack.values
                            .map(
                              (pack) => DropdownMenuItem<AppFontPack>(
                                value: pack,
                                child: Text(appFontPackLabel(pack)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(appFontPackProvider.notifier)
                              .setFontPack(value);
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.wallpaper_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Global Background',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      appBackgroundModeLabel(backgroundMode),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<AppBackgroundMode>(
                        value: backgroundMode,
                        dropdownColor: const Color(0xFF1C1C1E),
                        style: const TextStyle(color: Colors.white),
                        items: AppBackgroundMode.values
                            .map(
                              (mode) => DropdownMenuItem<AppBackgroundMode>(
                                value: mode,
                                child: Text(appBackgroundModeLabel(mode)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(appBackgroundModeProvider.notifier)
                              .setBackgroundMode(value);
                        },
                      ),
                    ),
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

            // ── ABOUT ─────────────────────────────────────────────────────
            _settingSectionLabel(context, 'ABOUT'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'About StudyMate',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: ref
                        .watch(_packageInfoProvider)
                        .when(
                          data: (info) => Text(
                            'Version ${info.version} (${info.buildNumber})',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          loading: () => const Text(
                            'Loading version...',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          error: (_, __) => const Text(
                            'Version unavailable',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                    onTap: _openAboutSheet,
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.ios_share_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Share App',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Share download details with others',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Share.share(
                        'StudyMate - Bible study companion\n'
                        'Download link: https://www.afmsear.org',
                      );
                    },
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
                  const Divider(height: 1, color: Colors.white10),
                  const ListTile(
                    leading: Icon(
                      Icons.archive_rounded,
                      color: Colors.white70,
                    ),
                    title: Text(
                      'Storage Optimization',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'App assets are bundle-compressed and optimized on first launch',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile.adaptive(
                    value: lowResourceMode,
                    onChanged: (value) {
                      ref
                          .read(lowResourceModeProvider.notifier)
                          .setValue(value);
                    },
                    secondary: const Icon(
                      Icons.memory_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Low Resource Mode',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Reduces visual effects and heavy backgrounds',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile.adaptive(
                    value: cloudBackupEnabled,
                    onChanged: (value) {
                      ref
                          .read(cloudBackupEnabledProvider.notifier)
                          .setValue(value);
                    },
                    secondary: const Icon(
                      Icons.cloud_sync_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Cloud Backup',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Save profile/settings and study state to cloud',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  if (cloudBackupEnabled) ...<Widget>[
                    const Divider(height: 1, color: Colors.white10),
                    ListTile(
                      leading: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.white70,
                      ),
                      title: const Text(
                        'Backup Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Upload your latest app data immediately',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: _backupNow,
                    ),
                    const Divider(height: 1, color: Colors.white10),
                    ListTile(
                      leading: const Icon(
                        Icons.cloud_download_outlined,
                        color: Colors.white70,
                      ),
                      title: const Text(
                        'Restore from Cloud',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Download and replace local app data',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: _restoreFromCloud,
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: standardBottomContentPadding(context)),
          ],
        ),
      ),
    );
  }

  Future<void> _openAboutSheet() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AFM SEAR StudyMate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version ${info.version} (${info.buildNumber})',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              const Text(
                'Proprietary © Apostolic Faith Church. All rights reserved.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://www.afmsear.org');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Visit AFM SEAR Website'),
              ),
            ],
          ),
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
