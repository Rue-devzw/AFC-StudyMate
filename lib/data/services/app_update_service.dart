import 'dart:convert';

import 'package:afc_studymate/legal/app_legal.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService(client: http.Client());
});

class AppUpdateService {
  AppUpdateService({required this.client});

  final http.Client client;

  Future<AppUpdateStatus> fetchStatus() async {
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      final response = await client.get(Uri.parse(appVersionManifestUrl));
      if (response.statusCode != 200) {
        return AppUpdateStatus(
          packageInfo: packageInfo,
          errorMessage: 'Update service returned ${response.statusCode}.',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final manifest = AppReleaseManifest.fromJson(json);
      return AppUpdateStatus(
        packageInfo: packageInfo,
        manifest: manifest,
      );
    } catch (error) {
      return AppUpdateStatus(
        packageInfo: packageInfo,
        errorMessage: 'Could not reach the update service.',
      );
    }
  }
}

class AppReleaseManifest {
  const AppReleaseManifest({
    required this.appName,
    required this.channel,
    required this.releaseLabel,
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.minimumSupportedBuildNumber,
    required this.releaseDate,
    required this.releaseNotes,
    required this.releasePageUrl,
    required this.androidUrl,
    required this.iosUrl,
  });

  factory AppReleaseManifest.fromJson(Map<String, dynamic> json) {
    return AppReleaseManifest(
      appName: json['appName'] as String? ?? 'AFM SEAR StudyMate',
      channel: json['channel'] as String? ?? 'production',
      releaseLabel: json['releaseLabel'] as String? ?? 'Version 1',
      latestVersion: json['latestVersion'] as String? ?? '1.0.0',
      latestBuildNumber: json['latestBuildNumber'] as int? ?? 1,
      minimumSupportedBuildNumber:
          json['minimumSupportedBuildNumber'] as int? ?? 1,
      releaseDate: json['releaseDate'] as String? ?? '',
      releaseNotes:
          json['releaseNotes'] as String? ??
          'A new StudyMate release is available.',
      releasePageUrl: json['releasePageUrl'] as String? ?? appReleaseNotesUrl,
      androidUrl: json['androidUrl'] as String? ?? appReleaseNotesUrl,
      iosUrl: json['iosUrl'] as String? ?? appReleaseNotesUrl,
    );
  }

  final String appName;
  final String channel;
  final String releaseLabel;
  final String latestVersion;
  final int latestBuildNumber;
  final int minimumSupportedBuildNumber;
  final String releaseDate;
  final String releaseNotes;
  final String releasePageUrl;
  final String androidUrl;
  final String iosUrl;
}

class AppUpdateStatus {
  const AppUpdateStatus({
    required this.packageInfo,
    this.manifest,
    this.errorMessage,
  });

  final PackageInfo packageInfo;
  final AppReleaseManifest? manifest;
  final String? errorMessage;

  int get currentBuildNumber => int.tryParse(packageInfo.buildNumber) ?? 0;

  bool get hasError => errorMessage != null;

  bool get hasManifest => manifest != null;

  bool get updateAvailable {
    final release = manifest;
    if (release == null) {
      return false;
    }
    final versionCompare = _compareVersions(
      release.latestVersion,
      packageInfo.version,
    );
    if (versionCompare > 0) {
      return true;
    }
    if (versionCompare == 0 && release.latestBuildNumber > currentBuildNumber) {
      return true;
    }
    return false;
  }

  bool get requiresUpdate {
    final release = manifest;
    if (release == null) {
      return false;
    }
    return currentBuildNumber < release.minimumSupportedBuildNumber;
  }

  String get currentVersionLabel =>
      '${packageInfo.version} (${packageInfo.buildNumber})';

  String get latestVersionLabel {
    final release = manifest;
    if (release == null) {
      return currentVersionLabel;
    }
    return '${release.latestVersion} (${release.latestBuildNumber})';
  }

  String get statusSummary {
    if (hasError) {
      return errorMessage!;
    }
    if (requiresUpdate) {
      return 'This build is below the supported minimum version.';
    }
    if (updateAvailable) {
      final release = manifest!;
      return '${release.releaseLabel} is available.';
    }
    return 'You are on the latest available version.';
  }

  String get statusDetails {
    if (hasError) {
      return 'StudyMate could not verify the latest release right now.';
    }
    final release = manifest;
    if (release == null) {
      return 'No release information is available.';
    }
    if (updateAvailable || requiresUpdate) {
      return release.releaseNotes;
    }
    return 'Your current build matches the latest published release information.';
  }

  Uri? updateUriForPlatform(TargetPlatform platform) {
    final release = manifest;
    if (release == null) {
      return Uri.tryParse(appReleaseNotesUrl);
    }

    final url = switch (platform) {
      TargetPlatform.iOS => release.iosUrl,
      TargetPlatform.android => release.androidUrl,
      _ => release.releasePageUrl,
    };
    return Uri.tryParse(url);
  }

  static int _compareVersions(String left, String right) {
    final leftParts = left.split('.').map(_parseSegment).toList();
    final rightParts = right.split('.').map(_parseSegment).toList();
    final maxLength = leftParts.length > rightParts.length
        ? leftParts.length
        : rightParts.length;
    for (var index = 0; index < maxLength; index++) {
      final leftValue = index < leftParts.length ? leftParts[index] : 0;
      final rightValue = index < rightParts.length ? rightParts[index] : 0;
      if (leftValue != rightValue) {
        return leftValue.compareTo(rightValue);
      }
    }
    return 0;
  }

  static int _parseSegment(String value) {
    final numeric = RegExp(r'^\d+').stringMatch(value.trim());
    return int.tryParse(numeric ?? '') ?? 0;
  }
}
