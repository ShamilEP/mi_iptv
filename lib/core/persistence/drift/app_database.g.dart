// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedChannelsTable extends CachedChannels
    with TableInfo<$CachedChannelsTable, CachedChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bannerUrlMeta = const VerificationMeta(
    'bannerUrl',
  );
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
    'banner_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genresJsonMeta = const VerificationMeta(
    'genresJson',
  );
  @override
  late final GeneratedColumn<String> genresJson = GeneratedColumn<String>(
    'genres_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourcesJsonMeta = const VerificationMeta(
    'sourcesJson',
  );
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
    'sources_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    title,
    type,
    posterUrl,
    bannerUrl,
    genresJson,
    sourcesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedChannel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    }
    if (data.containsKey('banner_url')) {
      context.handle(
        _bannerUrlMeta,
        bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta),
      );
    }
    if (data.containsKey('genres_json')) {
      context.handle(
        _genresJsonMeta,
        genresJson.isAcceptableOrUnknown(data['genres_json']!, _genresJsonMeta),
      );
    }
    if (data.containsKey('sources_json')) {
      context.handle(
        _sourcesJsonMeta,
        sourcesJson.isAcceptableOrUnknown(
          data['sources_json']!,
          _sourcesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  CachedChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedChannel(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      ),
      bannerUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}banner_url'],
      ),
      genresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres_json'],
      )!,
      sourcesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sources_json'],
      )!,
    );
  }

  @override
  $CachedChannelsTable createAlias(String alias) {
    return $CachedChannelsTable(attachedDatabase, alias);
  }
}

class CachedChannel extends DataClass implements Insertable<CachedChannel> {
  final String contentId;
  final String title;
  final String type;
  final String? posterUrl;
  final String? bannerUrl;
  final String genresJson;
  final String sourcesJson;
  const CachedChannel({
    required this.contentId,
    required this.title,
    required this.type,
    this.posterUrl,
    this.bannerUrl,
    required this.genresJson,
    required this.sourcesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || posterUrl != null) {
      map['poster_url'] = Variable<String>(posterUrl);
    }
    if (!nullToAbsent || bannerUrl != null) {
      map['banner_url'] = Variable<String>(bannerUrl);
    }
    map['genres_json'] = Variable<String>(genresJson);
    map['sources_json'] = Variable<String>(sourcesJson);
    return map;
  }

