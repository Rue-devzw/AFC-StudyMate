import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final assetPackServiceProvider = Provider<AssetPackService>((ref) {
  return AssetPackService();
});

class AssetPackPrepareResult {
  const AssetPackPrepareResult({
    required this.usedCompressedBundles,
    required this.usedFallbackAssets,
    required this.version,
  });

  final bool usedCompressedBundles;
  final bool usedFallbackAssets;
  final int version;
}

class AssetPackProgress {
  const AssetPackProgress({
    required this.progress,
    required this.message,
  });

  final double progress;
  final String message;
}

class AssetPackService {
  static const _manifestAssetPath = 'assets/data_packs/manifest.json';
  static const _prefKeyPreparedVersion = 'asset_pack_prepared_version';
  static const _prefKeyPreparedRoot = 'asset_pack_prepared_root';

  final Map<String, String> _resolvedAssetPaths = <String, String>{};

  Future<AssetPackPrepareResult> prepare({
    void Function(AssetPackProgress progress)? onProgress,
    Set<String>? includeLogicalAssetPaths,
    Set<String>? includeExtensions,
  }) async {
    onProgress?.call(
      const AssetPackProgress(
        progress: 0.02,
        message: 'Reading data bundle manifest...',
      ),
    );

    try {
      final manifestRaw = await rootBundle.loadString(_manifestAssetPath);
      final manifest = _AssetPackManifest.fromJson(
        jsonDecode(manifestRaw) as Map<String, dynamic>,
      );
      final supportDir = await getApplicationSupportDirectory();
      final extractionRoot = Directory(
        '${supportDir.path}/asset_packs/v${manifest.version}',
      );
      await extractionRoot.create(recursive: true);

      final prefs = await SharedPreferences.getInstance();
      final preparedVersion = prefs.getInt(_prefKeyPreparedVersion);
      final preparedRoot = prefs.getString(_prefKeyPreparedRoot);
      final shouldVerifyAll =
          preparedVersion != manifest.version ||
          preparedRoot != extractionRoot.path;

      final bundles = manifest.bundles.where((bundle) {
        final matchesPath =
            includeLogicalAssetPaths == null ||
            includeLogicalAssetPaths.contains(bundle.logicalAssetPath);
        final matchesExtension =
            includeExtensions == null ||
            includeExtensions.any(
              (extension) => bundle.logicalAssetPath.toLowerCase().endsWith(
                extension.toLowerCase(),
              ),
            );
        return matchesPath && matchesExtension;
      }).toList();

      final total = bundles.length;
      if (total == 0) {
        return AssetPackPrepareResult(
          usedCompressedBundles: true,
          usedFallbackAssets: false,
          version: manifest.version,
        );
      }

      for (var index = 0; index < total; index++) {
        final bundle = bundles[index];
        final targetFile = File(
          '${extractionRoot.path}/${bundle.outputRelativePath}',
        );
        await targetFile.parent.create(recursive: true);
        final logicalProgress = 0.05 + (index / total) * 0.9;
        onProgress?.call(
          AssetPackProgress(
            progress: logicalProgress,
            message: 'Preparing ${bundle.outputRelativePath}...',
          ),
        );

        final exists = await targetFile.exists();
        final valid =
            exists &&
            (!shouldVerifyAll ||
                await _matchesChecksum(targetFile, bundle.sha256));
        if (!valid) {
          await _extractBundle(bundle, targetFile);
          final verified = await _matchesChecksum(targetFile, bundle.sha256);
          if (!verified) {
            throw StateError(
              'Checksum mismatch after extraction for ${bundle.outputRelativePath}',
            );
          }
        }
        _resolvedAssetPaths[bundle.logicalAssetPath] = targetFile.path;
      }

      await prefs.setInt(_prefKeyPreparedVersion, manifest.version);
      await prefs.setString(_prefKeyPreparedRoot, extractionRoot.path);

      onProgress?.call(
        const AssetPackProgress(progress: 1, message: 'Data bundles ready.'),
      );
      return AssetPackPrepareResult(
        usedCompressedBundles: true,
        usedFallbackAssets: false,
        version: manifest.version,
      );
    } catch (_) {
      onProgress?.call(
        const AssetPackProgress(
          progress: 1,
          message: 'Using fallback embedded assets (bundle unpack failed).',
        ),
      );
      return const AssetPackPrepareResult(
        usedCompressedBundles: false,
        usedFallbackAssets: true,
        version: 0,
      );
    }
  }

  Future<String> loadText(String logicalAssetPath) async {
    final path = _resolvedAssetPaths[logicalAssetPath];
    if (path == null) {
      return rootBundle.loadString(logicalAssetPath);
    }
    return File(path).readAsString();
  }

  Future<String?> resolveFilePath(String logicalAssetPath) async {
    final path = _resolvedAssetPaths[logicalAssetPath];
    if (path == null) {
      return null;
    }
    final file = File(path);
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  Future<void> _extractBundle(_AssetPackBundle bundle, File targetFile) async {
    final compressed = await rootBundle.load(bundle.compressedAssetPath);
    final compressedBytes = compressed.buffer.asUint8List(
      compressed.offsetInBytes,
      compressed.lengthInBytes,
    );
    final decompressedBytes = gzip.decode(compressedBytes);
    await targetFile.writeAsBytes(decompressedBytes, flush: true);
  }

  Future<bool> _matchesChecksum(File file, String expectedSha256) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes).toString();
    return digest == expectedSha256;
  }
}

class _AssetPackManifest {
  const _AssetPackManifest({
    required this.version,
    required this.bundles,
  });

  factory _AssetPackManifest.fromJson(Map<String, dynamic> json) {
    final bundlesRaw = json['bundles'] as List<dynamic>? ?? <dynamic>[];
    return _AssetPackManifest(
      version: json['version'] as int? ?? 1,
      bundles: bundlesRaw
          .whereType<Map<String, dynamic>>()
          .map(_AssetPackBundle.fromJson)
          .toList(),
    );
  }

  final int version;
  final List<_AssetPackBundle> bundles;
}

class _AssetPackBundle {
  const _AssetPackBundle({
    required this.logicalAssetPath,
    required this.compressedAssetPath,
    required this.outputRelativePath,
    required this.sha256,
  });

  factory _AssetPackBundle.fromJson(Map<String, dynamic> json) {
    return _AssetPackBundle(
      logicalAssetPath: json['logicalAssetPath'] as String,
      compressedAssetPath: json['compressedAssetPath'] as String,
      outputRelativePath:
          (json['outputRelativePath'] ?? json['outputFileName']) as String,
      sha256: json['sha256'] as String,
    );
  }

  final String logicalAssetPath;
  final String compressedAssetPath;
  final String outputRelativePath;
  final String sha256;
}
