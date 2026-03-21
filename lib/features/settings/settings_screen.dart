import 'dart:async';

import 'package:afc_studymate/data/providers/app_refresh_providers.dart';
import 'package:afc_studymate/data/services/app_update_service.dart';
import 'package:afc_studymate/data/services/auth_service.dart';
import 'package:afc_studymate/data/services/cloud_backup_service.dart';
import 'package:afc_studymate/data/services/feature_flags_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/legal/app_legal.dart';
import 'package:afc_studymate/theme/app_theme.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final _reminderEnabledProvider = StateProvider<bool>((ref) => false);
final _reminderHourProvider = StateProvider<int>((ref) => 6);
final _reminderMinuteProvider = StateProvider<int>((ref) => 0);
final _sundayReminderEnabledProvider = StateProvider<bool>((ref) => false);
final _sundayReminderHourProvider = StateProvider<int>((ref) => 8);
final _sundayReminderMinuteProvider = StateProvider<int>((ref) => 0);
final _discoveryReminderEnabledProvider = StateProvider<bool>((ref) => false);
final _discoveryReminderHourProvider = StateProvider<int>((ref) => 18);
final _discoveryReminderMinuteProvider = StateProvider<int>((ref) => 0);
final _packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});
final _appUpdateStatusProvider = FutureProvider<AppUpdateStatus>((ref) async {
  return ref.watch(appUpdateServiceProvider).fetchStatus();
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
    final hour = prefs.getInt('reminder_hour') ?? 6;
    final minute = prefs.getInt('reminder_minute') ?? 0;
    final sundayEnabled = prefs.getBool('sunday_reminder_enabled') ?? false;
    final sundayHour = prefs.getInt('sunday_reminder_hour') ?? 8;
    final sundayMinute = prefs.getInt('sunday_reminder_minute') ?? 0;
    final discoveryEnabled =
        prefs.getBool('discovery_reminder_enabled') ?? false;
    final discoveryHour = prefs.getInt('discovery_reminder_hour') ?? 18;
    final discoveryMinute = prefs.getInt('discovery_reminder_minute') ?? 0;

    ref.read(_reminderEnabledProvider.notifier).state = enabled;
    ref.read(_reminderHourProvider.notifier).state = hour;
    ref.read(_reminderMinuteProvider.notifier).state = minute;
    ref.read(_sundayReminderEnabledProvider.notifier).state = sundayEnabled;
    ref.read(_sundayReminderHourProvider.notifier).state = sundayHour;
    ref.read(_sundayReminderMinuteProvider.notifier).state = sundayMinute;
    ref.read(_discoveryReminderEnabledProvider.notifier).state =
        discoveryEnabled;
    ref.read(_discoveryReminderHourProvider.notifier).state = discoveryHour;
    ref.read(_discoveryReminderMinuteProvider.notifier).state = discoveryMinute;
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

  Future<void> _saveDiscoveryPrefs({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('discovery_reminder_enabled', enabled);
    await prefs.setInt('discovery_reminder_hour', hour);
    await prefs.setInt('discovery_reminder_minute', minute);
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

  Future<void> _onToggleDiscoveryReminder(bool enabled) async {
    final svc = ref.read(notificationServiceProvider);
    ref.read(_discoveryReminderEnabledProvider.notifier).state = enabled;

    if (enabled) {
      final granted = await svc.requestPermission();
      if (!granted) {
        ref.read(_discoveryReminderEnabledProvider.notifier).state = false;
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
      final hour = ref.read(_discoveryReminderHourProvider);
      final minute = ref.read(_discoveryReminderMinuteProvider);
      await svc.scheduleWeeklyDiscoveryReminder(hour: hour, minute: minute);
      await _saveDiscoveryPrefs(enabled: true, hour: hour, minute: minute);
    } else {
      await svc.cancelWeeklyDiscoveryReminder();
      await _saveDiscoveryPrefs(
        enabled: false,
        hour: ref.read(_discoveryReminderHourProvider),
        minute: ref.read(_discoveryReminderMinuteProvider),
      );
    }
  }

  Future<void> _backupNow() async {
    try {
      await ref.read(cloudBackupServiceProvider).backupNow();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Drive backup completed.'),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Drive backup failed: $error')),
        );
      }
    }
  }

  Future<void> _restoreFromCloud() async {
    try {
      await ref.read(cloudBackupServiceProvider).restoreLatest();
      triggerAppDataRefresh(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Google Drive restore completed. Updated screens are refreshing now.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Drive restore failed: $error')),
        );
      }
    }
  }

  Future<TimeOfDay?> _pickTime({
    required int hour,
    required int minute,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    return picked;
  }

  Future<void> _onPickTime() async {
    final picked = await _pickTime(
      hour: ref.read(_reminderHourProvider),
      minute: ref.read(_reminderMinuteProvider),
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

  Future<void> _onPickSundayTime() async {
    final picked = await _pickTime(
      hour: ref.read(_sundayReminderHourProvider),
      minute: ref.read(_sundayReminderMinuteProvider),
    );
    if (picked == null) {
      return;
    }

    ref.read(_sundayReminderHourProvider.notifier).state = picked.hour;
    ref.read(_sundayReminderMinuteProvider.notifier).state = picked.minute;

    final enabled = ref.read(_sundayReminderEnabledProvider);
    if (enabled) {
      await ref
          .read(notificationServiceProvider)
          .scheduleWeeklySundayReminder(
            hour: picked.hour,
            minute: picked.minute,
          );
    }
    await _saveSundayPrefs(
      enabled: enabled,
      hour: picked.hour,
      minute: picked.minute,
    );
  }

  Future<void> _onPickDiscoveryTime() async {
    final picked = await _pickTime(
      hour: ref.read(_discoveryReminderHourProvider),
      minute: ref.read(_discoveryReminderMinuteProvider),
    );
    if (picked == null) {
      return;
    }

    ref.read(_discoveryReminderHourProvider.notifier).state = picked.hour;
    ref.read(_discoveryReminderMinuteProvider.notifier).state = picked.minute;

    final enabled = ref.read(_discoveryReminderEnabledProvider);
    if (enabled) {
      await ref
          .read(notificationServiceProvider)
          .scheduleWeeklyDiscoveryReminder(
            hour: picked.hour,
            minute: picked.minute,
          );
    }
    await _saveDiscoveryPrefs(
      enabled: enabled,
      hour: picked.hour,
      minute: picked.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderEnabled = ref.watch(_reminderEnabledProvider);
    final reminderHour = ref.watch(_reminderHourProvider);
    final reminderMinute = ref.watch(_reminderMinuteProvider);
    final sundayReminderEnabled = ref.watch(_sundayReminderEnabledProvider);
    final discoveryReminderEnabled = ref.watch(
      _discoveryReminderEnabledProvider,
    );
    final timeStr = TimeOfDay(
      hour: reminderHour,
      minute: reminderMinute,
    ).format(context);
    final sundayTime = TimeOfDay(
      hour: ref.watch(_sundayReminderHourProvider),
      minute: ref.watch(_sundayReminderMinuteProvider),
    ).format(context);
    final discoveryTime = TimeOfDay(
      hour: ref.watch(_discoveryReminderHourProvider),
      minute: ref.watch(_discoveryReminderMinuteProvider),
    ).format(context);
    final appThemeMode = ref.watch(appThemeModeProvider);
    final fontPack = ref.watch(appFontPackProvider);
    final backgroundMode = ref.watch(appBackgroundModeProvider);
    final screenBackgroundSelections = <AppBackgroundSlot, AppBackgroundMode>{
      for (final slot in customizableBackgroundSlots)
        slot: ref.watch(screenBackgroundModeProvider(slot)),
    };
    final lowResourceMode = ref.watch(lowResourceModeProvider);
    final cloudBackupEnabled = ref.watch(cloudBackupEnabledProvider);
    final cloudFeaturesAvailable = ref.watch(cloudFeaturesAvailableProvider);
    final googleAccount = ref.watch(authUserProvider).valueOrNull;
    final hasAccountBackedSession = googleAccount != null;
    AppAppearancePreset? activePreset;
    for (final preset in AppAppearancePreset.values) {
      if (matchesAppearancePreset(
        preset: preset,
        themeMode: appThemeMode,
        fontPack: fontPack,
        globalBackgroundMode: backgroundMode,
        lowResourceMode: lowResourceMode,
        screenBackgrounds: screenBackgroundSelections,
      )) {
        activePreset = preset;
        break;
      }
    }

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      backgroundSlot: PremiumBackgroundSlots.settings,
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
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    enabled: sundayReminderEnabled,
                    leading: const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Sunday Reminder Time',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      sundayTime,
                      style: TextStyle(
                        color: sundayReminderEnabled
                            ? const Color(0xFFD4A017)
                            : Colors.white24,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: sundayReminderEnabled ? _onPickSundayTime : null,
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile.adaptive(
                    value: discoveryReminderEnabled,
                    onChanged: _onToggleDiscoveryReminder,
                    secondary: const Icon(
                      Icons.explore_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Discovery Reminder',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      discoveryReminderEnabled
                          ? 'Weekly mid-week reminder at $discoveryTime'
                          : 'Tap to enable Discovery reminders',
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
                    enabled: discoveryReminderEnabled,
                    leading: const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Discovery Reminder Time',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      discoveryTime,
                      style: TextStyle(
                        color: discoveryReminderEnabled
                            ? const Color(0xFFD4A017)
                            : Colors.white24,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: discoveryReminderEnabled
                        ? _onPickDiscoveryTime
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── APPEARANCE ────────────────────────────────────────────────
            _settingSectionLabel(context, 'APPEARANCE'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _settingDetailLabel(
                    title: 'Quick Style Packs',
                    subtitle:
                        'Start with a full look for kids, youth, classic readers, or accessibility needs.',
                  ),
                  const SizedBox(height: 12),
                  _buildPresetPreviewWrap(
                    activePreset: activePreset,
                    onSelected: _applyAppearancePreset,
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 20),
                  _settingDetailLabel(
                    title: 'Theme',
                    subtitle: 'Match the system, stay light, or stay dark.',
                  ),
                  const SizedBox(height: 12),
                  _buildGlassDropdownField<AppThemeMode>(
                    value: appThemeMode,
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
                  const SizedBox(height: 20),
                  _settingDetailLabel(
                    title: 'App Font',
                    subtitle:
                        'Choose a style that feels playful, classic, readable, or modern.',
                  ),
                  const SizedBox(height: 12),
                  _buildFontPreviewWrap(
                    selected: fontPack,
                    onSelected: (pack) {
                      ref.read(appFontPackProvider.notifier).setFontPack(pack);
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildGlassDropdownField<AppFontPack>(
                    value: fontPack,
                    items: AppFontPack.values
                        .map(
                          (pack) => DropdownMenuItem<AppFontPack>(
                            value: pack,
                            child: Text(appFontPackLabel(pack)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      ref.read(appFontPackProvider.notifier).setFontPack(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  _settingDetailLabel(
                    title: 'Global Background',
                    subtitle:
                        'Pick from ministry art, gentle HD scenes, or solid color palettes.',
                  ),
                  const SizedBox(height: 12),
                  _buildBackgroundPreviewWrap(
                    selected: backgroundMode,
                    availableModes: AppBackgroundMode.values
                        .where((mode) => mode != AppBackgroundMode.followGlobal)
                        .toList(),
                    onSelected: (mode) {
                      ref
                          .read(appBackgroundModeProvider.notifier)
                          .setBackgroundMode(mode);
                    },
                    fallbackAsset: 'assets/images/bg_journal.png',
                  ),
                  const SizedBox(height: 14),
                  _buildGlassDropdownField<AppBackgroundMode>(
                    value: backgroundMode,
                    items: AppBackgroundMode.values
                        .where((mode) => mode != AppBackgroundMode.followGlobal)
                        .map(
                          (mode) => DropdownMenuItem<AppBackgroundMode>(
                            value: mode,
                            child: Text(appBackgroundModeLabel(mode)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      ref
                          .read(appBackgroundModeProvider.notifier)
                          .setBackgroundMode(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 20),
                  _settingDetailLabel(
                    title: 'Per-Screen Backgrounds',
                    subtitle:
                        'Let a screen follow the global look, keep its original art, or use its own custom style.',
                  ),
                  const SizedBox(height: 16),
                  ...customizableBackgroundSlots.expand((slot) {
                    final selection = screenBackgroundSelections[slot]!;
                    return <Widget>[
                      _settingDetailLabel(
                        title: appBackgroundSlotLabel(slot),
                        subtitle: appBackgroundModeLabel(
                          selection,
                          forScreenOverride: true,
                        ),
                        compact: true,
                      ),
                      const SizedBox(height: 8),
                      _buildSelectedBackgroundPreview(
                        slot: slot,
                        selection: selection,
                        globalMode: backgroundMode,
                      ),
                      const SizedBox(height: 10),
                      _buildGlassDropdownField<AppBackgroundMode>(
                        value: selection,
                        items: AppBackgroundMode.values
                            .map(
                              (mode) => DropdownMenuItem<AppBackgroundMode>(
                                value: mode,
                                child: Text(
                                  appBackgroundModeLabel(
                                    mode,
                                    forScreenOverride: true,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          ref
                              .read(screenBackgroundModeProvider(slot).notifier)
                              .setBackgroundMode(value);
                        },
                      ),
                      const SizedBox(height: 16),
                    ];
                  }),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 20),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.language_rounded,
                      color: Colors.white70,
                    ),
                    title: Text(
                      'Verse Language',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Available throughout the app',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
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

            _settingSectionLabel(context, 'ACCOUNT & CLOUD'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Google Account',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      hasAccountBackedSession
                          ? 'Signed in as ${googleAccount.email}'
                          : 'Not signed in. Google Drive backup needs a Google account.',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Icon(
                      hasAccountBackedSession
                          ? Icons.check_circle_rounded
                          : Icons.person_outline_rounded,
                      color: hasAccountBackedSession
                          ? Colors.greenAccent
                          : Colors.white38,
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  const ListTile(
                    leading: Icon(
                      Icons.cloud_done_outlined,
                      color: Colors.white70,
                    ),
                    title: Text(
                      'Google Drive Backup',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Backups are stored in your own Google Drive app data space instead of Firestore or Firebase Storage.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  if (!hasAccountBackedSession) ...<Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white70,
                      ),
                      title: const Text(
                        'Sign In with Google',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Connect your Google account so backups stay in your own Drive.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      onTap: _signInToGoogleDrive,
                    ),
                  ] else ...<Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white70,
                      ),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Stop using Google Drive backup on this device until you sign in again',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      onTap: _signOut,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            _settingSectionLabel(context, 'PRIVACY & LEGAL'),
            const SizedBox(height: 12),
            PremiumGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Privacy & Data',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'See what stays on-device and how this mobile build handles data',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                    onTap: () => _openMarkdownSheet(
                      title: 'Privacy & Data',
                      markdown: appPrivacyMarkdown,
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.public_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Privacy Policy URL',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Open the public privacy policy page used for store listing compliance',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.open_in_new,
                      color: Colors.white38,
                    ),
                    onTap: () => _openExternalUri(
                      appPrivacyPolicyUrl,
                      failureMessage:
                          'Could not open the public privacy policy URL.',
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.phone_iphone_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Release Scope',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'This release is prepared for Android and iPhone',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                    onTap: () => _openMarkdownSheet(
                      title: 'Release Scope',
                      markdown: appReleaseScopeMarkdown,
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.gavel_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Third-Party Licenses',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Open the package license notices bundled with the app',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () async {
                      final info = await PackageInfo.fromPlatform();
                      if (!mounted) {
                        return;
                      }
                      showLicensePage(
                        context: context,
                        applicationName: 'AFM SEAR StudyMate',
                        applicationVersion:
                            '${info.version} (${info.buildNumber})',
                      );
                    },
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ListTile(
                    leading: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Acknowledgements',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Developer, organization, and contributor credits',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                    onTap: () => _openMarkdownSheet(
                      title: 'Acknowledgements',
                      markdown: appAcknowledgementsMarkdown,
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
                      Icons.system_update_alt_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Check for Updates',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: ref
                        .watch(_appUpdateStatusProvider)
                        .when(
                          data: (status) => Text(
                            status.statusSummary,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          loading: () => const Text(
                            'Checking release service...',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          error: (_, __) => const Text(
                            'Update status unavailable',
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
                    onTap: _checkForUpdates,
                  ),
                  const Divider(height: 1, color: Colors.white10),
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
                    subtitle: Text(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? 'Share this iPhone build with others'
                          : 'Share this Android build with others',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Share.share(
                        'AFM SEAR StudyMate\n'
                        'Local-first Sunday School companion for Android and iPhone.\n'
                        'More information: https://www.apostolicfaithsear.org',
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
                  if (cloudFeaturesAvailable && hasAccountBackedSession)
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
                        'Google Drive Backup',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Save profile, settings, journal data, and study state to your Google Drive app data folder',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    )
                  else if (cloudFeaturesAvailable)
                    ListTile(
                      leading: const Icon(
                        Icons.lock_person_outlined,
                        color: Colors.white70,
                      ),
                      title: const Text(
                        'Google Account Required',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Sign in with Google before enabling backup or restore to your Drive.',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: _signInToGoogleDrive,
                    )
                  else
                    const ListTile(
                      leading: Icon(
                        Icons.cloud_off_outlined,
                        color: Colors.white70,
                      ),
                      title: Text(
                        'Google Drive Backup Unavailable',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'This build is currently running without Google Drive backup enabled.',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ),
                  if (cloudFeaturesAvailable && cloudBackupEnabled) ...<Widget>[
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
                        'Upload your latest app data to your Google Drive app data folder',
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
                        'Restore from Google Drive',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Download your last Google Drive backup and replace local app data',
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
    final updateStatus = await ref.read(appUpdateServiceProvider).fetchStatus();
    final cloudFeaturesAvailable = ref.read(cloudFeaturesAvailableProvider);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height * 0.92,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + mediaQuery.viewPadding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Semantics(
                      label: 'AFM SEAR church logo',
                      image: true,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(
                              0xFFD4A017,
                            ).withValues(alpha: 0.55),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.24),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/church_logo.png',
                            width: 132,
                            height: 132,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
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
                  Text(
                    updateStatus.statusSummary,
                    style: TextStyle(
                      color:
                          updateStatus.updateAvailable ||
                              updateStatus.requiresUpdate
                          ? const Color(0xFFF6D566)
                          : Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Latest published build: ${updateStatus.latestVersionLabel}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Proprietary © Apostolic Faith Church. All rights reserved.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cloudFeaturesAvailable
                        ? 'Android and iPhone build with optional Google Drive backup'
                        : 'Android and iPhone local-first build',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Created and developed by Strivemore R. Tapera of S-Tech Solutions for the AFM SEAR Media Team and Sunday School Team.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    updateStatus.statusDetails,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Official church contact:\nApostolic Faith Mission Southern and Eastern Africa\nStand 10466, Lusaka, Highfields\nHarare, Zimbabwe\n+263 242 885 654\nwww.apostolicfaithsear.org',
                    style: TextStyle(color: Colors.white70, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _checkForUpdates,
                    icon: const Icon(Icons.system_update_alt_rounded),
                    label: const Text('Check for Updates'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('https://www.apostolicfaithsear.org');
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not open the AFM SEAR website.',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Visit AFM SEAR Website'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _openMarkdownSheet(
                      title: 'Acknowledgements',
                      markdown: appAcknowledgementsMarkdown,
                    ),
                    icon: const Icon(Icons.groups_rounded),
                    label: const Text('View Acknowledgements'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _checkForUpdates() async {
    final status = await ref.refresh(_appUpdateStatusProvider.future);
    if (!mounted) {
      return;
    }

    final uri = status.updateUriForPlatform(defaultTargetPlatform);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'StudyMate Updates',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installed: ${status.currentVersionLabel}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Latest: ${status.latestVersionLabel}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              status.statusSummary,
              style: TextStyle(
                color: status.updateAvailable || status.requiresUpdate
                    ? const Color(0xFFF6D566)
                    : Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status.statusDetails,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (uri != null)
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!launched && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open the update page.'),
                    ),
                  );
                }
              },
              child: Text(
                status.updateAvailable || status.requiresUpdate
                    ? 'Open Update Page'
                    : 'View Release Page',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openMarkdownSheet({
    required String title,
    required String markdown,
  }) async {
    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Markdown(
                  data: markdown,
                  shrinkWrap: true,
                  onTapLink: (text, href, title) {
                    if (href == null || href.isEmpty) {
                      return;
                    }
                    unawaited(
                      _openExternalUri(
                        href.startsWith('http') ? href : 'https://$href',
                        failureMessage: 'Could not open the requested link.',
                      ),
                    );
                  },
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: Colors.white70, height: 1.5),
                    h1: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                    h2: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    listBullet: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openExternalUri(
    String url, {
    required String failureMessage,
  }) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (launched) {
      return;
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failureMessage)));
  }

  Future<void> _signOut() async {
    try {
      await ref.read(authServiceProvider).signOut();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out. Cloud features are paused.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not sign out: $error')));
    }
  }

  Future<void> _signInToGoogleDrive() async {
    try {
      final account = await ref.read(cloudBackupServiceProvider).signIn();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            account == null
                ? 'Google sign-in was cancelled.'
                : 'Signed in as ${account.email}. Google Drive backup is ready.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not sign in to Google Drive: $error')),
      );
    }
  }

  Future<void> _applyAppearancePreset(AppAppearancePreset preset) async {
    final config = appAppearancePresetConfig(preset);
    await ref
        .read(themeModeProvider.notifier)
        .setAppThemeMode(config.themeMode);
    await ref.read(appFontPackProvider.notifier).setFontPack(config.fontPack);
    await ref
        .read(appBackgroundModeProvider.notifier)
        .setBackgroundMode(config.globalBackgroundMode);
    await ref
        .read(lowResourceModeProvider.notifier)
        .setValue(config.lowResourceMode);
    for (final slot in customizableBackgroundSlots) {
      await ref
          .read(screenBackgroundModeProvider(slot).notifier)
          .setBackgroundMode(
            config.screenOverrides[slot] ?? AppBackgroundMode.followGlobal,
          );
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${appAppearancePresetLabel(preset)} style pack applied.',
        ),
      ),
    );
  }

  Widget _settingDetailLabel({
    required String title,
    required String subtitle,
    bool compact = false,
  }) {
    final palette = PremiumSurfaceScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: palette.primaryText,
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: palette.tertiaryText,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPreviewWrap({
    required AppAppearancePreset? activePreset,
    required Future<void> Function(AppAppearancePreset preset) onSelected,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AppAppearancePreset.values.map((preset) {
        final config = appAppearancePresetConfig(preset);
        return _buildPresetPreviewCard(
          preset: preset,
          config: config,
          isSelected: preset == activePreset,
          onTap: () async => onSelected(preset),
        );
      }).toList(),
    );
  }

  Widget _buildPresetPreviewCard({
    required AppAppearancePreset preset,
    required AppAppearancePresetConfig config,
    required bool isSelected,
    required Future<void> Function() onTap,
  }) {
    final backgroundConfig = appBackgroundConfigForMode(
      config.globalBackgroundMode,
      fallbackAsset: 'assets/images/bg_journal.png',
    );
    final previewPalette = premiumSurfacePaletteForBackground(
      backgroundConfig,
      lowResourceMode: false,
    );
    final borderColor = isSelected
        ? const Color(0xFFD4A017)
        : previewPalette.borderBaseColor.withValues(
            alpha: previewPalette.borderOpacity,
          );
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${appAppearancePresetLabel(preset)} style pack',
      child: InkWell(
        onTap: () async => onTap(),
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 174,
          decoration: BoxDecoration(
            color: previewPalette.cardBaseColor.withValues(
              alpha: previewPalette.cardOpacity * 0.76,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: isSelected ? 1.7 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 102,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildBackgroundSwatch(
                      config: backgroundConfig,
                      height: 102,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(21),
                      ),
                      selected: isSelected,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Aa',
                          style: _fontPreviewStyle(config.fontPack).copyWith(
                            fontSize: 26,
                            color: previewPalette.primaryText,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appAppearancePresetLabel(preset),
                            style: TextStyle(
                              color: previewPalette.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (config.themeMode == AppThemeMode.dark)
                          const Icon(
                            Icons.dark_mode_rounded,
                            size: 16,
                            color: Color(0xCCFFFFFF),
                          )
                        else
                          const Icon(
                            Icons.light_mode_rounded,
                            size: 16,
                            color: Color(0xCCFFFFFF),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appAppearancePresetDescription(preset),
                      style: TextStyle(
                        color: previewPalette.secondaryText,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontPreviewWrap({
    required AppFontPack selected,
    required ValueChanged<AppFontPack> onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: AppFontPack.values.map((pack) {
        return _buildFontPreviewCard(
          pack: pack,
          isSelected: pack == selected,
          onTap: () => onSelected(pack),
        );
      }).toList(),
    );
  }

  Widget _buildFontPreviewCard({
    required AppFontPack pack,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final palette = PremiumSurfaceScope.of(context);
    final borderColor = isSelected
        ? const Color(0xFFD4A017)
        : palette.borderBaseColor.withValues(alpha: palette.borderOpacity);
    final backgroundColor = isSelected
        ? const Color(0xFFD4A017).withValues(alpha: 0.14)
        : palette.cardBaseColor.withValues(alpha: palette.cardOpacity * 0.82);
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${appFontPackLabel(pack)} font preview',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 142,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aa',
                style: _fontPreviewStyle(pack).copyWith(
                  fontSize: 28,
                  color: palette.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appFontPackLabel(pack),
                style: TextStyle(
                  color: palette.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Read with ease',
                style: _fontPreviewStyle(pack).copyWith(
                  color: palette.secondaryText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _fontPreviewStyle(AppFontPack pack) {
    switch (pack) {
      case AppFontPack.classic:
        return GoogleFonts.crimsonText(fontWeight: FontWeight.w600);
      case AppFontPack.nunito:
        return GoogleFonts.nunito(fontWeight: FontWeight.w700);
      case AppFontPack.lora:
        return GoogleFonts.lora(fontWeight: FontWeight.w600);
      case AppFontPack.merriweather:
        return GoogleFonts.merriweather(fontWeight: FontWeight.w600);
      case AppFontPack.rubik:
        return GoogleFonts.rubik(fontWeight: FontWeight.w600);
      case AppFontPack.lexend:
        return GoogleFonts.lexend(fontWeight: FontWeight.w600);
      case AppFontPack.poppins:
        return GoogleFonts.poppins(fontWeight: FontWeight.w600);
      case AppFontPack.sourceSans:
        return GoogleFonts.sourceSans3(fontWeight: FontWeight.w700);
      case AppFontPack.workSans:
        return GoogleFonts.workSans(fontWeight: FontWeight.w700);
    }
  }

  Widget _buildBackgroundPreviewWrap({
    required AppBackgroundMode selected,
    required List<AppBackgroundMode> availableModes,
    required ValueChanged<AppBackgroundMode> onSelected,
    required String fallbackAsset,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: availableModes.map((mode) {
        final config = appBackgroundConfigForMode(
          mode,
          fallbackAsset: fallbackAsset,
        );
        return _buildBackgroundPreviewCard(
          config: config,
          label: appBackgroundModeLabel(mode),
          isSelected: mode == selected,
          onTap: () => onSelected(mode),
        );
      }).toList(),
    );
  }

  Widget _buildBackgroundPreviewCard({
    required AppBackgroundConfig config,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final previewPalette = premiumSurfacePaletteForBackground(
      config,
      lowResourceMode: false,
    );
    final borderColor = isSelected
        ? const Color(0xFFD4A017)
        : previewPalette.borderBaseColor.withValues(
            alpha: previewPalette.borderOpacity,
          );
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label background preview',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 150,
          decoration: BoxDecoration(
            color: previewPalette.cardBaseColor.withValues(
              alpha: previewPalette.cardOpacity * 0.78,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackgroundSwatch(
                config: config,
                height: 96,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                selected: isSelected,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: previewPalette.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFFD4A017),
                        size: 18,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBackgroundPreview({
    required AppBackgroundSlot slot,
    required AppBackgroundMode selection,
    required AppBackgroundMode globalMode,
  }) {
    final fallbackAsset = _defaultBackgroundAssetForSlot(slot);
    final resolvedConfig = resolveAppBackgroundConfig(
      fallbackAsset: fallbackAsset,
      globalMode: globalMode,
      screenMode: selection,
    );
    final previewPalette = premiumSurfacePaletteForBackground(
      resolvedConfig,
      lowResourceMode: false,
    );
    final effectiveLabel = selection == AppBackgroundMode.followGlobal
        ? '${appBackgroundModeLabel(selection, forScreenOverride: true)}: ${appBackgroundModeLabel(globalMode)}'
        : appBackgroundModeLabel(selection, forScreenOverride: true);
    return Container(
      decoration: BoxDecoration(
        color: previewPalette.cardBaseColor.withValues(
          alpha: previewPalette.cardOpacity * 0.78,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: previewPalette.borderBaseColor.withValues(
            alpha: previewPalette.borderOpacity,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 68,
              height: 68,
              child: _buildBackgroundSwatch(
                config: resolvedConfig,
                height: 68,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  effectiveLabel,
                  style: TextStyle(
                    color: previewPalette.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preview for ${appBackgroundSlotLabel(slot)}',
                  style: TextStyle(
                    color: previewPalette.tertiaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundSwatch({
    required AppBackgroundConfig config,
    required double height,
    required BorderRadius borderRadius,
    bool selected = false,
  }) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: config.baseColors,
                stops: config.baseStops,
              ),
            ),
          ),
          if (config.assetPath != null)
            ClipRRect(
              borderRadius: borderRadius,
              child: Image.asset(
                config.assetPath!,
                fit: BoxFit.cover,
              ),
            ),
          ClipRRect(
            borderRadius: borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: config.overlayColors,
                  stops: config.overlayStops ?? const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          if (selected)
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFFD4A017),
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _defaultBackgroundAssetForSlot(AppBackgroundSlot slot) {
    switch (slot) {
      case AppBackgroundSlot.today:
      case AppBackgroundSlot.memoryVerse:
        return 'assets/images/bg_dashboard.png';
      case AppBackgroundSlot.journal:
      case AppBackgroundSlot.profile:
      case AppBackgroundSlot.settings:
        return 'assets/images/bg_journal.png';
      case AppBackgroundSlot.bible:
        return 'assets/images/bg_bible.png';
      case AppBackgroundSlot.discovery:
      case AppBackgroundSlot.discoveryArchive:
        return 'assets/images/bg_discovery.png';
      case AppBackgroundSlot.sundaySchool:
      case AppBackgroundSlot.classRoster:
      case AppBackgroundSlot.teacherGuides:
        return 'assets/images/bg_sunday_school.png';
    }
  }

  Widget _buildGlassDropdownField<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final palette = PremiumSurfaceScope.of(context);
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(18),
      dropdownColor: palette.dropdownBackground,
      style: TextStyle(color: palette.primaryText, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: palette.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: palette.borderBaseColor.withValues(
              alpha: palette.borderOpacity,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: palette.borderBaseColor.withValues(
              alpha: palette.borderOpacity,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFFD4A017).withValues(alpha: 0.75),
            width: 1.5,
          ),
        ),
      ),
      iconEnabledColor: palette.icon,
      selectedItemBuilder: (context) => items
          .map(
            (item) => Align(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle(
                style: TextStyle(color: palette.primaryText),
                child: item.child,
              ),
            ),
          )
          .toList(),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _settingSectionLabel(BuildContext context, String text) {
    final palette = PremiumSurfaceScope.of(context);
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: palette.secondaryText,
        letterSpacing: 1.5,
      ),
    );
  }
}