  CachedChannelsCompanion toCompanion(bool nullToAbsent) {
    return CachedChannelsCompanion(
      contentId: Value(contentId),
      title: Value(title),
      type: Value(type),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
      bannerUrl: bannerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bannerUrl),
      genresJson: Value(genresJson),
      sourcesJson: Value(sourcesJson),
    );
  }

  factory CachedChannel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedChannel(
      contentId: serializer.fromJson<String>(json['contentId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      posterUrl: serializer.fromJson<String?>(json['posterUrl']),
      bannerUrl: serializer.fromJson<String?>(json['bannerUrl']),
      genresJson: serializer.fromJson<String>(json['genresJson']),
      sourcesJson: serializer.fromJson<String>(json['sourcesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'posterUrl': serializer.toJson<String?>(posterUrl),
      'bannerUrl': serializer.toJson<String?>(bannerUrl),
      'genresJson': serializer.toJson<String>(genresJson),
      'sourcesJson': serializer.toJson<String>(sourcesJson),
    };
  }

  CachedChannel copyWith({
    String? contentId,
    String? title,
    String? type,
    Value<String?> posterUrl = const Value.absent(),
    Value<String?> bannerUrl = const Value.absent(),
    String? genresJson,
    String? sourcesJson,
  }) => CachedChannel(
    contentId: contentId ?? this.contentId,
    title: title ?? this.title,
    type: type ?? this.type,
    posterUrl: posterUrl.present ? posterUrl.value : this.posterUrl,
    bannerUrl: bannerUrl.present ? bannerUrl.value : this.bannerUrl,
    genresJson: genresJson ?? this.genresJson,
    sourcesJson: sourcesJson ?? this.sourcesJson,
  );
  CachedChannel copyWithCompanion(CachedChannelsCompanion data) {
    return CachedChannel(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      bannerUrl: data.bannerUrl.present ? data.bannerUrl.value : this.bannerUrl,
      genresJson: data.genresJson.present
          ? data.genresJson.value
          : this.genresJson,
      sourcesJson: data.sourcesJson.present
          ? data.sourcesJson.value
          : this.sourcesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannel(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genresJson: $genresJson, ')
          ..write('sourcesJson: $sourcesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    title,
    type,
    posterUrl,
    bannerUrl,
    genresJson,
    sourcesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedChannel &&
          other.contentId == this.contentId &&
          other.title == this.title &&
          other.type == this.type &&
          other.posterUrl == this.posterUrl &&
          other.bannerUrl == this.bannerUrl &&
          other.genresJson == this.genresJson &&
          other.sourcesJson == this.sourcesJson);
}

class CachedChannelsCompanion extends UpdateCompanion<CachedChannel> {
  final Value<String> contentId;
  final Value<String> title;
  final Value<String> type;
  final Value<String?> posterUrl;
  final Value<String?> bannerUrl;
  final Value<String> genresJson;
  final Value<String> sourcesJson;
  final Value<int> rowid;
  const CachedChannelsCompanion({
    this.contentId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedChannelsCompanion.insert({
    required String contentId,
    required String title,
    required String type,
    this.posterUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       title = Value(title),
       type = Value(type);
  static Insertable<CachedChannel> custom({
    Expression<String>? contentId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? posterUrl,
    Expression<String>? bannerUrl,
    Expression<String>? genresJson,
    Expression<String>? sourcesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (genresJson != null) 'genres_json': genresJson,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedChannelsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? title,
    Value<String>? type,
    Value<String?>? posterUrl,
    Value<String?>? bannerUrl,
    Value<String>? genresJson,
    Value<String>? sourcesJson,
    Value<int>? rowid,
  }) {
    return CachedChannelsCompanion(
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      type: type ?? this.type,
      posterUrl: posterUrl ?? this.posterUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      genresJson: genresJson ?? this.genresJson,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (genresJson.present) {
      map['genres_json'] = Variable<String>(genresJson.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannelsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genresJson: $genresJson, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedVodItemsTable extends CachedVodItems
    with TableInfo<$CachedVodItemsTable, CachedVodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedVodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bannerUrlMeta = const VerificationMeta(
    'bannerUrl',
  );
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
    'banner_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genresJsonMeta = const VerificationMeta(
    'genresJson',
  );
  @override
  late final GeneratedColumn<String> genresJson = GeneratedColumn<String>(
    'genres_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourcesJsonMeta = const VerificationMeta(
    'sourcesJson',
  );
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
    'sources_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    title,
    type,
    posterUrl,
    bannerUrl,
    genresJson,
    sourcesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_vod_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedVodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    }
    if (data.containsKey('banner_url')) {
      context.handle(
        _bannerUrlMeta,
        bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta),
      );
    }
    if (data.containsKey('genres_json')) {
      context.handle(
        _genresJsonMeta,
        genresJson.isAcceptableOrUnknown(data['genres_json']!, _genresJsonMeta),
      );
    }
    if (data.containsKey('sources_json')) {
      context.handle(
        _sourcesJsonMeta,
        sourcesJson.isAcceptableOrUnknown(
          data['sources_json']!,
          _sourcesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  CachedVodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedVodItem(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      ),
      bannerUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}banner_url'],
      ),
      genresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres_json'],
      )!,
      sourcesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sources_json'],
      )!,
    );
  }

  @override
  $CachedVodItemsTable createAlias(String alias) {
    return $CachedVodItemsTable(attachedDatabase, alias);
  }
}

class CachedVodItem extends DataClass implements Insertable<CachedVodItem> {
  final String contentId;
  final String title;
  final String type;
  final String? posterUrl;
  final String? bannerUrl;
  final String genresJson;
  final String sourcesJson;
  const CachedVodItem({
    required this.contentId,
    required this.title,
    required this.type,
    this.posterUrl,
    this.bannerUrl,
    required this.genresJson,
    required this.sourcesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || posterUrl != null) {
      map['poster_url'] = Variable<String>(posterUrl);
    }
    if (!nullToAbsent || bannerUrl != null) {
      map['banner_url'] = Variable<String>(bannerUrl);
    }
    map['genres_json'] = Variable<String>(genresJson);
    map['sources_json'] = Variable<String>(sourcesJson);
    return map;
  }

  CachedVodItemsCompanion toCompanion(bool nullToAbsent) {
    return CachedVodItemsCompanion(
      contentId: Value(contentId),
      title: Value(title),
      type: Value(type),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
      bannerUrl: bannerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bannerUrl),
      genresJson: Value(genresJson),
      sourcesJson: Value(sourcesJson),
    );
  }

  factory CachedVodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedVodItem(
      contentId: serializer.fromJson<String>(json['contentId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      posterUrl: serializer.fromJson<String?>(json['posterUrl']),
      bannerUrl: serializer.fromJson<String?>(json['bannerUrl']),
      genresJson: serializer.fromJson<String>(json['genresJson']),
      sourcesJson: serializer.fromJson<String>(json['sourcesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'posterUrl': serializer.toJson<String?>(posterUrl),
      'bannerUrl': serializer.toJson<String?>(bannerUrl),
      'genresJson': serializer.toJson<String>(genresJson),
      'sourcesJson': serializer.toJson<String>(sourcesJson),
    };
  }

  CachedVodItem copyWith({
    String? contentId,
    String? title,
    String? type,
    Value<String?> posterUrl = const Value.absent(),
    Value<String?> bannerUrl = const Value.absent(),
    String? genresJson,
    String? sourcesJson,
  }) => CachedVodItem(
    contentId: contentId ?? this.contentId,
    title: title ?? this.title,
    type: type ?? this.type,
    posterUrl: posterUrl.present ? posterUrl.value : this.posterUrl,
    bannerUrl: bannerUrl.present ? bannerUrl.value : this.bannerUrl,
    genresJson: genresJson ?? this.genresJson,
    sourcesJson: sourcesJson ?? this.sourcesJson,
  );
  CachedVodItem copyWithCompanion(CachedVodItemsCompanion data) {
    return CachedVodItem(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      bannerUrl: data.bannerUrl.present ? data.bannerUrl.value : this.bannerUrl,
      genresJson: data.genresJson.present
          ? data.genresJson.value
          : this.genresJson,
      sourcesJson: data.sourcesJson.present
          ? data.sourcesJson.value
          : this.sourcesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedVodItem(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genresJson: $genresJson, ')
          ..write('sourcesJson: $sourcesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    title,
    type,
    posterUrl,
    bannerUrl,
    genresJson,
    sourcesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedVodItem &&
          other.contentId == this.contentId &&
          other.title == this.title &&
          other.type == this.type &&
          other.posterUrl == this.posterUrl &&
          other.bannerUrl == this.bannerUrl &&
          other.genresJson == this.genresJson &&
          other.sourcesJson == this.sourcesJson);
}

class CachedVodItemsCompanion extends UpdateCompanion<CachedVodItem> {
  final Value<String> contentId;
  final Value<String> title;
  final Value<String> type;
  final Value<String?> posterUrl;
  final Value<String?> bannerUrl;
  final Value<String> genresJson;
  final Value<String> sourcesJson;
  final Value<int> rowid;
  const CachedVodItemsCompanion({
    this.contentId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedVodItemsCompanion.insert({
    required String contentId,
    required String title,
    required String type,
    this.posterUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       title = Value(title),
       type = Value(type);
  static Insertable<CachedVodItem> custom({
    Expression<String>? contentId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? posterUrl,
    Expression<String>? bannerUrl,
    Expression<String>? genresJson,
    Expression<String>? sourcesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (genresJson != null) 'genres_json': genresJson,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedVodItemsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? title,
    Value<String>? type,
    Value<String?>? posterUrl,
    Value<String?>? bannerUrl,
    Value<String>? genresJson,
    Value<String>? sourcesJson,
    Value<int>? rowid,
  }) {
    return CachedVodItemsCompanion(
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      type: type ?? this.type,
      posterUrl: posterUrl ?? this.posterUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      genresJson: genresJson ?? this.genresJson,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (genresJson.present) {
      map['genres_json'] = Variable<String>(genresJson.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedVodItemsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genresJson: $genresJson, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackProgressRowsTable extends PlaybackProgressRows
    with TableInfo<$PlaybackProgressRowsTable, PlaybackProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtServerMeta = const VerificationMeta(
    'updatedAtServer',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtServer =
      GeneratedColumn<DateTime>(
        'updated_at_server',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _forceResetMeta = const VerificationMeta(
    'forceReset',
  );
  @override
  late final GeneratedColumn<bool> forceReset = GeneratedColumn<bool>(
    'force_reset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("force_reset" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    positionMs,
    durationMs,
    syncVersion,
    updatedAtServer,
    forceReset,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncVersionMeta);
    }
    if (data.containsKey('updated_at_server')) {
      context.handle(
        _updatedAtServerMeta,
        updatedAtServer.isAcceptableOrUnknown(
          data['updated_at_server']!,
          _updatedAtServerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtServerMeta);
    }
    if (data.containsKey('force_reset')) {
      context.handle(
        _forceResetMeta,
        forceReset.isAcceptableOrUnknown(data['force_reset']!, _forceResetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  PlaybackProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackProgressRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      updatedAtServer: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_server'],
      )!,
      forceReset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}force_reset'],
      )!,
    );
  }

  @override
  $PlaybackProgressRowsTable createAlias(String alias) {
    return $PlaybackProgressRowsTable(attachedDatabase, alias);
  }
}

class PlaybackProgressRow extends DataClass
    implements Insertable<PlaybackProgressRow> {
  final String contentId;
  final int positionMs;
  final int? durationMs;
  final int syncVersion;
  final DateTime updatedAtServer;
  final bool forceReset;
  const PlaybackProgressRow({
    required this.contentId,
    required this.positionMs,
    this.durationMs,
    required this.syncVersion,
    required this.updatedAtServer,
    required this.forceReset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['position_ms'] = Variable<int>(positionMs);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['sync_version'] = Variable<int>(syncVersion);
    map['updated_at_server'] = Variable<DateTime>(updatedAtServer);
    map['force_reset'] = Variable<bool>(forceReset);
    return map;
  }

  PlaybackProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return PlaybackProgressRowsCompanion(
      contentId: Value(contentId),
      positionMs: Value(positionMs),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      syncVersion: Value(syncVersion),
      updatedAtServer: Value(updatedAtServer),
      forceReset: Value(forceReset),
    );
  }

  factory PlaybackProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackProgressRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      updatedAtServer: serializer.fromJson<DateTime>(json['updatedAtServer']),
      forceReset: serializer.fromJson<bool>(json['forceReset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'positionMs': serializer.toJson<int>(positionMs),
      'durationMs': serializer.toJson<int?>(durationMs),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'updatedAtServer': serializer.toJson<DateTime>(updatedAtServer),
      'forceReset': serializer.toJson<bool>(forceReset),
    };
  }

  PlaybackProgressRow copyWith({
    String? contentId,
    int? positionMs,
    Value<int?> durationMs = const Value.absent(),
    int? syncVersion,
    DateTime? updatedAtServer,
    bool? forceReset,
  }) => PlaybackProgressRow(
    contentId: contentId ?? this.contentId,
    positionMs: positionMs ?? this.positionMs,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    syncVersion: syncVersion ?? this.syncVersion,
    updatedAtServer: updatedAtServer ?? this.updatedAtServer,
    forceReset: forceReset ?? this.forceReset,
  );
  PlaybackProgressRow copyWithCompanion(PlaybackProgressRowsCompanion data) {
    return PlaybackProgressRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      updatedAtServer: data.updatedAtServer.present
          ? data.updatedAtServer.value
          : this.updatedAtServer,
      forceReset: data.forceReset.present
          ? data.forceReset.value
          : this.forceReset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRow(')
          ..write('contentId: $contentId, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAtServer: $updatedAtServer, ')
          ..write('forceReset: $forceReset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    positionMs,
    durationMs,
    syncVersion,
    updatedAtServer,
    forceReset,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackProgressRow &&
          other.contentId == this.contentId &&
          other.positionMs == this.positionMs &&
          other.durationMs == this.durationMs &&
          other.syncVersion == this.syncVersion &&
          other.updatedAtServer == this.updatedAtServer &&
          other.forceReset == this.forceReset);
}

class PlaybackProgressRowsCompanion
    extends UpdateCompanion<PlaybackProgressRow> {
  final Value<String> contentId;
  final Value<int> positionMs;
  final Value<int?> durationMs;
  final Value<int> syncVersion;
  final Value<DateTime> updatedAtServer;
  final Value<bool> forceReset;
  final Value<int> rowid;
  const PlaybackProgressRowsCompanion({
    this.contentId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAtServer = const Value.absent(),
    this.forceReset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackProgressRowsCompanion.insert({
    required String contentId,
    required int positionMs,
    this.durationMs = const Value.absent(),
    required int syncVersion,
    required DateTime updatedAtServer,
    this.forceReset = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       positionMs = Value(positionMs),
       syncVersion = Value(syncVersion),
       updatedAtServer = Value(updatedAtServer);
  static Insertable<PlaybackProgressRow> custom({
    Expression<String>? contentId,
    Expression<int>? positionMs,
    Expression<int>? durationMs,
    Expression<int>? syncVersion,
    Expression<DateTime>? updatedAtServer,
    Expression<bool>? forceReset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (positionMs != null) 'position_ms': positionMs,
      if (durationMs != null) 'duration_ms': durationMs,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (updatedAtServer != null) 'updated_at_server': updatedAtServer,
      if (forceReset != null) 'force_reset': forceReset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackProgressRowsCompanion copyWith({
    Value<String>? contentId,
    Value<int>? positionMs,
    Value<int?>? durationMs,
    Value<int>? syncVersion,
    Value<DateTime>? updatedAtServer,
    Value<bool>? forceReset,
    Value<int>? rowid,
  }) {
    return PlaybackProgressRowsCompanion(
      contentId: contentId ?? this.contentId,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAtServer: updatedAtServer ?? this.updatedAtServer,
      forceReset: forceReset ?? this.forceReset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (updatedAtServer.present) {
      map['updated_at_server'] = Variable<DateTime>(updatedAtServer.value);
    }
    if (forceReset.present) {
      map['force_reset'] = Variable<bool>(forceReset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRowsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAtServer: $updatedAtServer, ')
          ..write('forceReset: $forceReset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteRowsTable extends FavoriteRows
    with TableInfo<$FavoriteRowsTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtServerMeta = const VerificationMeta(
    'updatedAtServer',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtServer =
      GeneratedColumn<DateTime>(
        'updated_at_server',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    contentType,
    title,
    sortOrder,
    syncVersion,
    updatedAtServer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncVersionMeta);
    }
    if (data.containsKey('updated_at_server')) {
      context.handle(
        _updatedAtServerMeta,
        updatedAtServer.isAcceptableOrUnknown(
          data['updated_at_server']!,
          _updatedAtServerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtServerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      updatedAtServer: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_server'],
      )!,
    );
  }

  @override
  $FavoriteRowsTable createAlias(String alias) {
    return $FavoriteRowsTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  final String contentId;
  final String contentType;
  final String title;
  final int sortOrder;
  final int syncVersion;
  final DateTime updatedAtServer;
  const FavoriteRow({
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.sortOrder,
    required this.syncVersion,
    required this.updatedAtServer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['content_type'] = Variable<String>(contentType);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    map['sync_version'] = Variable<int>(syncVersion);
    map['updated_at_server'] = Variable<DateTime>(updatedAtServer);
    return map;
  }

  FavoriteRowsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteRowsCompanion(
      contentId: Value(contentId),
      contentType: Value(contentType),
      title: Value(title),
      sortOrder: Value(sortOrder),
      syncVersion: Value(syncVersion),
      updatedAtServer: Value(updatedAtServer),
    );
  }

  factory FavoriteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      updatedAtServer: serializer.fromJson<DateTime>(json['updatedAtServer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'contentType': serializer.toJson<String>(contentType),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'updatedAtServer': serializer.toJson<DateTime>(updatedAtServer),
    };
  }

  FavoriteRow copyWith({
    String? contentId,
    String? contentType,
    String? title,
    int? sortOrder,
    int? syncVersion,
    DateTime? updatedAtServer,
  }) => FavoriteRow(
    contentId: contentId ?? this.contentId,
    contentType: contentType ?? this.contentType,
    title: title ?? this.title,
    sortOrder: sortOrder ?? this.sortOrder,
    syncVersion: syncVersion ?? this.syncVersion,
    updatedAtServer: updatedAtServer ?? this.updatedAtServer,
  );
  FavoriteRow copyWithCompanion(FavoriteRowsCompanion data) {
    return FavoriteRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      updatedAtServer: data.updatedAtServer.present
          ? data.updatedAtServer.value
          : this.updatedAtServer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('contentId: $contentId, ')
          ..write('contentType: $contentType, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAtServer: $updatedAtServer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    contentType,
    title,
    sortOrder,
    syncVersion,
    updatedAtServer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.contentId == this.contentId &&
          other.contentType == this.contentType &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder &&
          other.syncVersion == this.syncVersion &&
          other.updatedAtServer == this.updatedAtServer);
}

class FavoriteRowsCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<String> contentId;
  final Value<String> contentType;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<int> syncVersion;
  final Value<DateTime> updatedAtServer;
  final Value<int> rowid;
  const FavoriteRowsCompanion({
    this.contentId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAtServer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteRowsCompanion.insert({
    required String contentId,
    required String contentType,
    required String title,
    required int sortOrder,
    required int syncVersion,
    required DateTime updatedAtServer,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       contentType = Value(contentType),
       title = Value(title),
       sortOrder = Value(sortOrder),
       syncVersion = Value(syncVersion),
       updatedAtServer = Value(updatedAtServer);
  static Insertable<FavoriteRow> custom({
    Expression<String>? contentId,
    Expression<String>? contentType,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<int>? syncVersion,
    Expression<DateTime>? updatedAtServer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (contentType != null) 'content_type': contentType,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (updatedAtServer != null) 'updated_at_server': updatedAtServer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteRowsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? contentType,
    Value<String>? title,
    Value<int>? sortOrder,
    Value<int>? syncVersion,
    Value<DateTime>? updatedAtServer,
    Value<int>? rowid,
  }) {
    return FavoriteRowsCompanion(
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAtServer: updatedAtServer ?? this.updatedAtServer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (updatedAtServer.present) {
      map['updated_at_server'] = Variable<DateTime>(updatedAtServer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRowsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('contentType: $contentType, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAtServer: $updatedAtServer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceRowsTable extends SourceRows
    with TableInfo<$SourceRowsTable, SourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [sourceId, kind, displayName, baseUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceId};
  @override
  SourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRow(
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      ),
    );
  }

  @override
  $SourceRowsTable createAlias(String alias) {
    return $SourceRowsTable(attachedDatabase, alias);
  }
}

class SourceRow extends DataClass implements Insertable<SourceRow> {
  final String sourceId;
  final String kind;
  final String displayName;
  final String? baseUrl;
  const SourceRow({
    required this.sourceId,
    required this.kind,
    required this.displayName,
    this.baseUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_id'] = Variable<String>(sourceId);
    map['kind'] = Variable<String>(kind);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || baseUrl != null) {
      map['base_url'] = Variable<String>(baseUrl);
    }
    return map;
  }

  SourceRowsCompanion toCompanion(bool nullToAbsent) {
    return SourceRowsCompanion(
      sourceId: Value(sourceId),
      kind: Value(kind),
      displayName: Value(displayName),
      baseUrl: baseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUrl),
    );
  }

  factory SourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRow(
      sourceId: serializer.fromJson<String>(json['sourceId']),
      kind: serializer.fromJson<String>(json['kind']),
      displayName: serializer.fromJson<String>(json['displayName']),
      baseUrl: serializer.fromJson<String?>(json['baseUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourceId': serializer.toJson<String>(sourceId),
      'kind': serializer.toJson<String>(kind),
      'displayName': serializer.toJson<String>(displayName),
      'baseUrl': serializer.toJson<String?>(baseUrl),
    };
  }

  SourceRow copyWith({
    String? sourceId,
    String? kind,
    String? displayName,
    Value<String?> baseUrl = const Value.absent(),
  }) => SourceRow(
    sourceId: sourceId ?? this.sourceId,
    kind: kind ?? this.kind,
    displayName: displayName ?? this.displayName,
    baseUrl: baseUrl.present ? baseUrl.value : this.baseUrl,
  );
  SourceRow copyWithCompanion(SourceRowsCompanion data) {
    return SourceRow(
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceRow(')
          ..write('sourceId: $sourceId, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sourceId, kind, displayName, baseUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceRow &&
          other.sourceId == this.sourceId &&
          other.kind == this.kind &&
          other.displayName == this.displayName &&
          other.baseUrl == this.baseUrl);
}

class SourceRowsCompanion extends UpdateCompanion<SourceRow> {
  final Value<String> sourceId;
  final Value<String> kind;
  final Value<String> displayName;
  final Value<String?> baseUrl;
  final Value<int> rowid;
  const SourceRowsCompanion({
    this.sourceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.displayName = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceRowsCompanion.insert({
    required String sourceId,
    required String kind,
    required String displayName,
    this.baseUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sourceId = Value(sourceId),
       kind = Value(kind),
       displayName = Value(displayName);
  static Insertable<SourceRow> custom({
    Expression<String>? sourceId,
    Expression<String>? kind,
    Expression<String>? displayName,
    Expression<String>? baseUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourceId != null) 'source_id': sourceId,
      if (kind != null) 'kind': kind,
      if (displayName != null) 'display_name': displayName,
      if (baseUrl != null) 'base_url': baseUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceRowsCompanion copyWith({
    Value<String>? sourceId,
    Value<String>? kind,
    Value<String>? displayName,
    Value<String?>? baseUrl,
    Value<int>? rowid,
  }) {
    return SourceRowsCompanion(
      sourceId: sourceId ?? this.sourceId,
      kind: kind ?? this.kind,
      displayName: displayName ?? this.displayName,
      baseUrl: baseUrl ?? this.baseUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceRowsCompanion(')
          ..write('sourceId: $sourceId, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingRowsTable extends SettingRows
    with TableInfo<$SettingRowsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingRowsTable createAlias(String alias) {
    return $SettingRowsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingRowsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingRowsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingRowsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingRowsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingRowsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingRowsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingRowsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingRowsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxRowsTable extends OutboxRows
    with TableInfo<$OutboxRowsTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityKindMeta = const VerificationMeta(
    'entityKind',
  );
  @override
  late final GeneratedColumn<String> entityKind = GeneratedColumn<String>(
    'entity_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enqueuedAtMeta = const VerificationMeta(
    'enqueuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> enqueuedAt = GeneratedColumn<DateTime>(
    'enqueued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityKind,
    operation,
    entityId,
    payloadJson,
    enqueuedAt,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_kind')) {
      context.handle(
        _entityKindMeta,
        entityKind.isAcceptableOrUnknown(data['entity_kind']!, _entityKindMeta),
      );
    } else if (isInserting) {
      context.missing(_entityKindMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('enqueued_at')) {
      context.handle(
        _enqueuedAtMeta,
        enqueuedAt.isAcceptableOrUnknown(data['enqueued_at']!, _enqueuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enqueuedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_kind'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      enqueuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}enqueued_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $OutboxRowsTable createAlias(String alias) {
    return $OutboxRowsTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final String id;
  final String entityKind;
  final String operation;
  final String entityId;
  final String payloadJson;
  final DateTime enqueuedAt;
  final int attempts;
  const OutboxRow({
    required this.id,
    required this.entityKind,
    required this.operation,
    required this.entityId,
    required this.payloadJson,
    required this.enqueuedAt,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_kind'] = Variable<String>(entityKind);
    map['operation'] = Variable<String>(operation);
    map['entity_id'] = Variable<String>(entityId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['enqueued_at'] = Variable<DateTime>(enqueuedAt);
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  OutboxRowsCompanion toCompanion(bool nullToAbsent) {
    return OutboxRowsCompanion(
      id: Value(id),
      entityKind: Value(entityKind),
      operation: Value(operation),
      entityId: Value(entityId),
      payloadJson: Value(payloadJson),
      enqueuedAt: Value(enqueuedAt),
      attempts: Value(attempts),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<String>(json['id']),
      entityKind: serializer.fromJson<String>(json['entityKind']),
      operation: serializer.fromJson<String>(json['operation']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      enqueuedAt: serializer.fromJson<DateTime>(json['enqueuedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityKind': serializer.toJson<String>(entityKind),
      'operation': serializer.toJson<String>(operation),
      'entityId': serializer.toJson<String>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'enqueuedAt': serializer.toJson<DateTime>(enqueuedAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  OutboxRow copyWith({
    String? id,
    String? entityKind,
    String? operation,
    String? entityId,
    String? payloadJson,
    DateTime? enqueuedAt,
    int? attempts,
  }) => OutboxRow(
    id: id ?? this.id,
    entityKind: entityKind ?? this.entityKind,
    operation: operation ?? this.operation,
    entityId: entityId ?? this.entityId,
    payloadJson: payloadJson ?? this.payloadJson,
    enqueuedAt: enqueuedAt ?? this.enqueuedAt,
    attempts: attempts ?? this.attempts,
  );
  OutboxRow copyWithCompanion(OutboxRowsCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      entityKind: data.entityKind.present
          ? data.entityKind.value
          : this.entityKind,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      enqueuedAt: data.enqueuedAt.present
          ? data.enqueuedAt.value
          : this.enqueuedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('entityKind: $entityKind, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityKind,
    operation,
    entityId,
    payloadJson,
    enqueuedAt,
    attempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.entityKind == this.entityKind &&
          other.operation == this.operation &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.enqueuedAt == this.enqueuedAt &&
          other.attempts == this.attempts);
}

class OutboxRowsCompanion extends UpdateCompanion<OutboxRow> {
  final Value<String> id;
  final Value<String> entityKind;
  final Value<String> operation;
  final Value<String> entityId;
  final Value<String> payloadJson;
  final Value<DateTime> enqueuedAt;
  final Value<int> attempts;
  final Value<int> rowid;
  const OutboxRowsCompanion({
    this.id = const Value.absent(),
    this.entityKind = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.enqueuedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxRowsCompanion.insert({
    required String id,
    required String entityKind,
    required String operation,
    required String entityId,
    required String payloadJson,
    required DateTime enqueuedAt,
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityKind = Value(entityKind),
       operation = Value(operation),
       entityId = Value(entityId),
       payloadJson = Value(payloadJson),
       enqueuedAt = Value(enqueuedAt);
  static Insertable<OutboxRow> custom({
    Expression<String>? id,
    Expression<String>? entityKind,
    Expression<String>? operation,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<DateTime>? enqueuedAt,
    Expression<int>? attempts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityKind != null) 'entity_kind': entityKind,
      if (operation != null) 'operation': operation,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (enqueuedAt != null) 'enqueued_at': enqueuedAt,
      if (attempts != null) 'attempts': attempts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityKind,
    Value<String>? operation,
    Value<String>? entityId,
    Value<String>? payloadJson,
    Value<DateTime>? enqueuedAt,
    Value<int>? attempts,
    Value<int>? rowid,
  }) {
    return OutboxRowsCompanion(
      id: id ?? this.id,
      entityKind: entityKind ?? this.entityKind,
      operation: operation ?? this.operation,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
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
    if (entityKind.present) {
      map['entity_kind'] = Variable<String>(entityKind.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (enqueuedAt.present) {
      map['enqueued_at'] = Variable<DateTime>(enqueuedAt.value);
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
    return (StringBuffer('OutboxRowsCompanion(')
          ..write('id: $id, ')
          ..write('entityKind: $entityKind, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('attempts: $attempts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedChannelsTable cachedChannels = $CachedChannelsTable(this);
  late final $CachedVodItemsTable cachedVodItems = $CachedVodItemsTable(this);
  late final $PlaybackProgressRowsTable playbackProgressRows =
      $PlaybackProgressRowsTable(this);
  late final $FavoriteRowsTable favoriteRows = $FavoriteRowsTable(this);
  late final $SourceRowsTable sourceRows = $SourceRowsTable(this);
  late final $SettingRowsTable settingRows = $SettingRowsTable(this);
  late final $OutboxRowsTable outboxRows = $OutboxRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedChannels,
    cachedVodItems,
    playbackProgressRows,
    favoriteRows,
    sourceRows,
    settingRows,
    outboxRows,
  ];
}

typedef $$CachedChannelsTableCreateCompanionBuilder =
    CachedChannelsCompanion Function({
      required String contentId,
      required String title,
      required String type,
      Value<String?> posterUrl,
      Value<String?> bannerUrl,
      Value<String> genresJson,
      Value<String> sourcesJson,
      Value<int> rowid,
    });
typedef $$CachedChannelsTableUpdateCompanionBuilder =
    CachedChannelsCompanion Function({
      Value<String> contentId,
      Value<String> title,
      Value<String> type,
      Value<String?> posterUrl,
      Value<String?> bannerUrl,
      Value<String> genresJson,
      Value<String> sourcesJson,
      Value<int> rowid,
    });

class $$CachedChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<String> get bannerUrl =>
      $composableBuilder(column: $table.bannerUrl, builder: (column) => column);

  GeneratedColumn<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => column,
  );
}

class $$CachedChannelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedChannelsTable,
          CachedChannel,
          $$CachedChannelsTableFilterComposer,
          $$CachedChannelsTableOrderingComposer,
          $$CachedChannelsTableAnnotationComposer,
          $$CachedChannelsTableCreateCompanionBuilder,
          $$CachedChannelsTableUpdateCompanionBuilder,
          (
            CachedChannel,
            BaseReferences<_$AppDatabase, $CachedChannelsTable, CachedChannel>,
          ),
          CachedChannel,
          PrefetchHooks Function()
        > {
  $$CachedChannelsTableTableManager(
    _$AppDatabase db,
    $CachedChannelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelsCompanion(
                contentId: contentId,
                title: title,
                type: type,
                posterUrl: posterUrl,
                bannerUrl: bannerUrl,
                genresJson: genresJson,
                sourcesJson: sourcesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String title,
                required String type,
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelsCompanion.insert(
                contentId: contentId,
                title: title,
                type: type,
                posterUrl: posterUrl,
                bannerUrl: bannerUrl,
                genresJson: genresJson,
                sourcesJson: sourcesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedChannelsTable, CachedChannel>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedChannelsTable,
                    CachedChannel
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedChannelsTable,
      CachedChannel,
      $$CachedChannelsTableFilterComposer,
      $$CachedChannelsTableOrderingComposer,
      $$CachedChannelsTableAnnotationComposer,
      $$CachedChannelsTableCreateCompanionBuilder,
      $$CachedChannelsTableUpdateCompanionBuilder,
      (
        CachedChannel,
        BaseReferences<_$AppDatabase, $CachedChannelsTable, CachedChannel>,
      ),
      CachedChannel,
      PrefetchHooks Function()
    >;
typedef $$CachedVodItemsTableCreateCompanionBuilder =
    CachedVodItemsCompanion Function({
      required String contentId,
      required String title,
      required String type,
      Value<String?> posterUrl,
      Value<String?> bannerUrl,
      Value<String> genresJson,
      Value<String> sourcesJson,
      Value<int> rowid,
    });
typedef $$CachedVodItemsTableUpdateCompanionBuilder =
    CachedVodItemsCompanion Function({
      Value<String> contentId,
      Value<String> title,
      Value<String> type,
      Value<String?> posterUrl,
      Value<String?> bannerUrl,
      Value<String> genresJson,
      Value<String> sourcesJson,
      Value<int> rowid,
    });

class $$CachedVodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedVodItemsTable> {
  $$CachedVodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedVodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedVodItemsTable> {
  $$CachedVodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedVodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedVodItemsTable> {
  $$CachedVodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<String> get bannerUrl =>
      $composableBuilder(column: $table.bannerUrl, builder: (column) => column);

  GeneratedColumn<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => column,
  );
}

class $$CachedVodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedVodItemsTable,
          CachedVodItem,
          $$CachedVodItemsTableFilterComposer,
          $$CachedVodItemsTableOrderingComposer,
          $$CachedVodItemsTableAnnotationComposer,
          $$CachedVodItemsTableCreateCompanionBuilder,
          $$CachedVodItemsTableUpdateCompanionBuilder,
          (
            CachedVodItem,
            BaseReferences<_$AppDatabase, $CachedVodItemsTable, CachedVodItem>,
          ),
          CachedVodItem,
          PrefetchHooks Function()
        > {
  $$CachedVodItemsTableTableManager(
    _$AppDatabase db,
    $CachedVodItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedVodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedVodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedVodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedVodItemsCompanion(
                contentId: contentId,
                title: title,
                type: type,
                posterUrl: posterUrl,
                bannerUrl: bannerUrl,
                genresJson: genresJson,
                sourcesJson: sourcesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String title,
                required String type,
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedVodItemsCompanion.insert(
                contentId: contentId,
                title: title,
                type: type,
                posterUrl: posterUrl,
                bannerUrl: bannerUrl,
                genresJson: genresJson,
                sourcesJson: sourcesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedVodItemsTable, CachedVodItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedVodItemsTable,
                    CachedVodItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedVodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedVodItemsTable,
      CachedVodItem,
      $$CachedVodItemsTableFilterComposer,
      $$CachedVodItemsTableOrderingComposer,
      $$CachedVodItemsTableAnnotationComposer,
      $$CachedVodItemsTableCreateCompanionBuilder,
      $$CachedVodItemsTableUpdateCompanionBuilder,
      (
        CachedVodItem,
        BaseReferences<_$AppDatabase, $CachedVodItemsTable, CachedVodItem>,
      ),
      CachedVodItem,
      PrefetchHooks Function()
    >;
typedef $$PlaybackProgressRowsTableCreateCompanionBuilder =
    PlaybackProgressRowsCompanion Function({
      required String contentId,
      required int positionMs,
      Value<int?> durationMs,
      required int syncVersion,
      required DateTime updatedAtServer,
      Value<bool> forceReset,
      Value<int> rowid,
    });
typedef $$PlaybackProgressRowsTableUpdateCompanionBuilder =
    PlaybackProgressRowsCompanion Function({
      Value<String> contentId,
      Value<int> positionMs,
      Value<int?> durationMs,
      Value<int> syncVersion,
      Value<DateTime> updatedAtServer,
      Value<bool> forceReset,
      Value<int> rowid,
    });

class $$PlaybackProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get forceReset => $composableBuilder(
    column: $table.forceReset,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaybackProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get forceReset => $composableBuilder(
    column: $table.forceReset,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaybackProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get forceReset => $composableBuilder(
    column: $table.forceReset,
    builder: (column) => column,
  );
}

class $$PlaybackProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackProgressRowsTable,
          PlaybackProgressRow,
          $$PlaybackProgressRowsTableFilterComposer,
          $$PlaybackProgressRowsTableOrderingComposer,
          $$PlaybackProgressRowsTableAnnotationComposer,
          $$PlaybackProgressRowsTableCreateCompanionBuilder,
          $$PlaybackProgressRowsTableUpdateCompanionBuilder,
          (
            PlaybackProgressRow,
            BaseReferences<
              _$AppDatabase,
              $PlaybackProgressRowsTable,
              PlaybackProgressRow
            >,
          ),
          PlaybackProgressRow,
          PrefetchHooks Function()
        > {
  $$PlaybackProgressRowsTableTableManager(
    _$AppDatabase db,
    $PlaybackProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackProgressRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PlaybackProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAtServer = const Value.absent(),
                Value<bool> forceReset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressRowsCompanion(
                contentId: contentId,
                positionMs: positionMs,
                durationMs: durationMs,
                syncVersion: syncVersion,
                updatedAtServer: updatedAtServer,
                forceReset: forceReset,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required int positionMs,
                Value<int?> durationMs = const Value.absent(),
                required int syncVersion,
                required DateTime updatedAtServer,
                Value<bool> forceReset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressRowsCompanion.insert(
                contentId: contentId,
                positionMs: positionMs,
                durationMs: durationMs,
                syncVersion: syncVersion,
                updatedAtServer: updatedAtServer,
                forceReset: forceReset,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaybackProgressRowsTable, PlaybackProgressRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $PlaybackProgressRowsTable,
                    PlaybackProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaybackProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackProgressRowsTable,
      PlaybackProgressRow,
      $$PlaybackProgressRowsTableFilterComposer,
      $$PlaybackProgressRowsTableOrderingComposer,
      $$PlaybackProgressRowsTableAnnotationComposer,
      $$PlaybackProgressRowsTableCreateCompanionBuilder,
      $$PlaybackProgressRowsTableUpdateCompanionBuilder,
      (
        PlaybackProgressRow,
        BaseReferences<
          _$AppDatabase,
          $PlaybackProgressRowsTable,
          PlaybackProgressRow
        >,
      ),
      PlaybackProgressRow,
      PrefetchHooks Function()
    >;
typedef $$FavoriteRowsTableCreateCompanionBuilder =
    FavoriteRowsCompanion Function({
      required String contentId,
      required String contentType,
      required String title,
      required int sortOrder,
      required int syncVersion,
      required DateTime updatedAtServer,
      Value<int> rowid,
    });
typedef $$FavoriteRowsTableUpdateCompanionBuilder =
    FavoriteRowsCompanion Function({
      Value<String> contentId,
      Value<String> contentType,
      Value<String> title,
      Value<int> sortOrder,
      Value<int> syncVersion,
      Value<DateTime> updatedAtServer,
      Value<int> rowid,
    });

class $$FavoriteRowsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteRowsTable> {
  $$FavoriteRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteRowsTable> {
  $$FavoriteRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteRowsTable> {
  $$FavoriteRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtServer => $composableBuilder(
    column: $table.updatedAtServer,
    builder: (column) => column,
  );
}

class $$FavoriteRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteRowsTable,
          FavoriteRow,
          $$FavoriteRowsTableFilterComposer,
          $$FavoriteRowsTableOrderingComposer,
          $$FavoriteRowsTableAnnotationComposer,
          $$FavoriteRowsTableCreateCompanionBuilder,
          $$FavoriteRowsTableUpdateCompanionBuilder,
          (
            FavoriteRow,
            BaseReferences<_$AppDatabase, $FavoriteRowsTable, FavoriteRow>,
          ),
          FavoriteRow,
          PrefetchHooks Function()
        > {
  $$FavoriteRowsTableTableManager(_$AppDatabase db, $FavoriteRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAtServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteRowsCompanion(
                contentId: contentId,
                contentType: contentType,
                title: title,
                sortOrder: sortOrder,
                syncVersion: syncVersion,
                updatedAtServer: updatedAtServer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String contentType,
                required String title,
                required int sortOrder,
                required int syncVersion,
                required DateTime updatedAtServer,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteRowsCompanion.insert(
                contentId: contentId,
                contentType: contentType,
                title: title,
                sortOrder: sortOrder,
                syncVersion: syncVersion,
                updatedAtServer: updatedAtServer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoriteRowsTable, FavoriteRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FavoriteRowsTable,
                    FavoriteRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteRowsTable,
      FavoriteRow,
      $$FavoriteRowsTableFilterComposer,
      $$FavoriteRowsTableOrderingComposer,
      $$FavoriteRowsTableAnnotationComposer,
      $$FavoriteRowsTableCreateCompanionBuilder,
      $$FavoriteRowsTableUpdateCompanionBuilder,
      (
        FavoriteRow,
        BaseReferences<_$AppDatabase, $FavoriteRowsTable, FavoriteRow>,
      ),
      FavoriteRow,
      PrefetchHooks Function()
    >;
typedef $$SourceRowsTableCreateCompanionBuilder = SourceRowsCompanion Function({
  required String sourceId,
  required String kind,
  required String displayName,
  Value<String?> baseUrl,
  Value<int> rowid,
});
typedef $$SourceRowsTableUpdateCompanionBuilder = SourceRowsCompanion Function({
  Value<String> sourceId,
  Value<String> kind,
  Value<String> displayName,
  Value<String?> baseUrl,
  Value<int> rowid,
});

class $$SourceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceRowsTable> {
  $$SourceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceRowsTable> {
  $$SourceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceRowsTable> {
  $$SourceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);
}

class $$SourceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceRowsTable,
          SourceRow,
          $$SourceRowsTableFilterComposer,
          $$SourceRowsTableOrderingComposer,
          $$SourceRowsTableAnnotationComposer,
          $$SourceRowsTableCreateCompanionBuilder,
          $$SourceRowsTableUpdateCompanionBuilder,
          (
            SourceRow,
            BaseReferences<_$AppDatabase, $SourceRowsTable, SourceRow>,
          ),
          SourceRow,
          PrefetchHooks Function()
        > {
  $$SourceRowsTableTableManager(_$AppDatabase db, $SourceRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sourceId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> baseUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceRowsCompanion(
                sourceId: sourceId,
                kind: kind,
                displayName: displayName,
                baseUrl: baseUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sourceId,
                required String kind,
                required String displayName,
                Value<String?> baseUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceRowsCompanion.insert(
                sourceId: sourceId,
                kind: kind,
                displayName: displayName,
                baseUrl: baseUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceRowsTable, SourceRow>(table),
                  BaseReferences<_$AppDatabase, $SourceRowsTable, SourceRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceRowsTable,
      SourceRow,
      $$SourceRowsTableFilterComposer,
      $$SourceRowsTableOrderingComposer,
      $$SourceRowsTableAnnotationComposer,
      $$SourceRowsTableCreateCompanionBuilder,
      $$SourceRowsTableUpdateCompanionBuilder,
      (SourceRow, BaseReferences<_$AppDatabase, $SourceRowsTable, SourceRow>),
      SourceRow,
      PrefetchHooks Function()
    >;
typedef $$SettingRowsTableCreateCompanionBuilder =
    SettingRowsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingRowsTableUpdateCompanionBuilder =
    SettingRowsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingRowsTable,
          SettingRow,
          $$SettingRowsTableFilterComposer,
          $$SettingRowsTableOrderingComposer,
          $$SettingRowsTableAnnotationComposer,
          $$SettingRowsTableCreateCompanionBuilder,
          $$SettingRowsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingRowsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingRowsTableTableManager(_$AppDatabase db, $SettingRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingRowsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingRowsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingRowsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingRowsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingRowsTable,
      SettingRow,
      $$SettingRowsTableFilterComposer,
      $$SettingRowsTableOrderingComposer,
      $$SettingRowsTableAnnotationComposer,
      $$SettingRowsTableCreateCompanionBuilder,
      $$SettingRowsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $SettingRowsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxRowsTableCreateCompanionBuilder = OutboxRowsCompanion Function({
  required String id,
  required String entityKind,
  required String operation,
  required String entityId,
  required String payloadJson,
  required DateTime enqueuedAt,
  Value<int> attempts,
  Value<int> rowid,
});
typedef $$OutboxRowsTableUpdateCompanionBuilder = OutboxRowsCompanion Function({
  Value<String> id,
  Value<String> entityKind,
  Value<String> operation,
  Value<String> entityId,
  Value<String> payloadJson,
  Value<DateTime> enqueuedAt,
  Value<int> attempts,
  Value<int> rowid,
});

class $$OutboxRowsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxRowsTable> {
  $$OutboxRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxRowsTable> {
  $$OutboxRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxRowsTable> {
  $$OutboxRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$OutboxRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxRowsTable,
          OutboxRow,
          $$OutboxRowsTableFilterComposer,
          $$OutboxRowsTableOrderingComposer,
          $$OutboxRowsTableAnnotationComposer,
          $$OutboxRowsTableCreateCompanionBuilder,
          $$OutboxRowsTableUpdateCompanionBuilder,
          (
            OutboxRow,
            BaseReferences<_$AppDatabase, $OutboxRowsTable, OutboxRow>,
          ),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxRowsTableTableManager(_$AppDatabase db, $OutboxRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityKind = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> enqueuedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxRowsCompanion(
                id: id,
                entityKind: entityKind,
                operation: operation,
                entityId: entityId,
                payloadJson: payloadJson,
                enqueuedAt: enqueuedAt,
                attempts: attempts,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityKind,
                required String operation,
                required String entityId,
                required String payloadJson,
                required DateTime enqueuedAt,
                Value<int> attempts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxRowsCompanion.insert(
                id: id,
                entityKind: entityKind,
                operation: operation,
                entityId: entityId,
                payloadJson: payloadJson,
                enqueuedAt: enqueuedAt,
                attempts: attempts,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxRowsTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxRowsTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxRowsTable,
      OutboxRow,
      $$OutboxRowsTableFilterComposer,
      $$OutboxRowsTableOrderingComposer,
      $$OutboxRowsTableAnnotationComposer,
      $$OutboxRowsTableCreateCompanionBuilder,
      $$OutboxRowsTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxRowsTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedChannelsTableTableManager get cachedChannels =>
      $$CachedChannelsTableTableManager(_db, _db.cachedChannels);
  $$CachedVodItemsTableTableManager get cachedVodItems =>
      $$CachedVodItemsTableTableManager(_db, _db.cachedVodItems);
  $$PlaybackProgressRowsTableTableManager get playbackProgressRows =>
      $$PlaybackProgressRowsTableTableManager(_db, _db.playbackProgressRows);
  $$FavoriteRowsTableTableManager get favoriteRows =>
      $$FavoriteRowsTableTableManager(_db, _db.favoriteRows);
  $$SourceRowsTableTableManager get sourceRows =>
      $$SourceRowsTableTableManager(_db, _db.sourceRows);
  $$SettingRowsTableTableManager get settingRows =>
      $$SettingRowsTableTableManager(_db, _db.settingRows);
  $$OutboxRowsTableTableManager get outboxRows =>
      $$OutboxRowsTableTableManager(_db, _db.outboxRows);
}
