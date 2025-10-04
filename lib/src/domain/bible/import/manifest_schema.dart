import 'exceptions.dart';

/// Schema definition for Bible package manifests as specified in the
/// blueprint (see §5.1).
class BiblePackageManifest {
  BiblePackageManifest({
    required this.id,
    required this.language,
    required this.name,
    required this.version,
    required this.fileFormat,
    required this.checksum,
    this.source,
    List<String>? files,
  }) : files = List.unmodifiable(files ?? const []);

  final String id;
  final String language;
  final String name;
  final String version;
  final BiblePackageFileFormat fileFormat;
  final String checksum;
  final String? source;
  final List<String> files;

  static const Map<String, dynamic> schema = {
    r'$schema': 'http://json-schema.org/draft-07/schema#',
    'title': 'BiblePackageManifest',
    'type': 'object',
    'required': ['id', 'language', 'name', 'version', 'fileFormat', 'checksum'],
    'properties': {
      'id': {
        'type': 'string',
        'pattern': r'^[a-z0-9_-]+$',
      },
      'language': {
        'type': 'string',
      },
      'name': {
        'type': 'string',
      },
      'version': {
        'type': 'string',
      },
      'source': {
        'type': 'string',
      },
      'fileFormat': {
        'type': 'string',
        'enum': ['jsonl', 'sqlite'],
      },
      'checksum': {
        'type': 'string',
      },
      'files': {
        'type': 'array',
        'items': {
          'type': 'string',
        },
      },
    },
  };

  static BiblePackageManifest fromJson(Map<String, dynamic> json) {
    final errors = BiblePackageManifestValidator.validate(json);
    if (errors.isNotEmpty) {
      throw InvalidManifestException(errors);
    }
    return BiblePackageManifest(
      id: json['id'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      fileFormat: BiblePackageFileFormatX.fromJson(json['fileFormat'] as String),
      checksum: json['checksum'] as String,
      source: json['source'] as String?,
      files: (json['files'] as List<dynamic>?)
              ?.map((value) => value as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'name': name,
      'version': version,
      'fileFormat': fileFormat.toJson(),
      'checksum': checksum,
      if (source != null) 'source': source,
      if (files.isNotEmpty) 'files': files,
    };
  }
}

/// Supported payload types declared by the manifest.
enum BiblePackageFileFormat { jsonl, sqlite }

extension BiblePackageFileFormatX on BiblePackageFileFormat {
  String toJson() {
    switch (this) {
      case BiblePackageFileFormat.jsonl:
        return 'jsonl';
      case BiblePackageFileFormat.sqlite:
        return 'sqlite';
    }
  }

  static BiblePackageFileFormat fromJson(String value) {
    switch (value) {
      case 'jsonl':
        return BiblePackageFileFormat.jsonl;
      case 'sqlite':
        return BiblePackageFileFormat.sqlite;
      default:
        throw UnsupportedBiblePackageFormatException(value);
    }
  }
}

class BiblePackageManifestValidator {
  static final RegExp _idPattern = RegExp(r'^[a-z0-9_-]+$');

  static List<String> validate(Map<String, dynamic> json) {
    final errors = <String>[];

    void ensureRequired(String key) {
      if (!json.containsKey(key) || json[key] == null) {
        errors.add('Missing required property `$key`.');
      }
    }

    for (final key in
        ['id', 'language', 'name', 'version', 'fileFormat', 'checksum']) {
      ensureRequired(key);
    }

    if (json['id'] is! String || (json['id'] as String).trim().isEmpty) {
      errors.add('`id` must be a non-empty string.');
    } else {
      final id = (json['id'] as String).trim();
      if (!_idPattern.hasMatch(id)) {
        errors.add(r'`id` must match the pattern ^[a-z0-9_-]+$.');
      }
    }

    if (json['language'] != null && json['language'] is! String) {
      errors.add('`language` must be a string.');
    }
    if (json['name'] != null && json['name'] is! String) {
      errors.add('`name` must be a string.');
    }
    if (json['version'] != null && json['version'] is! String) {
      errors.add('`version` must be a string.');
    }
    if (json['source'] != null && json['source'] is! String) {
      errors.add('`source` must be a string when provided.');
    }
    if (json['checksum'] != null && json['checksum'] is! String) {
      errors.add('`checksum` must be a string.');
    }

    if (json['fileFormat'] != null) {
      if (json['fileFormat'] is! String) {
        errors.add('`fileFormat` must be a string.');
      } else {
        final value = json['fileFormat'] as String;
        if (!['jsonl', 'sqlite'].contains(value)) {
          errors.add('`fileFormat` must be one of: jsonl, sqlite.');
        }
      }
    }

    if (json['files'] != null) {
      if (json['files'] is! List) {
        errors.add('`files` must be an array of strings when provided.');
      } else {
        final files = json['files'] as List;
        for (var i = 0; i < files.length; i++) {
          final item = files[i];
          if (item is! String) {
            errors.add('`files[$i]` must be a string.');
          }
        }
      }
    }

    return errors;
  }
}
