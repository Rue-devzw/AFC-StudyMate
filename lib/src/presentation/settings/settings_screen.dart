import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/bible/import/exceptions.dart';
import '../../domain/bible/import/import_models.dart';
import '../../infrastructure/lessons/lesson_source_registry.dart';
import '../providers.dart';
import 'bible_import_controller.dart';
import 'about_screen.dart';
import 'lesson_sync_controller.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeControllerProvider);
    final translationsAsync = ref.watch(translationsProvider);
    final syncState = ref.watch(lessonSyncControllerProvider);
    final importState = ref.watch(bibleImportControllerProvider);

    ref.listen<BibleImportState>(bibleImportControllerProvider,
        (previous, next) {
      if (previous?.conflict != next.conflict && next.conflict != null) {
        Future.microtask(() async {
          final resolution = await _showConflictDialog(context, next.conflict!);
          final controller =
              ref.read(bibleImportControllerProvider.notifier);
          if (resolution == ImportConflictResolution.replace) {
            await controller.resolveConflict(ImportConflictResolution.replace);
          } else {
            controller.clearOutcome();
          }
        });
      } else if (previous?.imported != next.imported &&
          next.imported != null) {
        Future.microtask(() {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Imported ${next.imported!.name} (${next.imported!.language.toUpperCase()})',
              ),
            ),
          );
          ref.invalidate(translationsProvider);
          ref.invalidate(booksProvider);
          ref.invalidate(verseSearchResultsProvider);
          ref.read(bibleImportControllerProvider.notifier).clearOutcome();
        });
      } else if (previous?.error != next.error && next.error != null) {
        Future.microtask(() {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
          ref.read(bibleImportControllerProvider.notifier).clearOutcome();
        });
      }
    });

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
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Import translation package'),
            subtitle: const Text('Install a translation from a .zip package'),
            enabled: !importState.isImporting,
            onTap: importState.isImporting
                ? null
                : () => _pickAndImport(context, ref),
            trailing: importState.isImporting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          if (importState.isImporting && importState.progress != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(importState.progress!.message ??
                      importState.progress!.stage.name),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: importState.progress!.progress,
                  ),
                ],
              ),
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
            child: Text('Lessons'),
          ),
          ListTile(
            leading: const Icon(Icons.sync_outlined),
            title: const Text('Sync lessons'),
            subtitle: Text(_buildSyncSubtitle(syncState)),
            trailing: syncState.isSyncing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref
                        .read(lessonSyncControllerProvider.notifier)
                        .syncNow(),
                  ),
            enabled: !syncState.isSyncing,
            onTap: syncState.isSyncing
                ? null
                : () => ref
                    .read(lessonSyncControllerProvider.notifier)
                    .syncNow(),
          ),
          if (syncState.lastError != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                syncState.lastError!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          for (final status in syncState.sources)
            _LessonSourceTile(status: status),
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

  Future<void> _pickAndImport(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final path = result.files.single.path;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected file is not accessible.')),
      );
      return;
    }
    final file = File(path);
    await ref.read(bibleImportControllerProvider.notifier).importPackage(file);
  }

  Future<ImportConflictResolution?> _showConflictDialog(
    BuildContext context,
    DuplicateTranslationException conflict,
  ) {
    return showDialog<ImportConflictResolution>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Translation already installed'),
          content: Text(
            'The translation ${conflict.manifest.name} (${conflict.manifest.id}) is already installed. Replace the existing version?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImportConflictResolution.skip),
              child: const Text('Keep existing'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(ImportConflictResolution.replace),
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );
  }
}

String _buildSyncSubtitle(LessonSyncState state) {
  final parts = <String>[];
  if (state.isSyncing) {
    parts.add('Sync in progress…');
  } else if (state.lastRun != null) {
    parts.add('Last sync: ${_formatTimestamp(state.lastRun!)}');
  } else {
    parts.add('Not yet synced');
  }
  return parts.join(' • ');
}

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);
  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  }
  return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
}

String _formatBytes(int bytes) {
  if (bytes <= 0) {
    return '0 B';
  }
  const units = ['B', 'KB', 'MB', 'GB'];
  var size = bytes.toDouble();
  var unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }
  return '${size.toStringAsFixed(unitIndex == 0 ? 0 : 1)} ${units[unitIndex]}';
}

class _LessonSourceTile extends ConsumerWidget {
  const _LessonSourceTile({required this.status});

  final LessonSourceStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final checksumLabel = status.checksum == null || status.checksum!.isEmpty
        ? '—'
        : status.checksum!.substring(
            0,
            status.checksum!.length < 7 ? status.checksum!.length : 7,
          );
    final subtitle = <Widget>[
      Text(
        'Last sync: ${status.lastSyncedAt == null ? '—' : _formatTimestamp(status.lastSyncedAt!)}',
        style: theme.textTheme.bodySmall,
      ),
      Text(
        'Version: $checksumLabel',
        style: theme.textTheme.bodySmall,
      ),
      Text(
        'Attachments: ${_formatBytes(status.attachmentBytes)} cached',
        style: theme.textTheme.bodySmall,
      ),
    ];
    if (status.lastError != null && status.lastError!.isNotEmpty) {
      subtitle.add(
        Text(
          'Error: ${status.lastError}',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }
    return SwitchListTile.adaptive(
      title: Text(status.displayName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subtitle,
      ),
      secondary: Icon(
        status.type == LessonSourceType.remote
            ? Icons.cloud_download_outlined
            : Icons.folder_copy_outlined,
      ),
      value: status.enabled,
      onChanged: status.isBundled
          ? null
          : (value) => ref
              .read(lessonSyncControllerProvider.notifier)
              .toggleSource(status.id, value),
    );
  }
}
