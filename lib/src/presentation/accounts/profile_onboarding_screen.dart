import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/accounts/entities.dart';
import '../providers.dart';
import '../l10n/l10n.dart';
import 'cloud_auth_sheet.dart';
import 'profile_management_screen.dart';

const _avatarOptions = [
  '😀',
  '😇',
  '🕊️',
  '📚',
  '🌟',
  '🎓',
  '🙏',
  '💡',
  '🌈',
  '❤️',
];

class ProfileOnboardingScreen extends ConsumerWidget {
  const ProfileOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final cloudUserAsync = ref.watch(firebaseAuthUserProvider);
    final authState = ref.watch(cloudAuthControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.onboardingWelcomeTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.onboardingWelcomeDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: accountsAsync.when(
                  data: (profiles) {
                    if (profiles.isEmpty) {
                      return _EmptyState(onCreate: () => _createProfile(context, ref));
                    }
                    return ListView.separated(
                      itemCount: profiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: _ProfileAvatar(avatar: profile.avatarUrl, name: profile.displayName),
                            title: Text(
                              profile.displayName?.isNotEmpty == true
                                  ? profile.displayName!
                                  : context.l10n.onboardingDefaultProfileName(index + 1),
                            ),
                            subtitle: Text(
                              profile.preferredCohortTitle?.isNotEmpty == true
                                  ? profile.preferredCohortTitle!
                                  : profile.preferredLessonClass?.isNotEmpty == true
                                      ? profile.preferredLessonClass!
                                      : context.l10n.onboardingNoCohortPreference,
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _selectProfile(context, ref, profile.id),
                              child: Text(context.l10n.onboardingUseProfile),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(context.l10n.onboardingProfilesLoadError('$error')),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              cloudUserAsync.when(
                data: (user) {
                  if (user == null) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.cloud_outlined),
                        title: Text(context.l10n.onboardingConnectCloudAccount),
                        subtitle: Text(
                          context.l10n.onboardingConnectCloudDescription,
                        ),
                        trailing: FilledButton(
                          onPressed:
                              authState.isLoading ? null : () => CloudAuthSheet.show(context),
                          child: Text(context.l10n.actionSignIn),
                        ),
                      ),
                    );
                  }
                  final providerSummary =
                      user.providerData.map((item) => item.providerId).toList();
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.cloud_done_outlined),
                      title: Text(
                        user.displayName ??
                            user.email ??
                            context.l10n.onboardingSignedInFallback,
                      ),
                      subtitle: Text(
                        providerSummary.isEmpty
                            ? context.l10n.onboardingCloudSyncActive
                            : context.l10n
                                .onboardingCloudSyncVia(providerSummary.join(', ')),
                      ),
                      trailing: authState.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : TextButton(
                              onPressed: () => _signOutCloud(context, ref),
                              child: Text(context.l10n.actionSignOut),
                            ),
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 72,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.cloud_off_outlined),
                    title: Text(context.l10n.onboardingCloudUnavailable),
                    subtitle: Text(
                      context.l10n.onboardingCloudStatusError('$error'),
                    ),
                    trailing: TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => CloudAuthSheet.show(context),
                      child: Text(context.l10n.actionTryAgain),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _createProfile(context, ref),
                icon: const Icon(Icons.add),
                label: Text(context.l10n.onboardingCreateProfile),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileManagementScreen()),
                  );
                },
                child: Text(context.l10n.onboardingManageProfiles),
              ),
            ],
          ),
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
          SnackBar(content: Text(context.l10n.snackbarProfileCreated)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.snackbarProfileCreateFailed('$error')),
          ),
        );
      }
    }
  }

  Future<void> _selectProfile(BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(setActiveAccountUseCaseProvider)(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.snackbarProfileSelected)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.snackbarProfileSelectFailed('$error')),
          ),
        );
      }
    }
  }

  Future<void> _signOutCloud(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(cloudAuthControllerProvider.notifier);
    final success = await controller.signOut();
    final state = ref.read(cloudAuthControllerProvider);
    if (!context.mounted) {
      return;
    }
    final message = success
        ? context.l10n.snackbarCloudSignedOut
        : state.errorMessage ?? context.l10n.snackbarCloudSignOutFailed;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_add_alt_1, size: 64),
          const SizedBox(height: 16),
          Text(
            context.l10n.emptyProfilesTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.emptyProfilesDescription),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onCreate,
            child: Text(context.l10n.emptyProfilesCreate),
          ),
        ],
      ),
    );
  }
}

class ProfileFormResult {
  const ProfileFormResult({
    required this.displayName,
    required this.avatar,
    required this.cohortId,
    required this.cohortTitle,
    required this.cohortLessonClass,
  });

  final String? displayName;
  final String? avatar;
  final String? cohortId;
  final String? cohortTitle;
  final String? cohortLessonClass;
}

class ProfileFormDialog extends ConsumerStatefulWidget {
  const ProfileFormDialog({super.key, this.initial});

  final LocalAccount? initial;

  @override
  ConsumerState<ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends ConsumerState<ProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _selectedAvatar;
  String? _selectedCohortId;
  bool _cohortInitialised = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.displayName ?? '');
    _selectedAvatar = widget.initial?.avatarUrl;
    _selectedCohortId = widget.initial?.preferredCohortId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cohortOptionsAsync = ref.watch(cohortOptionsProvider);
    final cohortOptions = cohortOptionsAsync.maybeWhen(
      data: (data) {
        if (!_cohortInitialised && _selectedCohortId != null) {
          final exists = data.any((option) => option.id == _selectedCohortId);
          if (!exists) {
            _selectedCohortId = null;
          }
          _cohortInitialised = true;
        }
        return data;
      },
      orElse: () => const <CohortOption>[],
    );

    return AlertDialog(
      title: Text(
        widget.initial == null
            ? context.l10n.dialogCreateProfileTitle
            : context.l10n.dialogEditProfileTitle,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: context.l10n.formDisplayNameLabel),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.formDisplayNameValidation;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.formChooseAvatar,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final avatar in _avatarOptions)
                    ChoiceChip(
                      label: Text(avatar, style: const TextStyle(fontSize: 20)),
                      selected: _selectedAvatar == avatar,
                      onSelected: (_) {
                        setState(() {
                          _selectedAvatar = avatar;
                        });
                      },
                  ),
                  ChoiceChip(
                    label: Text(context.l10n.formAvatarNone),
                    selected: _selectedAvatar == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedAvatar = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.formPreferredCohort,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: _selectedCohortId,
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(context.l10n.formPreferredCohortNone),
                  ),
                  for (final option in cohortOptions)
                    DropdownMenuItem<String?>(
                      value: option.id,
                      child: Text(option.displayName),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCohortId = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            CohortOption? selectedCohort;
            for (final option in cohortOptions) {
              if (option.id == _selectedCohortId) {
                selectedCohort = option;
                break;
              }
            }
            Navigator.pop(
              context,
              ProfileFormResult(
                displayName: _nameController.text.trim(),
                avatar: _selectedAvatar,
                cohortId: selectedCohort?.id,
                cohortTitle: selectedCohort?.title,
                cohortLessonClass: selectedCohort?.lessonClass,
              ),
            );
          },
          child: Text(context.l10n.actionSave),
        ),
      ],
    );
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
