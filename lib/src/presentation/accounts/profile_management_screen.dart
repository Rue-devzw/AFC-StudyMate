import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/accounts/entities.dart';
import '../providers.dart';
import 'profile_onboarding_screen.dart';

class ProfileManagementScreen extends ConsumerWidget {
  const ProfileManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final activeAccountAsync = ref.watch(activeAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage profiles'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProfile(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add profile'),
      ),
      body: accountsAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return const Center(child: Text('No profiles yet. Create one to get started.'));
          }
          final activeId = activeAccountAsync.maybeWhen(
            data: (account) => account?.id,
            orElse: () => null,
          );
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              final isActive = profile.id == activeId;
              return Card(
                child: ListTile(
                  leading: _ProfileAvatar(avatar: profile.avatarUrl, name: profile.displayName),
                  title: Text(profile.displayName?.isNotEmpty == true
                      ? profile.displayName!
                      : 'Profile ${index + 1}'),
                  subtitle: Text(
                    profile.preferredCohortTitle?.isNotEmpty == true
                        ? profile.preferredCohortTitle!
                        : profile.preferredLessonClass?.isNotEmpty == true
                            ? profile.preferredLessonClass!
                            : 'No cohort preference',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (isActive)
                        Chip(
                          label: Text('Active', style: Theme.of(context).textTheme.labelSmall),
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        )
                      else
                        TextButton(
                          onPressed: () => _setActive(context, ref, profile.id),
                          child: const Text('Set active'),
                        ),
                      IconButton(
                        tooltip: 'Edit profile',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editProfile(context, ref, profile),
                      ),
                      IconButton(
                        tooltip: 'Delete profile',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, ref, profile),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load profiles: $error'),
        ),
      ),
    );
  }

  Future<void> _createProfile(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<ProfileFormResult>(
      context: context,
      builder: (dialogContext) => const ProfileFormDialog(),
    );
    if (result == null) {
      return;
    }
    final id = const Uuid().v4();
    final account = LocalAccount(
      id: id,
      displayName: result.displayName,
      avatarUrl: result.avatar,
      preferredCohortId: result.cohortId,
      preferredCohortTitle: result.cohortTitle,
      preferredLessonClass: result.cohortLessonClass,
    );
    try {
      await ref.read(saveAccountUseCaseProvider)(account);
      await ref.read(setActiveAccountUseCaseProvider)(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile: $error')),
        );
      }
    }
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref, LocalAccount account) async {
    final result = await showDialog<ProfileFormResult>(
      context: context,
      builder: (dialogContext) => ProfileFormDialog(initial: account),
    );
    if (result == null) {
      return;
    }
    final updated = account.copyWith(
      displayName: result.displayName,
      avatarUrl: result.avatar,
      preferredCohortId: result.cohortId,
      preferredCohortTitle: result.cohortTitle,
      preferredLessonClass: result.cohortLessonClass,
    );
    try {
      await ref.read(saveAccountUseCaseProvider)(updated);
      if (updated.isActive) {
        await ref.read(setActiveAccountUseCaseProvider)(updated.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    }
  }

  Future<void> _setActive(BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(setActiveAccountUseCaseProvider)(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile activated.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to activate profile: $error')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, LocalAccount account) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete profile'),
        content: Text('Are you sure you want to delete "${account.displayName ?? 'this profile'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) {
      return;
    }
    try {
      await ref.read(deleteAccountUseCaseProvider)(account.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete profile: $error')),
        );
      }
    }
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.avatar, this.name});

  final String? avatar;
  final String? name;

  @override
  Widget build(BuildContext context) {
    if (avatar != null && avatar!.isNotEmpty) {
      return CircleAvatar(child: Text(avatar!, style: const TextStyle(fontSize: 20)));
    }
    final initial = (name ?? '').trim().isNotEmpty ? name!.trim()[0].toUpperCase() : '?';
    return CircleAvatar(child: Text(initial));
  }
}
