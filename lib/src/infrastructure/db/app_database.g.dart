// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageNameMeta =
      const VerificationMeta('languageName');
  @override
  late final GeneratedColumn<String> languageName = GeneratedColumn<String>(
      'language_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _copyrightMeta =
      const VerificationMeta('copyright');
  @override
  late final GeneratedColumn<String> copyright = GeneratedColumn<String>(
      'copyright', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _installedAtMeta =
      const VerificationMeta('installedAt');
  @override
  late final GeneratedColumn<int> installedAt = GeneratedColumn<int>(
      'installed_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        language,
        languageName,
        version,
        copyright,
        source,
        installedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(Insertable<Translation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('language_name')) {
      context.handle(
          _languageNameMeta,
          languageName.isAcceptableOrUnknown(
              data['language_name']!, _languageNameMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('copyright')) {
      context.handle(_copyrightMeta,
          copyright.isAcceptableOrUnknown(data['copyright']!, _copyrightMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('installed_at')) {
      context.handle(
          _installedAtMeta,
          installedAt.isAcceptableOrUnknown(
              data['installed_at']!, _installedAtMeta));
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      languageName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_name'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      copyright: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}copyright'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      installedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installed_at'])!,
    );
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final String id;
  final String name;
  final String language;
  final String languageName;
  final String version;
  final String copyright;
  final String? source;
  final int installedAt;
  const Translation(
      {required this.id,
      required this.name,
      required this.language,
      required this.languageName,
      required this.version,
      required this.copyright,
      this.source,
      required this.installedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['language'] = Variable<String>(language);
    map['language_name'] = Variable<String>(languageName);
    map['version'] = Variable<String>(version);
    map['copyright'] = Variable<String>(copyright);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['installed_at'] = Variable<int>(installedAt);
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      name: Value(name),
      language: Value(language),
      languageName: Value(languageName),
      version: Value(version),
      copyright: Value(copyright),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      installedAt: Value(installedAt),
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      language: serializer.fromJson<String>(json['language']),
      languageName: serializer.fromJson<String>(json['languageName']),
      version: serializer.fromJson<String>(json['version']),
      copyright: serializer.fromJson<String>(json['copyright']),
      source: serializer.fromJson<String?>(json['source']),
      installedAt: serializer.fromJson<int>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'language': serializer.toJson<String>(language),
      'languageName': serializer.toJson<String>(languageName),
      'version': serializer.toJson<String>(version),
      'copyright': serializer.toJson<String>(copyright),
      'source': serializer.toJson<String?>(source),
      'installedAt': serializer.toJson<int>(installedAt),
    };
  }

  Translation copyWith(
          {String? id,
          String? name,
          String? language,
          String? languageName,
          String? version,
          String? copyright,
          Value<String?> source = const Value.absent(),
          int? installedAt}) =>
      Translation(
        id: id ?? this.id,
        name: name ?? this.name,
        language: language ?? this.language,
        languageName: languageName ?? this.languageName,
        version: version ?? this.version,
        copyright: copyright ?? this.copyright,
        source: source.present ? source.value : this.source,
        installedAt: installedAt ?? this.installedAt,
      );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      language: data.language.present ? data.language.value : this.language,
      languageName: data.languageName.present
          ? data.languageName.value
          : this.languageName,
      version: data.version.present ? data.version.value : this.version,
      copyright: data.copyright.present ? data.copyright.value : this.copyright,
      source: data.source.present ? data.source.value : this.source,
      installedAt:
          data.installedAt.present ? data.installedAt.value : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('languageName: $languageName, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('source: $source, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, language, languageName, version,
      copyright, source, installedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.name == this.name &&
          other.language == this.language &&
          other.languageName == this.languageName &&
          other.version == this.version &&
          other.copyright == this.copyright &&
          other.source == this.source &&
          other.installedAt == this.installedAt);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> language;
  final Value<String> languageName;
  final Value<String> version;
  final Value<String> copyright;
  final Value<String?> source;
  final Value<int> installedAt;
  final Value<int> rowid;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.language = const Value.absent(),
    this.languageName = const Value.absent(),
    this.version = const Value.absent(),
    this.copyright = const Value.absent(),
    this.source = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranslationsCompanion.insert({
    required String id,
    required String name,
    required String language,
    this.languageName = const Value.absent(),
    required String version,
    this.copyright = const Value.absent(),
    this.source = const Value.absent(),
    required int installedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        language = Value(language),
        version = Value(version),
        installedAt = Value(installedAt);
  static Insertable<Translation> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? language,
    Expression<String>? languageName,
    Expression<String>? version,
    Expression<String>? copyright,
    Expression<String>? source,
    Expression<int>? installedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (language != null) 'language': language,
      if (languageName != null) 'language_name': languageName,
      if (version != null) 'version': version,
      if (copyright != null) 'copyright': copyright,
      if (source != null) 'source': source,
      if (installedAt != null) 'installed_at': installedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranslationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? language,
      Value<String>? languageName,
      Value<String>? version,
      Value<String>? copyright,
      Value<String?>? source,
      Value<int>? installedAt,
      Value<int>? rowid}) {
    return TranslationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
      version: version ?? this.version,
      copyright: copyright ?? this.copyright,
      source: source ?? this.source,
      installedAt: installedAt ?? this.installedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (languageName.present) {
      map['language_name'] = Variable<String>(languageName.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (copyright.present) {
      map['copyright'] = Variable<String>(copyright.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<int>(installedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('languageName: $languageName, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('source: $source, ')
          ..write('installedAt: $installedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VersesTable extends Verses with TableInfo<$VersesTable, VerseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _translationIdMeta =
      const VerificationMeta('translationId');
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
      'translation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES translations (id) ON DELETE CASCADE'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseTextMeta =
      const VerificationMeta('verseText');
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
      'verse_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [translationId, bookId, chapter, verse, verseText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(Insertable<VerseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('translation_id')) {
      context.handle(
          _translationIdMeta,
          translationId.isAcceptableOrUnknown(
              data['translation_id']!, _translationIdMeta));
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('verse_text')) {
      context.handle(_verseTextMeta,
          verseText.isAcceptableOrUnknown(data['verse_text']!, _verseTextMeta));
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {translationId, bookId, chapter, verse};
  @override
  VerseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseRow(
      translationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      verseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_text'])!,
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class VerseRow extends DataClass implements Insertable<VerseRow> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String verseText;
  const VerseRow(
      {required this.translationId,
      required this.bookId,
      required this.chapter,
      required this.verse,
      required this.verseText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['verse_text'] = Variable<String>(verseText);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      verseText: Value(verseText),
    );
  }

  factory VerseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseRow(
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      verseText: serializer.fromJson<String>(json['verseText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'verseText': serializer.toJson<String>(verseText),
    };
  }

  VerseRow copyWith(
          {String? translationId,
          int? bookId,
          int? chapter,
          int? verse,
          String? verseText}) =>
      VerseRow(
        translationId: translationId ?? this.translationId,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        verseText: verseText ?? this.verseText,
      );
  VerseRow copyWithCompanion(VersesCompanion data) {
    return VerseRow(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseRow(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(translationId, bookId, chapter, verse, verseText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseRow &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.verseText == this.verseText);
}

class VersesCompanion extends UpdateCompanion<VerseRow> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> verseText;
  final Value<int> rowid;
  const VersesCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.verseText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VersesCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String verseText,
    this.rowid = const Value.absent(),
  })  : translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        verseText = Value(verseText);
  static Insertable<VerseRow> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? verseText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (verseText != null) 'verse_text': verseText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VersesCompanion copyWith(
      {Value<String>? translationId,
      Value<int>? bookId,
      Value<int>? chapter,
      Value<int>? verse,
      Value<String>? verseText,
      Value<int>? rowid}) {
    return VersesCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      verseText: verseText ?? this.verseText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (verseText.present) {
      map['verse_text'] = Variable<String>(verseText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredCohortIdMeta =
      const VerificationMeta('preferredCohortId');
  @override
  late final GeneratedColumn<String> preferredCohortId =
      GeneratedColumn<String>('preferred_cohort_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredCohortTitleMeta =
      const VerificationMeta('preferredCohortTitle');
  @override
  late final GeneratedColumn<String> preferredCohortTitle =
      GeneratedColumn<String>('preferred_cohort_title', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredLessonClassMeta =
      const VerificationMeta('preferredLessonClass');
  @override
  late final GeneratedColumn<String> preferredLessonClass =
      GeneratedColumn<String>('preferred_lesson_class', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rolesMeta = const VerificationMeta('roles');
  @override
  late final GeneratedColumn<String> roles = GeneratedColumn<String>(
      'roles', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        displayName,
        avatarUrl,
        preferredCohortId,
        preferredCohortTitle,
        preferredLessonClass,
        roles,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(Insertable<LocalUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('preferred_cohort_id')) {
      context.handle(
          _preferredCohortIdMeta,
          preferredCohortId.isAcceptableOrUnknown(
              data['preferred_cohort_id']!, _preferredCohortIdMeta));
    }
    if (data.containsKey('preferred_cohort_title')) {
      context.handle(
          _preferredCohortTitleMeta,
          preferredCohortTitle.isAcceptableOrUnknown(
              data['preferred_cohort_title']!, _preferredCohortTitleMeta));
    }
    if (data.containsKey('preferred_lesson_class')) {
      context.handle(
          _preferredLessonClassMeta,
          preferredLessonClass.isAcceptableOrUnknown(
              data['preferred_lesson_class']!, _preferredLessonClassMeta));
    }
    if (data.containsKey('roles')) {
      context.handle(
          _rolesMeta, roles.isAcceptableOrUnknown(data['roles']!, _rolesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      preferredCohortId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_cohort_id']),
      preferredCohortTitle: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preferred_cohort_title']),
      preferredLessonClass: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preferred_lesson_class']),
      roles: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}roles'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? preferredCohortId;
  final String? preferredCohortTitle;
  final String? preferredLessonClass;
  final String roles;
  final bool isActive;
  const LocalUser(
      {required this.id,
      this.displayName,
      this.avatarUrl,
      this.preferredCohortId,
      this.preferredCohortTitle,
      this.preferredLessonClass,
      required this.roles,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || preferredCohortId != null) {
      map['preferred_cohort_id'] = Variable<String>(preferredCohortId);
    }
    if (!nullToAbsent || preferredCohortTitle != null) {
      map['preferred_cohort_title'] = Variable<String>(preferredCohortTitle);
    }
    if (!nullToAbsent || preferredLessonClass != null) {
      map['preferred_lesson_class'] = Variable<String>(preferredLessonClass);
    }
    map['roles'] = Variable<String>(roles);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      preferredCohortId: preferredCohortId == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredCohortId),
      preferredCohortTitle: preferredCohortTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredCohortTitle),
      preferredLessonClass: preferredLessonClass == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredLessonClass),
      roles: Value(roles),
      isActive: Value(isActive),
    );
  }

  factory LocalUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      preferredCohortId:
          serializer.fromJson<String?>(json['preferredCohortId']),
      preferredCohortTitle:
          serializer.fromJson<String?>(json['preferredCohortTitle']),
      preferredLessonClass:
          serializer.fromJson<String?>(json['preferredLessonClass']),
      roles: serializer.fromJson<String>(json['roles']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'preferredCohortId': serializer.toJson<String?>(preferredCohortId),
      'preferredCohortTitle': serializer.toJson<String?>(preferredCohortTitle),
      'preferredLessonClass': serializer.toJson<String?>(preferredLessonClass),
      'roles': serializer.toJson<String>(roles),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalUser copyWith(
          {String? id,
          Value<String?> displayName = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          Value<String?> preferredCohortId = const Value.absent(),
          Value<String?> preferredCohortTitle = const Value.absent(),
          Value<String?> preferredLessonClass = const Value.absent(),
          String? roles,
          bool? isActive}) =>
      LocalUser(
        id: id ?? this.id,
        displayName: displayName.present ? displayName.value : this.displayName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        preferredCohortId: preferredCohortId.present
            ? preferredCohortId.value
            : this.preferredCohortId,
        preferredCohortTitle: preferredCohortTitle.present
            ? preferredCohortTitle.value
            : this.preferredCohortTitle,
        preferredLessonClass: preferredLessonClass.present
            ? preferredLessonClass.value
            : this.preferredLessonClass,
        roles: roles ?? this.roles,
        isActive: isActive ?? this.isActive,
      );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      preferredCohortId: data.preferredCohortId.present
          ? data.preferredCohortId.value
          : this.preferredCohortId,
      preferredCohortTitle: data.preferredCohortTitle.present
          ? data.preferredCohortTitle.value
          : this.preferredCohortTitle,
      preferredLessonClass: data.preferredLessonClass.present
          ? data.preferredLessonClass.value
          : this.preferredLessonClass,
      roles: data.roles.present ? data.roles.value : this.roles,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('preferredCohortId: $preferredCohortId, ')
          ..write('preferredCohortTitle: $preferredCohortTitle, ')
          ..write('preferredLessonClass: $preferredLessonClass, ')
          ..write('roles: $roles, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, avatarUrl, preferredCohortId,
      preferredCohortTitle, preferredLessonClass, roles, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.preferredCohortId == this.preferredCohortId &&
          other.preferredCohortTitle == this.preferredCohortTitle &&
          other.preferredLessonClass == this.preferredLessonClass &&
          other.roles == this.roles &&
          other.isActive == this.isActive);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<String?> avatarUrl;
  final Value<String?> preferredCohortId;
  final Value<String?> preferredCohortTitle;
  final Value<String?> preferredLessonClass;
  final Value<String> roles;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.preferredCohortId = const Value.absent(),
    this.preferredCohortTitle = const Value.absent(),
    this.preferredLessonClass = const Value.absent(),
    this.roles = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.preferredCohortId = const Value.absent(),
    this.preferredCohortTitle = const Value.absent(),
    this.preferredLessonClass = const Value.absent(),
    this.roles = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<LocalUser> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? preferredCohortId,
    Expression<String>? preferredCohortTitle,
    Expression<String>? preferredLessonClass,
    Expression<String>? roles,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (preferredCohortId != null) 'preferred_cohort_id': preferredCohortId,
      if (preferredCohortTitle != null)
        'preferred_cohort_title': preferredCohortTitle,
      if (preferredLessonClass != null)
        'preferred_lesson_class': preferredLessonClass,
      if (roles != null) 'roles': roles,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? displayName,
      Value<String?>? avatarUrl,
      Value<String?>? preferredCohortId,
      Value<String?>? preferredCohortTitle,
      Value<String?>? preferredLessonClass,
      Value<String>? roles,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredCohortId: preferredCohortId ?? this.preferredCohortId,
      preferredCohortTitle: preferredCohortTitle ?? this.preferredCohortTitle,
      preferredLessonClass: preferredLessonClass ?? this.preferredLessonClass,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (preferredCohortId.present) {
      map['preferred_cohort_id'] = Variable<String>(preferredCohortId.value);
    }
    if (preferredCohortTitle.present) {
      map['preferred_cohort_title'] =
          Variable<String>(preferredCohortTitle.value);
    }
    if (preferredLessonClass.present) {
      map['preferred_lesson_class'] =
          Variable<String>(preferredLessonClass.value);
    }
    if (roles.present) {
      map['roles'] = Variable<String>(roles.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('preferredCohortId: $preferredCohortId, ')
          ..write('preferredCohortTitle: $preferredCohortTitle, ')
          ..write('preferredLessonClass: $preferredLessonClass, ')
          ..write('roles: $roles, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES local_users (id) ON DELETE CASCADE'),
      defaultValue: const Constant('local-user'));
  static const VerificationMeta _translationIdMeta =
      const VerificationMeta('translationId');
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
      'translation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES translations (id) ON DELETE CASCADE'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, translationId, bookId, chapter, verse, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<BookmarkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('translation_id')) {
      context.handle(
          _translationIdMeta,
          translationId.isAcceptableOrUnknown(
              data['translation_id']!, _translationIdMeta));
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      translationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final int createdAt;
  const BookmarkRow(
      {required this.id,
      required this.userId,
      required this.translationId,
      required this.bookId,
      required this.chapter,
      required this.verse,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      userId: Value(userId),
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  BookmarkRow copyWith(
          {String? id,
          String? userId,
          String? translationId,
          int? bookId,
          int? chapter,
          int? verse,
          int? createdAt}) =>
      BookmarkRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        translationId: translationId ?? this.translationId,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        createdAt: createdAt ?? this.createdAt,
      );
  BookmarkRow copyWithCompanion(BookmarksCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, translationId, bookId, chapter, verse, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        createdAt = Value(createdAt);
  static Insertable<BookmarkRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? translationId,
      Value<int>? bookId,
      Value<int>? chapter,
      Value<int>? verse,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightsTable extends Highlights
    with TableInfo<$HighlightsTable, HighlightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES local_users (id) ON DELETE CASCADE'),
      defaultValue: const Constant('local-user'));
  static const VerificationMeta _translationIdMeta =
      const VerificationMeta('translationId');
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
      'translation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES translations (id) ON DELETE CASCADE'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<String> colour = GeneratedColumn<String>(
      'colour', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, translationId, bookId, chapter, verse, colour, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlights';
  @override
  VerificationContext validateIntegrity(Insertable<HighlightRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('translation_id')) {
      context.handle(
          _translationIdMeta,
          translationId.isAcceptableOrUnknown(
              data['translation_id']!, _translationIdMeta));
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('colour')) {
      context.handle(_colourMeta,
          colour.isAcceptableOrUnknown(data['colour']!, _colourMeta));
    } else if (isInserting) {
      context.missing(_colourMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighlightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      translationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      colour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}colour'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HighlightsTable createAlias(String alias) {
    return $HighlightsTable(attachedDatabase, alias);
  }
}

class HighlightRow extends DataClass implements Insertable<HighlightRow> {
  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String colour;
  final int createdAt;
  const HighlightRow(
      {required this.id,
      required this.userId,
      required this.translationId,
      required this.bookId,
      required this.chapter,
      required this.verse,
      required this.colour,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['colour'] = Variable<String>(colour);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  HighlightsCompanion toCompanion(bool nullToAbsent) {
    return HighlightsCompanion(
      id: Value(id),
      userId: Value(userId),
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      colour: Value(colour),
      createdAt: Value(createdAt),
    );
  }

  factory HighlightRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      colour: serializer.fromJson<String>(json['colour']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'colour': serializer.toJson<String>(colour),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  HighlightRow copyWith(
          {String? id,
          String? userId,
          String? translationId,
          int? bookId,
          int? chapter,
          int? verse,
          String? colour,
          int? createdAt}) =>
      HighlightRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        translationId: translationId ?? this.translationId,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        colour: colour ?? this.colour,
        createdAt: createdAt ?? this.createdAt,
      );
  HighlightRow copyWithCompanion(HighlightsCompanion data) {
    return HighlightRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      colour: data.colour.present ? data.colour.value : this.colour,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('colour: $colour, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, translationId, bookId, chapter, verse, colour, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.colour == this.colour &&
          other.createdAt == this.createdAt);
}

class HighlightsCompanion extends UpdateCompanion<HighlightRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> colour;
  final Value<int> createdAt;
  final Value<int> rowid;
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.colour = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HighlightsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String colour,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        colour = Value(colour),
        createdAt = Value(createdAt);
  static Insertable<HighlightRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? colour,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (colour != null) 'colour': colour,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HighlightsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? translationId,
      Value<int>? bookId,
      Value<int>? chapter,
      Value<int>? verse,
      Value<String>? colour,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return HighlightsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      colour: colour ?? this.colour,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('colour: $colour, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES local_users (id) ON DELETE CASCADE'),
      defaultValue: const Constant('local-user'));
  static const VerificationMeta _translationIdMeta =
      const VerificationMeta('translationId');
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
      'translation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES translations (id) ON DELETE CASCADE'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteTextMeta =
      const VerificationMeta('noteText');
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
      'note_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        translationId,
        bookId,
        chapter,
        verse,
        noteText,
        version,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('translation_id')) {
      context.handle(
          _translationIdMeta,
          translationId.isAcceptableOrUnknown(
              data['translation_id']!, _translationIdMeta));
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(_noteTextMeta,
          noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta));
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      translationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      noteText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_text'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String noteText;
  final int version;
  final int updatedAt;
  const NoteRow(
      {required this.id,
      required this.userId,
      required this.translationId,
      required this.bookId,
      required this.chapter,
      required this.verse,
      required this.noteText,
      required this.version,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['note_text'] = Variable<String>(noteText);
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      userId: Value(userId),
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      noteText: Value(noteText),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      noteText: serializer.fromJson<String>(json['noteText']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'noteText': serializer.toJson<String>(noteText),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NoteRow copyWith(
          {String? id,
          String? userId,
          String? translationId,
          int? bookId,
          int? chapter,
          int? verse,
          String? noteText,
          int? version,
          int? updatedAt}) =>
      NoteRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        translationId: translationId ?? this.translationId,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        noteText: noteText ?? this.noteText,
        version: version ?? this.version,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('noteText: $noteText, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, translationId, bookId, chapter,
      verse, noteText, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.noteText == this.noteText &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> noteText;
  final Value<int> version;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.noteText = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String noteText,
    this.version = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        noteText = Value(noteText),
        updatedAt = Value(updatedAt);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? noteText,
    Expression<int>? version,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (noteText != null) 'note_text': noteText,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? translationId,
      Value<int>? bookId,
      Value<int>? chapter,
      Value<int>? verse,
      Value<String>? noteText,
      Value<int>? version,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      noteText: noteText ?? this.noteText,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('noteText: $noteText, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteRevisionsTable extends NoteRevisions
    with TableInfo<$NoteRevisionsTable, NoteRevisionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES notes (id) ON DELETE CASCADE'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _revisionTextMeta =
      const VerificationMeta('revisionText');
  @override
  late final GeneratedColumn<String> revisionText = GeneratedColumn<String>(
      'revision_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [noteId, version, revisionText, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_revisions';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRevisionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('revision_text')) {
      context.handle(
          _revisionTextMeta,
          revisionText.isAcceptableOrUnknown(
              data['revision_text']!, _revisionTextMeta));
    } else if (isInserting) {
      context.missing(_revisionTextMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, version};
  @override
  NoteRevisionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRevisionRow(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      revisionText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}revision_text'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NoteRevisionsTable createAlias(String alias) {
    return $NoteRevisionsTable(attachedDatabase, alias);
  }
}

class NoteRevisionRow extends DataClass implements Insertable<NoteRevisionRow> {
  final String noteId;
  final int version;
  final String revisionText;
  final int updatedAt;
  const NoteRevisionRow(
      {required this.noteId,
      required this.version,
      required this.revisionText,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['version'] = Variable<int>(version);
    map['revision_text'] = Variable<String>(revisionText);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NoteRevisionsCompanion toCompanion(bool nullToAbsent) {
    return NoteRevisionsCompanion(
      noteId: Value(noteId),
      version: Value(version),
      revisionText: Value(revisionText),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRevisionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRevisionRow(
      noteId: serializer.fromJson<String>(json['noteId']),
      version: serializer.fromJson<int>(json['version']),
      revisionText: serializer.fromJson<String>(json['revisionText']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'version': serializer.toJson<int>(version),
      'revisionText': serializer.toJson<String>(revisionText),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NoteRevisionRow copyWith(
          {String? noteId,
          int? version,
          String? revisionText,
          int? updatedAt}) =>
      NoteRevisionRow(
        noteId: noteId ?? this.noteId,
        version: version ?? this.version,
        revisionText: revisionText ?? this.revisionText,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NoteRevisionRow copyWithCompanion(NoteRevisionsCompanion data) {
    return NoteRevisionRow(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      version: data.version.present ? data.version.value : this.version,
      revisionText: data.revisionText.present
          ? data.revisionText.value
          : this.revisionText,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRevisionRow(')
          ..write('noteId: $noteId, ')
          ..write('version: $version, ')
          ..write('revisionText: $revisionText, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, version, revisionText, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRevisionRow &&
          other.noteId == this.noteId &&
          other.version == this.version &&
          other.revisionText == this.revisionText &&
          other.updatedAt == this.updatedAt);
}

class NoteRevisionsCompanion extends UpdateCompanion<NoteRevisionRow> {
  final Value<String> noteId;
  final Value<int> version;
  final Value<String> revisionText;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const NoteRevisionsCompanion({
    this.noteId = const Value.absent(),
    this.version = const Value.absent(),
    this.revisionText = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteRevisionsCompanion.insert({
    required String noteId,
    required int version,
    required String revisionText,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        version = Value(version),
        revisionText = Value(revisionText),
        updatedAt = Value(updatedAt);
  static Insertable<NoteRevisionRow> custom({
    Expression<String>? noteId,
    Expression<int>? version,
    Expression<String>? revisionText,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (version != null) 'version': version,
      if (revisionText != null) 'revision_text': revisionText,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteRevisionsCompanion copyWith(
      {Value<String>? noteId,
      Value<int>? version,
      Value<String>? revisionText,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return NoteRevisionsCompanion(
      noteId: noteId ?? this.noteId,
      version: version ?? this.version,
      revisionText: revisionText ?? this.revisionText,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (revisionText.present) {
      map['revision_text'] = Variable<String>(revisionText.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteRevisionsCompanion(')
          ..write('noteId: $noteId, ')
          ..write('version: $version, ')
          ..write('revisionText: $revisionText, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, LessonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonClassMeta =
      const VerificationMeta('lessonClass');
  @override
  late final GeneratedColumn<String> lessonClass = GeneratedColumn<String>(
      'lesson_class', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ageMinMeta = const VerificationMeta('ageMin');
  @override
  late final GeneratedColumn<int> ageMin = GeneratedColumn<int>(
      'age_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ageMaxMeta = const VerificationMeta('ageMax');
  @override
  late final GeneratedColumn<int> ageMax = GeneratedColumn<int>(
      'age_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _objectivesMeta =
      const VerificationMeta('objectives');
  @override
  late final GeneratedColumn<String> objectives = GeneratedColumn<String>(
      'objectives', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scripturesMeta =
      const VerificationMeta('scriptures');
  @override
  late final GeneratedColumn<String> scriptures = GeneratedColumn<String>(
      'scriptures', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentHtmlMeta =
      const VerificationMeta('contentHtml');
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
      'content_html', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _teacherNotesMeta =
      const VerificationMeta('teacherNotes');
  @override
  late final GeneratedColumn<String> teacherNotes = GeneratedColumn<String>(
      'teacher_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quizzesMeta =
      const VerificationMeta('quizzes');
  @override
  late final GeneratedColumn<String> quizzes = GeneratedColumn<String>(
      'quizzes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastFetchedAtMeta =
      const VerificationMeta('lastFetchedAt');
  @override
  late final GeneratedColumn<int> lastFetchedAt = GeneratedColumn<int>(
      'last_fetched_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _feedIdMeta = const VerificationMeta('feedId');
  @override
  late final GeneratedColumn<String> feedId = GeneratedColumn<String>(
      'feed_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cohortIdMeta =
      const VerificationMeta('cohortId');
  @override
  late final GeneratedColumn<String> cohortId = GeneratedColumn<String>(
      'cohort_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        lessonClass,
        ageMin,
        ageMax,
        objectives,
        scriptures,
        contentHtml,
        teacherNotes,
        attachments,
        quizzes,
        sourceUrl,
        lastFetchedAt,
        feedId,
        cohortId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('lesson_class')) {
      context.handle(
          _lessonClassMeta,
          lessonClass.isAcceptableOrUnknown(
              data['lesson_class']!, _lessonClassMeta));
    } else if (isInserting) {
      context.missing(_lessonClassMeta);
    }
    if (data.containsKey('age_min')) {
      context.handle(_ageMinMeta,
          ageMin.isAcceptableOrUnknown(data['age_min']!, _ageMinMeta));
    }
    if (data.containsKey('age_max')) {
      context.handle(_ageMaxMeta,
          ageMax.isAcceptableOrUnknown(data['age_max']!, _ageMaxMeta));
    }
    if (data.containsKey('objectives')) {
      context.handle(
          _objectivesMeta,
          objectives.isAcceptableOrUnknown(
              data['objectives']!, _objectivesMeta));
    }
    if (data.containsKey('scriptures')) {
      context.handle(
          _scripturesMeta,
          scriptures.isAcceptableOrUnknown(
              data['scriptures']!, _scripturesMeta));
    }
    if (data.containsKey('content_html')) {
      context.handle(
          _contentHtmlMeta,
          contentHtml.isAcceptableOrUnknown(
              data['content_html']!, _contentHtmlMeta));
    }
    if (data.containsKey('teacher_notes')) {
      context.handle(
          _teacherNotesMeta,
          teacherNotes.isAcceptableOrUnknown(
              data['teacher_notes']!, _teacherNotesMeta));
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    }
    if (data.containsKey('quizzes')) {
      context.handle(_quizzesMeta,
          quizzes.isAcceptableOrUnknown(data['quizzes']!, _quizzesMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
          _lastFetchedAtMeta,
          lastFetchedAt.isAcceptableOrUnknown(
              data['last_fetched_at']!, _lastFetchedAtMeta));
    }
    if (data.containsKey('feed_id')) {
      context.handle(_feedIdMeta,
          feedId.isAcceptableOrUnknown(data['feed_id']!, _feedIdMeta));
    }
    if (data.containsKey('cohort_id')) {
      context.handle(_cohortIdMeta,
          cohortId.isAcceptableOrUnknown(data['cohort_id']!, _cohortIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      lessonClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_class'])!,
      ageMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age_min']),
      ageMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age_max']),
      objectives: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}objectives']),
      scriptures: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scriptures']),
      contentHtml: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_html']),
      teacherNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_notes']),
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments']),
      quizzes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quizzes']),
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
      lastFetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_fetched_at']),
      feedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feed_id']),
      cohortId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cohort_id']),
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class LessonRow extends DataClass implements Insertable<LessonRow> {
  final String id;
  final String title;
  final String lessonClass;
  final int? ageMin;
  final int? ageMax;
  final String? objectives;
  final String? scriptures;
  final String? contentHtml;
  final String? teacherNotes;
  final String? attachments;
  final String? quizzes;
  final String? sourceUrl;
  final int? lastFetchedAt;
  final String? feedId;
  final String? cohortId;
  const LessonRow(
      {required this.id,
      required this.title,
      required this.lessonClass,
      this.ageMin,
      this.ageMax,
      this.objectives,
      this.scriptures,
      this.contentHtml,
      this.teacherNotes,
      this.attachments,
      this.quizzes,
      this.sourceUrl,
      this.lastFetchedAt,
      this.feedId,
      this.cohortId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['lesson_class'] = Variable<String>(lessonClass);
    if (!nullToAbsent || ageMin != null) {
      map['age_min'] = Variable<int>(ageMin);
    }
    if (!nullToAbsent || ageMax != null) {
      map['age_max'] = Variable<int>(ageMax);
    }
    if (!nullToAbsent || objectives != null) {
      map['objectives'] = Variable<String>(objectives);
    }
    if (!nullToAbsent || scriptures != null) {
      map['scriptures'] = Variable<String>(scriptures);
    }
    if (!nullToAbsent || contentHtml != null) {
      map['content_html'] = Variable<String>(contentHtml);
    }
    if (!nullToAbsent || teacherNotes != null) {
      map['teacher_notes'] = Variable<String>(teacherNotes);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    if (!nullToAbsent || quizzes != null) {
      map['quizzes'] = Variable<String>(quizzes);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || lastFetchedAt != null) {
      map['last_fetched_at'] = Variable<int>(lastFetchedAt);
    }
    if (!nullToAbsent || feedId != null) {
      map['feed_id'] = Variable<String>(feedId);
    }
    if (!nullToAbsent || cohortId != null) {
      map['cohort_id'] = Variable<String>(cohortId);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      title: Value(title),
      lessonClass: Value(lessonClass),
      ageMin:
          ageMin == null && nullToAbsent ? const Value.absent() : Value(ageMin),
      ageMax:
          ageMax == null && nullToAbsent ? const Value.absent() : Value(ageMax),
      objectives: objectives == null && nullToAbsent
          ? const Value.absent()
          : Value(objectives),
      scriptures: scriptures == null && nullToAbsent
          ? const Value.absent()
          : Value(scriptures),
      contentHtml: contentHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHtml),
      teacherNotes: teacherNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherNotes),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
      quizzes: quizzes == null && nullToAbsent
          ? const Value.absent()
          : Value(quizzes),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      lastFetchedAt: lastFetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetchedAt),
      feedId:
          feedId == null && nullToAbsent ? const Value.absent() : Value(feedId),
      cohortId: cohortId == null && nullToAbsent
          ? const Value.absent()
          : Value(cohortId),
    );
  }

  factory LessonRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      lessonClass: serializer.fromJson<String>(json['lessonClass']),
      ageMin: serializer.fromJson<int?>(json['ageMin']),
      ageMax: serializer.fromJson<int?>(json['ageMax']),
      objectives: serializer.fromJson<String?>(json['objectives']),
      scriptures: serializer.fromJson<String?>(json['scriptures']),
      contentHtml: serializer.fromJson<String?>(json['contentHtml']),
      teacherNotes: serializer.fromJson<String?>(json['teacherNotes']),
      attachments: serializer.fromJson<String?>(json['attachments']),
      quizzes: serializer.fromJson<String?>(json['quizzes']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      lastFetchedAt: serializer.fromJson<int?>(json['lastFetchedAt']),
      feedId: serializer.fromJson<String?>(json['feedId']),
      cohortId: serializer.fromJson<String?>(json['cohortId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'lessonClass': serializer.toJson<String>(lessonClass),
      'ageMin': serializer.toJson<int?>(ageMin),
      'ageMax': serializer.toJson<int?>(ageMax),
      'objectives': serializer.toJson<String?>(objectives),
      'scriptures': serializer.toJson<String?>(scriptures),
      'contentHtml': serializer.toJson<String?>(contentHtml),
      'teacherNotes': serializer.toJson<String?>(teacherNotes),
      'attachments': serializer.toJson<String?>(attachments),
      'quizzes': serializer.toJson<String?>(quizzes),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'lastFetchedAt': serializer.toJson<int?>(lastFetchedAt),
      'feedId': serializer.toJson<String?>(feedId),
      'cohortId': serializer.toJson<String?>(cohortId),
    };
  }

  LessonRow copyWith(
          {String? id,
          String? title,
          String? lessonClass,
          Value<int?> ageMin = const Value.absent(),
          Value<int?> ageMax = const Value.absent(),
          Value<String?> objectives = const Value.absent(),
          Value<String?> scriptures = const Value.absent(),
          Value<String?> contentHtml = const Value.absent(),
          Value<String?> teacherNotes = const Value.absent(),
          Value<String?> attachments = const Value.absent(),
          Value<String?> quizzes = const Value.absent(),
          Value<String?> sourceUrl = const Value.absent(),
          Value<int?> lastFetchedAt = const Value.absent(),
          Value<String?> feedId = const Value.absent(),
          Value<String?> cohortId = const Value.absent()}) =>
      LessonRow(
        id: id ?? this.id,
        title: title ?? this.title,
        lessonClass: lessonClass ?? this.lessonClass,
        ageMin: ageMin.present ? ageMin.value : this.ageMin,
        ageMax: ageMax.present ? ageMax.value : this.ageMax,
        objectives: objectives.present ? objectives.value : this.objectives,
        scriptures: scriptures.present ? scriptures.value : this.scriptures,
        contentHtml: contentHtml.present ? contentHtml.value : this.contentHtml,
        teacherNotes:
            teacherNotes.present ? teacherNotes.value : this.teacherNotes,
        attachments: attachments.present ? attachments.value : this.attachments,
        quizzes: quizzes.present ? quizzes.value : this.quizzes,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
        lastFetchedAt:
            lastFetchedAt.present ? lastFetchedAt.value : this.lastFetchedAt,
        feedId: feedId.present ? feedId.value : this.feedId,
        cohortId: cohortId.present ? cohortId.value : this.cohortId,
      );
  LessonRow copyWithCompanion(LessonsCompanion data) {
    return LessonRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      lessonClass:
          data.lessonClass.present ? data.lessonClass.value : this.lessonClass,
      ageMin: data.ageMin.present ? data.ageMin.value : this.ageMin,
      ageMax: data.ageMax.present ? data.ageMax.value : this.ageMax,
      objectives:
          data.objectives.present ? data.objectives.value : this.objectives,
      scriptures:
          data.scriptures.present ? data.scriptures.value : this.scriptures,
      contentHtml:
          data.contentHtml.present ? data.contentHtml.value : this.contentHtml,
      teacherNotes: data.teacherNotes.present
          ? data.teacherNotes.value
          : this.teacherNotes,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
      quizzes: data.quizzes.present ? data.quizzes.value : this.quizzes,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      feedId: data.feedId.present ? data.feedId.value : this.feedId,
      cohortId: data.cohortId.present ? data.cohortId.value : this.cohortId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('objectives: $objectives, ')
          ..write('scriptures: $scriptures, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('teacherNotes: $teacherNotes, ')
          ..write('attachments: $attachments, ')
          ..write('quizzes: $quizzes, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('feedId: $feedId, ')
          ..write('cohortId: $cohortId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      lessonClass,
      ageMin,
      ageMax,
      objectives,
      scriptures,
      contentHtml,
      teacherNotes,
      attachments,
      quizzes,
      sourceUrl,
      lastFetchedAt,
      feedId,
      cohortId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.lessonClass == this.lessonClass &&
          other.ageMin == this.ageMin &&
          other.ageMax == this.ageMax &&
          other.objectives == this.objectives &&
          other.scriptures == this.scriptures &&
          other.contentHtml == this.contentHtml &&
          other.teacherNotes == this.teacherNotes &&
          other.attachments == this.attachments &&
          other.quizzes == this.quizzes &&
          other.sourceUrl == this.sourceUrl &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.feedId == this.feedId &&
          other.cohortId == this.cohortId);
}

class LessonsCompanion extends UpdateCompanion<LessonRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> lessonClass;
  final Value<int?> ageMin;
  final Value<int?> ageMax;
  final Value<String?> objectives;
  final Value<String?> scriptures;
  final Value<String?> contentHtml;
  final Value<String?> teacherNotes;
  final Value<String?> attachments;
  final Value<String?> quizzes;
  final Value<String?> sourceUrl;
  final Value<int?> lastFetchedAt;
  final Value<String?> feedId;
  final Value<String?> cohortId;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.objectives = const Value.absent(),
    this.scriptures = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.teacherNotes = const Value.absent(),
    this.attachments = const Value.absent(),
    this.quizzes = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.feedId = const Value.absent(),
    this.cohortId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String title,
    required String lessonClass,
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.objectives = const Value.absent(),
    this.scriptures = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.teacherNotes = const Value.absent(),
    this.attachments = const Value.absent(),
    this.quizzes = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.feedId = const Value.absent(),
    this.cohortId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        lessonClass = Value(lessonClass);
  static Insertable<LessonRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? lessonClass,
    Expression<int>? ageMin,
    Expression<int>? ageMax,
    Expression<String>? objectives,
    Expression<String>? scriptures,
    Expression<String>? contentHtml,
    Expression<String>? teacherNotes,
    Expression<String>? attachments,
    Expression<String>? quizzes,
    Expression<String>? sourceUrl,
    Expression<int>? lastFetchedAt,
    Expression<String>? feedId,
    Expression<String>? cohortId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (lessonClass != null) 'lesson_class': lessonClass,
      if (ageMin != null) 'age_min': ageMin,
      if (ageMax != null) 'age_max': ageMax,
      if (objectives != null) 'objectives': objectives,
      if (scriptures != null) 'scriptures': scriptures,
      if (contentHtml != null) 'content_html': contentHtml,
      if (teacherNotes != null) 'teacher_notes': teacherNotes,
      if (attachments != null) 'attachments': attachments,
      if (quizzes != null) 'quizzes': quizzes,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (feedId != null) 'feed_id': feedId,
      if (cohortId != null) 'cohort_id': cohortId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? lessonClass,
      Value<int?>? ageMin,
      Value<int?>? ageMax,
      Value<String?>? objectives,
      Value<String?>? scriptures,
      Value<String?>? contentHtml,
      Value<String?>? teacherNotes,
      Value<String?>? attachments,
      Value<String?>? quizzes,
      Value<String?>? sourceUrl,
      Value<int?>? lastFetchedAt,
      Value<String?>? feedId,
      Value<String?>? cohortId,
      Value<int>? rowid}) {
    return LessonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonClass: lessonClass ?? this.lessonClass,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      objectives: objectives ?? this.objectives,
      scriptures: scriptures ?? this.scriptures,
      contentHtml: contentHtml ?? this.contentHtml,
      teacherNotes: teacherNotes ?? this.teacherNotes,
      attachments: attachments ?? this.attachments,
      quizzes: quizzes ?? this.quizzes,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      feedId: feedId ?? this.feedId,
      cohortId: cohortId ?? this.cohortId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lessonClass.present) {
      map['lesson_class'] = Variable<String>(lessonClass.value);
    }
    if (ageMin.present) {
      map['age_min'] = Variable<int>(ageMin.value);
    }
    if (ageMax.present) {
      map['age_max'] = Variable<int>(ageMax.value);
    }
    if (objectives.present) {
      map['objectives'] = Variable<String>(objectives.value);
    }
    if (scriptures.present) {
      map['scriptures'] = Variable<String>(scriptures.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    if (teacherNotes.present) {
      map['teacher_notes'] = Variable<String>(teacherNotes.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (quizzes.present) {
      map['quizzes'] = Variable<String>(quizzes.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<int>(lastFetchedAt.value);
    }
    if (feedId.present) {
      map['feed_id'] = Variable<String>(feedId.value);
    }
    if (cohortId.present) {
      map['cohort_id'] = Variable<String>(cohortId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('objectives: $objectives, ')
          ..write('scriptures: $scriptures, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('teacherNotes: $teacherNotes, ')
          ..write('attachments: $attachments, ')
          ..write('quizzes: $quizzes, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('feedId: $feedId, ')
          ..write('cohortId: $cohortId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonObjectivesTable extends LessonObjectives
    with TableInfo<$LessonObjectivesTable, LessonObjectiveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonObjectivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lessons (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectiveMeta =
      const VerificationMeta('objective');
  @override
  late final GeneratedColumn<String> objective = GeneratedColumn<String>(
      'objective', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [lessonId, position, objective];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_objectives';
  @override
  VerificationContext validateIntegrity(Insertable<LessonObjectiveRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('objective')) {
      context.handle(_objectiveMeta,
          objective.isAcceptableOrUnknown(data['objective']!, _objectiveMeta));
    } else if (isInserting) {
      context.missing(_objectiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, position};
  @override
  LessonObjectiveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonObjectiveRow(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      objective: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}objective'])!,
    );
  }

  @override
  $LessonObjectivesTable createAlias(String alias) {
    return $LessonObjectivesTable(attachedDatabase, alias);
  }
}

class LessonObjectiveRow extends DataClass
    implements Insertable<LessonObjectiveRow> {
  final String lessonId;
  final int position;
  final String objective;
  const LessonObjectiveRow(
      {required this.lessonId,
      required this.position,
      required this.objective});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['objective'] = Variable<String>(objective);
    return map;
  }

  LessonObjectivesCompanion toCompanion(bool nullToAbsent) {
    return LessonObjectivesCompanion(
      lessonId: Value(lessonId),
      position: Value(position),
      objective: Value(objective),
    );
  }

  factory LessonObjectiveRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonObjectiveRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      objective: serializer.fromJson<String>(json['objective']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'objective': serializer.toJson<String>(objective),
    };
  }

  LessonObjectiveRow copyWith(
          {String? lessonId, int? position, String? objective}) =>
      LessonObjectiveRow(
        lessonId: lessonId ?? this.lessonId,
        position: position ?? this.position,
        objective: objective ?? this.objective,
      );
  LessonObjectiveRow copyWithCompanion(LessonObjectivesCompanion data) {
    return LessonObjectiveRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      objective: data.objective.present ? data.objective.value : this.objective,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonObjectiveRow(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('objective: $objective')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonId, position, objective);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonObjectiveRow &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.objective == this.objective);
}

class LessonObjectivesCompanion extends UpdateCompanion<LessonObjectiveRow> {
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> objective;
  final Value<int> rowid;
  const LessonObjectivesCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.objective = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonObjectivesCompanion.insert({
    required String lessonId,
    required int position,
    required String objective,
    this.rowid = const Value.absent(),
  })  : lessonId = Value(lessonId),
        position = Value(position),
        objective = Value(objective);
  static Insertable<LessonObjectiveRow> custom({
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? objective,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (objective != null) 'objective': objective,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonObjectivesCompanion copyWith(
      {Value<String>? lessonId,
      Value<int>? position,
      Value<String>? objective,
      Value<int>? rowid}) {
    return LessonObjectivesCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      objective: objective ?? this.objective,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (objective.present) {
      map['objective'] = Variable<String>(objective.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonObjectivesCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('objective: $objective, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonScripturesTable extends LessonScriptures
    with TableInfo<$LessonScripturesTable, LessonScriptureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonScripturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lessons (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translationIdMeta =
      const VerificationMeta('translationId');
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
      'translation_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [lessonId, position, reference, translationId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_scriptures';
  @override
  VerificationContext validateIntegrity(Insertable<LessonScriptureRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('translation_id')) {
      context.handle(
          _translationIdMeta,
          translationId.isAcceptableOrUnknown(
              data['translation_id']!, _translationIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, position};
  @override
  LessonScriptureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonScriptureRow(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      translationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_id']),
    );
  }

  @override
  $LessonScripturesTable createAlias(String alias) {
    return $LessonScripturesTable(attachedDatabase, alias);
  }
}

class LessonScriptureRow extends DataClass
    implements Insertable<LessonScriptureRow> {
  final String lessonId;
  final int position;
  final String reference;
  final String? translationId;
  const LessonScriptureRow(
      {required this.lessonId,
      required this.position,
      required this.reference,
      this.translationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || translationId != null) {
      map['translation_id'] = Variable<String>(translationId);
    }
    return map;
  }

  LessonScripturesCompanion toCompanion(bool nullToAbsent) {
    return LessonScripturesCompanion(
      lessonId: Value(lessonId),
      position: Value(position),
      reference: Value(reference),
      translationId: translationId == null && nullToAbsent
          ? const Value.absent()
          : Value(translationId),
    );
  }

  factory LessonScriptureRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonScriptureRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      reference: serializer.fromJson<String>(json['reference']),
      translationId: serializer.fromJson<String?>(json['translationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'reference': serializer.toJson<String>(reference),
      'translationId': serializer.toJson<String?>(translationId),
    };
  }

  LessonScriptureRow copyWith(
          {String? lessonId,
          int? position,
          String? reference,
          Value<String?> translationId = const Value.absent()}) =>
      LessonScriptureRow(
        lessonId: lessonId ?? this.lessonId,
        position: position ?? this.position,
        reference: reference ?? this.reference,
        translationId:
            translationId.present ? translationId.value : this.translationId,
      );
  LessonScriptureRow copyWithCompanion(LessonScripturesCompanion data) {
    return LessonScriptureRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      reference: data.reference.present ? data.reference.value : this.reference,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonScriptureRow(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('reference: $reference, ')
          ..write('translationId: $translationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonId, position, reference, translationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonScriptureRow &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.reference == this.reference &&
          other.translationId == this.translationId);
}

class LessonScripturesCompanion extends UpdateCompanion<LessonScriptureRow> {
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> reference;
  final Value<String?> translationId;
  final Value<int> rowid;
  const LessonScripturesCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.reference = const Value.absent(),
    this.translationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonScripturesCompanion.insert({
    required String lessonId,
    required int position,
    required String reference,
    this.translationId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : lessonId = Value(lessonId),
        position = Value(position),
        reference = Value(reference);
  static Insertable<LessonScriptureRow> custom({
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? reference,
    Expression<String>? translationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (reference != null) 'reference': reference,
      if (translationId != null) 'translation_id': translationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonScripturesCompanion copyWith(
      {Value<String>? lessonId,
      Value<int>? position,
      Value<String>? reference,
      Value<String?>? translationId,
      Value<int>? rowid}) {
    return LessonScripturesCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      reference: reference ?? this.reference,
      translationId: translationId ?? this.translationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonScripturesCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('reference: $reference, ')
          ..write('translationId: $translationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonAttachmentsTable extends LessonAttachments
    with TableInfo<$LessonAttachmentsTable, LessonAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lessons (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
      'downloaded_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        lessonId,
        position,
        type,
        title,
        url,
        localPath,
        sizeBytes,
        downloadedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_attachments';
  @override
  VerificationContext validateIntegrity(
      Insertable<LessonAttachmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, position};
  @override
  LessonAttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonAttachmentRow(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes']),
      downloadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}downloaded_at']),
    );
  }

  @override
  $LessonAttachmentsTable createAlias(String alias) {
    return $LessonAttachmentsTable(attachedDatabase, alias);
  }
}

class LessonAttachmentRow extends DataClass
    implements Insertable<LessonAttachmentRow> {
  final String lessonId;
  final int position;
  final String type;
  final String? title;
  final String url;
  final String? localPath;
  final int? sizeBytes;
  final int? downloadedAt;
  const LessonAttachmentRow(
      {required this.lessonId,
      required this.position,
      required this.type,
      this.title,
      required this.url,
      this.localPath,
      this.sizeBytes,
      this.downloadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    if (!nullToAbsent || downloadedAt != null) {
      map['downloaded_at'] = Variable<int>(downloadedAt);
    }
    return map;
  }

  LessonAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return LessonAttachmentsCompanion(
      lessonId: Value(lessonId),
      position: Value(position),
      type: Value(type),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      url: Value(url),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      downloadedAt: downloadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadedAt),
    );
  }

  factory LessonAttachmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonAttachmentRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String?>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      downloadedAt: serializer.fromJson<int?>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String?>(title),
      'url': serializer.toJson<String>(url),
      'localPath': serializer.toJson<String?>(localPath),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'downloadedAt': serializer.toJson<int?>(downloadedAt),
    };
  }

  LessonAttachmentRow copyWith(
          {String? lessonId,
          int? position,
          String? type,
          Value<String?> title = const Value.absent(),
          String? url,
          Value<String?> localPath = const Value.absent(),
          Value<int?> sizeBytes = const Value.absent(),
          Value<int?> downloadedAt = const Value.absent()}) =>
      LessonAttachmentRow(
        lessonId: lessonId ?? this.lessonId,
        position: position ?? this.position,
        type: type ?? this.type,
        title: title.present ? title.value : this.title,
        url: url ?? this.url,
        localPath: localPath.present ? localPath.value : this.localPath,
        sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
        downloadedAt:
            downloadedAt.present ? downloadedAt.value : this.downloadedAt,
      );
  LessonAttachmentRow copyWithCompanion(LessonAttachmentsCompanion data) {
    return LessonAttachmentRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttachmentRow(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lessonId, position, type, title, url, localPath, sizeBytes, downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonAttachmentRow &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.type == this.type &&
          other.title == this.title &&
          other.url == this.url &&
          other.localPath == this.localPath &&
          other.sizeBytes == this.sizeBytes &&
          other.downloadedAt == this.downloadedAt);
}

class LessonAttachmentsCompanion extends UpdateCompanion<LessonAttachmentRow> {
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> type;
  final Value<String?> title;
  final Value<String> url;
  final Value<String?> localPath;
  final Value<int?> sizeBytes;
  final Value<int?> downloadedAt;
  final Value<int> rowid;
  const LessonAttachmentsCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonAttachmentsCompanion.insert({
    required String lessonId,
    required int position,
    required String type,
    this.title = const Value.absent(),
    required String url,
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : lessonId = Value(lessonId),
        position = Value(position),
        type = Value(type),
        url = Value(url);
  static Insertable<LessonAttachmentRow> custom({
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? localPath,
    Expression<int>? sizeBytes,
    Expression<int>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (localPath != null) 'local_path': localPath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonAttachmentsCompanion copyWith(
      {Value<String>? lessonId,
      Value<int>? position,
      Value<String>? type,
      Value<String?>? title,
      Value<String>? url,
      Value<String?>? localPath,
      Value<int?>? sizeBytes,
      Value<int?>? downloadedAt,
      Value<int>? rowid}) {
    return LessonAttachmentsCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      title: title ?? this.title,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttachmentsCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonQuizzesTable extends LessonQuizzes
    with TableInfo<$LessonQuizzesTable, LessonQuizRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonQuizzesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lessons (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
      'prompt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, position, type, prompt, answer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_quizzes';
  @override
  VerificationContext validateIntegrity(Insertable<LessonQuizRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(_promptMeta,
          prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta));
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonQuizRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonQuizRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      prompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prompt'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
    );
  }

  @override
  $LessonQuizzesTable createAlias(String alias) {
    return $LessonQuizzesTable(attachedDatabase, alias);
  }
}

class LessonQuizRow extends DataClass implements Insertable<LessonQuizRow> {
  final String id;
  final String lessonId;
  final int position;
  final String type;
  final String prompt;
  final String? answer;
  const LessonQuizRow(
      {required this.id,
      required this.lessonId,
      required this.position,
      required this.type,
      required this.prompt,
      this.answer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['type'] = Variable<String>(type);
    map['prompt'] = Variable<String>(prompt);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    return map;
  }

  LessonQuizzesCompanion toCompanion(bool nullToAbsent) {
    return LessonQuizzesCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      position: Value(position),
      type: Value(type),
      prompt: Value(prompt),
      answer:
          answer == null && nullToAbsent ? const Value.absent() : Value(answer),
    );
  }

  factory LessonQuizRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonQuizRow(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      type: serializer.fromJson<String>(json['type']),
      prompt: serializer.fromJson<String>(json['prompt']),
      answer: serializer.fromJson<String?>(json['answer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'type': serializer.toJson<String>(type),
      'prompt': serializer.toJson<String>(prompt),
      'answer': serializer.toJson<String?>(answer),
    };
  }

  LessonQuizRow copyWith(
          {String? id,
          String? lessonId,
          int? position,
          String? type,
          String? prompt,
          Value<String?> answer = const Value.absent()}) =>
      LessonQuizRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        position: position ?? this.position,
        type: type ?? this.type,
        prompt: prompt ?? this.prompt,
        answer: answer.present ? answer.value : this.answer,
      );
  LessonQuizRow copyWithCompanion(LessonQuizzesCompanion data) {
    return LessonQuizRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      type: data.type.present ? data.type.value : this.type,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      answer: data.answer.present ? data.answer.value : this.answer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonQuizRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, position, type, prompt, answer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonQuizRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.type == this.type &&
          other.prompt == this.prompt &&
          other.answer == this.answer);
}

class LessonQuizzesCompanion extends UpdateCompanion<LessonQuizRow> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> type;
  final Value<String> prompt;
  final Value<String?> answer;
  final Value<int> rowid;
  const LessonQuizzesCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.type = const Value.absent(),
    this.prompt = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonQuizzesCompanion.insert({
    required String id,
    required String lessonId,
    required int position,
    required String type,
    required String prompt,
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        position = Value(position),
        type = Value(type),
        prompt = Value(prompt);
  static Insertable<LessonQuizRow> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? type,
    Expression<String>? prompt,
    Expression<String>? answer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (type != null) 'type': type,
      if (prompt != null) 'prompt': prompt,
      if (answer != null) 'answer': answer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonQuizzesCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<int>? position,
      Value<String>? type,
      Value<String>? prompt,
      Value<String?>? answer,
      Value<int>? rowid}) {
    return LessonQuizzesCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      answer: answer ?? this.answer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonQuizzesCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonQuizOptionsTable extends LessonQuizOptions
    with TableInfo<$LessonQuizOptionsTable, LessonQuizOptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonQuizOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
      'quiz_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lesson_quizzes (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [quizId, position, label, isCorrect];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_quiz_options';
  @override
  VerificationContext validateIntegrity(
      Insertable<LessonQuizOptionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quiz_id')) {
      context.handle(_quizIdMeta,
          quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta));
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quizId, position};
  @override
  LessonQuizOptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonQuizOptionRow(
      quizId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quiz_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
    );
  }

  @override
  $LessonQuizOptionsTable createAlias(String alias) {
    return $LessonQuizOptionsTable(attachedDatabase, alias);
  }
}

class LessonQuizOptionRow extends DataClass
    implements Insertable<LessonQuizOptionRow> {
  final String quizId;
  final int position;
  final String label;
  final bool isCorrect;
  const LessonQuizOptionRow(
      {required this.quizId,
      required this.position,
      required this.label,
      required this.isCorrect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quiz_id'] = Variable<String>(quizId);
    map['position'] = Variable<int>(position);
    map['label'] = Variable<String>(label);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  LessonQuizOptionsCompanion toCompanion(bool nullToAbsent) {
    return LessonQuizOptionsCompanion(
      quizId: Value(quizId),
      position: Value(position),
      label: Value(label),
      isCorrect: Value(isCorrect),
    );
  }

  factory LessonQuizOptionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonQuizOptionRow(
      quizId: serializer.fromJson<String>(json['quizId']),
      position: serializer.fromJson<int>(json['position']),
      label: serializer.fromJson<String>(json['label']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quizId': serializer.toJson<String>(quizId),
      'position': serializer.toJson<int>(position),
      'label': serializer.toJson<String>(label),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  LessonQuizOptionRow copyWith(
          {String? quizId, int? position, String? label, bool? isCorrect}) =>
      LessonQuizOptionRow(
        quizId: quizId ?? this.quizId,
        position: position ?? this.position,
        label: label ?? this.label,
        isCorrect: isCorrect ?? this.isCorrect,
      );
  LessonQuizOptionRow copyWithCompanion(LessonQuizOptionsCompanion data) {
    return LessonQuizOptionRow(
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      position: data.position.present ? data.position.value : this.position,
      label: data.label.present ? data.label.value : this.label,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonQuizOptionRow(')
          ..write('quizId: $quizId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(quizId, position, label, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonQuizOptionRow &&
          other.quizId == this.quizId &&
          other.position == this.position &&
          other.label == this.label &&
          other.isCorrect == this.isCorrect);
}

class LessonQuizOptionsCompanion extends UpdateCompanion<LessonQuizOptionRow> {
  final Value<String> quizId;
  final Value<int> position;
  final Value<String> label;
  final Value<bool> isCorrect;
  final Value<int> rowid;
  const LessonQuizOptionsCompanion({
    this.quizId = const Value.absent(),
    this.position = const Value.absent(),
    this.label = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonQuizOptionsCompanion.insert({
    required String quizId,
    required int position,
    required String label,
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : quizId = Value(quizId),
        position = Value(position),
        label = Value(label);
  static Insertable<LessonQuizOptionRow> custom({
    Expression<String>? quizId,
    Expression<int>? position,
    Expression<String>? label,
    Expression<bool>? isCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quizId != null) 'quiz_id': quizId,
      if (position != null) 'position': position,
      if (label != null) 'label': label,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonQuizOptionsCompanion copyWith(
      {Value<String>? quizId,
      Value<int>? position,
      Value<String>? label,
      Value<bool>? isCorrect,
      Value<int>? rowid}) {
    return LessonQuizOptionsCompanion(
      quizId: quizId ?? this.quizId,
      position: position ?? this.position,
      label: label ?? this.label,
      isCorrect: isCorrect ?? this.isCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonQuizOptionsCompanion(')
          ..write('quizId: $quizId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonDraftsTable extends LessonDrafts
    with TableInfo<$LessonDraftsTable, LessonDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deltaJsonMeta =
      const VerificationMeta('deltaJson');
  @override
  late final GeneratedColumn<String> deltaJson = GeneratedColumn<String>(
      'delta_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _approverIdMeta =
      const VerificationMeta('approverId');
  @override
  late final GeneratedColumn<String> approverId = GeneratedColumn<String>(
      'approver_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reviewerCommentMeta =
      const VerificationMeta('reviewerComment');
  @override
  late final GeneratedColumn<String> reviewerComment = GeneratedColumn<String>(
      'reviewer_comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        lessonId,
        authorId,
        title,
        deltaJson,
        status,
        approverId,
        reviewerComment,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<LessonDraftRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('delta_json')) {
      context.handle(_deltaJsonMeta,
          deltaJson.isAcceptableOrUnknown(data['delta_json']!, _deltaJsonMeta));
    } else if (isInserting) {
      context.missing(_deltaJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('approver_id')) {
      context.handle(
          _approverIdMeta,
          approverId.isAcceptableOrUnknown(
              data['approver_id']!, _approverIdMeta));
    }
    if (data.containsKey('reviewer_comment')) {
      context.handle(
          _reviewerCommentMeta,
          reviewerComment.isAcceptableOrUnknown(
              data['reviewer_comment']!, _reviewerCommentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonDraftRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id']),
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      deltaJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}delta_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      approverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approver_id']),
      reviewerComment: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reviewer_comment']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LessonDraftsTable createAlias(String alias) {
    return $LessonDraftsTable(attachedDatabase, alias);
  }
}

class LessonDraftRow extends DataClass implements Insertable<LessonDraftRow> {
  final String id;
  final String? lessonId;
  final String authorId;
  final String title;
  final String deltaJson;
  final String status;
  final String? approverId;
  final String? reviewerComment;
  final int createdAt;
  final int updatedAt;
  const LessonDraftRow(
      {required this.id,
      this.lessonId,
      required this.authorId,
      required this.title,
      required this.deltaJson,
      required this.status,
      this.approverId,
      this.reviewerComment,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['author_id'] = Variable<String>(authorId);
    map['title'] = Variable<String>(title);
    map['delta_json'] = Variable<String>(deltaJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || approverId != null) {
      map['approver_id'] = Variable<String>(approverId);
    }
    if (!nullToAbsent || reviewerComment != null) {
      map['reviewer_comment'] = Variable<String>(reviewerComment);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LessonDraftsCompanion toCompanion(bool nullToAbsent) {
    return LessonDraftsCompanion(
      id: Value(id),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      authorId: Value(authorId),
      title: Value(title),
      deltaJson: Value(deltaJson),
      status: Value(status),
      approverId: approverId == null && nullToAbsent
          ? const Value.absent()
          : Value(approverId),
      reviewerComment: reviewerComment == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewerComment),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonDraftRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonDraftRow(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      title: serializer.fromJson<String>(json['title']),
      deltaJson: serializer.fromJson<String>(json['deltaJson']),
      status: serializer.fromJson<String>(json['status']),
      approverId: serializer.fromJson<String?>(json['approverId']),
      reviewerComment: serializer.fromJson<String?>(json['reviewerComment']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String?>(lessonId),
      'authorId': serializer.toJson<String>(authorId),
      'title': serializer.toJson<String>(title),
      'deltaJson': serializer.toJson<String>(deltaJson),
      'status': serializer.toJson<String>(status),
      'approverId': serializer.toJson<String?>(approverId),
      'reviewerComment': serializer.toJson<String?>(reviewerComment),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LessonDraftRow copyWith(
          {String? id,
          Value<String?> lessonId = const Value.absent(),
          String? authorId,
          String? title,
          String? deltaJson,
          String? status,
          Value<String?> approverId = const Value.absent(),
          Value<String?> reviewerComment = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      LessonDraftRow(
        id: id ?? this.id,
        lessonId: lessonId.present ? lessonId.value : this.lessonId,
        authorId: authorId ?? this.authorId,
        title: title ?? this.title,
        deltaJson: deltaJson ?? this.deltaJson,
        status: status ?? this.status,
        approverId: approverId.present ? approverId.value : this.approverId,
        reviewerComment: reviewerComment.present
            ? reviewerComment.value
            : this.reviewerComment,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LessonDraftRow copyWithCompanion(LessonDraftsCompanion data) {
    return LessonDraftRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      title: data.title.present ? data.title.value : this.title,
      deltaJson: data.deltaJson.present ? data.deltaJson.value : this.deltaJson,
      status: data.status.present ? data.status.value : this.status,
      approverId:
          data.approverId.present ? data.approverId.value : this.approverId,
      reviewerComment: data.reviewerComment.present
          ? data.reviewerComment.value
          : this.reviewerComment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonDraftRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('authorId: $authorId, ')
          ..write('title: $title, ')
          ..write('deltaJson: $deltaJson, ')
          ..write('status: $status, ')
          ..write('approverId: $approverId, ')
          ..write('reviewerComment: $reviewerComment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, authorId, title, deltaJson,
      status, approverId, reviewerComment, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonDraftRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.authorId == this.authorId &&
          other.title == this.title &&
          other.deltaJson == this.deltaJson &&
          other.status == this.status &&
          other.approverId == this.approverId &&
          other.reviewerComment == this.reviewerComment &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LessonDraftsCompanion extends UpdateCompanion<LessonDraftRow> {
  final Value<String> id;
  final Value<String?> lessonId;
  final Value<String> authorId;
  final Value<String> title;
  final Value<String> deltaJson;
  final Value<String> status;
  final Value<String?> approverId;
  final Value<String?> reviewerComment;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LessonDraftsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.title = const Value.absent(),
    this.deltaJson = const Value.absent(),
    this.status = const Value.absent(),
    this.approverId = const Value.absent(),
    this.reviewerComment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonDraftsCompanion.insert({
    required String id,
    this.lessonId = const Value.absent(),
    required String authorId,
    required String title,
    required String deltaJson,
    this.status = const Value.absent(),
    this.approverId = const Value.absent(),
    this.reviewerComment = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        authorId = Value(authorId),
        title = Value(title),
        deltaJson = Value(deltaJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<LessonDraftRow> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? authorId,
    Expression<String>? title,
    Expression<String>? deltaJson,
    Expression<String>? status,
    Expression<String>? approverId,
    Expression<String>? reviewerComment,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (authorId != null) 'author_id': authorId,
      if (title != null) 'title': title,
      if (deltaJson != null) 'delta_json': deltaJson,
      if (status != null) 'status': status,
      if (approverId != null) 'approver_id': approverId,
      if (reviewerComment != null) 'reviewer_comment': reviewerComment,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonDraftsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? lessonId,
      Value<String>? authorId,
      Value<String>? title,
      Value<String>? deltaJson,
      Value<String>? status,
      Value<String?>? approverId,
      Value<String?>? reviewerComment,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return LessonDraftsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      deltaJson: deltaJson ?? this.deltaJson,
      status: status ?? this.status,
      approverId: approverId ?? this.approverId,
      reviewerComment: reviewerComment ?? this.reviewerComment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (deltaJson.present) {
      map['delta_json'] = Variable<String>(deltaJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (approverId.present) {
      map['approver_id'] = Variable<String>(approverId.value);
    }
    if (reviewerComment.present) {
      map['reviewer_comment'] = Variable<String>(reviewerComment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonDraftsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('authorId: $authorId, ')
          ..write('title: $title, ')
          ..write('deltaJson: $deltaJson, ')
          ..write('status: $status, ')
          ..write('approverId: $approverId, ')
          ..write('reviewerComment: $reviewerComment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonFeedsTable extends LessonFeeds
    with TableInfo<$LessonFeedsTable, LessonFeedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonFeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cohortMeta = const VerificationMeta('cohort');
  @override
  late final GeneratedColumn<String> cohort = GeneratedColumn<String>(
      'cohort', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lessonClassMeta =
      const VerificationMeta('lessonClass');
  @override
  late final GeneratedColumn<String> lessonClass = GeneratedColumn<String>(
      'lesson_class', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
      'etag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<int> lastModified = GeneratedColumn<int>(
      'last_modified', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastFetchedAtMeta =
      const VerificationMeta('lastFetchedAt');
  @override
  late final GeneratedColumn<int> lastFetchedAt = GeneratedColumn<int>(
      'last_fetched_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCheckedAtMeta =
      const VerificationMeta('lastCheckedAt');
  @override
  late final GeneratedColumn<int> lastCheckedAt = GeneratedColumn<int>(
      'last_checked_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        source,
        cohort,
        lessonClass,
        checksum,
        etag,
        lastModified,
        lastFetchedAt,
        lastCheckedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_feeds';
  @override
  VerificationContext validateIntegrity(Insertable<LessonFeedRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('cohort')) {
      context.handle(_cohortMeta,
          cohort.isAcceptableOrUnknown(data['cohort']!, _cohortMeta));
    }
    if (data.containsKey('lesson_class')) {
      context.handle(
          _lessonClassMeta,
          lessonClass.isAcceptableOrUnknown(
              data['lesson_class']!, _lessonClassMeta));
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    }
    if (data.containsKey('etag')) {
      context.handle(
          _etagMeta, etag.isAcceptableOrUnknown(data['etag']!, _etagMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
          _lastFetchedAtMeta,
          lastFetchedAt.isAcceptableOrUnknown(
              data['last_fetched_at']!, _lastFetchedAtMeta));
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
          _lastCheckedAtMeta,
          lastCheckedAt.isAcceptableOrUnknown(
              data['last_checked_at']!, _lastCheckedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonFeedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonFeedRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      cohort: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cohort']),
      lessonClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_class']),
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum']),
      etag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}etag']),
      lastModified: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_modified']),
      lastFetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_fetched_at']),
      lastCheckedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_checked_at']),
    );
  }

  @override
  $LessonFeedsTable createAlias(String alias) {
    return $LessonFeedsTable(attachedDatabase, alias);
  }
}

class LessonFeedRow extends DataClass implements Insertable<LessonFeedRow> {
  final String id;
  final String source;
  final String? cohort;
  final String? lessonClass;
  final String? checksum;
  final String? etag;
  final int? lastModified;
  final int? lastFetchedAt;
  final int? lastCheckedAt;
  const LessonFeedRow(
      {required this.id,
      required this.source,
      this.cohort,
      this.lessonClass,
      this.checksum,
      this.etag,
      this.lastModified,
      this.lastFetchedAt,
      this.lastCheckedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || cohort != null) {
      map['cohort'] = Variable<String>(cohort);
    }
    if (!nullToAbsent || lessonClass != null) {
      map['lesson_class'] = Variable<String>(lessonClass);
    }
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<int>(lastModified);
    }
    if (!nullToAbsent || lastFetchedAt != null) {
      map['last_fetched_at'] = Variable<int>(lastFetchedAt);
    }
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<int>(lastCheckedAt);
    }
    return map;
  }

  LessonFeedsCompanion toCompanion(bool nullToAbsent) {
    return LessonFeedsCompanion(
      id: Value(id),
      source: Value(source),
      cohort:
          cohort == null && nullToAbsent ? const Value.absent() : Value(cohort),
      lessonClass: lessonClass == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonClass),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      lastFetchedAt: lastFetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetchedAt),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
    );
  }

  factory LessonFeedRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonFeedRow(
      id: serializer.fromJson<String>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      cohort: serializer.fromJson<String?>(json['cohort']),
      lessonClass: serializer.fromJson<String?>(json['lessonClass']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<int?>(json['lastModified']),
      lastFetchedAt: serializer.fromJson<int?>(json['lastFetchedAt']),
      lastCheckedAt: serializer.fromJson<int?>(json['lastCheckedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<String>(source),
      'cohort': serializer.toJson<String?>(cohort),
      'lessonClass': serializer.toJson<String?>(lessonClass),
      'checksum': serializer.toJson<String?>(checksum),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<int?>(lastModified),
      'lastFetchedAt': serializer.toJson<int?>(lastFetchedAt),
      'lastCheckedAt': serializer.toJson<int?>(lastCheckedAt),
    };
  }

  LessonFeedRow copyWith(
          {String? id,
          String? source,
          Value<String?> cohort = const Value.absent(),
          Value<String?> lessonClass = const Value.absent(),
          Value<String?> checksum = const Value.absent(),
          Value<String?> etag = const Value.absent(),
          Value<int?> lastModified = const Value.absent(),
          Value<int?> lastFetchedAt = const Value.absent(),
          Value<int?> lastCheckedAt = const Value.absent()}) =>
      LessonFeedRow(
        id: id ?? this.id,
        source: source ?? this.source,
        cohort: cohort.present ? cohort.value : this.cohort,
        lessonClass: lessonClass.present ? lessonClass.value : this.lessonClass,
        checksum: checksum.present ? checksum.value : this.checksum,
        etag: etag.present ? etag.value : this.etag,
        lastModified:
            lastModified.present ? lastModified.value : this.lastModified,
        lastFetchedAt:
            lastFetchedAt.present ? lastFetchedAt.value : this.lastFetchedAt,
        lastCheckedAt:
            lastCheckedAt.present ? lastCheckedAt.value : this.lastCheckedAt,
      );
  LessonFeedRow copyWithCompanion(LessonFeedsCompanion data) {
    return LessonFeedRow(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      cohort: data.cohort.present ? data.cohort.value : this.cohort,
      lessonClass:
          data.lessonClass.present ? data.lessonClass.value : this.lessonClass,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonFeedRow(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('cohort: $cohort, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('checksum: $checksum, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastCheckedAt: $lastCheckedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, source, cohort, lessonClass, checksum,
      etag, lastModified, lastFetchedAt, lastCheckedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonFeedRow &&
          other.id == this.id &&
          other.source == this.source &&
          other.cohort == this.cohort &&
          other.lessonClass == this.lessonClass &&
          other.checksum == this.checksum &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.lastCheckedAt == this.lastCheckedAt);
}

class LessonFeedsCompanion extends UpdateCompanion<LessonFeedRow> {
  final Value<String> id;
  final Value<String> source;
  final Value<String?> cohort;
  final Value<String?> lessonClass;
  final Value<String?> checksum;
  final Value<String?> etag;
  final Value<int?> lastModified;
  final Value<int?> lastFetchedAt;
  final Value<int?> lastCheckedAt;
  final Value<int> rowid;
  const LessonFeedsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonFeedsCompanion.insert({
    required String id,
    required String source,
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        source = Value(source);
  static Insertable<LessonFeedRow> custom({
    Expression<String>? id,
    Expression<String>? source,
    Expression<String>? cohort,
    Expression<String>? lessonClass,
    Expression<String>? checksum,
    Expression<String>? etag,
    Expression<int>? lastModified,
    Expression<int>? lastFetchedAt,
    Expression<int>? lastCheckedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (cohort != null) 'cohort': cohort,
      if (lessonClass != null) 'lesson_class': lessonClass,
      if (checksum != null) 'checksum': checksum,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonFeedsCompanion copyWith(
      {Value<String>? id,
      Value<String>? source,
      Value<String?>? cohort,
      Value<String?>? lessonClass,
      Value<String?>? checksum,
      Value<String?>? etag,
      Value<int?>? lastModified,
      Value<int?>? lastFetchedAt,
      Value<int?>? lastCheckedAt,
      Value<int>? rowid}) {
    return LessonFeedsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      cohort: cohort ?? this.cohort,
      lessonClass: lessonClass ?? this.lessonClass,
      checksum: checksum ?? this.checksum,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (cohort.present) {
      map['cohort'] = Variable<String>(cohort.value);
    }
    if (lessonClass.present) {
      map['lesson_class'] = Variable<String>(lessonClass.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<int>(lastModified.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<int>(lastFetchedAt.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<int>(lastCheckedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonFeedsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('cohort: $cohort, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('checksum: $checksum, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonSourcesTable extends LessonSources
    with TableInfo<$LessonSourcesTable, LessonSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cohortMeta = const VerificationMeta('cohort');
  @override
  late final GeneratedColumn<String> cohort = GeneratedColumn<String>(
      'cohort', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lessonClassMeta =
      const VerificationMeta('lessonClass');
  @override
  late final GeneratedColumn<String> lessonClass = GeneratedColumn<String>(
      'lesson_class', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isBundledMeta =
      const VerificationMeta('isBundled');
  @override
  late final GeneratedColumn<bool> isBundled = GeneratedColumn<bool>(
      'is_bundled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bundled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
      'etag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<int> lastModified = GeneratedColumn<int>(
      'last_modified', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastAttemptedAtMeta =
      const VerificationMeta('lastAttemptedAt');
  @override
  late final GeneratedColumn<int> lastAttemptedAt = GeneratedColumn<int>(
      'last_attempted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCheckedAtMeta =
      const VerificationMeta('lastCheckedAt');
  @override
  late final GeneratedColumn<int> lastCheckedAt = GeneratedColumn<int>(
      'last_checked_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lessonCountMeta =
      const VerificationMeta('lessonCount');
  @override
  late final GeneratedColumn<int> lessonCount = GeneratedColumn<int>(
      'lesson_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attachmentBytesMeta =
      const VerificationMeta('attachmentBytes');
  @override
  late final GeneratedColumn<int> attachmentBytes = GeneratedColumn<int>(
      'attachment_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quotaBytesMeta =
      const VerificationMeta('quotaBytes');
  @override
  late final GeneratedColumn<int> quotaBytes = GeneratedColumn<int>(
      'quota_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        location,
        label,
        cohort,
        lessonClass,
        enabled,
        isBundled,
        priority,
        checksum,
        etag,
        lastModified,
        lastSyncedAt,
        lastAttemptedAt,
        lastCheckedAt,
        lastError,
        lessonCount,
        attachmentBytes,
        quotaBytes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_sources';
  @override
  VerificationContext validateIntegrity(Insertable<LessonSourceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('cohort')) {
      context.handle(_cohortMeta,
          cohort.isAcceptableOrUnknown(data['cohort']!, _cohortMeta));
    }
    if (data.containsKey('lesson_class')) {
      context.handle(
          _lessonClassMeta,
          lessonClass.isAcceptableOrUnknown(
              data['lesson_class']!, _lessonClassMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('is_bundled')) {
      context.handle(_isBundledMeta,
          isBundled.isAcceptableOrUnknown(data['is_bundled']!, _isBundledMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    }
    if (data.containsKey('etag')) {
      context.handle(
          _etagMeta, etag.isAcceptableOrUnknown(data['etag']!, _etagMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('last_attempted_at')) {
      context.handle(
          _lastAttemptedAtMeta,
          lastAttemptedAt.isAcceptableOrUnknown(
              data['last_attempted_at']!, _lastAttemptedAtMeta));
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
          _lastCheckedAtMeta,
          lastCheckedAt.isAcceptableOrUnknown(
              data['last_checked_at']!, _lastCheckedAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('lesson_count')) {
      context.handle(
          _lessonCountMeta,
          lessonCount.isAcceptableOrUnknown(
              data['lesson_count']!, _lessonCountMeta));
    }
    if (data.containsKey('attachment_bytes')) {
      context.handle(
          _attachmentBytesMeta,
          attachmentBytes.isAcceptableOrUnknown(
              data['attachment_bytes']!, _attachmentBytesMeta));
    }
    if (data.containsKey('quota_bytes')) {
      context.handle(
          _quotaBytesMeta,
          quotaBytes.isAcceptableOrUnknown(
              data['quota_bytes']!, _quotaBytesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonSourceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      cohort: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cohort']),
      lessonClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_class']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      isBundled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bundled'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum']),
      etag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}etag']),
      lastModified: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_modified']),
      lastSyncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_synced_at']),
      lastAttemptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_attempted_at']),
      lastCheckedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_checked_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      lessonCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson_count'])!,
      attachmentBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attachment_bytes'])!,
      quotaBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quota_bytes']),
    );
  }

  @override
  $LessonSourcesTable createAlias(String alias) {
    return $LessonSourcesTable(attachedDatabase, alias);
  }
}

class LessonSourceRow extends DataClass implements Insertable<LessonSourceRow> {
  final String id;
  final String type;
  final String location;
  final String? label;
  final String? cohort;
  final String? lessonClass;
  final bool enabled;
  final bool isBundled;
  final int priority;
  final String? checksum;
  final String? etag;
  final int? lastModified;
  final int? lastSyncedAt;
  final int? lastAttemptedAt;
  final int? lastCheckedAt;
  final String? lastError;
  final int lessonCount;
  final int attachmentBytes;
  final int? quotaBytes;
  const LessonSourceRow(
      {required this.id,
      required this.type,
      required this.location,
      this.label,
      this.cohort,
      this.lessonClass,
      required this.enabled,
      required this.isBundled,
      required this.priority,
      this.checksum,
      this.etag,
      this.lastModified,
      this.lastSyncedAt,
      this.lastAttemptedAt,
      this.lastCheckedAt,
      this.lastError,
      required this.lessonCount,
      required this.attachmentBytes,
      this.quotaBytes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['location'] = Variable<String>(location);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || cohort != null) {
      map['cohort'] = Variable<String>(cohort);
    }
    if (!nullToAbsent || lessonClass != null) {
      map['lesson_class'] = Variable<String>(lessonClass);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['is_bundled'] = Variable<bool>(isBundled);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<int>(lastModified);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    if (!nullToAbsent || lastAttemptedAt != null) {
      map['last_attempted_at'] = Variable<int>(lastAttemptedAt);
    }
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<int>(lastCheckedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['lesson_count'] = Variable<int>(lessonCount);
    map['attachment_bytes'] = Variable<int>(attachmentBytes);
    if (!nullToAbsent || quotaBytes != null) {
      map['quota_bytes'] = Variable<int>(quotaBytes);
    }
    return map;
  }

  LessonSourcesCompanion toCompanion(bool nullToAbsent) {
    return LessonSourcesCompanion(
      id: Value(id),
      type: Value(type),
      location: Value(location),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      cohort:
          cohort == null && nullToAbsent ? const Value.absent() : Value(cohort),
      lessonClass: lessonClass == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonClass),
      enabled: Value(enabled),
      isBundled: Value(isBundled),
      priority: Value(priority),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastAttemptedAt: lastAttemptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptedAt),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lessonCount: Value(lessonCount),
      attachmentBytes: Value(attachmentBytes),
      quotaBytes: quotaBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(quotaBytes),
    );
  }

  factory LessonSourceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonSourceRow(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      location: serializer.fromJson<String>(json['location']),
      label: serializer.fromJson<String?>(json['label']),
      cohort: serializer.fromJson<String?>(json['cohort']),
      lessonClass: serializer.fromJson<String?>(json['lessonClass']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      isBundled: serializer.fromJson<bool>(json['isBundled']),
      priority: serializer.fromJson<int>(json['priority']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<int?>(json['lastModified']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      lastAttemptedAt: serializer.fromJson<int?>(json['lastAttemptedAt']),
      lastCheckedAt: serializer.fromJson<int?>(json['lastCheckedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lessonCount: serializer.fromJson<int>(json['lessonCount']),
      attachmentBytes: serializer.fromJson<int>(json['attachmentBytes']),
      quotaBytes: serializer.fromJson<int?>(json['quotaBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'location': serializer.toJson<String>(location),
      'label': serializer.toJson<String?>(label),
      'cohort': serializer.toJson<String?>(cohort),
      'lessonClass': serializer.toJson<String?>(lessonClass),
      'enabled': serializer.toJson<bool>(enabled),
      'isBundled': serializer.toJson<bool>(isBundled),
      'priority': serializer.toJson<int>(priority),
      'checksum': serializer.toJson<String?>(checksum),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<int?>(lastModified),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'lastAttemptedAt': serializer.toJson<int?>(lastAttemptedAt),
      'lastCheckedAt': serializer.toJson<int?>(lastCheckedAt),
      'lastError': serializer.toJson<String?>(lastError),
      'lessonCount': serializer.toJson<int>(lessonCount),
      'attachmentBytes': serializer.toJson<int>(attachmentBytes),
      'quotaBytes': serializer.toJson<int?>(quotaBytes),
    };
  }

  LessonSourceRow copyWith(
          {String? id,
          String? type,
          String? location,
          Value<String?> label = const Value.absent(),
          Value<String?> cohort = const Value.absent(),
          Value<String?> lessonClass = const Value.absent(),
          bool? enabled,
          bool? isBundled,
          int? priority,
          Value<String?> checksum = const Value.absent(),
          Value<String?> etag = const Value.absent(),
          Value<int?> lastModified = const Value.absent(),
          Value<int?> lastSyncedAt = const Value.absent(),
          Value<int?> lastAttemptedAt = const Value.absent(),
          Value<int?> lastCheckedAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          int? lessonCount,
          int? attachmentBytes,
          Value<int?> quotaBytes = const Value.absent()}) =>
      LessonSourceRow(
        id: id ?? this.id,
        type: type ?? this.type,
        location: location ?? this.location,
        label: label.present ? label.value : this.label,
        cohort: cohort.present ? cohort.value : this.cohort,
        lessonClass: lessonClass.present ? lessonClass.value : this.lessonClass,
        enabled: enabled ?? this.enabled,
        isBundled: isBundled ?? this.isBundled,
        priority: priority ?? this.priority,
        checksum: checksum.present ? checksum.value : this.checksum,
        etag: etag.present ? etag.value : this.etag,
        lastModified:
            lastModified.present ? lastModified.value : this.lastModified,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        lastAttemptedAt: lastAttemptedAt.present
            ? lastAttemptedAt.value
            : this.lastAttemptedAt,
        lastCheckedAt:
            lastCheckedAt.present ? lastCheckedAt.value : this.lastCheckedAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        lessonCount: lessonCount ?? this.lessonCount,
        attachmentBytes: attachmentBytes ?? this.attachmentBytes,
        quotaBytes: quotaBytes.present ? quotaBytes.value : this.quotaBytes,
      );
  LessonSourceRow copyWithCompanion(LessonSourcesCompanion data) {
    return LessonSourceRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      location: data.location.present ? data.location.value : this.location,
      label: data.label.present ? data.label.value : this.label,
      cohort: data.cohort.present ? data.cohort.value : this.cohort,
      lessonClass:
          data.lessonClass.present ? data.lessonClass.value : this.lessonClass,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      isBundled: data.isBundled.present ? data.isBundled.value : this.isBundled,
      priority: data.priority.present ? data.priority.value : this.priority,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastAttemptedAt: data.lastAttemptedAt.present
          ? data.lastAttemptedAt.value
          : this.lastAttemptedAt,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lessonCount:
          data.lessonCount.present ? data.lessonCount.value : this.lessonCount,
      attachmentBytes: data.attachmentBytes.present
          ? data.attachmentBytes.value
          : this.attachmentBytes,
      quotaBytes:
          data.quotaBytes.present ? data.quotaBytes.value : this.quotaBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonSourceRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('label: $label, ')
          ..write('cohort: $cohort, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('enabled: $enabled, ')
          ..write('isBundled: $isBundled, ')
          ..write('priority: $priority, ')
          ..write('checksum: $checksum, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('lastError: $lastError, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('attachmentBytes: $attachmentBytes, ')
          ..write('quotaBytes: $quotaBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      type,
      location,
      label,
      cohort,
      lessonClass,
      enabled,
      isBundled,
      priority,
      checksum,
      etag,
      lastModified,
      lastSyncedAt,
      lastAttemptedAt,
      lastCheckedAt,
      lastError,
      lessonCount,
      attachmentBytes,
      quotaBytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonSourceRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.location == this.location &&
          other.label == this.label &&
          other.cohort == this.cohort &&
          other.lessonClass == this.lessonClass &&
          other.enabled == this.enabled &&
          other.isBundled == this.isBundled &&
          other.priority == this.priority &&
          other.checksum == this.checksum &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastAttemptedAt == this.lastAttemptedAt &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.lastError == this.lastError &&
          other.lessonCount == this.lessonCount &&
          other.attachmentBytes == this.attachmentBytes &&
          other.quotaBytes == this.quotaBytes);
}

class LessonSourcesCompanion extends UpdateCompanion<LessonSourceRow> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> location;
  final Value<String?> label;
  final Value<String?> cohort;
  final Value<String?> lessonClass;
  final Value<bool> enabled;
  final Value<bool> isBundled;
  final Value<int> priority;
  final Value<String?> checksum;
  final Value<String?> etag;
  final Value<int?> lastModified;
  final Value<int?> lastSyncedAt;
  final Value<int?> lastAttemptedAt;
  final Value<int?> lastCheckedAt;
  final Value<String?> lastError;
  final Value<int> lessonCount;
  final Value<int> attachmentBytes;
  final Value<int?> quotaBytes;
  final Value<int> rowid;
  const LessonSourcesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.label = const Value.absent(),
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.priority = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.attachmentBytes = const Value.absent(),
    this.quotaBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonSourcesCompanion.insert({
    required String id,
    required String type,
    required String location,
    this.label = const Value.absent(),
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.priority = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.attachmentBytes = const Value.absent(),
    this.quotaBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        location = Value(location);
  static Insertable<LessonSourceRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? location,
    Expression<String>? label,
    Expression<String>? cohort,
    Expression<String>? lessonClass,
    Expression<bool>? enabled,
    Expression<bool>? isBundled,
    Expression<int>? priority,
    Expression<String>? checksum,
    Expression<String>? etag,
    Expression<int>? lastModified,
    Expression<int>? lastSyncedAt,
    Expression<int>? lastAttemptedAt,
    Expression<int>? lastCheckedAt,
    Expression<String>? lastError,
    Expression<int>? lessonCount,
    Expression<int>? attachmentBytes,
    Expression<int>? quotaBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (location != null) 'location': location,
      if (label != null) 'label': label,
      if (cohort != null) 'cohort': cohort,
      if (lessonClass != null) 'lesson_class': lessonClass,
      if (enabled != null) 'enabled': enabled,
      if (isBundled != null) 'is_bundled': isBundled,
      if (priority != null) 'priority': priority,
      if (checksum != null) 'checksum': checksum,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastAttemptedAt != null) 'last_attempted_at': lastAttemptedAt,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (lastError != null) 'last_error': lastError,
      if (lessonCount != null) 'lesson_count': lessonCount,
      if (attachmentBytes != null) 'attachment_bytes': attachmentBytes,
      if (quotaBytes != null) 'quota_bytes': quotaBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonSourcesCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? location,
      Value<String?>? label,
      Value<String?>? cohort,
      Value<String?>? lessonClass,
      Value<bool>? enabled,
      Value<bool>? isBundled,
      Value<int>? priority,
      Value<String?>? checksum,
      Value<String?>? etag,
      Value<int?>? lastModified,
      Value<int?>? lastSyncedAt,
      Value<int?>? lastAttemptedAt,
      Value<int?>? lastCheckedAt,
      Value<String?>? lastError,
      Value<int>? lessonCount,
      Value<int>? attachmentBytes,
      Value<int?>? quotaBytes,
      Value<int>? rowid}) {
    return LessonSourcesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      location: location ?? this.location,
      label: label ?? this.label,
      cohort: cohort ?? this.cohort,
      lessonClass: lessonClass ?? this.lessonClass,
      enabled: enabled ?? this.enabled,
      isBundled: isBundled ?? this.isBundled,
      priority: priority ?? this.priority,
      checksum: checksum ?? this.checksum,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      lastError: lastError ?? this.lastError,
      lessonCount: lessonCount ?? this.lessonCount,
      attachmentBytes: attachmentBytes ?? this.attachmentBytes,
      quotaBytes: quotaBytes ?? this.quotaBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (cohort.present) {
      map['cohort'] = Variable<String>(cohort.value);
    }
    if (lessonClass.present) {
      map['lesson_class'] = Variable<String>(lessonClass.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (isBundled.present) {
      map['is_bundled'] = Variable<bool>(isBundled.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<int>(lastModified.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (lastAttemptedAt.present) {
      map['last_attempted_at'] = Variable<int>(lastAttemptedAt.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<int>(lastCheckedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lessonCount.present) {
      map['lesson_count'] = Variable<int>(lessonCount.value);
    }
    if (attachmentBytes.present) {
      map['attachment_bytes'] = Variable<int>(attachmentBytes.value);
    }
    if (quotaBytes.present) {
      map['quota_bytes'] = Variable<int>(quotaBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonSourcesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('label: $label, ')
          ..write('cohort: $cohort, ')
          ..write('lessonClass: $lessonClass, ')
          ..write('enabled: $enabled, ')
          ..write('isBundled: $isBundled, ')
          ..write('priority: $priority, ')
          ..write('checksum: $checksum, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('lastError: $lastError, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('attachmentBytes: $attachmentBytes, ')
          ..write('quotaBytes: $quotaBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoundtableEventsTable extends RoundtableEvents
    with TableInfo<$RoundtableEventsTable, RoundtableRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundtableEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conferencingUrlMeta =
      const VerificationMeta('conferencingUrl');
  @override
  late final GeneratedColumn<String> conferencingUrl = GeneratedColumn<String>(
      'conferencing_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hostConferencingUrlMeta =
      const VerificationMeta('hostConferencingUrl');
  @override
  late final GeneratedColumn<String> hostConferencingUrl =
      GeneratedColumn<String>('host_conferencing_url', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meetingRoomMeta =
      const VerificationMeta('meetingRoom');
  @override
  late final GeneratedColumn<String> meetingRoom = GeneratedColumn<String>(
      'meeting_room', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderMinutesBeforeMeta =
      const VerificationMeta('reminderMinutesBefore');
  @override
  late final GeneratedColumn<int> reminderMinutesBefore = GeneratedColumn<int>(
      'reminder_minutes_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recordingStoragePathMeta =
      const VerificationMeta('recordingStoragePath');
  @override
  late final GeneratedColumn<String> recordingStoragePath =
      GeneratedColumn<String>('recording_storage_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordingUrlMeta =
      const VerificationMeta('recordingUrl');
  @override
  late final GeneratedColumn<String> recordingUrl = GeneratedColumn<String>(
      'recording_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordingIndexedAtMeta =
      const VerificationMeta('recordingIndexedAt');
  @override
  late final GeneratedColumn<int> recordingIndexedAt = GeneratedColumn<int>(
      'recording_indexed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        classId,
        startTime,
        endTime,
        conferencingUrl,
        hostConferencingUrl,
        meetingRoom,
        reminderMinutesBefore,
        createdBy,
        updatedAt,
        recordingStoragePath,
        recordingUrl,
        recordingIndexedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roundtable_events';
  @override
  VerificationContext validateIntegrity(Insertable<RoundtableRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('conferencing_url')) {
      context.handle(
          _conferencingUrlMeta,
          conferencingUrl.isAcceptableOrUnknown(
              data['conferencing_url']!, _conferencingUrlMeta));
    }
    if (data.containsKey('host_conferencing_url')) {
      context.handle(
          _hostConferencingUrlMeta,
          hostConferencingUrl.isAcceptableOrUnknown(
              data['host_conferencing_url']!, _hostConferencingUrlMeta));
    }
    if (data.containsKey('meeting_room')) {
      context.handle(
          _meetingRoomMeta,
          meetingRoom.isAcceptableOrUnknown(
              data['meeting_room']!, _meetingRoomMeta));
    }
    if (data.containsKey('reminder_minutes_before')) {
      context.handle(
          _reminderMinutesBeforeMeta,
          reminderMinutesBefore.isAcceptableOrUnknown(
              data['reminder_minutes_before']!, _reminderMinutesBeforeMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('recording_storage_path')) {
      context.handle(
          _recordingStoragePathMeta,
          recordingStoragePath.isAcceptableOrUnknown(
              data['recording_storage_path']!, _recordingStoragePathMeta));
    }
    if (data.containsKey('recording_url')) {
      context.handle(
          _recordingUrlMeta,
          recordingUrl.isAcceptableOrUnknown(
              data['recording_url']!, _recordingUrlMeta));
    }
    if (data.containsKey('recording_indexed_at')) {
      context.handle(
          _recordingIndexedAtMeta,
          recordingIndexedAt.isAcceptableOrUnknown(
              data['recording_indexed_at']!, _recordingIndexedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoundtableRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoundtableRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      conferencingUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conferencing_url']),
      hostConferencingUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}host_conferencing_url']),
      meetingRoom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meeting_room']),
      reminderMinutesBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_minutes_before'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      recordingStoragePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recording_storage_path']),
      recordingUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recording_url']),
      recordingIndexedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recording_indexed_at']),
    );
  }

  @override
  $RoundtableEventsTable createAlias(String alias) {
    return $RoundtableEventsTable(attachedDatabase, alias);
  }
}

class RoundtableRow extends DataClass implements Insertable<RoundtableRow> {
  final String id;
  final String title;
  final String? description;
  final String? classId;
  final int startTime;
  final int endTime;
  final String? conferencingUrl;
  final String? hostConferencingUrl;
  final String? meetingRoom;
  final int reminderMinutesBefore;
  final String createdBy;
  final int updatedAt;
  final String? recordingStoragePath;
  final String? recordingUrl;
  final int? recordingIndexedAt;
  const RoundtableRow(
      {required this.id,
      required this.title,
      this.description,
      this.classId,
      required this.startTime,
      required this.endTime,
      this.conferencingUrl,
      this.hostConferencingUrl,
      this.meetingRoom,
      required this.reminderMinutesBefore,
      required this.createdBy,
      required this.updatedAt,
      this.recordingStoragePath,
      this.recordingUrl,
      this.recordingIndexedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || classId != null) {
      map['class_id'] = Variable<String>(classId);
    }
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    if (!nullToAbsent || conferencingUrl != null) {
      map['conferencing_url'] = Variable<String>(conferencingUrl);
    }
    if (!nullToAbsent || hostConferencingUrl != null) {
      map['host_conferencing_url'] = Variable<String>(hostConferencingUrl);
    }
    if (!nullToAbsent || meetingRoom != null) {
      map['meeting_room'] = Variable<String>(meetingRoom);
    }
    map['reminder_minutes_before'] = Variable<int>(reminderMinutesBefore);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || recordingStoragePath != null) {
      map['recording_storage_path'] = Variable<String>(recordingStoragePath);
    }
    if (!nullToAbsent || recordingUrl != null) {
      map['recording_url'] = Variable<String>(recordingUrl);
    }
    if (!nullToAbsent || recordingIndexedAt != null) {
      map['recording_indexed_at'] = Variable<int>(recordingIndexedAt);
    }
    return map;
  }

  RoundtableEventsCompanion toCompanion(bool nullToAbsent) {
    return RoundtableEventsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      classId: classId == null && nullToAbsent
          ? const Value.absent()
          : Value(classId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      conferencingUrl: conferencingUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(conferencingUrl),
      hostConferencingUrl: hostConferencingUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(hostConferencingUrl),
      meetingRoom: meetingRoom == null && nullToAbsent
          ? const Value.absent()
          : Value(meetingRoom),
      reminderMinutesBefore: Value(reminderMinutesBefore),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      recordingStoragePath: recordingStoragePath == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingStoragePath),
      recordingUrl: recordingUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingUrl),
      recordingIndexedAt: recordingIndexedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingIndexedAt),
    );
  }

  factory RoundtableRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoundtableRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      classId: serializer.fromJson<String?>(json['classId']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      conferencingUrl: serializer.fromJson<String?>(json['conferencingUrl']),
      hostConferencingUrl:
          serializer.fromJson<String?>(json['hostConferencingUrl']),
      meetingRoom: serializer.fromJson<String?>(json['meetingRoom']),
      reminderMinutesBefore:
          serializer.fromJson<int>(json['reminderMinutesBefore']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      recordingStoragePath:
          serializer.fromJson<String?>(json['recordingStoragePath']),
      recordingUrl: serializer.fromJson<String?>(json['recordingUrl']),
      recordingIndexedAt: serializer.fromJson<int?>(json['recordingIndexedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'classId': serializer.toJson<String?>(classId),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'conferencingUrl': serializer.toJson<String?>(conferencingUrl),
      'hostConferencingUrl': serializer.toJson<String?>(hostConferencingUrl),
      'meetingRoom': serializer.toJson<String?>(meetingRoom),
      'reminderMinutesBefore': serializer.toJson<int>(reminderMinutesBefore),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'recordingStoragePath': serializer.toJson<String?>(recordingStoragePath),
      'recordingUrl': serializer.toJson<String?>(recordingUrl),
      'recordingIndexedAt': serializer.toJson<int?>(recordingIndexedAt),
    };
  }

  RoundtableRow copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> classId = const Value.absent(),
          int? startTime,
          int? endTime,
          Value<String?> conferencingUrl = const Value.absent(),
          Value<String?> hostConferencingUrl = const Value.absent(),
          Value<String?> meetingRoom = const Value.absent(),
          int? reminderMinutesBefore,
          String? createdBy,
          int? updatedAt,
          Value<String?> recordingStoragePath = const Value.absent(),
          Value<String?> recordingUrl = const Value.absent(),
          Value<int?> recordingIndexedAt = const Value.absent()}) =>
      RoundtableRow(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        classId: classId.present ? classId.value : this.classId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        conferencingUrl: conferencingUrl.present
            ? conferencingUrl.value
            : this.conferencingUrl,
        hostConferencingUrl: hostConferencingUrl.present
            ? hostConferencingUrl.value
            : this.hostConferencingUrl,
        meetingRoom: meetingRoom.present ? meetingRoom.value : this.meetingRoom,
        reminderMinutesBefore:
            reminderMinutesBefore ?? this.reminderMinutesBefore,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        recordingStoragePath: recordingStoragePath.present
            ? recordingStoragePath.value
            : this.recordingStoragePath,
        recordingUrl:
            recordingUrl.present ? recordingUrl.value : this.recordingUrl,
        recordingIndexedAt: recordingIndexedAt.present
            ? recordingIndexedAt.value
            : this.recordingIndexedAt,
      );
  RoundtableRow copyWithCompanion(RoundtableEventsCompanion data) {
    return RoundtableRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      classId: data.classId.present ? data.classId.value : this.classId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      conferencingUrl: data.conferencingUrl.present
          ? data.conferencingUrl.value
          : this.conferencingUrl,
      hostConferencingUrl: data.hostConferencingUrl.present
          ? data.hostConferencingUrl.value
          : this.hostConferencingUrl,
      meetingRoom:
          data.meetingRoom.present ? data.meetingRoom.value : this.meetingRoom,
      reminderMinutesBefore: data.reminderMinutesBefore.present
          ? data.reminderMinutesBefore.value
          : this.reminderMinutesBefore,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      recordingStoragePath: data.recordingStoragePath.present
          ? data.recordingStoragePath.value
          : this.recordingStoragePath,
      recordingUrl: data.recordingUrl.present
          ? data.recordingUrl.value
          : this.recordingUrl,
      recordingIndexedAt: data.recordingIndexedAt.present
          ? data.recordingIndexedAt.value
          : this.recordingIndexedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoundtableRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('classId: $classId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('conferencingUrl: $conferencingUrl, ')
          ..write('hostConferencingUrl: $hostConferencingUrl, ')
          ..write('meetingRoom: $meetingRoom, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordingStoragePath: $recordingStoragePath, ')
          ..write('recordingUrl: $recordingUrl, ')
          ..write('recordingIndexedAt: $recordingIndexedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      classId,
      startTime,
      endTime,
      conferencingUrl,
      hostConferencingUrl,
      meetingRoom,
      reminderMinutesBefore,
      createdBy,
      updatedAt,
      recordingStoragePath,
      recordingUrl,
      recordingIndexedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundtableRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.classId == this.classId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.conferencingUrl == this.conferencingUrl &&
          other.hostConferencingUrl == this.hostConferencingUrl &&
          other.meetingRoom == this.meetingRoom &&
          other.reminderMinutesBefore == this.reminderMinutesBefore &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.recordingStoragePath == this.recordingStoragePath &&
          other.recordingUrl == this.recordingUrl &&
          other.recordingIndexedAt == this.recordingIndexedAt);
}

class RoundtableEventsCompanion extends UpdateCompanion<RoundtableRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> classId;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String?> conferencingUrl;
  final Value<String?> hostConferencingUrl;
  final Value<String?> meetingRoom;
  final Value<int> reminderMinutesBefore;
  final Value<String> createdBy;
  final Value<int> updatedAt;
  final Value<String?> recordingStoragePath;
  final Value<String?> recordingUrl;
  final Value<int?> recordingIndexedAt;
  final Value<int> rowid;
  const RoundtableEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.classId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.conferencingUrl = const Value.absent(),
    this.hostConferencingUrl = const Value.absent(),
    this.meetingRoom = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoundtableEventsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.classId = const Value.absent(),
    required int startTime,
    required int endTime,
    this.conferencingUrl = const Value.absent(),
    this.hostConferencingUrl = const Value.absent(),
    this.meetingRoom = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    required String createdBy,
    required int updatedAt,
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        startTime = Value(startTime),
        endTime = Value(endTime),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt);
  static Insertable<RoundtableRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? classId,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? conferencingUrl,
    Expression<String>? hostConferencingUrl,
    Expression<String>? meetingRoom,
    Expression<int>? reminderMinutesBefore,
    Expression<String>? createdBy,
    Expression<int>? updatedAt,
    Expression<String>? recordingStoragePath,
    Expression<String>? recordingUrl,
    Expression<int>? recordingIndexedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (classId != null) 'class_id': classId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (conferencingUrl != null) 'conferencing_url': conferencingUrl,
      if (hostConferencingUrl != null)
        'host_conferencing_url': hostConferencingUrl,
      if (meetingRoom != null) 'meeting_room': meetingRoom,
      if (reminderMinutesBefore != null)
        'reminder_minutes_before': reminderMinutesBefore,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (recordingStoragePath != null)
        'recording_storage_path': recordingStoragePath,
      if (recordingUrl != null) 'recording_url': recordingUrl,
      if (recordingIndexedAt != null)
        'recording_indexed_at': recordingIndexedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoundtableEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? classId,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<String?>? conferencingUrl,
      Value<String?>? hostConferencingUrl,
      Value<String?>? meetingRoom,
      Value<int>? reminderMinutesBefore,
      Value<String>? createdBy,
      Value<int>? updatedAt,
      Value<String?>? recordingStoragePath,
      Value<String?>? recordingUrl,
      Value<int?>? recordingIndexedAt,
      Value<int>? rowid}) {
    return RoundtableEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      classId: classId ?? this.classId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      conferencingUrl: conferencingUrl ?? this.conferencingUrl,
      hostConferencingUrl: hostConferencingUrl ?? this.hostConferencingUrl,
      meetingRoom: meetingRoom ?? this.meetingRoom,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      recordingStoragePath: recordingStoragePath ?? this.recordingStoragePath,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      recordingIndexedAt: recordingIndexedAt ?? this.recordingIndexedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (conferencingUrl.present) {
      map['conferencing_url'] = Variable<String>(conferencingUrl.value);
    }
    if (hostConferencingUrl.present) {
      map['host_conferencing_url'] =
          Variable<String>(hostConferencingUrl.value);
    }
    if (meetingRoom.present) {
      map['meeting_room'] = Variable<String>(meetingRoom.value);
    }
    if (reminderMinutesBefore.present) {
      map['reminder_minutes_before'] =
          Variable<int>(reminderMinutesBefore.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (recordingStoragePath.present) {
      map['recording_storage_path'] =
          Variable<String>(recordingStoragePath.value);
    }
    if (recordingUrl.present) {
      map['recording_url'] = Variable<String>(recordingUrl.value);
    }
    if (recordingIndexedAt.present) {
      map['recording_indexed_at'] = Variable<int>(recordingIndexedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundtableEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('classId: $classId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('conferencingUrl: $conferencingUrl, ')
          ..write('hostConferencingUrl: $hostConferencingUrl, ')
          ..write('meetingRoom: $meetingRoom, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordingStoragePath: $recordingStoragePath, ')
          ..write('recordingUrl: $recordingUrl, ')
          ..write('recordingIndexedAt: $recordingIndexedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeetingLinksTable extends MeetingLinks
    with TableInfo<$MeetingLinksTable, MeetingLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeetingLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextTypeMeta =
      const VerificationMeta('contextType');
  @override
  late final GeneratedColumn<String> contextType = GeneratedColumn<String>(
      'context_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextIdMeta =
      const VerificationMeta('contextId');
  @override
  late final GeneratedColumn<String> contextId = GeneratedColumn<String>(
      'context_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roomNameMeta =
      const VerificationMeta('roomName');
  @override
  late final GeneratedColumn<String> roomName = GeneratedColumn<String>(
      'room_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scheduledStartMeta =
      const VerificationMeta('scheduledStart');
  @override
  late final GeneratedColumn<int> scheduledStart = GeneratedColumn<int>(
      'scheduled_start', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderAtMeta =
      const VerificationMeta('reminderAt');
  @override
  late final GeneratedColumn<int> reminderAt = GeneratedColumn<int>(
      'reminder_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderScheduledMeta =
      const VerificationMeta('reminderScheduled');
  @override
  late final GeneratedColumn<bool> reminderScheduled = GeneratedColumn<bool>(
      'reminder_scheduled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_scheduled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recordingStoragePathMeta =
      const VerificationMeta('recordingStoragePath');
  @override
  late final GeneratedColumn<String> recordingStoragePath =
      GeneratedColumn<String>('recording_storage_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordingUrlMeta =
      const VerificationMeta('recordingUrl');
  @override
  late final GeneratedColumn<String> recordingUrl = GeneratedColumn<String>(
      'recording_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordingIndexedAtMeta =
      const VerificationMeta('recordingIndexedAt');
  @override
  late final GeneratedColumn<int> recordingIndexedAt = GeneratedColumn<int>(
      'recording_indexed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        contextType,
        contextId,
        roomName,
        role,
        url,
        title,
        createdAt,
        scheduledStart,
        reminderAt,
        reminderScheduled,
        recordingStoragePath,
        recordingUrl,
        recordingIndexedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meeting_links';
  @override
  VerificationContext validateIntegrity(Insertable<MeetingLinkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('context_type')) {
      context.handle(
          _contextTypeMeta,
          contextType.isAcceptableOrUnknown(
              data['context_type']!, _contextTypeMeta));
    } else if (isInserting) {
      context.missing(_contextTypeMeta);
    }
    if (data.containsKey('context_id')) {
      context.handle(
          _contextIdMeta,
          contextId.isAcceptableOrUnknown(
              data['context_id']!, _contextIdMeta));
    } else if (isInserting) {
      context.missing(_contextIdMeta);
    }
    if (data.containsKey('room_name')) {
      context.handle(_roomNameMeta,
          roomName.isAcceptableOrUnknown(data['room_name']!, _roomNameMeta));
    } else if (isInserting) {
      context.missing(_roomNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta,
          title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
          _scheduledStartMeta,
          scheduledStart.isAcceptableOrUnknown(
              data['scheduled_start']!, _scheduledStartMeta));
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
          _reminderAtMeta,
          reminderAt.isAcceptableOrUnknown(
              data['reminder_at']!, _reminderAtMeta));
    }
    if (data.containsKey('reminder_scheduled')) {
      context.handle(
          _reminderScheduledMeta,
          reminderScheduled.isAcceptableOrUnknown(
              data['reminder_scheduled']!, _reminderScheduledMeta));
    }
    if (data.containsKey('recording_storage_path')) {
      context.handle(
          _recordingStoragePathMeta,
          recordingStoragePath.isAcceptableOrUnknown(
              data['recording_storage_path']!, _recordingStoragePathMeta));
    }
    if (data.containsKey('recording_url')) {
      context.handle(
          _recordingUrlMeta,
          recordingUrl.isAcceptableOrUnknown(
              data['recording_url']!, _recordingUrlMeta));
    }
    if (data.containsKey('recording_indexed_at')) {
      context.handle(
          _recordingIndexedAtMeta,
          recordingIndexedAt.isAcceptableOrUnknown(
              data['recording_indexed_at']!, _recordingIndexedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeetingLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeetingLinkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      contextType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}context_type'])!,
      contextId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context_id'])!,
      roomName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      scheduledStart: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}scheduled_start']),
      reminderAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_at']),
      reminderScheduled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}reminder_scheduled'])!,
      recordingStoragePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recording_storage_path']),
      recordingUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recording_url']),
      recordingIndexedAt: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}recording_indexed_at']),
    );
  }

  @override
  $MeetingLinksTable createAlias(String alias) {
    return $MeetingLinksTable(attachedDatabase, alias);
  }
}

class MeetingLinkRow extends DataClass implements Insertable<MeetingLinkRow> {
  final String id;
  final String contextType;
  final String contextId;
  final String roomName;
  final String role;
  final String url;
  final String title;
  final int createdAt;
  final int? scheduledStart;
  final int? reminderAt;
  final bool reminderScheduled;
  final String? recordingStoragePath;
  final String? recordingUrl;
  final int? recordingIndexedAt;
  const MeetingLinkRow({
    required this.id,
    required this.contextType,
    required this.contextId,
    required this.roomName,
    required this.role,
    required this.url,
    required this.title,
    required this.createdAt,
    this.scheduledStart,
    this.reminderAt,
    required this.reminderScheduled,
    this.recordingStoragePath,
    this.recordingUrl,
    this.recordingIndexedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['context_type'] = Variable<String>(contextType);
    map['context_id'] = Variable<String>(contextId);
    map['room_name'] = Variable<String>(roomName);
    map['role'] = Variable<String>(role);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || scheduledStart != null) {
      map['scheduled_start'] = Variable<int>(scheduledStart);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<int>(reminderAt);
    }
    map['reminder_scheduled'] = Variable<bool>(reminderScheduled);
    if (!nullToAbsent || recordingStoragePath != null) {
      map['recording_storage_path'] =
          Variable<String>(recordingStoragePath);
    }
    if (!nullToAbsent || recordingUrl != null) {
      map['recording_url'] = Variable<String>(recordingUrl);
    }
    if (!nullToAbsent || recordingIndexedAt != null) {
      map['recording_indexed_at'] = Variable<int>(recordingIndexedAt);
    }
    return map;
  }

  MeetingLinksCompanion toCompanion(bool nullToAbsent) {
    return MeetingLinksCompanion(
      id: Value(id),
      contextType: Value(contextType),
      contextId: Value(contextId),
      roomName: Value(roomName),
      role: Value(role),
      url: Value(url),
      title: Value(title),
      createdAt: Value(createdAt),
      scheduledStart: scheduledStart == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledStart),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      reminderScheduled: Value(reminderScheduled),
      recordingStoragePath: recordingStoragePath == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingStoragePath),
      recordingUrl: recordingUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingUrl),
      recordingIndexedAt: recordingIndexedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingIndexedAt),
    );
  }

  factory MeetingLinkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeetingLinkRow(
      id: serializer.fromJson<String>(json['id']),
      contextType: serializer.fromJson<String>(json['contextType']),
      contextId: serializer.fromJson<String>(json['contextId']),
      roomName: serializer.fromJson<String>(json['roomName']),
      role: serializer.fromJson<String>(json['role']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      scheduledStart: serializer.fromJson<int?>(json['scheduledStart']),
      reminderAt: serializer.fromJson<int?>(json['reminderAt']),
      reminderScheduled:
          serializer.fromJson<bool>(json['reminderScheduled']),
      recordingStoragePath:
          serializer.fromJson<String?>(json['recordingStoragePath']),
      recordingUrl: serializer.fromJson<String?>(json['recordingUrl']),
      recordingIndexedAt:
          serializer.fromJson<int?>(json['recordingIndexedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contextType': serializer.toJson<String>(contextType),
      'contextId': serializer.toJson<String>(contextId),
      'roomName': serializer.toJson<String>(roomName),
      'role': serializer.toJson<String>(role),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<int>(createdAt),
      'scheduledStart': serializer.toJson<int?>(scheduledStart),
      'reminderAt': serializer.toJson<int?>(reminderAt),
      'reminderScheduled':
          serializer.toJson<bool>(reminderScheduled),
      'recordingStoragePath':
          serializer.toJson<String?>(recordingStoragePath),
      'recordingUrl': serializer.toJson<String?>(recordingUrl),
      'recordingIndexedAt':
          serializer.toJson<int?>(recordingIndexedAt),
    };
  }

  MeetingLinkRow copyWith(
          {String? id,
          String? contextType,
          String? contextId,
          String? roomName,
          String? role,
          String? url,
          String? title,
          int? createdAt,
          Value<int?> scheduledStart = const Value.absent(),
          Value<int?> reminderAt = const Value.absent(),
          bool? reminderScheduled,
          Value<String?> recordingStoragePath = const Value.absent(),
          Value<String?> recordingUrl = const Value.absent(),
          Value<int?> recordingIndexedAt = const Value.absent()}) {
    return MeetingLinkRow(
      id: id ?? this.id,
      contextType: contextType ?? this.contextType,
      contextId: contextId ?? this.contextId,
      roomName: roomName ?? this.roomName,
      role: role ?? this.role,
      url: url ?? this.url,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      scheduledStart: scheduledStart.present
          ? scheduledStart.value
          : this.scheduledStart,
      reminderAt:
          reminderAt.present ? reminderAt.value : this.reminderAt,
      reminderScheduled: reminderScheduled ?? this.reminderScheduled,
      recordingStoragePath: recordingStoragePath.present
          ? recordingStoragePath.value
          : this.recordingStoragePath,
      recordingUrl:
          recordingUrl.present ? recordingUrl.value : this.recordingUrl,
      recordingIndexedAt: recordingIndexedAt.present
          ? recordingIndexedAt.value
          : this.recordingIndexedAt,
    );
  }

  MeetingLinkRow copyWithCompanion(MeetingLinksCompanion data) {
    return MeetingLinkRow(
      id: data.id.present ? data.id.value : this.id,
      contextType: data.contextType.present
          ? data.contextType.value
          : this.contextType,
      contextId:
          data.contextId.present ? data.contextId.value : this.contextId,
      roomName: data.roomName.present ? data.roomName.value : this.roomName,
      role: data.role.present ? data.role.value : this.role,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      createdAt:
          data.createdAt.present ? data.createdAt.value : this.createdAt,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      reminderScheduled: data.reminderScheduled.present
          ? data.reminderScheduled.value
          : this.reminderScheduled,
      recordingStoragePath: data.recordingStoragePath.present
          ? data.recordingStoragePath.value
          : this.recordingStoragePath,
      recordingUrl: data.recordingUrl.present
          ? data.recordingUrl.value
          : this.recordingUrl,
      recordingIndexedAt: data.recordingIndexedAt.present
          ? data.recordingIndexedAt.value
          : this.recordingIndexedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeetingLinkRow(')
          ..write('id: $id, ')
          ..write('contextType: $contextType, ')
          ..write('contextId: $contextId, ')
          ..write('roomName: $roomName, ')
          ..write('role: $role, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('reminderScheduled: $reminderScheduled, ')
          ..write('recordingStoragePath: $recordingStoragePath, ')
          ..write('recordingUrl: $recordingUrl, ')
          ..write('recordingIndexedAt: $recordingIndexedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      contextType,
      contextId,
      roomName,
      role,
      url,
      title,
      createdAt,
      scheduledStart,
      reminderAt,
      reminderScheduled,
      recordingStoragePath,
      recordingUrl,
      recordingIndexedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeetingLinkRow &&
          other.id == this.id &&
          other.contextType == this.contextType &&
          other.contextId == this.contextId &&
          other.roomName == this.roomName &&
          other.role == this.role &&
          other.url == this.url &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.scheduledStart == this.scheduledStart &&
          other.reminderAt == this.reminderAt &&
          other.reminderScheduled == this.reminderScheduled &&
          other.recordingStoragePath == this.recordingStoragePath &&
          other.recordingUrl == this.recordingUrl &&
          other.recordingIndexedAt == this.recordingIndexedAt);
}

class MeetingLinksCompanion extends UpdateCompanion<MeetingLinkRow> {
  final Value<String> id;
  final Value<String> contextType;
  final Value<String> contextId;
  final Value<String> roomName;
  final Value<String> role;
  final Value<String> url;
  final Value<String> title;
  final Value<int> createdAt;
  final Value<int?> scheduledStart;
  final Value<int?> reminderAt;
  final Value<bool> reminderScheduled;
  final Value<String?> recordingStoragePath;
  final Value<String?> recordingUrl;
  final Value<int?> recordingIndexedAt;
  final Value<int> rowid;
  const MeetingLinksCompanion({
    this.id = const Value.absent(),
    this.contextType = const Value.absent(),
    this.contextId = const Value.absent(),
    this.roomName = const Value.absent(),
    this.role = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.reminderScheduled = const Value.absent(),
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeetingLinksCompanion.insert({
    required String id,
    required String contextType,
    required String contextId,
    required String roomName,
    required String role,
    required String url,
    required String title,
    required int createdAt,
    this.scheduledStart = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.reminderScheduled = const Value.absent(),
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        contextType = Value(contextType),
        contextId = Value(contextId),
        roomName = Value(roomName),
        role = Value(role),
        url = Value(url),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<MeetingLinkRow> custom({
    Expression<String>? id,
    Expression<String>? contextType,
    Expression<String>? contextId,
    Expression<String>? roomName,
    Expression<String>? role,
    Expression<String>? url,
    Expression<String>? title,
    Expression<int>? createdAt,
    Expression<int>? scheduledStart,
    Expression<int>? reminderAt,
    Expression<bool>? reminderScheduled,
    Expression<String>? recordingStoragePath,
    Expression<String>? recordingUrl,
    Expression<int>? recordingIndexedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contextType != null) 'context_type': contextType,
      if (contextId != null) 'context_id': contextId,
      if (roomName != null) 'room_name': roomName,
      if (role != null) 'role': role,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (reminderScheduled != null)
        'reminder_scheduled': reminderScheduled,
      if (recordingStoragePath != null)
        'recording_storage_path': recordingStoragePath,
      if (recordingUrl != null) 'recording_url': recordingUrl,
      if (recordingIndexedAt != null)
        'recording_indexed_at': recordingIndexedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeetingLinksCompanion copyWith(
      {Value<String>? id,
      Value<String>? contextType,
      Value<String>? contextId,
      Value<String>? roomName,
      Value<String>? role,
      Value<String>? url,
      Value<String>? title,
      Value<int>? createdAt,
      Value<int?>? scheduledStart,
      Value<int?>? reminderAt,
      Value<bool>? reminderScheduled,
      Value<String?>? recordingStoragePath,
      Value<String?>? recordingUrl,
      Value<int?>? recordingIndexedAt,
      Value<int>? rowid}) {
    return MeetingLinksCompanion(
      id: id ?? this.id,
      contextType: contextType ?? this.contextType,
      contextId: contextId ?? this.contextId,
      roomName: roomName ?? this.roomName,
      role: role ?? this.role,
      url: url ?? this.url,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      reminderAt: reminderAt ?? this.reminderAt,
      reminderScheduled: reminderScheduled ?? this.reminderScheduled,
      recordingStoragePath:
          recordingStoragePath ?? this.recordingStoragePath,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      recordingIndexedAt:
          recordingIndexedAt ?? this.recordingIndexedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contextType.present) {
      map['context_type'] = Variable<String>(contextType.value);
    }
    if (contextId.present) {
      map['context_id'] = Variable<String>(contextId.value);
    }
    if (roomName.present) {
      map['room_name'] = Variable<String>(roomName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<int>(scheduledStart.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<int>(reminderAt.value);
    }
    if (reminderScheduled.present) {
      map['reminder_scheduled'] =
          Variable<bool>(reminderScheduled.value);
    }
    if (recordingStoragePath.present) {
      map['recording_storage_path'] =
          Variable<String>(recordingStoragePath.value);
    }
    if (recordingUrl.present) {
      map['recording_url'] = Variable<String>(recordingUrl.value);
    }
    if (recordingIndexedAt.present) {
      map['recording_indexed_at'] =
          Variable<int>(recordingIndexedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeetingLinksCompanion(')
          ..write('id: $id, ')
          ..write('contextType: $contextType, ')
          ..write('contextId: $contextId, ')
          ..write('roomName: $roomName, ')
          ..write('role: $role, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('reminderScheduled: $reminderScheduled, ')
          ..write('recordingStoragePath: $recordingStoragePath, ')
          ..write('recordingUrl: $recordingUrl, ')
          ..write('recordingIndexedAt: $recordingIndexedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscussionThreadsTable extends DiscussionThreads
    with TableInfo<$DiscussionThreadsTable, DiscussionThreadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscussionThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, classId, title, createdBy, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discussion_threads';
  @override
  VerificationContext validateIntegrity(
      Insertable<DiscussionThreadRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscussionThreadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscussionThreadRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DiscussionThreadsTable createAlias(String alias) {
    return $DiscussionThreadsTable(attachedDatabase, alias);
  }
}

class DiscussionThreadRow extends DataClass
    implements Insertable<DiscussionThreadRow> {
  final String id;
  final String classId;
  final String title;
  final String createdBy;
  final String status;
  final int createdAt;
  final int updatedAt;
  const DiscussionThreadRow(
      {required this.id,
      required this.classId,
      required this.title,
      required this.createdBy,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['class_id'] = Variable<String>(classId);
    map['title'] = Variable<String>(title);
    map['created_by'] = Variable<String>(createdBy);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DiscussionThreadsCompanion toCompanion(bool nullToAbsent) {
    return DiscussionThreadsCompanion(
      id: Value(id),
      classId: Value(classId),
      title: Value(title),
      createdBy: Value(createdBy),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiscussionThreadRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscussionThreadRow(
      id: serializer.fromJson<String>(json['id']),
      classId: serializer.fromJson<String>(json['classId']),
      title: serializer.fromJson<String>(json['title']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'classId': serializer.toJson<String>(classId),
      'title': serializer.toJson<String>(title),
      'createdBy': serializer.toJson<String>(createdBy),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DiscussionThreadRow copyWith(
          {String? id,
          String? classId,
          String? title,
          String? createdBy,
          String? status,
          int? createdAt,
          int? updatedAt}) =>
      DiscussionThreadRow(
        id: id ?? this.id,
        classId: classId ?? this.classId,
        title: title ?? this.title,
        createdBy: createdBy ?? this.createdBy,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DiscussionThreadRow copyWithCompanion(DiscussionThreadsCompanion data) {
    return DiscussionThreadRow(
      id: data.id.present ? data.id.value : this.id,
      classId: data.classId.present ? data.classId.value : this.classId,
      title: data.title.present ? data.title.value : this.title,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionThreadRow(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('title: $title, ')
          ..write('createdBy: $createdBy, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, classId, title, createdBy, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscussionThreadRow &&
          other.id == this.id &&
          other.classId == this.classId &&
          other.title == this.title &&
          other.createdBy == this.createdBy &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiscussionThreadsCompanion extends UpdateCompanion<DiscussionThreadRow> {
  final Value<String> id;
  final Value<String> classId;
  final Value<String> title;
  final Value<String> createdBy;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DiscussionThreadsCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscussionThreadsCompanion.insert({
    required String id,
    required String classId,
    required String title,
    required String createdBy,
    this.status = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        classId = Value(classId),
        title = Value(title),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DiscussionThreadRow> custom({
    Expression<String>? id,
    Expression<String>? classId,
    Expression<String>? title,
    Expression<String>? createdBy,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classId != null) 'class_id': classId,
      if (title != null) 'title': title,
      if (createdBy != null) 'created_by': createdBy,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscussionThreadsCompanion copyWith(
      {Value<String>? id,
      Value<String>? classId,
      Value<String>? title,
      Value<String>? createdBy,
      Value<String>? status,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return DiscussionThreadsCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionThreadsCompanion(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('title: $title, ')
          ..write('createdBy: $createdBy, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscussionPostsTable extends DiscussionPosts
    with TableInfo<$DiscussionPostsTable, DiscussionPostRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscussionPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _threadIdMeta =
      const VerificationMeta('threadId');
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
      'thread_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES discussion_threads (id) ON DELETE CASCADE'));
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, threadId, authorId, role, body, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discussion_posts';
  @override
  VerificationContext validateIntegrity(Insertable<DiscussionPostRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta));
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscussionPostRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscussionPostRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      threadId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thread_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role']),
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DiscussionPostsTable createAlias(String alias) {
    return $DiscussionPostsTable(attachedDatabase, alias);
  }
}

class DiscussionPostRow extends DataClass
    implements Insertable<DiscussionPostRow> {
  final String id;
  final String threadId;
  final String authorId;
  final String? role;
  final String body;
  final String status;
  final int createdAt;
  final int updatedAt;
  const DiscussionPostRow(
      {required this.id,
      required this.threadId,
      required this.authorId,
      this.role,
      required this.body,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    map['body'] = Variable<String>(body);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DiscussionPostsCompanion toCompanion(bool nullToAbsent) {
    return DiscussionPostsCompanion(
      id: Value(id),
      threadId: Value(threadId),
      authorId: Value(authorId),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      body: Value(body),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiscussionPostRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscussionPostRow(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      role: serializer.fromJson<String?>(json['role']),
      body: serializer.fromJson<String>(json['body']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'authorId': serializer.toJson<String>(authorId),
      'role': serializer.toJson<String?>(role),
      'body': serializer.toJson<String>(body),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DiscussionPostRow copyWith(
          {String? id,
          String? threadId,
          String? authorId,
          Value<String?> role = const Value.absent(),
          String? body,
          String? status,
          int? createdAt,
          int? updatedAt}) =>
      DiscussionPostRow(
        id: id ?? this.id,
        threadId: threadId ?? this.threadId,
        authorId: authorId ?? this.authorId,
        role: role.present ? role.value : this.role,
        body: body ?? this.body,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DiscussionPostRow copyWithCompanion(DiscussionPostsCompanion data) {
    return DiscussionPostRow(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      role: data.role.present ? data.role.value : this.role,
      body: data.body.present ? data.body.value : this.body,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionPostRow(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorId: $authorId, ')
          ..write('role: $role, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, threadId, authorId, role, body, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscussionPostRow &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.authorId == this.authorId &&
          other.role == this.role &&
          other.body == this.body &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiscussionPostsCompanion extends UpdateCompanion<DiscussionPostRow> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> authorId;
  final Value<String?> role;
  final Value<String> body;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DiscussionPostsCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.role = const Value.absent(),
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscussionPostsCompanion.insert({
    required String id,
    required String threadId,
    required String authorId,
    this.role = const Value.absent(),
    required String body,
    this.status = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        threadId = Value(threadId),
        authorId = Value(authorId),
        body = Value(body),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DiscussionPostRow> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? authorId,
    Expression<String>? role,
    Expression<String>? body,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (authorId != null) 'author_id': authorId,
      if (role != null) 'role': role,
      if (body != null) 'body': body,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscussionPostsCompanion copyWith(
      {Value<String>? id,
      Value<String>? threadId,
      Value<String>? authorId,
      Value<String?>? role,
      Value<String>? body,
      Value<String>? status,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return DiscussionPostsCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      authorId: authorId ?? this.authorId,
      role: role ?? this.role,
      body: body ?? this.body,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionPostsCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorId: $authorId, ')
          ..write('role: $role, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressTable extends Progress
    with TableInfo<$ProgressTable, ProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lessons (id) ON DELETE CASCADE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quizScoreMeta =
      const VerificationMeta('quizScore');
  @override
  late final GeneratedColumn<double> quizScore = GeneratedColumn<double>(
      'quiz_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _timeSpentSecondsMeta =
      const VerificationMeta('timeSpentSeconds');
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
      'time_spent_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
      'started_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        lessonId,
        status,
        quizScore,
        timeSpentSeconds,
        startedAt,
        completedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('quiz_score')) {
      context.handle(_quizScoreMeta,
          quizScore.isAcceptableOrUnknown(data['quiz_score']!, _quizScoreMeta));
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
          _timeSpentSecondsMeta,
          timeSpentSeconds.isAcceptableOrUnknown(
              data['time_spent_seconds']!, _timeSpentSecondsMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      quizScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quiz_score']),
      timeSpentSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_spent_seconds'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProgressTable createAlias(String alias) {
    return $ProgressTable(attachedDatabase, alias);
  }
}

class ProgressData extends DataClass implements Insertable<ProgressData> {
  final String id;
  final String userId;
  final String lessonId;
  final String status;
  final double? quizScore;
  final int timeSpentSeconds;
  final int? startedAt;
  final int? completedAt;
  final int updatedAt;
  const ProgressData(
      {required this.id,
      required this.userId,
      required this.lessonId,
      required this.status,
      this.quizScore,
      required this.timeSpentSeconds,
      this.startedAt,
      this.completedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || quizScore != null) {
      map['quiz_score'] = Variable<double>(quizScore);
    }
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<int>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ProgressCompanion toCompanion(bool nullToAbsent) {
    return ProgressCompanion(
      id: Value(id),
      userId: Value(userId),
      lessonId: Value(lessonId),
      status: Value(status),
      quizScore: quizScore == null && nullToAbsent
          ? const Value.absent()
          : Value(quizScore),
      timeSpentSeconds: Value(timeSpentSeconds),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      quizScore: serializer.fromJson<double?>(json['quizScore']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
      startedAt: serializer.fromJson<int?>(json['startedAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'lessonId': serializer.toJson<String>(lessonId),
      'status': serializer.toJson<String>(status),
      'quizScore': serializer.toJson<double?>(quizScore),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
      'startedAt': serializer.toJson<int?>(startedAt),
      'completedAt': serializer.toJson<int?>(completedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ProgressData copyWith(
          {String? id,
          String? userId,
          String? lessonId,
          String? status,
          Value<double?> quizScore = const Value.absent(),
          int? timeSpentSeconds,
          Value<int?> startedAt = const Value.absent(),
          Value<int?> completedAt = const Value.absent(),
          int? updatedAt}) =>
      ProgressData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        lessonId: lessonId ?? this.lessonId,
        status: status ?? this.status,
        quizScore: quizScore.present ? quizScore.value : this.quizScore,
        timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProgressData copyWithCompanion(ProgressCompanion data) {
    return ProgressData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      quizScore: data.quizScore.present ? data.quizScore.value : this.quizScore,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('quizScore: $quizScore, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, lessonId, status, quizScore,
      timeSpentSeconds, startedAt, completedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.quizScore == this.quizScore &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class ProgressCompanion extends UpdateCompanion<ProgressData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> lessonId;
  final Value<String> status;
  final Value<double?> quizScore;
  final Value<int> timeSpentSeconds;
  final Value<int?> startedAt;
  final Value<int?> completedAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.quizScore = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressCompanion.insert({
    required String id,
    required String userId,
    required String lessonId,
    required String status,
    this.quizScore = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        lessonId = Value(lessonId),
        status = Value(status),
        updatedAt = Value(updatedAt);
  static Insertable<ProgressData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? lessonId,
    Expression<String>? status,
    Expression<double>? quizScore,
    Expression<int>? timeSpentSeconds,
    Expression<int>? startedAt,
    Expression<int>? completedAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (quizScore != null) 'quiz_score': quizScore,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? lessonId,
      Value<String>? status,
      Value<double?>? quizScore,
      Value<int>? timeSpentSeconds,
      Value<int?>? startedAt,
      Value<int?>? completedAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return ProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      quizScore: quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (quizScore.present) {
      map['quiz_score'] = Variable<double>(quizScore.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('quizScore: $quizScore, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
      'op_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastTriedAtMeta =
      const VerificationMeta('lastTriedAt');
  @override
  late final GeneratedColumn<int> lastTriedAt = GeneratedColumn<int>(
      'last_tried_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, opType, payload, createdAt, lastTriedAt, attempts];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('op_type')) {
      context.handle(_opTypeMeta,
          opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta));
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_tried_at')) {
      context.handle(
          _lastTriedAtMeta,
          lastTriedAt.isAcceptableOrUnknown(
              data['last_tried_at']!, _lastTriedAtMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      opType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}op_type'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      lastTriedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_tried_at']),
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String userId;
  final String opType;
  final String payload;
  final int createdAt;
  final int? lastTriedAt;
  final int attempts;
  const SyncQueueData(
      {required this.id,
      required this.userId,
      required this.opType,
      required this.payload,
      required this.createdAt,
      this.lastTriedAt,
      required this.attempts});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['op_type'] = Variable<String>(opType);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || lastTriedAt != null) {
      map['last_tried_at'] = Variable<int>(lastTriedAt);
    }
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      userId: Value(userId),
      opType: Value(opType),
      payload: Value(payload),
      createdAt: Value(createdAt),
      lastTriedAt: lastTriedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTriedAt),
      attempts: Value(attempts),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      opType: serializer.fromJson<String>(json['opType']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastTriedAt: serializer.fromJson<int?>(json['lastTriedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'opType': serializer.toJson<String>(opType),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastTriedAt': serializer.toJson<int?>(lastTriedAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          String? userId,
          String? opType,
          String? payload,
          int? createdAt,
          Value<int?> lastTriedAt = const Value.absent(),
          int? attempts}) =>
      SyncQueueData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        opType: opType ?? this.opType,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        lastTriedAt: lastTriedAt.present ? lastTriedAt.value : this.lastTriedAt,
        attempts: attempts ?? this.attempts,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      opType: data.opType.present ? data.opType.value : this.opType,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastTriedAt:
          data.lastTriedAt.present ? data.lastTriedAt.value : this.lastTriedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastTriedAt: $lastTriedAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, opType, payload, createdAt, lastTriedAt, attempts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.opType == this.opType &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.lastTriedAt == this.lastTriedAt &&
          other.attempts == this.attempts);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> opType;
  final Value<String> payload;
  final Value<int> createdAt;
  final Value<int?> lastTriedAt;
  final Value<int> attempts;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.opType = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastTriedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String userId,
    required String opType,
    required String payload,
    required int createdAt,
    this.lastTriedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        opType = Value(opType),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? opType,
    Expression<String>? payload,
    Expression<int>? createdAt,
    Expression<int>? lastTriedAt,
    Expression<int>? attempts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (opType != null) 'op_type': opType,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (lastTriedAt != null) 'last_tried_at': lastTriedAt,
      if (attempts != null) 'attempts': attempts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? opType,
      Value<String>? payload,
      Value<int>? createdAt,
      Value<int?>? lastTriedAt,
      Value<int>? attempts,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      opType: opType ?? this.opType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      lastTriedAt: lastTriedAt ?? this.lastTriedAt,
      attempts: attempts ?? this.attempts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastTriedAt.present) {
      map['last_tried_at'] = Variable<int>(lastTriedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastTriedAt: $lastTriedAt, ')
          ..write('attempts: $attempts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _flaggedMeta =
      const VerificationMeta('flagged');
  @override
  late final GeneratedColumn<bool> flagged = GeneratedColumn<bool>(
      'flagged', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("flagged" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _authorNameMeta =
      const VerificationMeta('authorName');
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
      'author_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        classId,
        userId,
        body,
        createdAt,
        updatedAt,
        deleted,
        flagged,
        attachments,
        authorName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('flagged')) {
      context.handle(_flaggedMeta,
          flagged.isAcceptableOrUnknown(data['flagged']!, _flaggedMeta));
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name']!, _authorNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      flagged: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}flagged'])!,
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments'])!,
      authorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_name']),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String classId;
  final String userId;
  final String body;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final bool flagged;
  final String attachments;
  final String? authorName;
  const Message(
      {required this.id,
      required this.classId,
      required this.userId,
      required this.body,
      required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.flagged,
      required this.attachments,
      this.authorName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['class_id'] = Variable<String>(classId);
    map['user_id'] = Variable<String>(userId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['flagged'] = Variable<bool>(flagged);
    map['attachments'] = Variable<String>(attachments);
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      classId: Value(classId),
      userId: Value(userId),
      body: Value(body),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      flagged: Value(flagged),
      attachments: Value(attachments),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      classId: serializer.fromJson<String>(json['classId']),
      userId: serializer.fromJson<String>(json['userId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      flagged: serializer.fromJson<bool>(json['flagged']),
      attachments: serializer.fromJson<String>(json['attachments']),
      authorName: serializer.fromJson<String?>(json['authorName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'classId': serializer.toJson<String>(classId),
      'userId': serializer.toJson<String>(userId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'flagged': serializer.toJson<bool>(flagged),
      'attachments': serializer.toJson<String>(attachments),
      'authorName': serializer.toJson<String?>(authorName),
    };
  }

  Message copyWith(
          {String? id,
          String? classId,
          String? userId,
          String? body,
          int? createdAt,
          int? updatedAt,
          bool? deleted,
          bool? flagged,
          String? attachments,
          Value<String?> authorName = const Value.absent()}) =>
      Message(
        id: id ?? this.id,
        classId: classId ?? this.classId,
        userId: userId ?? this.userId,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        flagged: flagged ?? this.flagged,
        attachments: attachments ?? this.attachments,
        authorName: authorName.present ? authorName.value : this.authorName,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      classId: data.classId.present ? data.classId.value : this.classId,
      userId: data.userId.present ? data.userId.value : this.userId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      flagged: data.flagged.present ? data.flagged.value : this.flagged,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
      authorName:
          data.authorName.present ? data.authorName.value : this.authorName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('flagged: $flagged, ')
          ..write('attachments: $attachments, ')
          ..write('authorName: $authorName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, classId, userId, body, createdAt,
      updatedAt, deleted, flagged, attachments, authorName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.classId == this.classId &&
          other.userId == this.userId &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.flagged == this.flagged &&
          other.attachments == this.attachments &&
          other.authorName == this.authorName);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> classId;
  final Value<String> userId;
  final Value<String> body;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<bool> flagged;
  final Value<String> attachments;
  final Value<String?> authorName;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.flagged = const Value.absent(),
    this.attachments = const Value.absent(),
    this.authorName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String classId,
    required String userId,
    required String body,
    required int createdAt,
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.flagged = const Value.absent(),
    this.attachments = const Value.absent(),
    this.authorName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        classId = Value(classId),
        userId = Value(userId),
        body = Value(body),
        createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? classId,
    Expression<String>? userId,
    Expression<String>? body,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? flagged,
    Expression<String>? attachments,
    Expression<String>? authorName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classId != null) 'class_id': classId,
      if (userId != null) 'user_id': userId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (flagged != null) 'flagged': flagged,
      if (attachments != null) 'attachments': attachments,
      if (authorName != null) 'author_name': authorName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? classId,
      Value<String>? userId,
      Value<String>? body,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<bool>? deleted,
      Value<bool>? flagged,
      Value<String>? attachments,
      Value<String?>? authorName,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      flagged: flagged ?? this.flagged,
      attachments: attachments ?? this.attachments,
      authorName: authorName ?? this.authorName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (flagged.present) {
      map['flagged'] = Variable<bool>(flagged.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('flagged: $flagged, ')
          ..write('attachments: $attachments, ')
          ..write('authorName: $authorName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TypingIndicatorsTable extends TypingIndicators
    with TableInfo<$TypingIndicatorsTable, TypingIndicatorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingIndicatorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isTypingMeta =
      const VerificationMeta('isTyping');
  @override
  late final GeneratedColumn<bool> isTyping = GeneratedColumn<bool>(
      'is_typing', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_typing" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [classId, userId, isTyping, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_indicators';
  @override
  VerificationContext validateIntegrity(Insertable<TypingIndicatorRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_typing')) {
      context.handle(_isTypingMeta,
          isTyping.isAcceptableOrUnknown(data['is_typing']!, _isTypingMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {classId, userId};
  @override
  TypingIndicatorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingIndicatorRow(
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      isTyping: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_typing'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TypingIndicatorsTable createAlias(String alias) {
    return $TypingIndicatorsTable(attachedDatabase, alias);
  }
}

class TypingIndicatorRow extends DataClass
    implements Insertable<TypingIndicatorRow> {
  final String classId;
  final String userId;
  final bool isTyping;
  final int updatedAt;
  const TypingIndicatorRow(
      {required this.classId,
      required this.userId,
      required this.isTyping,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['class_id'] = Variable<String>(classId);
    map['user_id'] = Variable<String>(userId);
    map['is_typing'] = Variable<bool>(isTyping);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TypingIndicatorsCompanion toCompanion(bool nullToAbsent) {
    return TypingIndicatorsCompanion(
      classId: Value(classId),
      userId: Value(userId),
      isTyping: Value(isTyping),
      updatedAt: Value(updatedAt),
    );
  }

  factory TypingIndicatorRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingIndicatorRow(
      classId: serializer.fromJson<String>(json['classId']),
      userId: serializer.fromJson<String>(json['userId']),
      isTyping: serializer.fromJson<bool>(json['isTyping']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'classId': serializer.toJson<String>(classId),
      'userId': serializer.toJson<String>(userId),
      'isTyping': serializer.toJson<bool>(isTyping),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TypingIndicatorRow copyWith(
          {String? classId, String? userId, bool? isTyping, int? updatedAt}) =>
      TypingIndicatorRow(
        classId: classId ?? this.classId,
        userId: userId ?? this.userId,
        isTyping: isTyping ?? this.isTyping,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TypingIndicatorRow copyWithCompanion(TypingIndicatorsCompanion data) {
    return TypingIndicatorRow(
      classId: data.classId.present ? data.classId.value : this.classId,
      userId: data.userId.present ? data.userId.value : this.userId,
      isTyping: data.isTyping.present ? data.isTyping.value : this.isTyping,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingIndicatorRow(')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('isTyping: $isTyping, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(classId, userId, isTyping, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingIndicatorRow &&
          other.classId == this.classId &&
          other.userId == this.userId &&
          other.isTyping == this.isTyping &&
          other.updatedAt == this.updatedAt);
}

class TypingIndicatorsCompanion extends UpdateCompanion<TypingIndicatorRow> {
  final Value<String> classId;
  final Value<String> userId;
  final Value<bool> isTyping;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const TypingIndicatorsCompanion({
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.isTyping = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TypingIndicatorsCompanion.insert({
    required String classId,
    required String userId,
    this.isTyping = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : classId = Value(classId),
        userId = Value(userId);
  static Insertable<TypingIndicatorRow> custom({
    Expression<String>? classId,
    Expression<String>? userId,
    Expression<bool>? isTyping,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (classId != null) 'class_id': classId,
      if (userId != null) 'user_id': userId,
      if (isTyping != null) 'is_typing': isTyping,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TypingIndicatorsCompanion copyWith(
      {Value<String>? classId,
      Value<String>? userId,
      Value<bool>? isTyping,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return TypingIndicatorsCompanion(
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      isTyping: isTyping ?? this.isTyping,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isTyping.present) {
      map['is_typing'] = Variable<bool>(isTyping.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingIndicatorsCompanion(')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('isTyping: $isTyping, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModerationActionsTableTable extends ModerationActionsTable
    with TableInfo<$ModerationActionsTableTable, ModerationActionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModerationActionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetUserIdMeta =
      const VerificationMeta('targetUserId');
  @override
  late final GeneratedColumn<String> targetUserId = GeneratedColumn<String>(
      'target_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moderatorIdMeta =
      const VerificationMeta('moderatorId');
  @override
  late final GeneratedColumn<String> moderatorId = GeneratedColumn<String>(
      'moderator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        classId,
        targetUserId,
        moderatorId,
        type,
        status,
        reason,
        metadata,
        createdAt,
        expiresAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moderation_actions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModerationActionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('target_user_id')) {
      context.handle(
          _targetUserIdMeta,
          targetUserId.isAcceptableOrUnknown(
              data['target_user_id']!, _targetUserIdMeta));
    } else if (isInserting) {
      context.missing(_targetUserIdMeta);
    }
    if (data.containsKey('moderator_id')) {
      context.handle(
          _moderatorIdMeta,
          moderatorId.isAcceptableOrUnknown(
              data['moderator_id']!, _moderatorIdMeta));
    } else if (isInserting) {
      context.missing(_moderatorIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModerationActionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModerationActionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      targetUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_user_id'])!,
      moderatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moderator_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expires_at']),
    );
  }

  @override
  $ModerationActionsTableTable createAlias(String alias) {
    return $ModerationActionsTableTable(attachedDatabase, alias);
  }
}

class ModerationActionRow extends DataClass
    implements Insertable<ModerationActionRow> {
  final String id;
  final String classId;
  final String targetUserId;
  final String moderatorId;
  final String type;
  final String status;
  final String? reason;
  final String metadata;
  final int createdAt;
  final int? expiresAt;
  const ModerationActionRow(
      {required this.id,
      required this.classId,
      required this.targetUserId,
      required this.moderatorId,
      required this.type,
      required this.status,
      this.reason,
      required this.metadata,
      required this.createdAt,
      this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['class_id'] = Variable<String>(classId);
    map['target_user_id'] = Variable<String>(targetUserId);
    map['moderator_id'] = Variable<String>(moderatorId);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['metadata'] = Variable<String>(metadata);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    return map;
  }

  ModerationActionsTableCompanion toCompanion(bool nullToAbsent) {
    return ModerationActionsTableCompanion(
      id: Value(id),
      classId: Value(classId),
      targetUserId: Value(targetUserId),
      moderatorId: Value(moderatorId),
      type: Value(type),
      status: Value(status),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      metadata: Value(metadata),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory ModerationActionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModerationActionRow(
      id: serializer.fromJson<String>(json['id']),
      classId: serializer.fromJson<String>(json['classId']),
      targetUserId: serializer.fromJson<String>(json['targetUserId']),
      moderatorId: serializer.fromJson<String>(json['moderatorId']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
      metadata: serializer.fromJson<String>(json['metadata']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      expiresAt: serializer.fromJson<int?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'classId': serializer.toJson<String>(classId),
      'targetUserId': serializer.toJson<String>(targetUserId),
      'moderatorId': serializer.toJson<String>(moderatorId),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String?>(reason),
      'metadata': serializer.toJson<String>(metadata),
      'createdAt': serializer.toJson<int>(createdAt),
      'expiresAt': serializer.toJson<int?>(expiresAt),
    };
  }

  ModerationActionRow copyWith(
          {String? id,
          String? classId,
          String? targetUserId,
          String? moderatorId,
          String? type,
          String? status,
          Value<String?> reason = const Value.absent(),
          String? metadata,
          int? createdAt,
          Value<int?> expiresAt = const Value.absent()}) =>
      ModerationActionRow(
        id: id ?? this.id,
        classId: classId ?? this.classId,
        targetUserId: targetUserId ?? this.targetUserId,
        moderatorId: moderatorId ?? this.moderatorId,
        type: type ?? this.type,
        status: status ?? this.status,
        reason: reason.present ? reason.value : this.reason,
        metadata: metadata ?? this.metadata,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
      );
  ModerationActionRow copyWithCompanion(ModerationActionsTableCompanion data) {
    return ModerationActionRow(
      id: data.id.present ? data.id.value : this.id,
      classId: data.classId.present ? data.classId.value : this.classId,
      targetUserId: data.targetUserId.present
          ? data.targetUserId.value
          : this.targetUserId,
      moderatorId:
          data.moderatorId.present ? data.moderatorId.value : this.moderatorId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModerationActionRow(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('moderatorId: $moderatorId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, classId, targetUserId, moderatorId, type,
      status, reason, metadata, createdAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModerationActionRow &&
          other.id == this.id &&
          other.classId == this.classId &&
          other.targetUserId == this.targetUserId &&
          other.moderatorId == this.moderatorId &&
          other.type == this.type &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class ModerationActionsTableCompanion
    extends UpdateCompanion<ModerationActionRow> {
  final Value<String> id;
  final Value<String> classId;
  final Value<String> targetUserId;
  final Value<String> moderatorId;
  final Value<String> type;
  final Value<String> status;
  final Value<String?> reason;
  final Value<String> metadata;
  final Value<int> createdAt;
  final Value<int?> expiresAt;
  final Value<int> rowid;
  const ModerationActionsTableCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.targetUserId = const Value.absent(),
    this.moderatorId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModerationActionsTableCompanion.insert({
    required String id,
    required String classId,
    required String targetUserId,
    required String moderatorId,
    required String type,
    required String status,
    this.reason = const Value.absent(),
    this.metadata = const Value.absent(),
    required int createdAt,
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        classId = Value(classId),
        targetUserId = Value(targetUserId),
        moderatorId = Value(moderatorId),
        type = Value(type),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<ModerationActionRow> custom({
    Expression<String>? id,
    Expression<String>? classId,
    Expression<String>? targetUserId,
    Expression<String>? moderatorId,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<String>? metadata,
    Expression<int>? createdAt,
    Expression<int>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classId != null) 'class_id': classId,
      if (targetUserId != null) 'target_user_id': targetUserId,
      if (moderatorId != null) 'moderator_id': moderatorId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModerationActionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? classId,
      Value<String>? targetUserId,
      Value<String>? moderatorId,
      Value<String>? type,
      Value<String>? status,
      Value<String?>? reason,
      Value<String>? metadata,
      Value<int>? createdAt,
      Value<int?>? expiresAt,
      Value<int>? rowid}) {
    return ModerationActionsTableCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      targetUserId: targetUserId ?? this.targetUserId,
      moderatorId: moderatorId ?? this.moderatorId,
      type: type ?? this.type,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (targetUserId.present) {
      map['target_user_id'] = Variable<String>(targetUserId.value);
    }
    if (moderatorId.present) {
      map['moderator_id'] = Variable<String>(moderatorId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModerationActionsTableCompanion(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('moderatorId: $moderatorId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModerationAppealsTableTable extends ModerationAppealsTable
    with TableInfo<$ModerationAppealsTableTable, ModerationAppealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModerationAppealsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionIdMeta =
      const VerificationMeta('actionId');
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
      'action_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES moderation_actions_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resolutionNotesMeta =
      const VerificationMeta('resolutionNotes');
  @override
  late final GeneratedColumn<String> resolutionNotes = GeneratedColumn<String>(
      'resolution_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resolvedAtMeta =
      const VerificationMeta('resolvedAt');
  @override
  late final GeneratedColumn<int> resolvedAt = GeneratedColumn<int>(
      'resolved_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        actionId,
        classId,
        userId,
        message,
        status,
        resolutionNotes,
        createdAt,
        resolvedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moderation_appeals_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModerationAppealRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('action_id')) {
      context.handle(_actionIdMeta,
          actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta));
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('resolution_notes')) {
      context.handle(
          _resolutionNotesMeta,
          resolutionNotes.isAcceptableOrUnknown(
              data['resolution_notes']!, _resolutionNotesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
          _resolvedAtMeta,
          resolvedAt.isAcceptableOrUnknown(
              data['resolved_at']!, _resolvedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModerationAppealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModerationAppealRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      actionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_id'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      resolutionNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}resolution_notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      resolvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resolved_at']),
    );
  }

  @override
  $ModerationAppealsTableTable createAlias(String alias) {
    return $ModerationAppealsTableTable(attachedDatabase, alias);
  }
}

class ModerationAppealRow extends DataClass
    implements Insertable<ModerationAppealRow> {
  final String id;
  final String actionId;
  final String classId;
  final String userId;
  final String message;
  final String status;
  final String? resolutionNotes;
  final int createdAt;
  final int? resolvedAt;
  const ModerationAppealRow(
      {required this.id,
      required this.actionId,
      required this.classId,
      required this.userId,
      required this.message,
      required this.status,
      this.resolutionNotes,
      required this.createdAt,
      this.resolvedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['action_id'] = Variable<String>(actionId);
    map['class_id'] = Variable<String>(classId);
    map['user_id'] = Variable<String>(userId);
    map['message'] = Variable<String>(message);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || resolutionNotes != null) {
      map['resolution_notes'] = Variable<String>(resolutionNotes);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<int>(resolvedAt);
    }
    return map;
  }

  ModerationAppealsTableCompanion toCompanion(bool nullToAbsent) {
    return ModerationAppealsTableCompanion(
      id: Value(id),
      actionId: Value(actionId),
      classId: Value(classId),
      userId: Value(userId),
      message: Value(message),
      status: Value(status),
      resolutionNotes: resolutionNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionNotes),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory ModerationAppealRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModerationAppealRow(
      id: serializer.fromJson<String>(json['id']),
      actionId: serializer.fromJson<String>(json['actionId']),
      classId: serializer.fromJson<String>(json['classId']),
      userId: serializer.fromJson<String>(json['userId']),
      message: serializer.fromJson<String>(json['message']),
      status: serializer.fromJson<String>(json['status']),
      resolutionNotes: serializer.fromJson<String?>(json['resolutionNotes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      resolvedAt: serializer.fromJson<int?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actionId': serializer.toJson<String>(actionId),
      'classId': serializer.toJson<String>(classId),
      'userId': serializer.toJson<String>(userId),
      'message': serializer.toJson<String>(message),
      'status': serializer.toJson<String>(status),
      'resolutionNotes': serializer.toJson<String?>(resolutionNotes),
      'createdAt': serializer.toJson<int>(createdAt),
      'resolvedAt': serializer.toJson<int?>(resolvedAt),
    };
  }

  ModerationAppealRow copyWith(
          {String? id,
          String? actionId,
          String? classId,
          String? userId,
          String? message,
          String? status,
          Value<String?> resolutionNotes = const Value.absent(),
          int? createdAt,
          Value<int?> resolvedAt = const Value.absent()}) =>
      ModerationAppealRow(
        id: id ?? this.id,
        actionId: actionId ?? this.actionId,
        classId: classId ?? this.classId,
        userId: userId ?? this.userId,
        message: message ?? this.message,
        status: status ?? this.status,
        resolutionNotes: resolutionNotes.present
            ? resolutionNotes.value
            : this.resolutionNotes,
        createdAt: createdAt ?? this.createdAt,
        resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
      );
  ModerationAppealRow copyWithCompanion(ModerationAppealsTableCompanion data) {
    return ModerationAppealRow(
      id: data.id.present ? data.id.value : this.id,
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      classId: data.classId.present ? data.classId.value : this.classId,
      userId: data.userId.present ? data.userId.value : this.userId,
      message: data.message.present ? data.message.value : this.message,
      status: data.status.present ? data.status.value : this.status,
      resolutionNotes: data.resolutionNotes.present
          ? data.resolutionNotes.value
          : this.resolutionNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt:
          data.resolvedAt.present ? data.resolvedAt.value : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModerationAppealRow(')
          ..write('id: $id, ')
          ..write('actionId: $actionId, ')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('resolutionNotes: $resolutionNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, actionId, classId, userId, message,
      status, resolutionNotes, createdAt, resolvedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModerationAppealRow &&
          other.id == this.id &&
          other.actionId == this.actionId &&
          other.classId == this.classId &&
          other.userId == this.userId &&
          other.message == this.message &&
          other.status == this.status &&
          other.resolutionNotes == this.resolutionNotes &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class ModerationAppealsTableCompanion
    extends UpdateCompanion<ModerationAppealRow> {
  final Value<String> id;
  final Value<String> actionId;
  final Value<String> classId;
  final Value<String> userId;
  final Value<String> message;
  final Value<String> status;
  final Value<String?> resolutionNotes;
  final Value<int> createdAt;
  final Value<int?> resolvedAt;
  final Value<int> rowid;
  const ModerationAppealsTableCompanion({
    this.id = const Value.absent(),
    this.actionId = const Value.absent(),
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.resolutionNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModerationAppealsTableCompanion.insert({
    required String id,
    required String actionId,
    required String classId,
    required String userId,
    required String message,
    required String status,
    this.resolutionNotes = const Value.absent(),
    required int createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        actionId = Value(actionId),
        classId = Value(classId),
        userId = Value(userId),
        message = Value(message),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<ModerationAppealRow> custom({
    Expression<String>? id,
    Expression<String>? actionId,
    Expression<String>? classId,
    Expression<String>? userId,
    Expression<String>? message,
    Expression<String>? status,
    Expression<String>? resolutionNotes,
    Expression<int>? createdAt,
    Expression<int>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionId != null) 'action_id': actionId,
      if (classId != null) 'class_id': classId,
      if (userId != null) 'user_id': userId,
      if (message != null) 'message': message,
      if (status != null) 'status': status,
      if (resolutionNotes != null) 'resolution_notes': resolutionNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModerationAppealsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? actionId,
      Value<String>? classId,
      Value<String>? userId,
      Value<String>? message,
      Value<String>? status,
      Value<String?>? resolutionNotes,
      Value<int>? createdAt,
      Value<int?>? resolvedAt,
      Value<int>? rowid}) {
    return ModerationAppealsTableCompanion(
      id: id ?? this.id,
      actionId: actionId ?? this.actionId,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      status: status ?? this.status,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resolutionNotes.present) {
      map['resolution_notes'] = Variable<String>(resolutionNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<int>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModerationAppealsTableCompanion(')
          ..write('id: $id, ')
          ..write('actionId: $actionId, ')
          ..write('classId: $classId, ')
          ..write('userId: $userId, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('resolutionNotes: $resolutionNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteChangeTrackersTable extends NoteChangeTrackers
    with TableInfo<$NoteChangeTrackersTable, NoteChangeTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteChangeTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES notes (id) ON DELETE NO ACTION'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<int> localUpdatedAt = GeneratedColumn<int>(
      'local_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<int> remoteUpdatedAt = GeneratedColumn<int>(
      'remote_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastOperationMeta =
      const VerificationMeta('lastOperation');
  @override
  late final GeneratedColumn<String> lastOperation = GeneratedColumn<String>(
      'last_operation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('upsert'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _conflictReasonMeta =
      const VerificationMeta('conflictReason');
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
      'conflict_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictPayloadMeta =
      const VerificationMeta('conflictPayload');
  @override
  late final GeneratedColumn<String> conflictPayload = GeneratedColumn<String>(
      'conflict_payload', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictDetectedAtMeta =
      const VerificationMeta('conflictDetectedAt');
  @override
  late final GeneratedColumn<int> conflictDetectedAt = GeneratedColumn<int>(
      'conflict_detected_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        noteId,
        userId,
        localUpdatedAt,
        remoteUpdatedAt,
        lastSyncedAt,
        lastOperation,
        status,
        conflictReason,
        conflictPayload,
        conflictDetectedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_change_trackers';
  @override
  VerificationContext validateIntegrity(Insertable<NoteChangeTracker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('last_operation')) {
      context.handle(
          _lastOperationMeta,
          lastOperation.isAcceptableOrUnknown(
              data['last_operation']!, _lastOperationMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
          _conflictReasonMeta,
          conflictReason.isAcceptableOrUnknown(
              data['conflict_reason']!, _conflictReasonMeta));
    }
    if (data.containsKey('conflict_payload')) {
      context.handle(
          _conflictPayloadMeta,
          conflictPayload.isAcceptableOrUnknown(
              data['conflict_payload']!, _conflictPayloadMeta));
    }
    if (data.containsKey('conflict_detected_at')) {
      context.handle(
          _conflictDetectedAtMeta,
          conflictDetectedAt.isAcceptableOrUnknown(
              data['conflict_detected_at']!, _conflictDetectedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId};
  @override
  NoteChangeTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteChangeTracker(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      localUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_updated_at'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_synced_at']),
      lastOperation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_operation'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      conflictReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conflict_reason']),
      conflictPayload: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conflict_payload']),
      conflictDetectedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}conflict_detected_at']),
    );
  }

  @override
  $NoteChangeTrackersTable createAlias(String alias) {
    return $NoteChangeTrackersTable(attachedDatabase, alias);
  }
}

class NoteChangeTracker extends DataClass
    implements Insertable<NoteChangeTracker> {
  final String noteId;
  final String userId;
  final int localUpdatedAt;
  final int remoteUpdatedAt;
  final int? lastSyncedAt;
  final String lastOperation;
  final String status;
  final String? conflictReason;
  final String? conflictPayload;
  final int? conflictDetectedAt;
  const NoteChangeTracker(
      {required this.noteId,
      required this.userId,
      required this.localUpdatedAt,
      required this.remoteUpdatedAt,
      this.lastSyncedAt,
      required this.lastOperation,
      required this.status,
      this.conflictReason,
      this.conflictPayload,
      this.conflictDetectedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['user_id'] = Variable<String>(userId);
    map['local_updated_at'] = Variable<int>(localUpdatedAt);
    map['remote_updated_at'] = Variable<int>(remoteUpdatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    map['last_operation'] = Variable<String>(lastOperation);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || conflictReason != null) {
      map['conflict_reason'] = Variable<String>(conflictReason);
    }
    if (!nullToAbsent || conflictPayload != null) {
      map['conflict_payload'] = Variable<String>(conflictPayload);
    }
    if (!nullToAbsent || conflictDetectedAt != null) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt);
    }
    return map;
  }

  NoteChangeTrackersCompanion toCompanion(bool nullToAbsent) {
    return NoteChangeTrackersCompanion(
      noteId: Value(noteId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      remoteUpdatedAt: Value(remoteUpdatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastOperation: Value(lastOperation),
      status: Value(status),
      conflictReason: conflictReason == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictReason),
      conflictPayload: conflictPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictPayload),
      conflictDetectedAt: conflictDetectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictDetectedAt),
    );
  }

  factory NoteChangeTracker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteChangeTracker(
      noteId: serializer.fromJson<String>(json['noteId']),
      userId: serializer.fromJson<String>(json['userId']),
      localUpdatedAt: serializer.fromJson<int>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<int>(json['remoteUpdatedAt']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      lastOperation: serializer.fromJson<String>(json['lastOperation']),
      status: serializer.fromJson<String>(json['status']),
      conflictReason: serializer.fromJson<String?>(json['conflictReason']),
      conflictPayload: serializer.fromJson<String?>(json['conflictPayload']),
      conflictDetectedAt: serializer.fromJson<int?>(json['conflictDetectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'userId': serializer.toJson<String>(userId),
      'localUpdatedAt': serializer.toJson<int>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<int>(remoteUpdatedAt),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'lastOperation': serializer.toJson<String>(lastOperation),
      'status': serializer.toJson<String>(status),
      'conflictReason': serializer.toJson<String?>(conflictReason),
      'conflictPayload': serializer.toJson<String?>(conflictPayload),
      'conflictDetectedAt': serializer.toJson<int?>(conflictDetectedAt),
    };
  }

  NoteChangeTracker copyWith(
          {String? noteId,
          String? userId,
          int? localUpdatedAt,
          int? remoteUpdatedAt,
          Value<int?> lastSyncedAt = const Value.absent(),
          String? lastOperation,
          String? status,
          Value<String?> conflictReason = const Value.absent(),
          Value<String?> conflictPayload = const Value.absent(),
          Value<int?> conflictDetectedAt = const Value.absent()}) =>
      NoteChangeTracker(
        noteId: noteId ?? this.noteId,
        userId: userId ?? this.userId,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        lastOperation: lastOperation ?? this.lastOperation,
        status: status ?? this.status,
        conflictReason:
            conflictReason.present ? conflictReason.value : this.conflictReason,
        conflictPayload: conflictPayload.present
            ? conflictPayload.value
            : this.conflictPayload,
        conflictDetectedAt: conflictDetectedAt.present
            ? conflictDetectedAt.value
            : this.conflictDetectedAt,
      );
  NoteChangeTracker copyWithCompanion(NoteChangeTrackersCompanion data) {
    return NoteChangeTracker(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      userId: data.userId.present ? data.userId.value : this.userId,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastOperation: data.lastOperation.present
          ? data.lastOperation.value
          : this.lastOperation,
      status: data.status.present ? data.status.value : this.status,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      conflictPayload: data.conflictPayload.present
          ? data.conflictPayload.value
          : this.conflictPayload,
      conflictDetectedAt: data.conflictDetectedAt.present
          ? data.conflictDetectedAt.value
          : this.conflictDetectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteChangeTracker(')
          ..write('noteId: $noteId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      noteId,
      userId,
      localUpdatedAt,
      remoteUpdatedAt,
      lastSyncedAt,
      lastOperation,
      status,
      conflictReason,
      conflictPayload,
      conflictDetectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteChangeTracker &&
          other.noteId == this.noteId &&
          other.userId == this.userId &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastOperation == this.lastOperation &&
          other.status == this.status &&
          other.conflictReason == this.conflictReason &&
          other.conflictPayload == this.conflictPayload &&
          other.conflictDetectedAt == this.conflictDetectedAt);
}

class NoteChangeTrackersCompanion extends UpdateCompanion<NoteChangeTracker> {
  final Value<String> noteId;
  final Value<String> userId;
  final Value<int> localUpdatedAt;
  final Value<int> remoteUpdatedAt;
  final Value<int?> lastSyncedAt;
  final Value<String> lastOperation;
  final Value<String> status;
  final Value<String?> conflictReason;
  final Value<String?> conflictPayload;
  final Value<int?> conflictDetectedAt;
  final Value<int> rowid;
  const NoteChangeTrackersCompanion({
    this.noteId = const Value.absent(),
    this.userId = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteChangeTrackersCompanion.insert({
    required String noteId,
    required String userId,
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        userId = Value(userId);
  static Insertable<NoteChangeTracker> custom({
    Expression<String>? noteId,
    Expression<String>? userId,
    Expression<int>? localUpdatedAt,
    Expression<int>? remoteUpdatedAt,
    Expression<int>? lastSyncedAt,
    Expression<String>? lastOperation,
    Expression<String>? status,
    Expression<String>? conflictReason,
    Expression<String>? conflictPayload,
    Expression<int>? conflictDetectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (userId != null) 'user_id': userId,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastOperation != null) 'last_operation': lastOperation,
      if (status != null) 'status': status,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (conflictPayload != null) 'conflict_payload': conflictPayload,
      if (conflictDetectedAt != null)
        'conflict_detected_at': conflictDetectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteChangeTrackersCompanion copyWith(
      {Value<String>? noteId,
      Value<String>? userId,
      Value<int>? localUpdatedAt,
      Value<int>? remoteUpdatedAt,
      Value<int?>? lastSyncedAt,
      Value<String>? lastOperation,
      Value<String>? status,
      Value<String?>? conflictReason,
      Value<String?>? conflictPayload,
      Value<int?>? conflictDetectedAt,
      Value<int>? rowid}) {
    return NoteChangeTrackersCompanion(
      noteId: noteId ?? this.noteId,
      userId: userId ?? this.userId,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastOperation: lastOperation ?? this.lastOperation,
      status: status ?? this.status,
      conflictReason: conflictReason ?? this.conflictReason,
      conflictPayload: conflictPayload ?? this.conflictPayload,
      conflictDetectedAt: conflictDetectedAt ?? this.conflictDetectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<int>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<int>(remoteUpdatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (lastOperation.present) {
      map['last_operation'] = Variable<String>(lastOperation.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (conflictPayload.present) {
      map['conflict_payload'] = Variable<String>(conflictPayload.value);
    }
    if (conflictDetectedAt.present) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteChangeTrackersCompanion(')
          ..write('noteId: $noteId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressChangeTrackersTable extends ProgressChangeTrackers
    with TableInfo<$ProgressChangeTrackersTable, ProgressChangeTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressChangeTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _progressIdMeta =
      const VerificationMeta('progressId');
  @override
  late final GeneratedColumn<String> progressId = GeneratedColumn<String>(
      'progress_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES progress (id) ON DELETE NO ACTION'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<int> localUpdatedAt = GeneratedColumn<int>(
      'local_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<int> remoteUpdatedAt = GeneratedColumn<int>(
      'remote_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastOperationMeta =
      const VerificationMeta('lastOperation');
  @override
  late final GeneratedColumn<String> lastOperation = GeneratedColumn<String>(
      'last_operation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('upsert'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _conflictReasonMeta =
      const VerificationMeta('conflictReason');
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
      'conflict_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictPayloadMeta =
      const VerificationMeta('conflictPayload');
  @override
  late final GeneratedColumn<String> conflictPayload = GeneratedColumn<String>(
      'conflict_payload', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictDetectedAtMeta =
      const VerificationMeta('conflictDetectedAt');
  @override
  late final GeneratedColumn<int> conflictDetectedAt = GeneratedColumn<int>(
      'conflict_detected_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        progressId,
        userId,
        localUpdatedAt,
        remoteUpdatedAt,
        lastSyncedAt,
        lastOperation,
        status,
        conflictReason,
        conflictPayload,
        conflictDetectedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_change_trackers';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgressChangeTracker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('progress_id')) {
      context.handle(
          _progressIdMeta,
          progressId.isAcceptableOrUnknown(
              data['progress_id']!, _progressIdMeta));
    } else if (isInserting) {
      context.missing(_progressIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('last_operation')) {
      context.handle(
          _lastOperationMeta,
          lastOperation.isAcceptableOrUnknown(
              data['last_operation']!, _lastOperationMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
          _conflictReasonMeta,
          conflictReason.isAcceptableOrUnknown(
              data['conflict_reason']!, _conflictReasonMeta));
    }
    if (data.containsKey('conflict_payload')) {
      context.handle(
          _conflictPayloadMeta,
          conflictPayload.isAcceptableOrUnknown(
              data['conflict_payload']!, _conflictPayloadMeta));
    }
    if (data.containsKey('conflict_detected_at')) {
      context.handle(
          _conflictDetectedAtMeta,
          conflictDetectedAt.isAcceptableOrUnknown(
              data['conflict_detected_at']!, _conflictDetectedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {progressId};
  @override
  ProgressChangeTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressChangeTracker(
      progressId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}progress_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      localUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_updated_at'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_synced_at']),
      lastOperation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_operation'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      conflictReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conflict_reason']),
      conflictPayload: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conflict_payload']),
      conflictDetectedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}conflict_detected_at']),
    );
  }

  @override
  $ProgressChangeTrackersTable createAlias(String alias) {
    return $ProgressChangeTrackersTable(attachedDatabase, alias);
  }
}

class ProgressChangeTracker extends DataClass
    implements Insertable<ProgressChangeTracker> {
  final String progressId;
  final String userId;
  final int localUpdatedAt;
  final int remoteUpdatedAt;
  final int? lastSyncedAt;
  final String lastOperation;
  final String status;
  final String? conflictReason;
  final String? conflictPayload;
  final int? conflictDetectedAt;
  const ProgressChangeTracker(
      {required this.progressId,
      required this.userId,
      required this.localUpdatedAt,
      required this.remoteUpdatedAt,
      this.lastSyncedAt,
      required this.lastOperation,
      required this.status,
      this.conflictReason,
      this.conflictPayload,
      this.conflictDetectedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['progress_id'] = Variable<String>(progressId);
    map['user_id'] = Variable<String>(userId);
    map['local_updated_at'] = Variable<int>(localUpdatedAt);
    map['remote_updated_at'] = Variable<int>(remoteUpdatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    map['last_operation'] = Variable<String>(lastOperation);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || conflictReason != null) {
      map['conflict_reason'] = Variable<String>(conflictReason);
    }
    if (!nullToAbsent || conflictPayload != null) {
      map['conflict_payload'] = Variable<String>(conflictPayload);
    }
    if (!nullToAbsent || conflictDetectedAt != null) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt);
    }
    return map;
  }

  ProgressChangeTrackersCompanion toCompanion(bool nullToAbsent) {
    return ProgressChangeTrackersCompanion(
      progressId: Value(progressId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      remoteUpdatedAt: Value(remoteUpdatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastOperation: Value(lastOperation),
      status: Value(status),
      conflictReason: conflictReason == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictReason),
      conflictPayload: conflictPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictPayload),
      conflictDetectedAt: conflictDetectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictDetectedAt),
    );
  }

  factory ProgressChangeTracker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressChangeTracker(
      progressId: serializer.fromJson<String>(json['progressId']),
      userId: serializer.fromJson<String>(json['userId']),
      localUpdatedAt: serializer.fromJson<int>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<int>(json['remoteUpdatedAt']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      lastOperation: serializer.fromJson<String>(json['lastOperation']),
      status: serializer.fromJson<String>(json['status']),
      conflictReason: serializer.fromJson<String?>(json['conflictReason']),
      conflictPayload: serializer.fromJson<String?>(json['conflictPayload']),
      conflictDetectedAt: serializer.fromJson<int?>(json['conflictDetectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'progressId': serializer.toJson<String>(progressId),
      'userId': serializer.toJson<String>(userId),
      'localUpdatedAt': serializer.toJson<int>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<int>(remoteUpdatedAt),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'lastOperation': serializer.toJson<String>(lastOperation),
      'status': serializer.toJson<String>(status),
      'conflictReason': serializer.toJson<String?>(conflictReason),
      'conflictPayload': serializer.toJson<String?>(conflictPayload),
      'conflictDetectedAt': serializer.toJson<int?>(conflictDetectedAt),
    };
  }

  ProgressChangeTracker copyWith(
          {String? progressId,
          String? userId,
          int? localUpdatedAt,
          int? remoteUpdatedAt,
          Value<int?> lastSyncedAt = const Value.absent(),
          String? lastOperation,
          String? status,
          Value<String?> conflictReason = const Value.absent(),
          Value<String?> conflictPayload = const Value.absent(),
          Value<int?> conflictDetectedAt = const Value.absent()}) =>
      ProgressChangeTracker(
        progressId: progressId ?? this.progressId,
        userId: userId ?? this.userId,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        lastOperation: lastOperation ?? this.lastOperation,
        status: status ?? this.status,
        conflictReason:
            conflictReason.present ? conflictReason.value : this.conflictReason,
        conflictPayload: conflictPayload.present
            ? conflictPayload.value
            : this.conflictPayload,
        conflictDetectedAt: conflictDetectedAt.present
            ? conflictDetectedAt.value
            : this.conflictDetectedAt,
      );
  ProgressChangeTracker copyWithCompanion(
      ProgressChangeTrackersCompanion data) {
    return ProgressChangeTracker(
      progressId:
          data.progressId.present ? data.progressId.value : this.progressId,
      userId: data.userId.present ? data.userId.value : this.userId,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastOperation: data.lastOperation.present
          ? data.lastOperation.value
          : this.lastOperation,
      status: data.status.present ? data.status.value : this.status,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      conflictPayload: data.conflictPayload.present
          ? data.conflictPayload.value
          : this.conflictPayload,
      conflictDetectedAt: data.conflictDetectedAt.present
          ? data.conflictDetectedAt.value
          : this.conflictDetectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressChangeTracker(')
          ..write('progressId: $progressId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      progressId,
      userId,
      localUpdatedAt,
      remoteUpdatedAt,
      lastSyncedAt,
      lastOperation,
      status,
      conflictReason,
      conflictPayload,
      conflictDetectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressChangeTracker &&
          other.progressId == this.progressId &&
          other.userId == this.userId &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastOperation == this.lastOperation &&
          other.status == this.status &&
          other.conflictReason == this.conflictReason &&
          other.conflictPayload == this.conflictPayload &&
          other.conflictDetectedAt == this.conflictDetectedAt);
}

class ProgressChangeTrackersCompanion
    extends UpdateCompanion<ProgressChangeTracker> {
  final Value<String> progressId;
  final Value<String> userId;
  final Value<int> localUpdatedAt;
  final Value<int> remoteUpdatedAt;
  final Value<int?> lastSyncedAt;
  final Value<String> lastOperation;
  final Value<String> status;
  final Value<String?> conflictReason;
  final Value<String?> conflictPayload;
  final Value<int?> conflictDetectedAt;
  final Value<int> rowid;
  const ProgressChangeTrackersCompanion({
    this.progressId = const Value.absent(),
    this.userId = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressChangeTrackersCompanion.insert({
    required String progressId,
    required String userId,
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : progressId = Value(progressId),
        userId = Value(userId);
  static Insertable<ProgressChangeTracker> custom({
    Expression<String>? progressId,
    Expression<String>? userId,
    Expression<int>? localUpdatedAt,
    Expression<int>? remoteUpdatedAt,
    Expression<int>? lastSyncedAt,
    Expression<String>? lastOperation,
    Expression<String>? status,
    Expression<String>? conflictReason,
    Expression<String>? conflictPayload,
    Expression<int>? conflictDetectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (progressId != null) 'progress_id': progressId,
      if (userId != null) 'user_id': userId,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastOperation != null) 'last_operation': lastOperation,
      if (status != null) 'status': status,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (conflictPayload != null) 'conflict_payload': conflictPayload,
      if (conflictDetectedAt != null)
        'conflict_detected_at': conflictDetectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressChangeTrackersCompanion copyWith(
      {Value<String>? progressId,
      Value<String>? userId,
      Value<int>? localUpdatedAt,
      Value<int>? remoteUpdatedAt,
      Value<int?>? lastSyncedAt,
      Value<String>? lastOperation,
      Value<String>? status,
      Value<String?>? conflictReason,
      Value<String?>? conflictPayload,
      Value<int?>? conflictDetectedAt,
      Value<int>? rowid}) {
    return ProgressChangeTrackersCompanion(
      progressId: progressId ?? this.progressId,
      userId: userId ?? this.userId,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastOperation: lastOperation ?? this.lastOperation,
      status: status ?? this.status,
      conflictReason: conflictReason ?? this.conflictReason,
      conflictPayload: conflictPayload ?? this.conflictPayload,
      conflictDetectedAt: conflictDetectedAt ?? this.conflictDetectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (progressId.present) {
      map['progress_id'] = Variable<String>(progressId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<int>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<int>(remoteUpdatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (lastOperation.present) {
      map['last_operation'] = Variable<String>(lastOperation.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (conflictPayload.present) {
      map['conflict_payload'] = Variable<String>(conflictPayload.value);
    }
    if (conflictDetectedAt.present) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressChangeTrackersCompanion(')
          ..write('progressId: $progressId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageChangeTrackersTable extends MessageChangeTrackers
    with TableInfo<$MessageChangeTrackersTable, MessageChangeTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageChangeTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES messages (id) ON DELETE CASCADE'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<int> localUpdatedAt = GeneratedColumn<int>(
      'local_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<int> remoteUpdatedAt = GeneratedColumn<int>(
      'remote_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastOperationMeta =
      const VerificationMeta('lastOperation');
  @override
  late final GeneratedColumn<String> lastOperation = GeneratedColumn<String>(
      'last_operation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('upsert'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _conflictReasonMeta =
      const VerificationMeta('conflictReason');
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
      'conflict_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictPayloadMeta =
      const VerificationMeta('conflictPayload');
  @override
  late final GeneratedColumn<String> conflictPayload = GeneratedColumn<String>(
      'conflict_payload', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictDetectedAtMeta =
      const VerificationMeta('conflictDetectedAt');
  @override
  late final GeneratedColumn<int> conflictDetectedAt = GeneratedColumn<int>(
      'conflict_detected_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        messageId,
        userId,
        localUpdatedAt,
        remoteUpdatedAt,
        lastSyncedAt,
        lastOperation,
        status,
        conflictReason,
        conflictPayload,
        conflictDetectedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_change_trackers';
  @override
  VerificationContext validateIntegrity(
      Insertable<MessageChangeTracker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('last_operation')) {
      context.handle(
          _lastOperationMeta,
          lastOperation.isAcceptableOrUnknown(
              data['last_operation']!, _lastOperationMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
          _conflictReasonMeta,
          conflictReason.isAcceptableOrUnknown(
              data['conflict_reason']!, _conflictReasonMeta));
    }
    if (data.containsKey('conflict_payload')) {
      context.handle(
          _conflictPayloadMeta,
          conflictPayload.isAcceptableOrUnknown(
              data['conflict_payload']!, _conflictPayloadMeta));
    }
    if (data.containsKey('conflict_detected_at')) {
      context.handle(
          _conflictDetectedAtMeta,
          conflictDetectedAt.isAcceptableOrUnknown(
              data['conflict_detected_at']!, _conflictDetectedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId};
  @override
  MessageChangeTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageChangeTracker(
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      localUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_updated_at'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_synced_at']),
      lastOperation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_operation'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      conflictReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conflict_reason']),
      conflictPayload: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conflict_payload']),
      conflictDetectedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}conflict_detected_at']),
    );
  }

  @override
  $MessageChangeTrackersTable createAlias(String alias) {
    return $MessageChangeTrackersTable(attachedDatabase, alias);
  }
}

class MessageChangeTracker extends DataClass
    implements Insertable<MessageChangeTracker> {
  final String messageId;
  final String userId;
  final int localUpdatedAt;
  final int remoteUpdatedAt;
  final int? lastSyncedAt;
  final String lastOperation;
  final String status;
  final String? conflictReason;
  final String? conflictPayload;
  final int? conflictDetectedAt;
  const MessageChangeTracker(
      {required this.messageId,
      required this.userId,
      required this.localUpdatedAt,
      required this.remoteUpdatedAt,
      this.lastSyncedAt,
      required this.lastOperation,
      required this.status,
      this.conflictReason,
      this.conflictPayload,
      this.conflictDetectedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['local_updated_at'] = Variable<int>(localUpdatedAt);
    map['remote_updated_at'] = Variable<int>(remoteUpdatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    map['last_operation'] = Variable<String>(lastOperation);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || conflictReason != null) {
      map['conflict_reason'] = Variable<String>(conflictReason);
    }
    if (!nullToAbsent || conflictPayload != null) {
      map['conflict_payload'] = Variable<String>(conflictPayload);
    }
    if (!nullToAbsent || conflictDetectedAt != null) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt);
    }
    return map;
  }

  MessageChangeTrackersCompanion toCompanion(bool nullToAbsent) {
    return MessageChangeTrackersCompanion(
      messageId: Value(messageId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      remoteUpdatedAt: Value(remoteUpdatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastOperation: Value(lastOperation),
      status: Value(status),
      conflictReason: conflictReason == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictReason),
      conflictPayload: conflictPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictPayload),
      conflictDetectedAt: conflictDetectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictDetectedAt),
    );
  }

  factory MessageChangeTracker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageChangeTracker(
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      localUpdatedAt: serializer.fromJson<int>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<int>(json['remoteUpdatedAt']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      lastOperation: serializer.fromJson<String>(json['lastOperation']),
      status: serializer.fromJson<String>(json['status']),
      conflictReason: serializer.fromJson<String?>(json['conflictReason']),
      conflictPayload: serializer.fromJson<String?>(json['conflictPayload']),
      conflictDetectedAt: serializer.fromJson<int?>(json['conflictDetectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'localUpdatedAt': serializer.toJson<int>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<int>(remoteUpdatedAt),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'lastOperation': serializer.toJson<String>(lastOperation),
      'status': serializer.toJson<String>(status),
      'conflictReason': serializer.toJson<String?>(conflictReason),
      'conflictPayload': serializer.toJson<String?>(conflictPayload),
      'conflictDetectedAt': serializer.toJson<int?>(conflictDetectedAt),
    };
  }

  MessageChangeTracker copyWith(
          {String? messageId,
          String? userId,
          int? localUpdatedAt,
          int? remoteUpdatedAt,
          Value<int?> lastSyncedAt = const Value.absent(),
          String? lastOperation,
          String? status,
          Value<String?> conflictReason = const Value.absent(),
          Value<String?> conflictPayload = const Value.absent(),
          Value<int?> conflictDetectedAt = const Value.absent()}) =>
      MessageChangeTracker(
        messageId: messageId ?? this.messageId,
        userId: userId ?? this.userId,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        lastOperation: lastOperation ?? this.lastOperation,
        status: status ?? this.status,
        conflictReason:
            conflictReason.present ? conflictReason.value : this.conflictReason,
        conflictPayload: conflictPayload.present
            ? conflictPayload.value
            : this.conflictPayload,
        conflictDetectedAt: conflictDetectedAt.present
            ? conflictDetectedAt.value
            : this.conflictDetectedAt,
      );
  MessageChangeTracker copyWithCompanion(MessageChangeTrackersCompanion data) {
    return MessageChangeTracker(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastOperation: data.lastOperation.present
          ? data.lastOperation.value
          : this.lastOperation,
      status: data.status.present ? data.status.value : this.status,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      conflictPayload: data.conflictPayload.present
          ? data.conflictPayload.value
          : this.conflictPayload,
      conflictDetectedAt: data.conflictDetectedAt.present
          ? data.conflictDetectedAt.value
          : this.conflictDetectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageChangeTracker(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      messageId,
      userId,
      localUpdatedAt,
      remoteUpdatedAt,
      lastSyncedAt,
      lastOperation,
      status,
      conflictReason,
      conflictPayload,
      conflictDetectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageChangeTracker &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastOperation == this.lastOperation &&
          other.status == this.status &&
          other.conflictReason == this.conflictReason &&
          other.conflictPayload == this.conflictPayload &&
          other.conflictDetectedAt == this.conflictDetectedAt);
}

class MessageChangeTrackersCompanion
    extends UpdateCompanion<MessageChangeTracker> {
  final Value<String> messageId;
  final Value<String> userId;
  final Value<int> localUpdatedAt;
  final Value<int> remoteUpdatedAt;
  final Value<int?> lastSyncedAt;
  final Value<String> lastOperation;
  final Value<String> status;
  final Value<String?> conflictReason;
  final Value<String?> conflictPayload;
  final Value<int?> conflictDetectedAt;
  final Value<int> rowid;
  const MessageChangeTrackersCompanion({
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageChangeTrackersCompanion.insert({
    required String messageId,
    required String userId,
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastOperation = const Value.absent(),
    this.status = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.conflictPayload = const Value.absent(),
    this.conflictDetectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : messageId = Value(messageId),
        userId = Value(userId);
  static Insertable<MessageChangeTracker> custom({
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<int>? localUpdatedAt,
    Expression<int>? remoteUpdatedAt,
    Expression<int>? lastSyncedAt,
    Expression<String>? lastOperation,
    Expression<String>? status,
    Expression<String>? conflictReason,
    Expression<String>? conflictPayload,
    Expression<int>? conflictDetectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastOperation != null) 'last_operation': lastOperation,
      if (status != null) 'status': status,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (conflictPayload != null) 'conflict_payload': conflictPayload,
      if (conflictDetectedAt != null)
        'conflict_detected_at': conflictDetectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageChangeTrackersCompanion copyWith(
      {Value<String>? messageId,
      Value<String>? userId,
      Value<int>? localUpdatedAt,
      Value<int>? remoteUpdatedAt,
      Value<int?>? lastSyncedAt,
      Value<String>? lastOperation,
      Value<String>? status,
      Value<String?>? conflictReason,
      Value<String?>? conflictPayload,
      Value<int?>? conflictDetectedAt,
      Value<int>? rowid}) {
    return MessageChangeTrackersCompanion(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastOperation: lastOperation ?? this.lastOperation,
      status: status ?? this.status,
      conflictReason: conflictReason ?? this.conflictReason,
      conflictPayload: conflictPayload ?? this.conflictPayload,
      conflictDetectedAt: conflictDetectedAt ?? this.conflictDetectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<int>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<int>(remoteUpdatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (lastOperation.present) {
      map['last_operation'] = Variable<String>(lastOperation.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (conflictPayload.present) {
      map['conflict_payload'] = Variable<String>(conflictPayload.value);
    }
    if (conflictDetectedAt.present) {
      map['conflict_detected_at'] = Variable<int>(conflictDetectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageChangeTrackersCompanion(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastOperation: $lastOperation, ')
          ..write('status: $status, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('conflictPayload: $conflictPayload, ')
          ..write('conflictDetectedAt: $conflictDetectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $HighlightsTable highlights = $HighlightsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $NoteRevisionsTable noteRevisions = $NoteRevisionsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $LessonObjectivesTable lessonObjectives =
      $LessonObjectivesTable(this);
  late final $LessonScripturesTable lessonScriptures =
      $LessonScripturesTable(this);
  late final $LessonAttachmentsTable lessonAttachments =
      $LessonAttachmentsTable(this);
  late final $LessonQuizzesTable lessonQuizzes = $LessonQuizzesTable(this);
  late final $LessonQuizOptionsTable lessonQuizOptions =
      $LessonQuizOptionsTable(this);
  late final $LessonDraftsTable lessonDrafts = $LessonDraftsTable(this);
  late final $LessonFeedsTable lessonFeeds = $LessonFeedsTable(this);
  late final $LessonSourcesTable lessonSources = $LessonSourcesTable(this);
  late final $RoundtableEventsTable roundtableEvents =
      $RoundtableEventsTable(this);
  late final $MeetingLinksTable meetingLinks = $MeetingLinksTable(this);
  late final $DiscussionThreadsTable discussionThreads =
      $DiscussionThreadsTable(this);
  late final $DiscussionPostsTable discussionPosts =
      $DiscussionPostsTable(this);
  late final $ProgressTable progress = $ProgressTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $TypingIndicatorsTable typingIndicators =
      $TypingIndicatorsTable(this);
  late final $ModerationActionsTableTable moderationActionsTable =
      $ModerationActionsTableTable(this);
  late final $ModerationAppealsTableTable moderationAppealsTable =
      $ModerationAppealsTableTable(this);
  late final $NoteChangeTrackersTable noteChangeTrackers =
      $NoteChangeTrackersTable(this);
  late final $ProgressChangeTrackersTable progressChangeTrackers =
      $ProgressChangeTrackersTable(this);
  late final $MessageChangeTrackersTable messageChangeTrackers =
      $MessageChangeTrackersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        translations,
        verses,
        localUsers,
        bookmarks,
        highlights,
        notes,
        noteRevisions,
        lessons,
        lessonObjectives,
        lessonScriptures,
        lessonAttachments,
        lessonQuizzes,
        lessonQuizOptions,
        lessonDrafts,
        lessonFeeds,
        lessonSources,
        roundtableEvents,
        meetingLinks,
        discussionThreads,
        discussionPosts,
        progress,
        syncQueue,
        messages,
        typingIndicators,
        moderationActionsTable,
        moderationAppealsTable,
        noteChangeTrackers,
        progressChangeTrackers,
        messageChangeTrackers
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('translations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('verses', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('local_users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('bookmarks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('translations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('bookmarks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('local_users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('highlights', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('translations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('highlights', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('local_users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('notes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('translations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('notes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('notes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('note_revisions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lessons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lesson_objectives', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lessons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lesson_scriptures', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lessons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lesson_attachments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lessons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lesson_quizzes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lesson_quizzes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lesson_quiz_options', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('discussion_threads',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('discussion_posts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lessons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('progress', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('moderation_actions_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('moderation_appeals_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('messages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('message_change_trackers', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$TranslationsTableCreateCompanionBuilder = TranslationsCompanion
    Function({
  required String id,
  required String name,
  required String language,
  Value<String> languageName,
  required String version,
  Value<String> copyright,
  Value<String?> source,
  required int installedAt,
  Value<int> rowid,
});
typedef $$TranslationsTableUpdateCompanionBuilder = TranslationsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> language,
  Value<String> languageName,
  Value<String> version,
  Value<String> copyright,
  Value<String?> source,
  Value<int> installedAt,
  Value<int> rowid,
});

final class $$TranslationsTableReferences
    extends BaseReferences<_$AppDatabase, $TranslationsTable, Translation> {
  $$TranslationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VersesTable, List<VerseRow>> _versesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.verses,
          aliasName: $_aliasNameGenerator(
              db.translations.id, db.verses.translationId));

  $$VersesTableProcessedTableManager get versesRefs {
    final manager = $$VersesTableTableManager($_db, $_db.verses).filter(
        (f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_versesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BookmarksTable, List<BookmarkRow>>
      _bookmarksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.bookmarks,
              aliasName: $_aliasNameGenerator(
                  db.translations.id, db.bookmarks.translationId));

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager($_db, $_db.bookmarks).filter(
        (f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HighlightsTable, List<HighlightRow>>
      _highlightsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.highlights,
              aliasName: $_aliasNameGenerator(
                  db.translations.id, db.highlights.translationId));

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager($_db, $_db.highlights).filter(
        (f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.notes,
          aliasName:
              $_aliasNameGenerator(db.translations.id, db.notes.translationId));

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager($_db, $_db.notes).filter(
        (f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageName => $composableBuilder(
      column: $table.languageName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get copyright => $composableBuilder(
      column: $table.copyright, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> versesRefs(
      Expression<bool> Function($$VersesTableFilterComposer f) f) {
    final $$VersesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.verses,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VersesTableFilterComposer(
              $db: $db,
              $table: $db.verses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
      Expression<bool> Function($$BookmarksTableFilterComposer f) f) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableFilterComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> highlightsRefs(
      Expression<bool> Function($$HighlightsTableFilterComposer f) f) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.highlights,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HighlightsTableFilterComposer(
              $db: $db,
              $table: $db.highlights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notesRefs(
      Expression<bool> Function($$NotesTableFilterComposer f) f) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableFilterComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageName => $composableBuilder(
      column: $table.languageName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get copyright => $composableBuilder(
      column: $table.copyright, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => ColumnOrderings(column));
}

class $$TranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get languageName => $composableBuilder(
      column: $table.languageName, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get copyright =>
      $composableBuilder(column: $table.copyright, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => column);

  Expression<T> versesRefs<T extends Object>(
      Expression<T> Function($$VersesTableAnnotationComposer a) f) {
    final $$VersesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.verses,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VersesTableAnnotationComposer(
              $db: $db,
              $table: $db.verses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
      Expression<T> Function($$BookmarksTableAnnotationComposer a) f) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
      Expression<T> Function($$HighlightsTableAnnotationComposer a) f) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.highlights,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HighlightsTableAnnotationComposer(
              $db: $db,
              $table: $db.highlights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
      Expression<T> Function($$NotesTableAnnotationComposer a) f) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.translationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableAnnotationComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranslationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (Translation, $$TranslationsTableReferences),
    Translation,
    PrefetchHooks Function(
        {bool versesRefs,
        bool bookmarksRefs,
        bool highlightsRefs,
        bool notesRefs})> {
  $$TranslationsTableTableManager(_$AppDatabase db, $TranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> languageName = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> copyright = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<int> installedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranslationsCompanion(
            id: id,
            name: name,
            language: language,
            languageName: languageName,
            version: version,
            copyright: copyright,
            source: source,
            installedAt: installedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String language,
            Value<String> languageName = const Value.absent(),
            required String version,
            Value<String> copyright = const Value.absent(),
            Value<String?> source = const Value.absent(),
            required int installedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TranslationsCompanion.insert(
            id: id,
            name: name,
            language: language,
            languageName: languageName,
            version: version,
            copyright: copyright,
            source: source,
            installedAt: installedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TranslationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {versesRefs = false,
              bookmarksRefs = false,
              highlightsRefs = false,
              notesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (versesRefs) db.verses,
                if (bookmarksRefs) db.bookmarks,
                if (highlightsRefs) db.highlights,
                if (notesRefs) db.notes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (versesRefs)
                    await $_getPrefetchedData<Translation, $TranslationsTable,
                            VerseRow>(
                        currentTable: table,
                        referencedTable:
                            $$TranslationsTableReferences._versesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranslationsTableReferences(db, table, p0)
                                .versesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.translationId == item.id),
                        typedResults: items),
                  if (bookmarksRefs)
                    await $_getPrefetchedData<Translation, $TranslationsTable,
                            BookmarkRow>(
                        currentTable: table,
                        referencedTable: $$TranslationsTableReferences
                            ._bookmarksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranslationsTableReferences(db, table, p0)
                                .bookmarksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.translationId == item.id),
                        typedResults: items),
                  if (highlightsRefs)
                    await $_getPrefetchedData<Translation, $TranslationsTable,
                            HighlightRow>(
                        currentTable: table,
                        referencedTable: $$TranslationsTableReferences
                            ._highlightsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranslationsTableReferences(db, table, p0)
                                .highlightsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.translationId == item.id),
                        typedResults: items),
                  if (notesRefs)
                    await $_getPrefetchedData<Translation, $TranslationsTable,
                            NoteRow>(
                        currentTable: table,
                        referencedTable:
                            $$TranslationsTableReferences._notesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranslationsTableReferences(db, table, p0)
                                .notesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.translationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TranslationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (Translation, $$TranslationsTableReferences),
    Translation,
    PrefetchHooks Function(
        {bool versesRefs,
        bool bookmarksRefs,
        bool highlightsRefs,
        bool notesRefs})>;
typedef $$VersesTableCreateCompanionBuilder = VersesCompanion Function({
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  required String verseText,
  Value<int> rowid,
});
typedef $$VersesTableUpdateCompanionBuilder = VersesCompanion Function({
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<String> verseText,
  Value<int> rowid,
});

final class $$VersesTableReferences
    extends BaseReferences<_$AppDatabase, $VersesTable, VerseRow> {
  $$VersesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TranslationsTable _translationIdTable(_$AppDatabase db) =>
      db.translations.createAlias(
          $_aliasNameGenerator(db.verses.translationId, db.translations.id));

  $$TranslationsTableProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $$TranslationsTableTableManager($_db, $_db.translations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$VersesTableFilterComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnFilters(column));

  $$TranslationsTableFilterComposer get translationId {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableFilterComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VersesTableOrderingComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnOrderings(column));

  $$TranslationsTableOrderingComposer get translationId {
    final $$TranslationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableOrderingComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  $$TranslationsTableAnnotationComposer get translationId {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableAnnotationComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VersesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VersesTable,
    VerseRow,
    $$VersesTableFilterComposer,
    $$VersesTableOrderingComposer,
    $$VersesTableAnnotationComposer,
    $$VersesTableCreateCompanionBuilder,
    $$VersesTableUpdateCompanionBuilder,
    (VerseRow, $$VersesTableReferences),
    VerseRow,
    PrefetchHooks Function({bool translationId})> {
  $$VersesTableTableManager(_$AppDatabase db, $VersesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> translationId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<String> verseText = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VersesCompanion(
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            verseText: verseText,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String translationId,
            required int bookId,
            required int chapter,
            required int verse,
            required String verseText,
            Value<int> rowid = const Value.absent(),
          }) =>
              VersesCompanion.insert(
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            verseText: verseText,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VersesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({translationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (translationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.translationId,
                    referencedTable:
                        $$VersesTableReferences._translationIdTable(db),
                    referencedColumn:
                        $$VersesTableReferences._translationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$VersesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VersesTable,
    VerseRow,
    $$VersesTableFilterComposer,
    $$VersesTableOrderingComposer,
    $$VersesTableAnnotationComposer,
    $$VersesTableCreateCompanionBuilder,
    $$VersesTableUpdateCompanionBuilder,
    (VerseRow, $$VersesTableReferences),
    VerseRow,
    PrefetchHooks Function({bool translationId})>;
typedef $$LocalUsersTableCreateCompanionBuilder = LocalUsersCompanion Function({
  required String id,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> preferredCohortId,
  Value<String?> preferredCohortTitle,
  Value<String?> preferredLessonClass,
  Value<String> roles,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$LocalUsersTableUpdateCompanionBuilder = LocalUsersCompanion Function({
  Value<String> id,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> preferredCohortId,
  Value<String?> preferredCohortTitle,
  Value<String?> preferredLessonClass,
  Value<String> roles,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$LocalUsersTableReferences
    extends BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser> {
  $$LocalUsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookmarksTable, List<BookmarkRow>>
      _bookmarksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.bookmarks,
              aliasName:
                  $_aliasNameGenerator(db.localUsers.id, db.bookmarks.userId));

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager($_db, $_db.bookmarks)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HighlightsTable, List<HighlightRow>>
      _highlightsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.highlights,
              aliasName:
                  $_aliasNameGenerator(db.localUsers.id, db.highlights.userId));

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager($_db, $_db.highlights)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.notes,
          aliasName: $_aliasNameGenerator(db.localUsers.id, db.notes.userId));

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager($_db, $_db.notes)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredCohortId => $composableBuilder(
      column: $table.preferredCohortId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredCohortTitle => $composableBuilder(
      column: $table.preferredCohortTitle,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredLessonClass => $composableBuilder(
      column: $table.preferredLessonClass,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roles => $composableBuilder(
      column: $table.roles, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> bookmarksRefs(
      Expression<bool> Function($$BookmarksTableFilterComposer f) f) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableFilterComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> highlightsRefs(
      Expression<bool> Function($$HighlightsTableFilterComposer f) f) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.highlights,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HighlightsTableFilterComposer(
              $db: $db,
              $table: $db.highlights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notesRefs(
      Expression<bool> Function($$NotesTableFilterComposer f) f) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableFilterComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredCohortId => $composableBuilder(
      column: $table.preferredCohortId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredCohortTitle => $composableBuilder(
      column: $table.preferredCohortTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredLessonClass => $composableBuilder(
      column: $table.preferredLessonClass,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roles => $composableBuilder(
      column: $table.roles, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get preferredCohortId => $composableBuilder(
      column: $table.preferredCohortId, builder: (column) => column);

  GeneratedColumn<String> get preferredCohortTitle => $composableBuilder(
      column: $table.preferredCohortTitle, builder: (column) => column);

  GeneratedColumn<String> get preferredLessonClass => $composableBuilder(
      column: $table.preferredLessonClass, builder: (column) => column);

  GeneratedColumn<String> get roles =>
      $composableBuilder(column: $table.roles, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> bookmarksRefs<T extends Object>(
      Expression<T> Function($$BookmarksTableAnnotationComposer a) f) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
      Expression<T> Function($$HighlightsTableAnnotationComposer a) f) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.highlights,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HighlightsTableAnnotationComposer(
              $db: $db,
              $table: $db.highlights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
      Expression<T> Function($$NotesTableAnnotationComposer a) f) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableAnnotationComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LocalUsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalUsersTable,
    LocalUser,
    $$LocalUsersTableFilterComposer,
    $$LocalUsersTableOrderingComposer,
    $$LocalUsersTableAnnotationComposer,
    $$LocalUsersTableCreateCompanionBuilder,
    $$LocalUsersTableUpdateCompanionBuilder,
    (LocalUser, $$LocalUsersTableReferences),
    LocalUser,
    PrefetchHooks Function(
        {bool bookmarksRefs, bool highlightsRefs, bool notesRefs})> {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> preferredCohortId = const Value.absent(),
            Value<String?> preferredCohortTitle = const Value.absent(),
            Value<String?> preferredLessonClass = const Value.absent(),
            Value<String> roles = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalUsersCompanion(
            id: id,
            displayName: displayName,
            avatarUrl: avatarUrl,
            preferredCohortId: preferredCohortId,
            preferredCohortTitle: preferredCohortTitle,
            preferredLessonClass: preferredLessonClass,
            roles: roles,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> preferredCohortId = const Value.absent(),
            Value<String?> preferredCohortTitle = const Value.absent(),
            Value<String?> preferredLessonClass = const Value.absent(),
            Value<String> roles = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalUsersCompanion.insert(
            id: id,
            displayName: displayName,
            avatarUrl: avatarUrl,
            preferredCohortId: preferredCohortId,
            preferredCohortTitle: preferredCohortTitle,
            preferredLessonClass: preferredLessonClass,
            roles: roles,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LocalUsersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {bookmarksRefs = false,
              highlightsRefs = false,
              notesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bookmarksRefs) db.bookmarks,
                if (highlightsRefs) db.highlights,
                if (notesRefs) db.notes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookmarksRefs)
                    await $_getPrefetchedData<LocalUser, $LocalUsersTable,
                            BookmarkRow>(
                        currentTable: table,
                        referencedTable:
                            $$LocalUsersTableReferences._bookmarksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LocalUsersTableReferences(db, table, p0)
                                .bookmarksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (highlightsRefs)
                    await $_getPrefetchedData<LocalUser, $LocalUsersTable,
                            HighlightRow>(
                        currentTable: table,
                        referencedTable: $$LocalUsersTableReferences
                            ._highlightsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LocalUsersTableReferences(db, table, p0)
                                .highlightsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (notesRefs)
                    await $_getPrefetchedData<LocalUser, $LocalUsersTable,
                            NoteRow>(
                        currentTable: table,
                        referencedTable:
                            $$LocalUsersTableReferences._notesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LocalUsersTableReferences(db, table, p0)
                                .notesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LocalUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalUsersTable,
    LocalUser,
    $$LocalUsersTableFilterComposer,
    $$LocalUsersTableOrderingComposer,
    $$LocalUsersTableAnnotationComposer,
    $$LocalUsersTableCreateCompanionBuilder,
    $$LocalUsersTableUpdateCompanionBuilder,
    (LocalUser, $$LocalUsersTableReferences),
    LocalUser,
    PrefetchHooks Function(
        {bool bookmarksRefs, bool highlightsRefs, bool notesRefs})>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String id,
  Value<String> userId,
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  required int createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkRow> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalUsersTable _userIdTable(_$AppDatabase db) => db.localUsers
      .createAlias($_aliasNameGenerator(db.bookmarks.userId, db.localUsers.id));

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager($_db, $_db.localUsers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TranslationsTable _translationIdTable(_$AppDatabase db) =>
      db.translations.createAlias(
          $_aliasNameGenerator(db.bookmarks.translationId, db.translations.id));

  $$TranslationsTableProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $$TranslationsTableTableManager($_db, $_db.translations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableFilterComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableFilterComposer get translationId {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableFilterComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableOrderingComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableOrderingComposer get translationId {
    final $$TranslationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableOrderingComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableAnnotationComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableAnnotationComposer get translationId {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableAnnotationComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarkRow,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (BookmarkRow, $$BookmarksTableReferences),
    BookmarkRow,
    PrefetchHooks Function({bool userId, bool translationId})> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> translationId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> userId = const Value.absent(),
            required String translationId,
            required int bookId,
            required int chapter,
            required int verse,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BookmarksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, translationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$BookmarksTableReferences._userIdTable(db),
                    referencedColumn:
                        $$BookmarksTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (translationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.translationId,
                    referencedTable:
                        $$BookmarksTableReferences._translationIdTable(db),
                    referencedColumn:
                        $$BookmarksTableReferences._translationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarkRow,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (BookmarkRow, $$BookmarksTableReferences),
    BookmarkRow,
    PrefetchHooks Function({bool userId, bool translationId})>;
typedef $$HighlightsTableCreateCompanionBuilder = HighlightsCompanion Function({
  required String id,
  Value<String> userId,
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  required String colour,
  required int createdAt,
  Value<int> rowid,
});
typedef $$HighlightsTableUpdateCompanionBuilder = HighlightsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<String> colour,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$HighlightsTableReferences
    extends BaseReferences<_$AppDatabase, $HighlightsTable, HighlightRow> {
  $$HighlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalUsersTable _userIdTable(_$AppDatabase db) =>
      db.localUsers.createAlias(
          $_aliasNameGenerator(db.highlights.userId, db.localUsers.id));

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager($_db, $_db.localUsers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TranslationsTable _translationIdTable(_$AppDatabase db) =>
      db.translations.createAlias($_aliasNameGenerator(
          db.highlights.translationId, db.translations.id));

  $$TranslationsTableProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $$TranslationsTableTableManager($_db, $_db.translations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colour => $composableBuilder(
      column: $table.colour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableFilterComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableFilterComposer get translationId {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableFilterComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colour => $composableBuilder(
      column: $table.colour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableOrderingComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableOrderingComposer get translationId {
    final $$TranslationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableOrderingComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableAnnotationComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableAnnotationComposer get translationId {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableAnnotationComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HighlightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HighlightsTable,
    HighlightRow,
    $$HighlightsTableFilterComposer,
    $$HighlightsTableOrderingComposer,
    $$HighlightsTableAnnotationComposer,
    $$HighlightsTableCreateCompanionBuilder,
    $$HighlightsTableUpdateCompanionBuilder,
    (HighlightRow, $$HighlightsTableReferences),
    HighlightRow,
    PrefetchHooks Function({bool userId, bool translationId})> {
  $$HighlightsTableTableManager(_$AppDatabase db, $HighlightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> translationId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<String> colour = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HighlightsCompanion(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            colour: colour,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> userId = const Value.absent(),
            required String translationId,
            required int bookId,
            required int chapter,
            required int verse,
            required String colour,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HighlightsCompanion.insert(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            colour: colour,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HighlightsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, translationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$HighlightsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$HighlightsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (translationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.translationId,
                    referencedTable:
                        $$HighlightsTableReferences._translationIdTable(db),
                    referencedColumn:
                        $$HighlightsTableReferences._translationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HighlightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HighlightsTable,
    HighlightRow,
    $$HighlightsTableFilterComposer,
    $$HighlightsTableOrderingComposer,
    $$HighlightsTableAnnotationComposer,
    $$HighlightsTableCreateCompanionBuilder,
    $$HighlightsTableUpdateCompanionBuilder,
    (HighlightRow, $$HighlightsTableReferences),
    HighlightRow,
    PrefetchHooks Function({bool userId, bool translationId})>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  Value<String> userId,
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  required String noteText,
  Value<int> version,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<String> noteText,
  Value<int> version,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NoteRow> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalUsersTable _userIdTable(_$AppDatabase db) => db.localUsers
      .createAlias($_aliasNameGenerator(db.notes.userId, db.localUsers.id));

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager($_db, $_db.localUsers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TranslationsTable _translationIdTable(_$AppDatabase db) =>
      db.translations.createAlias(
          $_aliasNameGenerator(db.notes.translationId, db.translations.id));

  $$TranslationsTableProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $$TranslationsTableTableManager($_db, $_db.translations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$NoteRevisionsTable, List<NoteRevisionRow>>
      _noteRevisionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.noteRevisions,
              aliasName:
                  $_aliasNameGenerator(db.notes.id, db.noteRevisions.noteId));

  $$NoteRevisionsTableProcessedTableManager get noteRevisionsRefs {
    final manager = $$NoteRevisionsTableTableManager($_db, $_db.noteRevisions)
        .filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteRevisionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NoteChangeTrackersTable, List<NoteChangeTracker>>
      _noteChangeTrackersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.noteChangeTrackers,
              aliasName: $_aliasNameGenerator(
                  db.notes.id, db.noteChangeTrackers.noteId));

  $$NoteChangeTrackersTableProcessedTableManager get noteChangeTrackersRefs {
    final manager =
        $$NoteChangeTrackersTableTableManager($_db, $_db.noteChangeTrackers)
            .filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_noteChangeTrackersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableFilterComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableFilterComposer get translationId {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableFilterComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> noteRevisionsRefs(
      Expression<bool> Function($$NoteRevisionsTableFilterComposer f) f) {
    final $$NoteRevisionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteRevisions,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteRevisionsTableFilterComposer(
              $db: $db,
              $table: $db.noteRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> noteChangeTrackersRefs(
      Expression<bool> Function($$NoteChangeTrackersTableFilterComposer f) f) {
    final $$NoteChangeTrackersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteChangeTrackers,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteChangeTrackersTableFilterComposer(
              $db: $db,
              $table: $db.noteChangeTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableOrderingComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableOrderingComposer get translationId {
    final $$TranslationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableOrderingComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.localUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocalUsersTableAnnotationComposer(
              $db: $db,
              $table: $db.localUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TranslationsTableAnnotationComposer get translationId {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.translationId,
        referencedTable: $db.translations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslationsTableAnnotationComposer(
              $db: $db,
              $table: $db.translations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> noteRevisionsRefs<T extends Object>(
      Expression<T> Function($$NoteRevisionsTableAnnotationComposer a) f) {
    final $$NoteRevisionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteRevisions,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteRevisionsTableAnnotationComposer(
              $db: $db,
              $table: $db.noteRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> noteChangeTrackersRefs<T extends Object>(
      Expression<T> Function($$NoteChangeTrackersTableAnnotationComposer a) f) {
    final $$NoteChangeTrackersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.noteChangeTrackers,
            getReferencedColumn: (t) => t.noteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NoteChangeTrackersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.noteChangeTrackers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, $$NotesTableReferences),
    NoteRow,
    PrefetchHooks Function(
        {bool userId,
        bool translationId,
        bool noteRevisionsRefs,
        bool noteChangeTrackersRefs})> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> translationId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<String> noteText = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            noteText: noteText,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> userId = const Value.absent(),
            required String translationId,
            required int bookId,
            required int chapter,
            required int verse,
            required String noteText,
            Value<int> version = const Value.absent(),
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            userId: userId,
            translationId: translationId,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            noteText: noteText,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$NotesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {userId = false,
              translationId = false,
              noteRevisionsRefs = false,
              noteChangeTrackersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (noteRevisionsRefs) db.noteRevisions,
                if (noteChangeTrackersRefs) db.noteChangeTrackers
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$NotesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$NotesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (translationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.translationId,
                    referencedTable:
                        $$NotesTableReferences._translationIdTable(db),
                    referencedColumn:
                        $$NotesTableReferences._translationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteRevisionsRefs)
                    await $_getPrefetchedData<NoteRow, $NotesTable,
                            NoteRevisionRow>(
                        currentTable: table,
                        referencedTable:
                            $$NotesTableReferences._noteRevisionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NotesTableReferences(db, table, p0)
                                .noteRevisionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.noteId == item.id),
                        typedResults: items),
                  if (noteChangeTrackersRefs)
                    await $_getPrefetchedData<NoteRow, $NotesTable,
                            NoteChangeTracker>(
                        currentTable: table,
                        referencedTable: $$NotesTableReferences
                            ._noteChangeTrackersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NotesTableReferences(db, table, p0)
                                .noteChangeTrackersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.noteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, $$NotesTableReferences),
    NoteRow,
    PrefetchHooks Function(
        {bool userId,
        bool translationId,
        bool noteRevisionsRefs,
        bool noteChangeTrackersRefs})>;
typedef $$NoteRevisionsTableCreateCompanionBuilder = NoteRevisionsCompanion
    Function({
  required String noteId,
  required int version,
  required String revisionText,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$NoteRevisionsTableUpdateCompanionBuilder = NoteRevisionsCompanion
    Function({
  Value<String> noteId,
  Value<int> version,
  Value<String> revisionText,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$NoteRevisionsTableReferences extends BaseReferences<_$AppDatabase,
    $NoteRevisionsTable, NoteRevisionRow> {
  $$NoteRevisionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) => db.notes
      .createAlias($_aliasNameGenerator(db.noteRevisions.noteId, db.notes.id));

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager($_db, $_db.notes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NoteRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revisionText => $composableBuilder(
      column: $table.revisionText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableFilterComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revisionText => $composableBuilder(
      column: $table.revisionText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableOrderingComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteRevisionsTable> {
  $$NoteRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get revisionText => $composableBuilder(
      column: $table.revisionText, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableAnnotationComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteRevisionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteRevisionsTable,
    NoteRevisionRow,
    $$NoteRevisionsTableFilterComposer,
    $$NoteRevisionsTableOrderingComposer,
    $$NoteRevisionsTableAnnotationComposer,
    $$NoteRevisionsTableCreateCompanionBuilder,
    $$NoteRevisionsTableUpdateCompanionBuilder,
    (NoteRevisionRow, $$NoteRevisionsTableReferences),
    NoteRevisionRow,
    PrefetchHooks Function({bool noteId})> {
  $$NoteRevisionsTableTableManager(_$AppDatabase db, $NoteRevisionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteRevisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteRevisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> noteId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String> revisionText = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteRevisionsCompanion(
            noteId: noteId,
            version: version,
            revisionText: revisionText,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String noteId,
            required int version,
            required String revisionText,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteRevisionsCompanion.insert(
            noteId: noteId,
            version: version,
            revisionText: revisionText,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NoteRevisionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (noteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.noteId,
                    referencedTable:
                        $$NoteRevisionsTableReferences._noteIdTable(db),
                    referencedColumn:
                        $$NoteRevisionsTableReferences._noteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NoteRevisionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteRevisionsTable,
    NoteRevisionRow,
    $$NoteRevisionsTableFilterComposer,
    $$NoteRevisionsTableOrderingComposer,
    $$NoteRevisionsTableAnnotationComposer,
    $$NoteRevisionsTableCreateCompanionBuilder,
    $$NoteRevisionsTableUpdateCompanionBuilder,
    (NoteRevisionRow, $$NoteRevisionsTableReferences),
    NoteRevisionRow,
    PrefetchHooks Function({bool noteId})>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String title,
  required String lessonClass,
  Value<int?> ageMin,
  Value<int?> ageMax,
  Value<String?> objectives,
  Value<String?> scriptures,
  Value<String?> contentHtml,
  Value<String?> teacherNotes,
  Value<String?> attachments,
  Value<String?> quizzes,
  Value<String?> sourceUrl,
  Value<int?> lastFetchedAt,
  Value<String?> feedId,
  Value<String?> cohortId,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> lessonClass,
  Value<int?> ageMin,
  Value<int?> ageMax,
  Value<String?> objectives,
  Value<String?> scriptures,
  Value<String?> contentHtml,
  Value<String?> teacherNotes,
  Value<String?> attachments,
  Value<String?> quizzes,
  Value<String?> sourceUrl,
  Value<int?> lastFetchedAt,
  Value<String?> feedId,
  Value<String?> cohortId,
  Value<int> rowid,
});

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, LessonRow> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LessonObjectivesTable, List<LessonObjectiveRow>>
      _lessonObjectivesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonObjectives,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonObjectives.lessonId));

  $$LessonObjectivesTableProcessedTableManager get lessonObjectivesRefs {
    final manager = $$LessonObjectivesTableTableManager(
            $_db, $_db.lessonObjectives)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonObjectivesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonScripturesTable, List<LessonScriptureRow>>
      _lessonScripturesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonScriptures,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonScriptures.lessonId));

  $$LessonScripturesTableProcessedTableManager get lessonScripturesRefs {
    final manager = $$LessonScripturesTableTableManager(
            $_db, $_db.lessonScriptures)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonScripturesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonAttachmentsTable, List<LessonAttachmentRow>>
      _lessonAttachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonAttachments,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonAttachments.lessonId));

  $$LessonAttachmentsTableProcessedTableManager get lessonAttachmentsRefs {
    final manager = $$LessonAttachmentsTableTableManager(
            $_db, $_db.lessonAttachments)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonAttachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonQuizzesTable, List<LessonQuizRow>>
      _lessonQuizzesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonQuizzes,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonQuizzes.lessonId));

  $$LessonQuizzesTableProcessedTableManager get lessonQuizzesRefs {
    final manager = $$LessonQuizzesTableTableManager($_db, $_db.lessonQuizzes)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonQuizzesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProgressTable, List<ProgressData>>
      _progressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.progress,
          aliasName: $_aliasNameGenerator(db.lessons.id, db.progress.lessonId));

  $$ProgressTableProcessedTableManager get progressRefs {
    final manager = $$ProgressTableTableManager($_db, $_db.progress)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_progressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ageMin => $composableBuilder(
      column: $table.ageMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ageMax => $composableBuilder(
      column: $table.ageMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scriptures => $composableBuilder(
      column: $table.scriptures, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get teacherNotes => $composableBuilder(
      column: $table.teacherNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quizzes => $composableBuilder(
      column: $table.quizzes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feedId => $composableBuilder(
      column: $table.feedId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cohortId => $composableBuilder(
      column: $table.cohortId, builder: (column) => ColumnFilters(column));

  Expression<bool> lessonObjectivesRefs(
      Expression<bool> Function($$LessonObjectivesTableFilterComposer f) f) {
    final $$LessonObjectivesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonObjectives,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonObjectivesTableFilterComposer(
              $db: $db,
              $table: $db.lessonObjectives,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonScripturesRefs(
      Expression<bool> Function($$LessonScripturesTableFilterComposer f) f) {
    final $$LessonScripturesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonScriptures,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonScripturesTableFilterComposer(
              $db: $db,
              $table: $db.lessonScriptures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonAttachmentsRefs(
      Expression<bool> Function($$LessonAttachmentsTableFilterComposer f) f) {
    final $$LessonAttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonAttachments,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonAttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.lessonAttachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonQuizzesRefs(
      Expression<bool> Function($$LessonQuizzesTableFilterComposer f) f) {
    final $$LessonQuizzesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonQuizzes,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizzesTableFilterComposer(
              $db: $db,
              $table: $db.lessonQuizzes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> progressRefs(
      Expression<bool> Function($$ProgressTableFilterComposer f) f) {
    final $$ProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.progress,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgressTableFilterComposer(
              $db: $db,
              $table: $db.progress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ageMin => $composableBuilder(
      column: $table.ageMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ageMax => $composableBuilder(
      column: $table.ageMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scriptures => $composableBuilder(
      column: $table.scriptures, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get teacherNotes => $composableBuilder(
      column: $table.teacherNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quizzes => $composableBuilder(
      column: $table.quizzes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feedId => $composableBuilder(
      column: $table.feedId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cohortId => $composableBuilder(
      column: $table.cohortId, builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => column);

  GeneratedColumn<int> get ageMin =>
      $composableBuilder(column: $table.ageMin, builder: (column) => column);

  GeneratedColumn<int> get ageMax =>
      $composableBuilder(column: $table.ageMax, builder: (column) => column);

  GeneratedColumn<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => column);

  GeneratedColumn<String> get scriptures => $composableBuilder(
      column: $table.scriptures, builder: (column) => column);

  GeneratedColumn<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => column);

  GeneratedColumn<String> get teacherNotes => $composableBuilder(
      column: $table.teacherNotes, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => column);

  GeneratedColumn<String> get quizzes =>
      $composableBuilder(column: $table.quizzes, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => column);

  GeneratedColumn<String> get feedId =>
      $composableBuilder(column: $table.feedId, builder: (column) => column);

  GeneratedColumn<String> get cohortId =>
      $composableBuilder(column: $table.cohortId, builder: (column) => column);

  Expression<T> lessonObjectivesRefs<T extends Object>(
      Expression<T> Function($$LessonObjectivesTableAnnotationComposer a) f) {
    final $$LessonObjectivesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonObjectives,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonObjectivesTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonObjectives,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> lessonScripturesRefs<T extends Object>(
      Expression<T> Function($$LessonScripturesTableAnnotationComposer a) f) {
    final $$LessonScripturesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonScriptures,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonScripturesTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonScriptures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> lessonAttachmentsRefs<T extends Object>(
      Expression<T> Function($$LessonAttachmentsTableAnnotationComposer a) f) {
    final $$LessonAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.lessonAttachments,
            getReferencedColumn: (t) => t.lessonId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LessonAttachmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.lessonAttachments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> lessonQuizzesRefs<T extends Object>(
      Expression<T> Function($$LessonQuizzesTableAnnotationComposer a) f) {
    final $$LessonQuizzesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonQuizzes,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizzesTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonQuizzes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> progressRefs<T extends Object>(
      Expression<T> Function($$ProgressTableAnnotationComposer a) f) {
    final $$ProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.progress,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.progress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonRow,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonRow, $$LessonsTableReferences),
    LessonRow,
    PrefetchHooks Function(
        {bool lessonObjectivesRefs,
        bool lessonScripturesRefs,
        bool lessonAttachmentsRefs,
        bool lessonQuizzesRefs,
        bool progressRefs})> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> lessonClass = const Value.absent(),
            Value<int?> ageMin = const Value.absent(),
            Value<int?> ageMax = const Value.absent(),
            Value<String?> objectives = const Value.absent(),
            Value<String?> scriptures = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> teacherNotes = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
            Value<String?> quizzes = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<int?> lastFetchedAt = const Value.absent(),
            Value<String?> feedId = const Value.absent(),
            Value<String?> cohortId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            title: title,
            lessonClass: lessonClass,
            ageMin: ageMin,
            ageMax: ageMax,
            objectives: objectives,
            scriptures: scriptures,
            contentHtml: contentHtml,
            teacherNotes: teacherNotes,
            attachments: attachments,
            quizzes: quizzes,
            sourceUrl: sourceUrl,
            lastFetchedAt: lastFetchedAt,
            feedId: feedId,
            cohortId: cohortId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String lessonClass,
            Value<int?> ageMin = const Value.absent(),
            Value<int?> ageMax = const Value.absent(),
            Value<String?> objectives = const Value.absent(),
            Value<String?> scriptures = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> teacherNotes = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
            Value<String?> quizzes = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<int?> lastFetchedAt = const Value.absent(),
            Value<String?> feedId = const Value.absent(),
            Value<String?> cohortId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            title: title,
            lessonClass: lessonClass,
            ageMin: ageMin,
            ageMax: ageMax,
            objectives: objectives,
            scriptures: scriptures,
            contentHtml: contentHtml,
            teacherNotes: teacherNotes,
            attachments: attachments,
            quizzes: quizzes,
            sourceUrl: sourceUrl,
            lastFetchedAt: lastFetchedAt,
            feedId: feedId,
            cohortId: cohortId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LessonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {lessonObjectivesRefs = false,
              lessonScripturesRefs = false,
              lessonAttachmentsRefs = false,
              lessonQuizzesRefs = false,
              progressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lessonObjectivesRefs) db.lessonObjectives,
                if (lessonScripturesRefs) db.lessonScriptures,
                if (lessonAttachmentsRefs) db.lessonAttachments,
                if (lessonQuizzesRefs) db.lessonQuizzes,
                if (progressRefs) db.progress
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonObjectivesRefs)
                    await $_getPrefetchedData<LessonRow, $LessonsTable,
                            LessonObjectiveRow>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonObjectivesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonObjectivesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items),
                  if (lessonScripturesRefs)
                    await $_getPrefetchedData<LessonRow, $LessonsTable,
                            LessonScriptureRow>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonScripturesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonScripturesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items),
                  if (lessonAttachmentsRefs)
                    await $_getPrefetchedData<LessonRow, $LessonsTable,
                            LessonAttachmentRow>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonAttachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonAttachmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items),
                  if (lessonQuizzesRefs)
                    await $_getPrefetchedData<LessonRow, $LessonsTable,
                            LessonQuizRow>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonQuizzesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonQuizzesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items),
                  if (progressRefs)
                    await $_getPrefetchedData<LessonRow, $LessonsTable,
                            ProgressData>(
                        currentTable: table,
                        referencedTable:
                            $$LessonsTableReferences._progressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .progressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonRow,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonRow, $$LessonsTableReferences),
    LessonRow,
    PrefetchHooks Function(
        {bool lessonObjectivesRefs,
        bool lessonScripturesRefs,
        bool lessonAttachmentsRefs,
        bool lessonQuizzesRefs,
        bool progressRefs})>;
typedef $$LessonObjectivesTableCreateCompanionBuilder
    = LessonObjectivesCompanion Function({
  required String lessonId,
  required int position,
  required String objective,
  Value<int> rowid,
});
typedef $$LessonObjectivesTableUpdateCompanionBuilder
    = LessonObjectivesCompanion Function({
  Value<String> lessonId,
  Value<int> position,
  Value<String> objective,
  Value<int> rowid,
});

final class $$LessonObjectivesTableReferences extends BaseReferences<
    _$AppDatabase, $LessonObjectivesTable, LessonObjectiveRow> {
  $$LessonObjectivesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonObjectives.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonObjectivesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonObjectivesTable> {
  $$LessonObjectivesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get objective => $composableBuilder(
      column: $table.objective, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonObjectivesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonObjectivesTable> {
  $$LessonObjectivesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get objective => $composableBuilder(
      column: $table.objective, builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonObjectivesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonObjectivesTable> {
  $$LessonObjectivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get objective =>
      $composableBuilder(column: $table.objective, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonObjectivesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonObjectivesTable,
    LessonObjectiveRow,
    $$LessonObjectivesTableFilterComposer,
    $$LessonObjectivesTableOrderingComposer,
    $$LessonObjectivesTableAnnotationComposer,
    $$LessonObjectivesTableCreateCompanionBuilder,
    $$LessonObjectivesTableUpdateCompanionBuilder,
    (LessonObjectiveRow, $$LessonObjectivesTableReferences),
    LessonObjectiveRow,
    PrefetchHooks Function({bool lessonId})> {
  $$LessonObjectivesTableTableManager(
      _$AppDatabase db, $LessonObjectivesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonObjectivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonObjectivesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonObjectivesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> objective = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonObjectivesCompanion(
            lessonId: lessonId,
            position: position,
            objective: objective,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            required int position,
            required String objective,
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonObjectivesCompanion.insert(
            lessonId: lessonId,
            position: position,
            objective: objective,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonObjectivesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonObjectivesTableReferences._lessonIdTable(db),
                    referencedColumn:
                        $$LessonObjectivesTableReferences._lessonIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LessonObjectivesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonObjectivesTable,
    LessonObjectiveRow,
    $$LessonObjectivesTableFilterComposer,
    $$LessonObjectivesTableOrderingComposer,
    $$LessonObjectivesTableAnnotationComposer,
    $$LessonObjectivesTableCreateCompanionBuilder,
    $$LessonObjectivesTableUpdateCompanionBuilder,
    (LessonObjectiveRow, $$LessonObjectivesTableReferences),
    LessonObjectiveRow,
    PrefetchHooks Function({bool lessonId})>;
typedef $$LessonScripturesTableCreateCompanionBuilder
    = LessonScripturesCompanion Function({
  required String lessonId,
  required int position,
  required String reference,
  Value<String?> translationId,
  Value<int> rowid,
});
typedef $$LessonScripturesTableUpdateCompanionBuilder
    = LessonScripturesCompanion Function({
  Value<String> lessonId,
  Value<int> position,
  Value<String> reference,
  Value<String?> translationId,
  Value<int> rowid,
});

final class $$LessonScripturesTableReferences extends BaseReferences<
    _$AppDatabase, $LessonScripturesTable, LessonScriptureRow> {
  $$LessonScripturesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonScriptures.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonScripturesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonScripturesTable> {
  $$LessonScripturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translationId => $composableBuilder(
      column: $table.translationId, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonScripturesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonScripturesTable> {
  $$LessonScripturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translationId => $composableBuilder(
      column: $table.translationId,
      builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonScripturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonScripturesTable> {
  $$LessonScripturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get translationId => $composableBuilder(
      column: $table.translationId, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonScripturesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonScripturesTable,
    LessonScriptureRow,
    $$LessonScripturesTableFilterComposer,
    $$LessonScripturesTableOrderingComposer,
    $$LessonScripturesTableAnnotationComposer,
    $$LessonScripturesTableCreateCompanionBuilder,
    $$LessonScripturesTableUpdateCompanionBuilder,
    (LessonScriptureRow, $$LessonScripturesTableReferences),
    LessonScriptureRow,
    PrefetchHooks Function({bool lessonId})> {
  $$LessonScripturesTableTableManager(
      _$AppDatabase db, $LessonScripturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonScripturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonScripturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonScripturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<String?> translationId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonScripturesCompanion(
            lessonId: lessonId,
            position: position,
            reference: reference,
            translationId: translationId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            required int position,
            required String reference,
            Value<String?> translationId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonScripturesCompanion.insert(
            lessonId: lessonId,
            position: position,
            reference: reference,
            translationId: translationId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonScripturesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonScripturesTableReferences._lessonIdTable(db),
                    referencedColumn:
                        $$LessonScripturesTableReferences._lessonIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LessonScripturesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonScripturesTable,
    LessonScriptureRow,
    $$LessonScripturesTableFilterComposer,
    $$LessonScripturesTableOrderingComposer,
    $$LessonScripturesTableAnnotationComposer,
    $$LessonScripturesTableCreateCompanionBuilder,
    $$LessonScripturesTableUpdateCompanionBuilder,
    (LessonScriptureRow, $$LessonScripturesTableReferences),
    LessonScriptureRow,
    PrefetchHooks Function({bool lessonId})>;
typedef $$LessonAttachmentsTableCreateCompanionBuilder
    = LessonAttachmentsCompanion Function({
  required String lessonId,
  required int position,
  required String type,
  Value<String?> title,
  required String url,
  Value<String?> localPath,
  Value<int?> sizeBytes,
  Value<int?> downloadedAt,
  Value<int> rowid,
});
typedef $$LessonAttachmentsTableUpdateCompanionBuilder
    = LessonAttachmentsCompanion Function({
  Value<String> lessonId,
  Value<int> position,
  Value<String> type,
  Value<String?> title,
  Value<String> url,
  Value<String?> localPath,
  Value<int?> sizeBytes,
  Value<int?> downloadedAt,
  Value<int> rowid,
});

final class $$LessonAttachmentsTableReferences extends BaseReferences<
    _$AppDatabase, $LessonAttachmentsTable, LessonAttachmentRow> {
  $$LessonAttachmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonAttachments.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonAttachmentsTable> {
  $$LessonAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonAttachmentsTable> {
  $$LessonAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt,
      builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonAttachmentsTable> {
  $$LessonAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonAttachmentsTable,
    LessonAttachmentRow,
    $$LessonAttachmentsTableFilterComposer,
    $$LessonAttachmentsTableOrderingComposer,
    $$LessonAttachmentsTableAnnotationComposer,
    $$LessonAttachmentsTableCreateCompanionBuilder,
    $$LessonAttachmentsTableUpdateCompanionBuilder,
    (LessonAttachmentRow, $$LessonAttachmentsTableReferences),
    LessonAttachmentRow,
    PrefetchHooks Function({bool lessonId})> {
  $$LessonAttachmentsTableTableManager(
      _$AppDatabase db, $LessonAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonAttachmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<int?> sizeBytes = const Value.absent(),
            Value<int?> downloadedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonAttachmentsCompanion(
            lessonId: lessonId,
            position: position,
            type: type,
            title: title,
            url: url,
            localPath: localPath,
            sizeBytes: sizeBytes,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            required int position,
            required String type,
            Value<String?> title = const Value.absent(),
            required String url,
            Value<String?> localPath = const Value.absent(),
            Value<int?> sizeBytes = const Value.absent(),
            Value<int?> downloadedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonAttachmentsCompanion.insert(
            lessonId: lessonId,
            position: position,
            type: type,
            title: title,
            url: url,
            localPath: localPath,
            sizeBytes: sizeBytes,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonAttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonAttachmentsTableReferences._lessonIdTable(db),
                    referencedColumn: $$LessonAttachmentsTableReferences
                        ._lessonIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LessonAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonAttachmentsTable,
    LessonAttachmentRow,
    $$LessonAttachmentsTableFilterComposer,
    $$LessonAttachmentsTableOrderingComposer,
    $$LessonAttachmentsTableAnnotationComposer,
    $$LessonAttachmentsTableCreateCompanionBuilder,
    $$LessonAttachmentsTableUpdateCompanionBuilder,
    (LessonAttachmentRow, $$LessonAttachmentsTableReferences),
    LessonAttachmentRow,
    PrefetchHooks Function({bool lessonId})>;
typedef $$LessonQuizzesTableCreateCompanionBuilder = LessonQuizzesCompanion
    Function({
  required String id,
  required String lessonId,
  required int position,
  required String type,
  required String prompt,
  Value<String?> answer,
  Value<int> rowid,
});
typedef $$LessonQuizzesTableUpdateCompanionBuilder = LessonQuizzesCompanion
    Function({
  Value<String> id,
  Value<String> lessonId,
  Value<int> position,
  Value<String> type,
  Value<String> prompt,
  Value<String?> answer,
  Value<int> rowid,
});

final class $$LessonQuizzesTableReferences
    extends BaseReferences<_$AppDatabase, $LessonQuizzesTable, LessonQuizRow> {
  $$LessonQuizzesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonQuizzes.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LessonQuizOptionsTable, List<LessonQuizOptionRow>>
      _lessonQuizOptionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonQuizOptions,
              aliasName: $_aliasNameGenerator(
                  db.lessonQuizzes.id, db.lessonQuizOptions.quizId));

  $$LessonQuizOptionsTableProcessedTableManager get lessonQuizOptionsRefs {
    final manager =
        $$LessonQuizOptionsTableTableManager($_db, $_db.lessonQuizOptions)
            .filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonQuizOptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LessonQuizzesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonQuizzesTable> {
  $$LessonQuizzesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prompt => $composableBuilder(
      column: $table.prompt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> lessonQuizOptionsRefs(
      Expression<bool> Function($$LessonQuizOptionsTableFilterComposer f) f) {
    final $$LessonQuizOptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonQuizOptions,
        getReferencedColumn: (t) => t.quizId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizOptionsTableFilterComposer(
              $db: $db,
              $table: $db.lessonQuizOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonQuizzesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonQuizzesTable> {
  $$LessonQuizzesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prompt => $composableBuilder(
      column: $table.prompt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonQuizzesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonQuizzesTable> {
  $$LessonQuizzesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> lessonQuizOptionsRefs<T extends Object>(
      Expression<T> Function($$LessonQuizOptionsTableAnnotationComposer a) f) {
    final $$LessonQuizOptionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.lessonQuizOptions,
            getReferencedColumn: (t) => t.quizId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LessonQuizOptionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.lessonQuizOptions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$LessonQuizzesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonQuizzesTable,
    LessonQuizRow,
    $$LessonQuizzesTableFilterComposer,
    $$LessonQuizzesTableOrderingComposer,
    $$LessonQuizzesTableAnnotationComposer,
    $$LessonQuizzesTableCreateCompanionBuilder,
    $$LessonQuizzesTableUpdateCompanionBuilder,
    (LessonQuizRow, $$LessonQuizzesTableReferences),
    LessonQuizRow,
    PrefetchHooks Function({bool lessonId, bool lessonQuizOptionsRefs})> {
  $$LessonQuizzesTableTableManager(_$AppDatabase db, $LessonQuizzesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonQuizzesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonQuizzesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonQuizzesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> prompt = const Value.absent(),
            Value<String?> answer = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonQuizzesCompanion(
            id: id,
            lessonId: lessonId,
            position: position,
            type: type,
            prompt: prompt,
            answer: answer,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required int position,
            required String type,
            required String prompt,
            Value<String?> answer = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonQuizzesCompanion.insert(
            id: id,
            lessonId: lessonId,
            position: position,
            type: type,
            prompt: prompt,
            answer: answer,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonQuizzesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {lessonId = false, lessonQuizOptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lessonQuizOptionsRefs) db.lessonQuizOptions
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonQuizzesTableReferences._lessonIdTable(db),
                    referencedColumn:
                        $$LessonQuizzesTableReferences._lessonIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonQuizOptionsRefs)
                    await $_getPrefetchedData<LessonQuizRow,
                            $LessonQuizzesTable, LessonQuizOptionRow>(
                        currentTable: table,
                        referencedTable: $$LessonQuizzesTableReferences
                            ._lessonQuizOptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonQuizzesTableReferences(db, table, p0)
                                .lessonQuizOptionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.quizId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LessonQuizzesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonQuizzesTable,
    LessonQuizRow,
    $$LessonQuizzesTableFilterComposer,
    $$LessonQuizzesTableOrderingComposer,
    $$LessonQuizzesTableAnnotationComposer,
    $$LessonQuizzesTableCreateCompanionBuilder,
    $$LessonQuizzesTableUpdateCompanionBuilder,
    (LessonQuizRow, $$LessonQuizzesTableReferences),
    LessonQuizRow,
    PrefetchHooks Function({bool lessonId, bool lessonQuizOptionsRefs})>;
typedef $$LessonQuizOptionsTableCreateCompanionBuilder
    = LessonQuizOptionsCompanion Function({
  required String quizId,
  required int position,
  required String label,
  Value<bool> isCorrect,
  Value<int> rowid,
});
typedef $$LessonQuizOptionsTableUpdateCompanionBuilder
    = LessonQuizOptionsCompanion Function({
  Value<String> quizId,
  Value<int> position,
  Value<String> label,
  Value<bool> isCorrect,
  Value<int> rowid,
});

final class $$LessonQuizOptionsTableReferences extends BaseReferences<
    _$AppDatabase, $LessonQuizOptionsTable, LessonQuizOptionRow> {
  $$LessonQuizOptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonQuizzesTable _quizIdTable(_$AppDatabase db) =>
      db.lessonQuizzes.createAlias($_aliasNameGenerator(
          db.lessonQuizOptions.quizId, db.lessonQuizzes.id));

  $$LessonQuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$LessonQuizzesTableTableManager($_db, $_db.lessonQuizzes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonQuizOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonQuizOptionsTable> {
  $$LessonQuizOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  $$LessonQuizzesTableFilterComposer get quizId {
    final $$LessonQuizzesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.quizId,
        referencedTable: $db.lessonQuizzes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizzesTableFilterComposer(
              $db: $db,
              $table: $db.lessonQuizzes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonQuizOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonQuizOptionsTable> {
  $$LessonQuizOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  $$LessonQuizzesTableOrderingComposer get quizId {
    final $$LessonQuizzesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.quizId,
        referencedTable: $db.lessonQuizzes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizzesTableOrderingComposer(
              $db: $db,
              $table: $db.lessonQuizzes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonQuizOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonQuizOptionsTable> {
  $$LessonQuizOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$LessonQuizzesTableAnnotationComposer get quizId {
    final $$LessonQuizzesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.quizId,
        referencedTable: $db.lessonQuizzes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonQuizzesTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonQuizzes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonQuizOptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonQuizOptionsTable,
    LessonQuizOptionRow,
    $$LessonQuizOptionsTableFilterComposer,
    $$LessonQuizOptionsTableOrderingComposer,
    $$LessonQuizOptionsTableAnnotationComposer,
    $$LessonQuizOptionsTableCreateCompanionBuilder,
    $$LessonQuizOptionsTableUpdateCompanionBuilder,
    (LessonQuizOptionRow, $$LessonQuizOptionsTableReferences),
    LessonQuizOptionRow,
    PrefetchHooks Function({bool quizId})> {
  $$LessonQuizOptionsTableTableManager(
      _$AppDatabase db, $LessonQuizOptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonQuizOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonQuizOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonQuizOptionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> quizId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonQuizOptionsCompanion(
            quizId: quizId,
            position: position,
            label: label,
            isCorrect: isCorrect,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String quizId,
            required int position,
            required String label,
            Value<bool> isCorrect = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonQuizOptionsCompanion.insert(
            quizId: quizId,
            position: position,
            label: label,
            isCorrect: isCorrect,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonQuizOptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({quizId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (quizId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.quizId,
                    referencedTable:
                        $$LessonQuizOptionsTableReferences._quizIdTable(db),
                    referencedColumn:
                        $$LessonQuizOptionsTableReferences._quizIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LessonQuizOptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonQuizOptionsTable,
    LessonQuizOptionRow,
    $$LessonQuizOptionsTableFilterComposer,
    $$LessonQuizOptionsTableOrderingComposer,
    $$LessonQuizOptionsTableAnnotationComposer,
    $$LessonQuizOptionsTableCreateCompanionBuilder,
    $$LessonQuizOptionsTableUpdateCompanionBuilder,
    (LessonQuizOptionRow, $$LessonQuizOptionsTableReferences),
    LessonQuizOptionRow,
    PrefetchHooks Function({bool quizId})>;
typedef $$LessonDraftsTableCreateCompanionBuilder = LessonDraftsCompanion
    Function({
  required String id,
  Value<String?> lessonId,
  required String authorId,
  required String title,
  required String deltaJson,
  Value<String> status,
  Value<String?> approverId,
  Value<String?> reviewerComment,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$LessonDraftsTableUpdateCompanionBuilder = LessonDraftsCompanion
    Function({
  Value<String> id,
  Value<String?> lessonId,
  Value<String> authorId,
  Value<String> title,
  Value<String> deltaJson,
  Value<String> status,
  Value<String?> approverId,
  Value<String?> reviewerComment,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$LessonDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonDraftsTable> {
  $$LessonDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deltaJson => $composableBuilder(
      column: $table.deltaJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approverId => $composableBuilder(
      column: $table.approverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reviewerComment => $composableBuilder(
      column: $table.reviewerComment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LessonDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonDraftsTable> {
  $$LessonDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deltaJson => $composableBuilder(
      column: $table.deltaJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approverId => $composableBuilder(
      column: $table.approverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reviewerComment => $composableBuilder(
      column: $table.reviewerComment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LessonDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonDraftsTable> {
  $$LessonDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get deltaJson =>
      $composableBuilder(column: $table.deltaJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approverId => $composableBuilder(
      column: $table.approverId, builder: (column) => column);

  GeneratedColumn<String> get reviewerComment => $composableBuilder(
      column: $table.reviewerComment, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LessonDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonDraftsTable,
    LessonDraftRow,
    $$LessonDraftsTableFilterComposer,
    $$LessonDraftsTableOrderingComposer,
    $$LessonDraftsTableAnnotationComposer,
    $$LessonDraftsTableCreateCompanionBuilder,
    $$LessonDraftsTableUpdateCompanionBuilder,
    (
      LessonDraftRow,
      BaseReferences<_$AppDatabase, $LessonDraftsTable, LessonDraftRow>
    ),
    LessonDraftRow,
    PrefetchHooks Function()> {
  $$LessonDraftsTableTableManager(_$AppDatabase db, $LessonDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> lessonId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> deltaJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> approverId = const Value.absent(),
            Value<String?> reviewerComment = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonDraftsCompanion(
            id: id,
            lessonId: lessonId,
            authorId: authorId,
            title: title,
            deltaJson: deltaJson,
            status: status,
            approverId: approverId,
            reviewerComment: reviewerComment,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> lessonId = const Value.absent(),
            required String authorId,
            required String title,
            required String deltaJson,
            Value<String> status = const Value.absent(),
            Value<String?> approverId = const Value.absent(),
            Value<String?> reviewerComment = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonDraftsCompanion.insert(
            id: id,
            lessonId: lessonId,
            authorId: authorId,
            title: title,
            deltaJson: deltaJson,
            status: status,
            approverId: approverId,
            reviewerComment: reviewerComment,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonDraftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonDraftsTable,
    LessonDraftRow,
    $$LessonDraftsTableFilterComposer,
    $$LessonDraftsTableOrderingComposer,
    $$LessonDraftsTableAnnotationComposer,
    $$LessonDraftsTableCreateCompanionBuilder,
    $$LessonDraftsTableUpdateCompanionBuilder,
    (
      LessonDraftRow,
      BaseReferences<_$AppDatabase, $LessonDraftsTable, LessonDraftRow>
    ),
    LessonDraftRow,
    PrefetchHooks Function()>;
typedef $$LessonFeedsTableCreateCompanionBuilder = LessonFeedsCompanion
    Function({
  required String id,
  required String source,
  Value<String?> cohort,
  Value<String?> lessonClass,
  Value<String?> checksum,
  Value<String?> etag,
  Value<int?> lastModified,
  Value<int?> lastFetchedAt,
  Value<int?> lastCheckedAt,
  Value<int> rowid,
});
typedef $$LessonFeedsTableUpdateCompanionBuilder = LessonFeedsCompanion
    Function({
  Value<String> id,
  Value<String> source,
  Value<String?> cohort,
  Value<String?> lessonClass,
  Value<String?> checksum,
  Value<String?> etag,
  Value<int?> lastModified,
  Value<int?> lastFetchedAt,
  Value<int?> lastCheckedAt,
  Value<int> rowid,
});

class $$LessonFeedsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonFeedsTable> {
  $$LessonFeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cohort => $composableBuilder(
      column: $table.cohort, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get etag => $composableBuilder(
      column: $table.etag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => ColumnFilters(column));
}

class $$LessonFeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonFeedsTable> {
  $$LessonFeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cohort => $composableBuilder(
      column: $table.cohort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get etag => $composableBuilder(
      column: $table.etag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastModified => $composableBuilder(
      column: $table.lastModified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LessonFeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonFeedsTable> {
  $$LessonFeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get cohort =>
      $composableBuilder(column: $table.cohort, builder: (column) => column);

  GeneratedColumn<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<int> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => column);

  GeneratedColumn<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => column);

  GeneratedColumn<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => column);
}

class $$LessonFeedsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonFeedsTable,
    LessonFeedRow,
    $$LessonFeedsTableFilterComposer,
    $$LessonFeedsTableOrderingComposer,
    $$LessonFeedsTableAnnotationComposer,
    $$LessonFeedsTableCreateCompanionBuilder,
    $$LessonFeedsTableUpdateCompanionBuilder,
    (
      LessonFeedRow,
      BaseReferences<_$AppDatabase, $LessonFeedsTable, LessonFeedRow>
    ),
    LessonFeedRow,
    PrefetchHooks Function()> {
  $$LessonFeedsTableTableManager(_$AppDatabase db, $LessonFeedsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonFeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonFeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonFeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> cohort = const Value.absent(),
            Value<String?> lessonClass = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            Value<String?> etag = const Value.absent(),
            Value<int?> lastModified = const Value.absent(),
            Value<int?> lastFetchedAt = const Value.absent(),
            Value<int?> lastCheckedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonFeedsCompanion(
            id: id,
            source: source,
            cohort: cohort,
            lessonClass: lessonClass,
            checksum: checksum,
            etag: etag,
            lastModified: lastModified,
            lastFetchedAt: lastFetchedAt,
            lastCheckedAt: lastCheckedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String source,
            Value<String?> cohort = const Value.absent(),
            Value<String?> lessonClass = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            Value<String?> etag = const Value.absent(),
            Value<int?> lastModified = const Value.absent(),
            Value<int?> lastFetchedAt = const Value.absent(),
            Value<int?> lastCheckedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonFeedsCompanion.insert(
            id: id,
            source: source,
            cohort: cohort,
            lessonClass: lessonClass,
            checksum: checksum,
            etag: etag,
            lastModified: lastModified,
            lastFetchedAt: lastFetchedAt,
            lastCheckedAt: lastCheckedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonFeedsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonFeedsTable,
    LessonFeedRow,
    $$LessonFeedsTableFilterComposer,
    $$LessonFeedsTableOrderingComposer,
    $$LessonFeedsTableAnnotationComposer,
    $$LessonFeedsTableCreateCompanionBuilder,
    $$LessonFeedsTableUpdateCompanionBuilder,
    (
      LessonFeedRow,
      BaseReferences<_$AppDatabase, $LessonFeedsTable, LessonFeedRow>
    ),
    LessonFeedRow,
    PrefetchHooks Function()>;
typedef $$LessonSourcesTableCreateCompanionBuilder = LessonSourcesCompanion
    Function({
  required String id,
  required String type,
  required String location,
  Value<String?> label,
  Value<String?> cohort,
  Value<String?> lessonClass,
  Value<bool> enabled,
  Value<bool> isBundled,
  Value<int> priority,
  Value<String?> checksum,
  Value<String?> etag,
  Value<int?> lastModified,
  Value<int?> lastSyncedAt,
  Value<int?> lastAttemptedAt,
  Value<int?> lastCheckedAt,
  Value<String?> lastError,
  Value<int> lessonCount,
  Value<int> attachmentBytes,
  Value<int?> quotaBytes,
  Value<int> rowid,
});
typedef $$LessonSourcesTableUpdateCompanionBuilder = LessonSourcesCompanion
    Function({
  Value<String> id,
  Value<String> type,
  Value<String> location,
  Value<String?> label,
  Value<String?> cohort,
  Value<String?> lessonClass,
  Value<bool> enabled,
  Value<bool> isBundled,
  Value<int> priority,
  Value<String?> checksum,
  Value<String?> etag,
  Value<int?> lastModified,
  Value<int?> lastSyncedAt,
  Value<int?> lastAttemptedAt,
  Value<int?> lastCheckedAt,
  Value<String?> lastError,
  Value<int> lessonCount,
  Value<int> attachmentBytes,
  Value<int?> quotaBytes,
  Value<int> rowid,
});

class $$LessonSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonSourcesTable> {
  $$LessonSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cohort => $composableBuilder(
      column: $table.cohort, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBundled => $composableBuilder(
      column: $table.isBundled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get etag => $composableBuilder(
      column: $table.etag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastAttemptedAt => $composableBuilder(
      column: $table.lastAttemptedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attachmentBytes => $composableBuilder(
      column: $table.attachmentBytes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quotaBytes => $composableBuilder(
      column: $table.quotaBytes, builder: (column) => ColumnFilters(column));
}

class $$LessonSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonSourcesTable> {
  $$LessonSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cohort => $composableBuilder(
      column: $table.cohort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBundled => $composableBuilder(
      column: $table.isBundled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get etag => $composableBuilder(
      column: $table.etag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastModified => $composableBuilder(
      column: $table.lastModified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastAttemptedAt => $composableBuilder(
      column: $table.lastAttemptedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attachmentBytes => $composableBuilder(
      column: $table.attachmentBytes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quotaBytes => $composableBuilder(
      column: $table.quotaBytes, builder: (column) => ColumnOrderings(column));
}

class $$LessonSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonSourcesTable> {
  $$LessonSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get cohort =>
      $composableBuilder(column: $table.cohort, builder: (column) => column);

  GeneratedColumn<String> get lessonClass => $composableBuilder(
      column: $table.lessonClass, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get isBundled =>
      $composableBuilder(column: $table.isBundled, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<int> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<int> get lastAttemptedAt => $composableBuilder(
      column: $table.lastAttemptedAt, builder: (column) => column);

  GeneratedColumn<int> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => column);

  GeneratedColumn<int> get attachmentBytes => $composableBuilder(
      column: $table.attachmentBytes, builder: (column) => column);

  GeneratedColumn<int> get quotaBytes => $composableBuilder(
      column: $table.quotaBytes, builder: (column) => column);
}

class $$LessonSourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonSourcesTable,
    LessonSourceRow,
    $$LessonSourcesTableFilterComposer,
    $$LessonSourcesTableOrderingComposer,
    $$LessonSourcesTableAnnotationComposer,
    $$LessonSourcesTableCreateCompanionBuilder,
    $$LessonSourcesTableUpdateCompanionBuilder,
    (
      LessonSourceRow,
      BaseReferences<_$AppDatabase, $LessonSourcesTable, LessonSourceRow>
    ),
    LessonSourceRow,
    PrefetchHooks Function()> {
  $$LessonSourcesTableTableManager(_$AppDatabase db, $LessonSourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<String?> cohort = const Value.absent(),
            Value<String?> lessonClass = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isBundled = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            Value<String?> etag = const Value.absent(),
            Value<int?> lastModified = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<int?> lastAttemptedAt = const Value.absent(),
            Value<int?> lastCheckedAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> lessonCount = const Value.absent(),
            Value<int> attachmentBytes = const Value.absent(),
            Value<int?> quotaBytes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonSourcesCompanion(
            id: id,
            type: type,
            location: location,
            label: label,
            cohort: cohort,
            lessonClass: lessonClass,
            enabled: enabled,
            isBundled: isBundled,
            priority: priority,
            checksum: checksum,
            etag: etag,
            lastModified: lastModified,
            lastSyncedAt: lastSyncedAt,
            lastAttemptedAt: lastAttemptedAt,
            lastCheckedAt: lastCheckedAt,
            lastError: lastError,
            lessonCount: lessonCount,
            attachmentBytes: attachmentBytes,
            quotaBytes: quotaBytes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String location,
            Value<String?> label = const Value.absent(),
            Value<String?> cohort = const Value.absent(),
            Value<String?> lessonClass = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isBundled = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            Value<String?> etag = const Value.absent(),
            Value<int?> lastModified = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<int?> lastAttemptedAt = const Value.absent(),
            Value<int?> lastCheckedAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> lessonCount = const Value.absent(),
            Value<int> attachmentBytes = const Value.absent(),
            Value<int?> quotaBytes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonSourcesCompanion.insert(
            id: id,
            type: type,
            location: location,
            label: label,
            cohort: cohort,
            lessonClass: lessonClass,
            enabled: enabled,
            isBundled: isBundled,
            priority: priority,
            checksum: checksum,
            etag: etag,
            lastModified: lastModified,
            lastSyncedAt: lastSyncedAt,
            lastAttemptedAt: lastAttemptedAt,
            lastCheckedAt: lastCheckedAt,
            lastError: lastError,
            lessonCount: lessonCount,
            attachmentBytes: attachmentBytes,
            quotaBytes: quotaBytes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonSourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonSourcesTable,
    LessonSourceRow,
    $$LessonSourcesTableFilterComposer,
    $$LessonSourcesTableOrderingComposer,
    $$LessonSourcesTableAnnotationComposer,
    $$LessonSourcesTableCreateCompanionBuilder,
    $$LessonSourcesTableUpdateCompanionBuilder,
    (
      LessonSourceRow,
      BaseReferences<_$AppDatabase, $LessonSourcesTable, LessonSourceRow>
    ),
    LessonSourceRow,
    PrefetchHooks Function()>;
typedef $$RoundtableEventsTableCreateCompanionBuilder
    = RoundtableEventsCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String?> classId,
  required int startTime,
  required int endTime,
  Value<String?> conferencingUrl,
  Value<String?> hostConferencingUrl,
  Value<String?> meetingRoom,
  Value<int> reminderMinutesBefore,
  required String createdBy,
  required int updatedAt,
  Value<String?> recordingStoragePath,
  Value<String?> recordingUrl,
  Value<int?> recordingIndexedAt,
  Value<int> rowid,
});
typedef $$RoundtableEventsTableUpdateCompanionBuilder
    = RoundtableEventsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String?> classId,
  Value<int> startTime,
  Value<int> endTime,
  Value<String?> conferencingUrl,
  Value<String?> hostConferencingUrl,
  Value<String?> meetingRoom,
  Value<int> reminderMinutesBefore,
  Value<String> createdBy,
  Value<int> updatedAt,
  Value<String?> recordingStoragePath,
  Value<String?> recordingUrl,
  Value<int?> recordingIndexedAt,
  Value<int> rowid,
});

class $$RoundtableEventsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundtableEventsTable> {
  $$RoundtableEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conferencingUrl => $composableBuilder(
      column: $table.conferencingUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hostConferencingUrl => $composableBuilder(
      column: $table.hostConferencingUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meetingRoom => $composableBuilder(
      column: $table.meetingRoom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordingStoragePath => $composableBuilder(
      column: $table.recordingStoragePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordingUrl => $composableBuilder(
      column: $table.recordingUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordingIndexedAt => $composableBuilder(
      column: $table.recordingIndexedAt,
      builder: (column) => ColumnFilters(column));
}

class $$RoundtableEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundtableEventsTable> {
  $$RoundtableEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conferencingUrl => $composableBuilder(
      column: $table.conferencingUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hostConferencingUrl => $composableBuilder(
      column: $table.hostConferencingUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meetingRoom => $composableBuilder(
      column: $table.meetingRoom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordingStoragePath => $composableBuilder(
      column: $table.recordingStoragePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordingUrl => $composableBuilder(
      column: $table.recordingUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordingIndexedAt => $composableBuilder(
      column: $table.recordingIndexedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RoundtableEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundtableEventsTable> {
  $$RoundtableEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get conferencingUrl => $composableBuilder(
      column: $table.conferencingUrl, builder: (column) => column);

  GeneratedColumn<String> get hostConferencingUrl => $composableBuilder(
      column: $table.hostConferencingUrl, builder: (column) => column);

  GeneratedColumn<String> get meetingRoom => $composableBuilder(
      column: $table.meetingRoom, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get recordingStoragePath => $composableBuilder(
      column: $table.recordingStoragePath, builder: (column) => column);

  GeneratedColumn<String> get recordingUrl => $composableBuilder(
      column: $table.recordingUrl, builder: (column) => column);

  GeneratedColumn<int> get recordingIndexedAt => $composableBuilder(
      column: $table.recordingIndexedAt, builder: (column) => column);
}

class $$RoundtableEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoundtableEventsTable,
    RoundtableRow,
    $$RoundtableEventsTableFilterComposer,
    $$RoundtableEventsTableOrderingComposer,
    $$RoundtableEventsTableAnnotationComposer,
    $$RoundtableEventsTableCreateCompanionBuilder,
    $$RoundtableEventsTableUpdateCompanionBuilder,
    (
      RoundtableRow,
      BaseReferences<_$AppDatabase, $RoundtableEventsTable, RoundtableRow>
    ),
    RoundtableRow,
    PrefetchHooks Function()> {
  $$RoundtableEventsTableTableManager(
      _$AppDatabase db, $RoundtableEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundtableEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundtableEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundtableEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> classId = const Value.absent(),
            Value<int> startTime = const Value.absent(),
            Value<int> endTime = const Value.absent(),
            Value<String?> conferencingUrl = const Value.absent(),
            Value<String?> hostConferencingUrl = const Value.absent(),
            Value<String?> meetingRoom = const Value.absent(),
            Value<int> reminderMinutesBefore = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> recordingStoragePath = const Value.absent(),
            Value<String?> recordingUrl = const Value.absent(),
            Value<int?> recordingIndexedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoundtableEventsCompanion(
            id: id,
            title: title,
            description: description,
            classId: classId,
            startTime: startTime,
            endTime: endTime,
            conferencingUrl: conferencingUrl,
            hostConferencingUrl: hostConferencingUrl,
            meetingRoom: meetingRoom,
            reminderMinutesBefore: reminderMinutesBefore,
            createdBy: createdBy,
            updatedAt: updatedAt,
            recordingStoragePath: recordingStoragePath,
            recordingUrl: recordingUrl,
            recordingIndexedAt: recordingIndexedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> classId = const Value.absent(),
            required int startTime,
            required int endTime,
            Value<String?> conferencingUrl = const Value.absent(),
            Value<String?> hostConferencingUrl = const Value.absent(),
            Value<String?> meetingRoom = const Value.absent(),
            Value<int> reminderMinutesBefore = const Value.absent(),
            required String createdBy,
            required int updatedAt,
            Value<String?> recordingStoragePath = const Value.absent(),
            Value<String?> recordingUrl = const Value.absent(),
            Value<int?> recordingIndexedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoundtableEventsCompanion.insert(
            id: id,
            title: title,
            description: description,
            classId: classId,
            startTime: startTime,
            endTime: endTime,
            conferencingUrl: conferencingUrl,
            hostConferencingUrl: hostConferencingUrl,
            meetingRoom: meetingRoom,
            reminderMinutesBefore: reminderMinutesBefore,
            createdBy: createdBy,
            updatedAt: updatedAt,
            recordingStoragePath: recordingStoragePath,
            recordingUrl: recordingUrl,
            recordingIndexedAt: recordingIndexedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoundtableEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoundtableEventsTable,
    RoundtableRow,
    $$RoundtableEventsTableFilterComposer,
    $$RoundtableEventsTableOrderingComposer,
    $$RoundtableEventsTableAnnotationComposer,
    $$RoundtableEventsTableCreateCompanionBuilder,
    $$RoundtableEventsTableUpdateCompanionBuilder,
    (
      RoundtableRow,
      BaseReferences<_$AppDatabase, $RoundtableEventsTable, RoundtableRow>
    ),
    RoundtableRow,
    PrefetchHooks Function()>;
typedef $$DiscussionThreadsTableCreateCompanionBuilder
    = DiscussionThreadsCompanion Function({
  required String id,
  required String classId,
  required String title,
  required String createdBy,
  Value<String> status,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$DiscussionThreadsTableUpdateCompanionBuilder
    = DiscussionThreadsCompanion Function({
  Value<String> id,
  Value<String> classId,
  Value<String> title,
  Value<String> createdBy,
  Value<String> status,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$DiscussionThreadsTableReferences extends BaseReferences<
    _$AppDatabase, $DiscussionThreadsTable, DiscussionThreadRow> {
  $$DiscussionThreadsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiscussionPostsTable, List<DiscussionPostRow>>
      _discussionPostsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.discussionPosts,
              aliasName: $_aliasNameGenerator(
                  db.discussionThreads.id, db.discussionPosts.threadId));

  $$DiscussionPostsTableProcessedTableManager get discussionPostsRefs {
    final manager = $$DiscussionPostsTableTableManager(
            $_db, $_db.discussionPosts)
        .filter((f) => f.threadId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_discussionPostsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DiscussionThreadsTableFilterComposer
    extends Composer<_$AppDatabase, $DiscussionThreadsTable> {
  $$DiscussionThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> discussionPostsRefs(
      Expression<bool> Function($$DiscussionPostsTableFilterComposer f) f) {
    final $$DiscussionPostsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.discussionPosts,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscussionPostsTableFilterComposer(
              $db: $db,
              $table: $db.discussionPosts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiscussionThreadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscussionThreadsTable> {
  $$DiscussionThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DiscussionThreadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscussionThreadsTable> {
  $$DiscussionThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> discussionPostsRefs<T extends Object>(
      Expression<T> Function($$DiscussionPostsTableAnnotationComposer a) f) {
    final $$DiscussionPostsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.discussionPosts,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscussionPostsTableAnnotationComposer(
              $db: $db,
              $table: $db.discussionPosts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiscussionThreadsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiscussionThreadsTable,
    DiscussionThreadRow,
    $$DiscussionThreadsTableFilterComposer,
    $$DiscussionThreadsTableOrderingComposer,
    $$DiscussionThreadsTableAnnotationComposer,
    $$DiscussionThreadsTableCreateCompanionBuilder,
    $$DiscussionThreadsTableUpdateCompanionBuilder,
    (DiscussionThreadRow, $$DiscussionThreadsTableReferences),
    DiscussionThreadRow,
    PrefetchHooks Function({bool discussionPostsRefs})> {
  $$DiscussionThreadsTableTableManager(
      _$AppDatabase db, $DiscussionThreadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscussionThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscussionThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscussionThreadsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> classId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscussionThreadsCompanion(
            id: id,
            classId: classId,
            title: title,
            createdBy: createdBy,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String classId,
            required String title,
            required String createdBy,
            Value<String> status = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscussionThreadsCompanion.insert(
            id: id,
            classId: classId,
            title: title,
            createdBy: createdBy,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DiscussionThreadsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({discussionPostsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (discussionPostsRefs) db.discussionPosts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (discussionPostsRefs)
                    await $_getPrefetchedData<DiscussionThreadRow,
                            $DiscussionThreadsTable, DiscussionPostRow>(
                        currentTable: table,
                        referencedTable: $$DiscussionThreadsTableReferences
                            ._discussionPostsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiscussionThreadsTableReferences(db, table, p0)
                                .discussionPostsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.threadId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DiscussionThreadsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiscussionThreadsTable,
    DiscussionThreadRow,
    $$DiscussionThreadsTableFilterComposer,
    $$DiscussionThreadsTableOrderingComposer,
    $$DiscussionThreadsTableAnnotationComposer,
    $$DiscussionThreadsTableCreateCompanionBuilder,
    $$DiscussionThreadsTableUpdateCompanionBuilder,
    (DiscussionThreadRow, $$DiscussionThreadsTableReferences),
    DiscussionThreadRow,
    PrefetchHooks Function({bool discussionPostsRefs})>;
typedef $$DiscussionPostsTableCreateCompanionBuilder = DiscussionPostsCompanion
    Function({
  required String id,
  required String threadId,
  required String authorId,
  Value<String?> role,
  required String body,
  Value<String> status,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$DiscussionPostsTableUpdateCompanionBuilder = DiscussionPostsCompanion
    Function({
  Value<String> id,
  Value<String> threadId,
  Value<String> authorId,
  Value<String?> role,
  Value<String> body,
  Value<String> status,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$DiscussionPostsTableReferences extends BaseReferences<
    _$AppDatabase, $DiscussionPostsTable, DiscussionPostRow> {
  $$DiscussionPostsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DiscussionThreadsTable _threadIdTable(_$AppDatabase db) =>
      db.discussionThreads.createAlias($_aliasNameGenerator(
          db.discussionPosts.threadId, db.discussionThreads.id));

  $$DiscussionThreadsTableProcessedTableManager get threadId {
    final $_column = $_itemColumn<String>('thread_id')!;

    final manager =
        $$DiscussionThreadsTableTableManager($_db, $_db.discussionThreads)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_threadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DiscussionPostsTableFilterComposer
    extends Composer<_$AppDatabase, $DiscussionPostsTable> {
  $$DiscussionPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DiscussionThreadsTableFilterComposer get threadId {
    final $$DiscussionThreadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.discussionThreads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscussionThreadsTableFilterComposer(
              $db: $db,
              $table: $db.discussionThreads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DiscussionPostsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscussionPostsTable> {
  $$DiscussionPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DiscussionThreadsTableOrderingComposer get threadId {
    final $$DiscussionThreadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.discussionThreads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscussionThreadsTableOrderingComposer(
              $db: $db,
              $table: $db.discussionThreads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DiscussionPostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscussionPostsTable> {
  $$DiscussionPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DiscussionThreadsTableAnnotationComposer get threadId {
    final $$DiscussionThreadsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.threadId,
            referencedTable: $db.discussionThreads,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DiscussionThreadsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.discussionThreads,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$DiscussionPostsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiscussionPostsTable,
    DiscussionPostRow,
    $$DiscussionPostsTableFilterComposer,
    $$DiscussionPostsTableOrderingComposer,
    $$DiscussionPostsTableAnnotationComposer,
    $$DiscussionPostsTableCreateCompanionBuilder,
    $$DiscussionPostsTableUpdateCompanionBuilder,
    (DiscussionPostRow, $$DiscussionPostsTableReferences),
    DiscussionPostRow,
    PrefetchHooks Function({bool threadId})> {
  $$DiscussionPostsTableTableManager(
      _$AppDatabase db, $DiscussionPostsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscussionPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscussionPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscussionPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> threadId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<String?> role = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscussionPostsCompanion(
            id: id,
            threadId: threadId,
            authorId: authorId,
            role: role,
            body: body,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String threadId,
            required String authorId,
            Value<String?> role = const Value.absent(),
            required String body,
            Value<String> status = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscussionPostsCompanion.insert(
            id: id,
            threadId: threadId,
            authorId: authorId,
            role: role,
            body: body,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DiscussionPostsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({threadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (threadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.threadId,
                    referencedTable:
                        $$DiscussionPostsTableReferences._threadIdTable(db),
                    referencedColumn:
                        $$DiscussionPostsTableReferences._threadIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DiscussionPostsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiscussionPostsTable,
    DiscussionPostRow,
    $$DiscussionPostsTableFilterComposer,
    $$DiscussionPostsTableOrderingComposer,
    $$DiscussionPostsTableAnnotationComposer,
    $$DiscussionPostsTableCreateCompanionBuilder,
    $$DiscussionPostsTableUpdateCompanionBuilder,
    (DiscussionPostRow, $$DiscussionPostsTableReferences),
    DiscussionPostRow,
    PrefetchHooks Function({bool threadId})>;
typedef $$ProgressTableCreateCompanionBuilder = ProgressCompanion Function({
  required String id,
  required String userId,
  required String lessonId,
  required String status,
  Value<double?> quizScore,
  Value<int> timeSpentSeconds,
  Value<int?> startedAt,
  Value<int?> completedAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$ProgressTableUpdateCompanionBuilder = ProgressCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> lessonId,
  Value<String> status,
  Value<double?> quizScore,
  Value<int> timeSpentSeconds,
  Value<int?> startedAt,
  Value<int?> completedAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$ProgressTableReferences
    extends BaseReferences<_$AppDatabase, $ProgressTable, ProgressData> {
  $$ProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) => db.lessons
      .createAlias($_aliasNameGenerator(db.progress.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProgressChangeTrackersTable,
      List<ProgressChangeTracker>> _progressChangeTrackersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.progressChangeTrackers,
          aliasName: $_aliasNameGenerator(
              db.progress.id, db.progressChangeTrackers.progressId));

  $$ProgressChangeTrackersTableProcessedTableManager
      get progressChangeTrackersRefs {
    final manager = $$ProgressChangeTrackersTableTableManager(
            $_db, $_db.progressChangeTrackers)
        .filter((f) => f.progressId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_progressChangeTrackersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quizScore => $composableBuilder(
      column: $table.quizScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> progressChangeTrackersRefs(
      Expression<bool> Function($$ProgressChangeTrackersTableFilterComposer f)
          f) {
    final $$ProgressChangeTrackersTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.progressChangeTrackers,
            getReferencedColumn: (t) => t.progressId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProgressChangeTrackersTableFilterComposer(
                  $db: $db,
                  $table: $db.progressChangeTrackers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quizScore => $composableBuilder(
      column: $table.quizScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get quizScore =>
      $composableBuilder(column: $table.quizScore, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> progressChangeTrackersRefs<T extends Object>(
      Expression<T> Function($$ProgressChangeTrackersTableAnnotationComposer a)
          f) {
    final $$ProgressChangeTrackersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.progressChangeTrackers,
            getReferencedColumn: (t) => t.progressId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProgressChangeTrackersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.progressChangeTrackers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressTable,
    ProgressData,
    $$ProgressTableFilterComposer,
    $$ProgressTableOrderingComposer,
    $$ProgressTableAnnotationComposer,
    $$ProgressTableCreateCompanionBuilder,
    $$ProgressTableUpdateCompanionBuilder,
    (ProgressData, $$ProgressTableReferences),
    ProgressData,
    PrefetchHooks Function({bool lessonId, bool progressChangeTrackersRefs})> {
  $$ProgressTableTableManager(_$AppDatabase db, $ProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double?> quizScore = const Value.absent(),
            Value<int> timeSpentSeconds = const Value.absent(),
            Value<int?> startedAt = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressCompanion(
            id: id,
            userId: userId,
            lessonId: lessonId,
            status: status,
            quizScore: quizScore,
            timeSpentSeconds: timeSpentSeconds,
            startedAt: startedAt,
            completedAt: completedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String lessonId,
            required String status,
            Value<double?> quizScore = const Value.absent(),
            Value<int> timeSpentSeconds = const Value.absent(),
            Value<int?> startedAt = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressCompanion.insert(
            id: id,
            userId: userId,
            lessonId: lessonId,
            status: status,
            quizScore: quizScore,
            timeSpentSeconds: timeSpentSeconds,
            startedAt: startedAt,
            completedAt: completedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProgressTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {lessonId = false, progressChangeTrackersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (progressChangeTrackersRefs) db.progressChangeTrackers
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$ProgressTableReferences._lessonIdTable(db),
                    referencedColumn:
                        $$ProgressTableReferences._lessonIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (progressChangeTrackersRefs)
                    await $_getPrefetchedData<ProgressData, $ProgressTable,
                            ProgressChangeTracker>(
                        currentTable: table,
                        referencedTable: $$ProgressTableReferences
                            ._progressChangeTrackersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProgressTableReferences(db, table, p0)
                                .progressChangeTrackersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.progressId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgressTable,
    ProgressData,
    $$ProgressTableFilterComposer,
    $$ProgressTableOrderingComposer,
    $$ProgressTableAnnotationComposer,
    $$ProgressTableCreateCompanionBuilder,
    $$ProgressTableUpdateCompanionBuilder,
    (ProgressData, $$ProgressTableReferences),
    ProgressData,
    PrefetchHooks Function({bool lessonId, bool progressChangeTrackersRefs})>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String userId,
  required String opType,
  required String payload,
  required int createdAt,
  Value<int?> lastTriedAt,
  Value<int> attempts,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> opType,
  Value<String> payload,
  Value<int> createdAt,
  Value<int?> lastTriedAt,
  Value<int> attempts,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get opType => $composableBuilder(
      column: $table.opType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastTriedAt => $composableBuilder(
      column: $table.lastTriedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get opType => $composableBuilder(
      column: $table.opType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastTriedAt => $composableBuilder(
      column: $table.lastTriedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get opType =>
      $composableBuilder(column: $table.opType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastTriedAt => $composableBuilder(
      column: $table.lastTriedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> opType = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> lastTriedAt = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            userId: userId,
            opType: opType,
            payload: payload,
            createdAt: createdAt,
            lastTriedAt: lastTriedAt,
            attempts: attempts,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String opType,
            required String payload,
            required int createdAt,
            Value<int?> lastTriedAt = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            userId: userId,
            opType: opType,
            payload: payload,
            createdAt: createdAt,
            lastTriedAt: lastTriedAt,
            attempts: attempts,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String classId,
  required String userId,
  required String body,
  required int createdAt,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<bool> flagged,
  Value<String> attachments,
  Value<String?> authorName,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> classId,
  Value<String> userId,
  Value<String> body,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<bool> flagged,
  Value<String> attachments,
  Value<String?> authorName,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessageChangeTrackersTable,
      List<MessageChangeTracker>> _messageChangeTrackersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.messageChangeTrackers,
          aliasName: $_aliasNameGenerator(
              db.messages.id, db.messageChangeTrackers.messageId));

  $$MessageChangeTrackersTableProcessedTableManager
      get messageChangeTrackersRefs {
    final manager = $$MessageChangeTrackersTableTableManager(
            $_db, $_db.messageChangeTrackers)
        .filter((f) => f.messageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_messageChangeTrackersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get flagged => $composableBuilder(
      column: $table.flagged, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnFilters(column));

  Expression<bool> messageChangeTrackersRefs(
      Expression<bool> Function($$MessageChangeTrackersTableFilterComposer f)
          f) {
    final $$MessageChangeTrackersTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.messageChangeTrackers,
            getReferencedColumn: (t) => t.messageId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MessageChangeTrackersTableFilterComposer(
                  $db: $db,
                  $table: $db.messageChangeTrackers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get flagged => $composableBuilder(
      column: $table.flagged, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get flagged =>
      $composableBuilder(column: $table.flagged, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => column);

  Expression<T> messageChangeTrackersRefs<T extends Object>(
      Expression<T> Function($$MessageChangeTrackersTableAnnotationComposer a)
          f) {
    final $$MessageChangeTrackersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.messageChangeTrackers,
            getReferencedColumn: (t) => t.messageId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MessageChangeTrackersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.messageChangeTrackers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool messageChangeTrackersRefs})> {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> classId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> flagged = const Value.absent(),
            Value<String> attachments = const Value.absent(),
            Value<String?> authorName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            classId: classId,
            userId: userId,
            body: body,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            flagged: flagged,
            attachments: attachments,
            authorName: authorName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String classId,
            required String userId,
            required String body,
            required int createdAt,
            Value<int> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> flagged = const Value.absent(),
            Value<String> attachments = const Value.absent(),
            Value<String?> authorName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            classId: classId,
            userId: userId,
            body: body,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            flagged: flagged,
            attachments: attachments,
            authorName: authorName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MessagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({messageChangeTrackersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (messageChangeTrackersRefs) db.messageChangeTrackers
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messageChangeTrackersRefs)
                    await $_getPrefetchedData<Message, $MessagesTable,
                            MessageChangeTracker>(
                        currentTable: table,
                        referencedTable: $$MessagesTableReferences
                            ._messageChangeTrackersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MessagesTableReferences(db, table, p0)
                                .messageChangeTrackersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.messageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool messageChangeTrackersRefs})>;
typedef $$TypingIndicatorsTableCreateCompanionBuilder
    = TypingIndicatorsCompanion Function({
  required String classId,
  required String userId,
  Value<bool> isTyping,
  Value<int> updatedAt,
  Value<int> rowid,
});
typedef $$TypingIndicatorsTableUpdateCompanionBuilder
    = TypingIndicatorsCompanion Function({
  Value<String> classId,
  Value<String> userId,
  Value<bool> isTyping,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$TypingIndicatorsTableFilterComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTable> {
  $$TypingIndicatorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTyping => $composableBuilder(
      column: $table.isTyping, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TypingIndicatorsTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTable> {
  $$TypingIndicatorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTyping => $composableBuilder(
      column: $table.isTyping, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TypingIndicatorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTable> {
  $$TypingIndicatorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isTyping =>
      $composableBuilder(column: $table.isTyping, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TypingIndicatorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TypingIndicatorsTable,
    TypingIndicatorRow,
    $$TypingIndicatorsTableFilterComposer,
    $$TypingIndicatorsTableOrderingComposer,
    $$TypingIndicatorsTableAnnotationComposer,
    $$TypingIndicatorsTableCreateCompanionBuilder,
    $$TypingIndicatorsTableUpdateCompanionBuilder,
    (
      TypingIndicatorRow,
      BaseReferences<_$AppDatabase, $TypingIndicatorsTable, TypingIndicatorRow>
    ),
    TypingIndicatorRow,
    PrefetchHooks Function()> {
  $$TypingIndicatorsTableTableManager(
      _$AppDatabase db, $TypingIndicatorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingIndicatorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TypingIndicatorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TypingIndicatorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> classId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<bool> isTyping = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TypingIndicatorsCompanion(
            classId: classId,
            userId: userId,
            isTyping: isTyping,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String classId,
            required String userId,
            Value<bool> isTyping = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TypingIndicatorsCompanion.insert(
            classId: classId,
            userId: userId,
            isTyping: isTyping,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TypingIndicatorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TypingIndicatorsTable,
    TypingIndicatorRow,
    $$TypingIndicatorsTableFilterComposer,
    $$TypingIndicatorsTableOrderingComposer,
    $$TypingIndicatorsTableAnnotationComposer,
    $$TypingIndicatorsTableCreateCompanionBuilder,
    $$TypingIndicatorsTableUpdateCompanionBuilder,
    (
      TypingIndicatorRow,
      BaseReferences<_$AppDatabase, $TypingIndicatorsTable, TypingIndicatorRow>
    ),
    TypingIndicatorRow,
    PrefetchHooks Function()>;
typedef $$ModerationActionsTableTableCreateCompanionBuilder
    = ModerationActionsTableCompanion Function({
  required String id,
  required String classId,
  required String targetUserId,
  required String moderatorId,
  required String type,
  required String status,
  Value<String?> reason,
  Value<String> metadata,
  required int createdAt,
  Value<int?> expiresAt,
  Value<int> rowid,
});
typedef $$ModerationActionsTableTableUpdateCompanionBuilder
    = ModerationActionsTableCompanion Function({
  Value<String> id,
  Value<String> classId,
  Value<String> targetUserId,
  Value<String> moderatorId,
  Value<String> type,
  Value<String> status,
  Value<String?> reason,
  Value<String> metadata,
  Value<int> createdAt,
  Value<int?> expiresAt,
  Value<int> rowid,
});

final class $$ModerationActionsTableTableReferences extends BaseReferences<
    _$AppDatabase, $ModerationActionsTableTable, ModerationActionRow> {
  $$ModerationActionsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ModerationAppealsTableTable,
      List<ModerationAppealRow>> _moderationAppealsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.moderationAppealsTable,
          aliasName: $_aliasNameGenerator(db.moderationActionsTable.id,
              db.moderationAppealsTable.actionId));

  $$ModerationAppealsTableTableProcessedTableManager
      get moderationAppealsTableRefs {
    final manager = $$ModerationAppealsTableTableTableManager(
            $_db, $_db.moderationAppealsTable)
        .filter((f) => f.actionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_moderationAppealsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ModerationActionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ModerationActionsTableTable> {
  $$ModerationActionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetUserId => $composableBuilder(
      column: $table.targetUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moderatorId => $composableBuilder(
      column: $table.moderatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  Expression<bool> moderationAppealsTableRefs(
      Expression<bool> Function($$ModerationAppealsTableTableFilterComposer f)
          f) {
    final $$ModerationAppealsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.moderationAppealsTable,
            getReferencedColumn: (t) => t.actionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ModerationAppealsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.moderationAppealsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ModerationActionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ModerationActionsTableTable> {
  $$ModerationActionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetUserId => $composableBuilder(
      column: $table.targetUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moderatorId => $composableBuilder(
      column: $table.moderatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$ModerationActionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModerationActionsTableTable> {
  $$ModerationActionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get targetUserId => $composableBuilder(
      column: $table.targetUserId, builder: (column) => column);

  GeneratedColumn<String> get moderatorId => $composableBuilder(
      column: $table.moderatorId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  Expression<T> moderationAppealsTableRefs<T extends Object>(
      Expression<T> Function($$ModerationAppealsTableTableAnnotationComposer a)
          f) {
    final $$ModerationAppealsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.moderationAppealsTable,
            getReferencedColumn: (t) => t.actionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ModerationAppealsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.moderationAppealsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ModerationActionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ModerationActionsTableTable,
    ModerationActionRow,
    $$ModerationActionsTableTableFilterComposer,
    $$ModerationActionsTableTableOrderingComposer,
    $$ModerationActionsTableTableAnnotationComposer,
    $$ModerationActionsTableTableCreateCompanionBuilder,
    $$ModerationActionsTableTableUpdateCompanionBuilder,
    (ModerationActionRow, $$ModerationActionsTableTableReferences),
    ModerationActionRow,
    PrefetchHooks Function({bool moderationAppealsTableRefs})> {
  $$ModerationActionsTableTableTableManager(
      _$AppDatabase db, $ModerationActionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModerationActionsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ModerationActionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModerationActionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> classId = const Value.absent(),
            Value<String> targetUserId = const Value.absent(),
            Value<String> moderatorId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String> metadata = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationActionsTableCompanion(
            id: id,
            classId: classId,
            targetUserId: targetUserId,
            moderatorId: moderatorId,
            type: type,
            status: status,
            reason: reason,
            metadata: metadata,
            createdAt: createdAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String classId,
            required String targetUserId,
            required String moderatorId,
            required String type,
            required String status,
            Value<String?> reason = const Value.absent(),
            Value<String> metadata = const Value.absent(),
            required int createdAt,
            Value<int?> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationActionsTableCompanion.insert(
            id: id,
            classId: classId,
            targetUserId: targetUserId,
            moderatorId: moderatorId,
            type: type,
            status: status,
            reason: reason,
            metadata: metadata,
            createdAt: createdAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ModerationActionsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({moderationAppealsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (moderationAppealsTableRefs) db.moderationAppealsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (moderationAppealsTableRefs)
                    await $_getPrefetchedData<ModerationActionRow,
                            $ModerationActionsTableTable, ModerationAppealRow>(
                        currentTable: table,
                        referencedTable: $$ModerationActionsTableTableReferences
                            ._moderationAppealsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModerationActionsTableTableReferences(
                                    db, table, p0)
                                .moderationAppealsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.actionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ModerationActionsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ModerationActionsTableTable,
        ModerationActionRow,
        $$ModerationActionsTableTableFilterComposer,
        $$ModerationActionsTableTableOrderingComposer,
        $$ModerationActionsTableTableAnnotationComposer,
        $$ModerationActionsTableTableCreateCompanionBuilder,
        $$ModerationActionsTableTableUpdateCompanionBuilder,
        (ModerationActionRow, $$ModerationActionsTableTableReferences),
        ModerationActionRow,
        PrefetchHooks Function({bool moderationAppealsTableRefs})>;
typedef $$ModerationAppealsTableTableCreateCompanionBuilder
    = ModerationAppealsTableCompanion Function({
  required String id,
  required String actionId,
  required String classId,
  required String userId,
  required String message,
  required String status,
  Value<String?> resolutionNotes,
  required int createdAt,
  Value<int?> resolvedAt,
  Value<int> rowid,
});
typedef $$ModerationAppealsTableTableUpdateCompanionBuilder
    = ModerationAppealsTableCompanion Function({
  Value<String> id,
  Value<String> actionId,
  Value<String> classId,
  Value<String> userId,
  Value<String> message,
  Value<String> status,
  Value<String?> resolutionNotes,
  Value<int> createdAt,
  Value<int?> resolvedAt,
  Value<int> rowid,
});

final class $$ModerationAppealsTableTableReferences extends BaseReferences<
    _$AppDatabase, $ModerationAppealsTableTable, ModerationAppealRow> {
  $$ModerationAppealsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ModerationActionsTableTable _actionIdTable(_$AppDatabase db) =>
      db.moderationActionsTable.createAlias($_aliasNameGenerator(
          db.moderationAppealsTable.actionId, db.moderationActionsTable.id));

  $$ModerationActionsTableTableProcessedTableManager get actionId {
    final $_column = $_itemColumn<String>('action_id')!;

    final manager = $$ModerationActionsTableTableTableManager(
            $_db, $_db.moderationActionsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ModerationAppealsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ModerationAppealsTableTable> {
  $$ModerationAppealsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolutionNotes => $composableBuilder(
      column: $table.resolutionNotes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnFilters(column));

  $$ModerationActionsTableTableFilterComposer get actionId {
    final $$ModerationActionsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.actionId,
            referencedTable: $db.moderationActionsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ModerationActionsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.moderationActionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ModerationAppealsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ModerationAppealsTableTable> {
  $$ModerationAppealsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolutionNotes => $composableBuilder(
      column: $table.resolutionNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnOrderings(column));

  $$ModerationActionsTableTableOrderingComposer get actionId {
    final $$ModerationActionsTableTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.actionId,
            referencedTable: $db.moderationActionsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ModerationActionsTableTableOrderingComposer(
                  $db: $db,
                  $table: $db.moderationActionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ModerationAppealsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModerationAppealsTableTable> {
  $$ModerationAppealsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resolutionNotes => $composableBuilder(
      column: $table.resolutionNotes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => column);

  $$ModerationActionsTableTableAnnotationComposer get actionId {
    final $$ModerationActionsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.actionId,
            referencedTable: $db.moderationActionsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ModerationActionsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.moderationActionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ModerationAppealsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ModerationAppealsTableTable,
    ModerationAppealRow,
    $$ModerationAppealsTableTableFilterComposer,
    $$ModerationAppealsTableTableOrderingComposer,
    $$ModerationAppealsTableTableAnnotationComposer,
    $$ModerationAppealsTableTableCreateCompanionBuilder,
    $$ModerationAppealsTableTableUpdateCompanionBuilder,
    (ModerationAppealRow, $$ModerationAppealsTableTableReferences),
    ModerationAppealRow,
    PrefetchHooks Function({bool actionId})> {
  $$ModerationAppealsTableTableTableManager(
      _$AppDatabase db, $ModerationAppealsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModerationAppealsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ModerationAppealsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModerationAppealsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> actionId = const Value.absent(),
            Value<String> classId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> resolutionNotes = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationAppealsTableCompanion(
            id: id,
            actionId: actionId,
            classId: classId,
            userId: userId,
            message: message,
            status: status,
            resolutionNotes: resolutionNotes,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String actionId,
            required String classId,
            required String userId,
            required String message,
            required String status,
            Value<String?> resolutionNotes = const Value.absent(),
            required int createdAt,
            Value<int?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationAppealsTableCompanion.insert(
            id: id,
            actionId: actionId,
            classId: classId,
            userId: userId,
            message: message,
            status: status,
            resolutionNotes: resolutionNotes,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ModerationAppealsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({actionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (actionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.actionId,
                    referencedTable: $$ModerationAppealsTableTableReferences
                        ._actionIdTable(db),
                    referencedColumn: $$ModerationAppealsTableTableReferences
                        ._actionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ModerationAppealsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ModerationAppealsTableTable,
        ModerationAppealRow,
        $$ModerationAppealsTableTableFilterComposer,
        $$ModerationAppealsTableTableOrderingComposer,
        $$ModerationAppealsTableTableAnnotationComposer,
        $$ModerationAppealsTableTableCreateCompanionBuilder,
        $$ModerationAppealsTableTableUpdateCompanionBuilder,
        (ModerationAppealRow, $$ModerationAppealsTableTableReferences),
        ModerationAppealRow,
        PrefetchHooks Function({bool actionId})>;
typedef $$NoteChangeTrackersTableCreateCompanionBuilder
    = NoteChangeTrackersCompanion Function({
  required String noteId,
  required String userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});
typedef $$NoteChangeTrackersTableUpdateCompanionBuilder
    = NoteChangeTrackersCompanion Function({
  Value<String> noteId,
  Value<String> userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});

final class $$NoteChangeTrackersTableReferences extends BaseReferences<
    _$AppDatabase, $NoteChangeTrackersTable, NoteChangeTracker> {
  $$NoteChangeTrackersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) => db.notes.createAlias(
      $_aliasNameGenerator(db.noteChangeTrackers.noteId, db.notes.id));

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager($_db, $_db.notes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NoteChangeTrackersTableFilterComposer
    extends Composer<_$AppDatabase, $NoteChangeTrackersTable> {
  $$NoteChangeTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnFilters(column));

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableFilterComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteChangeTrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteChangeTrackersTable> {
  $$NoteChangeTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnOrderings(column));

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableOrderingComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteChangeTrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteChangeTrackersTable> {
  $$NoteChangeTrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason, builder: (column) => column);

  GeneratedColumn<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload, builder: (column) => column);

  GeneratedColumn<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableAnnotationComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteChangeTrackersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteChangeTrackersTable,
    NoteChangeTracker,
    $$NoteChangeTrackersTableFilterComposer,
    $$NoteChangeTrackersTableOrderingComposer,
    $$NoteChangeTrackersTableAnnotationComposer,
    $$NoteChangeTrackersTableCreateCompanionBuilder,
    $$NoteChangeTrackersTableUpdateCompanionBuilder,
    (NoteChangeTracker, $$NoteChangeTrackersTableReferences),
    NoteChangeTracker,
    PrefetchHooks Function({bool noteId})> {
  $$NoteChangeTrackersTableTableManager(
      _$AppDatabase db, $NoteChangeTrackersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteChangeTrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteChangeTrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteChangeTrackersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> noteId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteChangeTrackersCompanion(
            noteId: noteId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String noteId,
            required String userId,
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteChangeTrackersCompanion.insert(
            noteId: noteId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NoteChangeTrackersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (noteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.noteId,
                    referencedTable:
                        $$NoteChangeTrackersTableReferences._noteIdTable(db),
                    referencedColumn:
                        $$NoteChangeTrackersTableReferences._noteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NoteChangeTrackersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteChangeTrackersTable,
    NoteChangeTracker,
    $$NoteChangeTrackersTableFilterComposer,
    $$NoteChangeTrackersTableOrderingComposer,
    $$NoteChangeTrackersTableAnnotationComposer,
    $$NoteChangeTrackersTableCreateCompanionBuilder,
    $$NoteChangeTrackersTableUpdateCompanionBuilder,
    (NoteChangeTracker, $$NoteChangeTrackersTableReferences),
    NoteChangeTracker,
    PrefetchHooks Function({bool noteId})>;
typedef $$ProgressChangeTrackersTableCreateCompanionBuilder
    = ProgressChangeTrackersCompanion Function({
  required String progressId,
  required String userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});
typedef $$ProgressChangeTrackersTableUpdateCompanionBuilder
    = ProgressChangeTrackersCompanion Function({
  Value<String> progressId,
  Value<String> userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});

final class $$ProgressChangeTrackersTableReferences extends BaseReferences<
    _$AppDatabase, $ProgressChangeTrackersTable, ProgressChangeTracker> {
  $$ProgressChangeTrackersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProgressTable _progressIdTable(_$AppDatabase db) =>
      db.progress.createAlias($_aliasNameGenerator(
          db.progressChangeTrackers.progressId, db.progress.id));

  $$ProgressTableProcessedTableManager get progressId {
    final $_column = $_itemColumn<String>('progress_id')!;

    final manager = $$ProgressTableTableManager($_db, $_db.progress)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_progressIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProgressChangeTrackersTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressChangeTrackersTable> {
  $$ProgressChangeTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnFilters(column));

  $$ProgressTableFilterComposer get progressId {
    final $$ProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.progressId,
        referencedTable: $db.progress,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgressTableFilterComposer(
              $db: $db,
              $table: $db.progress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgressChangeTrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressChangeTrackersTable> {
  $$ProgressChangeTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnOrderings(column));

  $$ProgressTableOrderingComposer get progressId {
    final $$ProgressTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.progressId,
        referencedTable: $db.progress,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgressTableOrderingComposer(
              $db: $db,
              $table: $db.progress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgressChangeTrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressChangeTrackersTable> {
  $$ProgressChangeTrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason, builder: (column) => column);

  GeneratedColumn<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload, builder: (column) => column);

  GeneratedColumn<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt, builder: (column) => column);

  $$ProgressTableAnnotationComposer get progressId {
    final $$ProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.progressId,
        referencedTable: $db.progress,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.progress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgressChangeTrackersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressChangeTrackersTable,
    ProgressChangeTracker,
    $$ProgressChangeTrackersTableFilterComposer,
    $$ProgressChangeTrackersTableOrderingComposer,
    $$ProgressChangeTrackersTableAnnotationComposer,
    $$ProgressChangeTrackersTableCreateCompanionBuilder,
    $$ProgressChangeTrackersTableUpdateCompanionBuilder,
    (ProgressChangeTracker, $$ProgressChangeTrackersTableReferences),
    ProgressChangeTracker,
    PrefetchHooks Function({bool progressId})> {
  $$ProgressChangeTrackersTableTableManager(
      _$AppDatabase db, $ProgressChangeTrackersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressChangeTrackersTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressChangeTrackersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressChangeTrackersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> progressId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressChangeTrackersCompanion(
            progressId: progressId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String progressId,
            required String userId,
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressChangeTrackersCompanion.insert(
            progressId: progressId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProgressChangeTrackersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({progressId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (progressId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.progressId,
                    referencedTable: $$ProgressChangeTrackersTableReferences
                        ._progressIdTable(db),
                    referencedColumn: $$ProgressChangeTrackersTableReferences
                        ._progressIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProgressChangeTrackersTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProgressChangeTrackersTable,
        ProgressChangeTracker,
        $$ProgressChangeTrackersTableFilterComposer,
        $$ProgressChangeTrackersTableOrderingComposer,
        $$ProgressChangeTrackersTableAnnotationComposer,
        $$ProgressChangeTrackersTableCreateCompanionBuilder,
        $$ProgressChangeTrackersTableUpdateCompanionBuilder,
        (ProgressChangeTracker, $$ProgressChangeTrackersTableReferences),
        ProgressChangeTracker,
        PrefetchHooks Function({bool progressId})>;
typedef $$MessageChangeTrackersTableCreateCompanionBuilder
    = MessageChangeTrackersCompanion Function({
  required String messageId,
  required String userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});
typedef $$MessageChangeTrackersTableUpdateCompanionBuilder
    = MessageChangeTrackersCompanion Function({
  Value<String> messageId,
  Value<String> userId,
  Value<int> localUpdatedAt,
  Value<int> remoteUpdatedAt,
  Value<int?> lastSyncedAt,
  Value<String> lastOperation,
  Value<String> status,
  Value<String?> conflictReason,
  Value<String?> conflictPayload,
  Value<int?> conflictDetectedAt,
  Value<int> rowid,
});

final class $$MessageChangeTrackersTableReferences extends BaseReferences<
    _$AppDatabase, $MessageChangeTrackersTable, MessageChangeTracker> {
  $$MessageChangeTrackersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MessagesTable _messageIdTable(_$AppDatabase db) =>
      db.messages.createAlias($_aliasNameGenerator(
          db.messageChangeTrackers.messageId, db.messages.id));

  $$MessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<String>('message_id')!;

    final manager = $$MessagesTableTableManager($_db, $_db.messages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessageChangeTrackersTableFilterComposer
    extends Composer<_$AppDatabase, $MessageChangeTrackersTable> {
  $$MessageChangeTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnFilters(column));

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageChangeTrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageChangeTrackersTable> {
  $$MessageChangeTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt,
      builder: (column) => ColumnOrderings(column));

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableOrderingComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageChangeTrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageChangeTrackersTable> {
  $$MessageChangeTrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get lastOperation => $composableBuilder(
      column: $table.lastOperation, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason, builder: (column) => column);

  GeneratedColumn<String> get conflictPayload => $composableBuilder(
      column: $table.conflictPayload, builder: (column) => column);

  GeneratedColumn<int> get conflictDetectedAt => $composableBuilder(
      column: $table.conflictDetectedAt, builder: (column) => column);

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageChangeTrackersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessageChangeTrackersTable,
    MessageChangeTracker,
    $$MessageChangeTrackersTableFilterComposer,
    $$MessageChangeTrackersTableOrderingComposer,
    $$MessageChangeTrackersTableAnnotationComposer,
    $$MessageChangeTrackersTableCreateCompanionBuilder,
    $$MessageChangeTrackersTableUpdateCompanionBuilder,
    (MessageChangeTracker, $$MessageChangeTrackersTableReferences),
    MessageChangeTracker,
    PrefetchHooks Function({bool messageId})> {
  $$MessageChangeTrackersTableTableManager(
      _$AppDatabase db, $MessageChangeTrackersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageChangeTrackersTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageChangeTrackersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageChangeTrackersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> messageId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageChangeTrackersCompanion(
            messageId: messageId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String messageId,
            required String userId,
            Value<int> localUpdatedAt = const Value.absent(),
            Value<int> remoteUpdatedAt = const Value.absent(),
            Value<int?> lastSyncedAt = const Value.absent(),
            Value<String> lastOperation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> conflictPayload = const Value.absent(),
            Value<int?> conflictDetectedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageChangeTrackersCompanion.insert(
            messageId: messageId,
            userId: userId,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            lastSyncedAt: lastSyncedAt,
            lastOperation: lastOperation,
            status: status,
            conflictReason: conflictReason,
            conflictPayload: conflictPayload,
            conflictDetectedAt: conflictDetectedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MessageChangeTrackersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (messageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.messageId,
                    referencedTable: $$MessageChangeTrackersTableReferences
                        ._messageIdTable(db),
                    referencedColumn: $$MessageChangeTrackersTableReferences
                        ._messageIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessageChangeTrackersTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MessageChangeTrackersTable,
        MessageChangeTracker,
        $$MessageChangeTrackersTableFilterComposer,
        $$MessageChangeTrackersTableOrderingComposer,
        $$MessageChangeTrackersTableAnnotationComposer,
        $$MessageChangeTrackersTableCreateCompanionBuilder,
        $$MessageChangeTrackersTableUpdateCompanionBuilder,
        (MessageChangeTracker, $$MessageChangeTrackersTableReferences),
        MessageChangeTracker,
        PrefetchHooks Function({bool messageId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db, _db.translations);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db, _db.highlights);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$NoteRevisionsTableTableManager get noteRevisions =>
      $$NoteRevisionsTableTableManager(_db, _db.noteRevisions);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$LessonObjectivesTableTableManager get lessonObjectives =>
      $$LessonObjectivesTableTableManager(_db, _db.lessonObjectives);
  $$LessonScripturesTableTableManager get lessonScriptures =>
      $$LessonScripturesTableTableManager(_db, _db.lessonScriptures);
  $$LessonAttachmentsTableTableManager get lessonAttachments =>
      $$LessonAttachmentsTableTableManager(_db, _db.lessonAttachments);
  $$LessonQuizzesTableTableManager get lessonQuizzes =>
      $$LessonQuizzesTableTableManager(_db, _db.lessonQuizzes);
  $$LessonQuizOptionsTableTableManager get lessonQuizOptions =>
      $$LessonQuizOptionsTableTableManager(_db, _db.lessonQuizOptions);
  $$LessonDraftsTableTableManager get lessonDrafts =>
      $$LessonDraftsTableTableManager(_db, _db.lessonDrafts);
  $$LessonFeedsTableTableManager get lessonFeeds =>
      $$LessonFeedsTableTableManager(_db, _db.lessonFeeds);
  $$LessonSourcesTableTableManager get lessonSources =>
      $$LessonSourcesTableTableManager(_db, _db.lessonSources);
  $$RoundtableEventsTableTableManager get roundtableEvents =>
      $$RoundtableEventsTableTableManager(_db, _db.roundtableEvents);
  $$DiscussionThreadsTableTableManager get discussionThreads =>
      $$DiscussionThreadsTableTableManager(_db, _db.discussionThreads);
  $$DiscussionPostsTableTableManager get discussionPosts =>
      $$DiscussionPostsTableTableManager(_db, _db.discussionPosts);
  $$ProgressTableTableManager get progress =>
      $$ProgressTableTableManager(_db, _db.progress);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$TypingIndicatorsTableTableManager get typingIndicators =>
      $$TypingIndicatorsTableTableManager(_db, _db.typingIndicators);
  $$ModerationActionsTableTableTableManager get moderationActionsTable =>
      $$ModerationActionsTableTableTableManager(
          _db, _db.moderationActionsTable);
  $$ModerationAppealsTableTableTableManager get moderationAppealsTable =>
      $$ModerationAppealsTableTableTableManager(
          _db, _db.moderationAppealsTable);
  $$NoteChangeTrackersTableTableManager get noteChangeTrackers =>
      $$NoteChangeTrackersTableTableManager(_db, _db.noteChangeTrackers);
  $$ProgressChangeTrackersTableTableManager get progressChangeTrackers =>
      $$ProgressChangeTrackersTableTableManager(
          _db, _db.progressChangeTrackers);
  $$MessageChangeTrackersTableTableManager get messageChangeTrackers =>
      $$MessageChangeTrackersTableTableManager(_db, _db.messageChangeTrackers);
}
