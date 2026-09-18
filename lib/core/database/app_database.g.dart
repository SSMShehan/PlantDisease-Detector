// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedDiagnosesTable extends CachedDiagnoses
    with TableInfo<$CachedDiagnosesTable, CachedDiagnose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDiagnosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diseaseIdMeta = const VerificationMeta(
    'diseaseId',
  );
  @override
  late final GeneratedColumn<String> diseaseId = GeneratedColumn<String>(
    'disease_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _top3Meta = const VerificationMeta('top3');
  @override
  late final GeneratedColumn<String> top3 = GeneratedColumn<String>(
    'top3',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('on_device'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _cropHintMeta = const VerificationMeta(
    'cropHint',
  );
  @override
  late final GeneratedColumn<String> cropHint = GeneratedColumn<String>(
    'crop_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    imagePath,
    diseaseId,
    confidence,
    top3,
    source,
    status,
    cropHint,
    district,
    clientUuid,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_diagnoses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDiagnose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('disease_id')) {
      context.handle(
        _diseaseIdMeta,
        diseaseId.isAcceptableOrUnknown(data['disease_id']!, _diseaseIdMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('top3')) {
      context.handle(
        _top3Meta,
        top3.isAcceptableOrUnknown(data['top3']!, _top3Meta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('crop_hint')) {
      context.handle(
        _cropHintMeta,
        cropHint.isAcceptableOrUnknown(data['crop_hint']!, _cropHintMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedDiagnose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDiagnose(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      diseaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disease_id'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      top3: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top3'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      cropHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_hint'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CachedDiagnosesTable createAlias(String alias) {
    return $CachedDiagnosesTable(attachedDatabase, alias);
  }
}

class CachedDiagnose extends DataClass implements Insertable<CachedDiagnose> {
  final String id;
  final String userId;
  final String? imagePath;
  final String? diseaseId;
  final double? confidence;
  final String? top3;
  final String source;
  final String status;
  final String? cropHint;
  final String? district;
  final String clientUuid;
  final DateTime createdAt;
  const CachedDiagnose({
    required this.id,
    required this.userId,
    this.imagePath,
    this.diseaseId,
    this.confidence,
    this.top3,
    required this.source,
    required this.status,
    this.cropHint,
    this.district,
    required this.clientUuid,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || diseaseId != null) {
      map['disease_id'] = Variable<String>(diseaseId);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || top3 != null) {
      map['top3'] = Variable<String>(top3);
    }
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || cropHint != null) {
      map['crop_hint'] = Variable<String>(cropHint);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    map['client_uuid'] = Variable<String>(clientUuid);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CachedDiagnosesCompanion toCompanion(bool nullToAbsent) {
    return CachedDiagnosesCompanion(
      id: Value(id),
      userId: Value(userId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      diseaseId: diseaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(diseaseId),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      top3: top3 == null && nullToAbsent ? const Value.absent() : Value(top3),
      source: Value(source),
      status: Value(status),
      cropHint: cropHint == null && nullToAbsent
          ? const Value.absent()
          : Value(cropHint),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      clientUuid: Value(clientUuid),
      createdAt: Value(createdAt),
    );
  }

  factory CachedDiagnose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDiagnose(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      diseaseId: serializer.fromJson<String?>(json['diseaseId']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      top3: serializer.fromJson<String?>(json['top3']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      cropHint: serializer.fromJson<String?>(json['cropHint']),
      district: serializer.fromJson<String?>(json['district']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'diseaseId': serializer.toJson<String?>(diseaseId),
      'confidence': serializer.toJson<double?>(confidence),
      'top3': serializer.toJson<String?>(top3),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'cropHint': serializer.toJson<String?>(cropHint),
      'district': serializer.toJson<String?>(district),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CachedDiagnose copyWith({
    String? id,
    String? userId,
    Value<String?> imagePath = const Value.absent(),
    Value<String?> diseaseId = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> top3 = const Value.absent(),
    String? source,
    String? status,
    Value<String?> cropHint = const Value.absent(),
    Value<String?> district = const Value.absent(),
    String? clientUuid,
    DateTime? createdAt,
  }) => CachedDiagnose(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    diseaseId: diseaseId.present ? diseaseId.value : this.diseaseId,
    confidence: confidence.present ? confidence.value : this.confidence,
    top3: top3.present ? top3.value : this.top3,
    source: source ?? this.source,
    status: status ?? this.status,
    cropHint: cropHint.present ? cropHint.value : this.cropHint,
    district: district.present ? district.value : this.district,
    clientUuid: clientUuid ?? this.clientUuid,
    createdAt: createdAt ?? this.createdAt,
  );
  CachedDiagnose copyWithCompanion(CachedDiagnosesCompanion data) {
    return CachedDiagnose(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      diseaseId: data.diseaseId.present ? data.diseaseId.value : this.diseaseId,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      top3: data.top3.present ? data.top3.value : this.top3,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      cropHint: data.cropHint.present ? data.cropHint.value : this.cropHint,
      district: data.district.present ? data.district.value : this.district,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDiagnose(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('imagePath: $imagePath, ')
          ..write('diseaseId: $diseaseId, ')
          ..write('confidence: $confidence, ')
          ..write('top3: $top3, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('cropHint: $cropHint, ')
          ..write('district: $district, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    imagePath,
    diseaseId,
    confidence,
    top3,
    source,
    status,
    cropHint,
    district,
    clientUuid,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDiagnose &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.imagePath == this.imagePath &&
          other.diseaseId == this.diseaseId &&
          other.confidence == this.confidence &&
          other.top3 == this.top3 &&
          other.source == this.source &&
          other.status == this.status &&
          other.cropHint == this.cropHint &&
          other.district == this.district &&
          other.clientUuid == this.clientUuid &&
          other.createdAt == this.createdAt);
}

class CachedDiagnosesCompanion extends UpdateCompanion<CachedDiagnose> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> imagePath;
  final Value<String?> diseaseId;
  final Value<double?> confidence;
  final Value<String?> top3;
  final Value<String> source;
  final Value<String> status;
  final Value<String?> cropHint;
  final Value<String?> district;
  final Value<String> clientUuid;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CachedDiagnosesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.diseaseId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.top3 = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.cropHint = const Value.absent(),
    this.district = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDiagnosesCompanion.insert({
    required String id,
    required String userId,
    this.imagePath = const Value.absent(),
    this.diseaseId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.top3 = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.cropHint = const Value.absent(),
    this.district = const Value.absent(),
    required String clientUuid,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       clientUuid = Value(clientUuid);
  static Insertable<CachedDiagnose> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? imagePath,
    Expression<String>? diseaseId,
    Expression<double>? confidence,
    Expression<String>? top3,
    Expression<String>? source,
    Expression<String>? status,
    Expression<String>? cropHint,
    Expression<String>? district,
    Expression<String>? clientUuid,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (imagePath != null) 'image_path': imagePath,
      if (diseaseId != null) 'disease_id': diseaseId,
      if (confidence != null) 'confidence': confidence,
      if (top3 != null) 'top3': top3,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (cropHint != null) 'crop_hint': cropHint,
      if (district != null) 'district': district,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDiagnosesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? imagePath,
    Value<String?>? diseaseId,
    Value<double?>? confidence,
    Value<String?>? top3,
    Value<String>? source,
    Value<String>? status,
    Value<String?>? cropHint,
    Value<String?>? district,
    Value<String>? clientUuid,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CachedDiagnosesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      diseaseId: diseaseId ?? this.diseaseId,
      confidence: confidence ?? this.confidence,
      top3: top3 ?? this.top3,
      source: source ?? this.source,
      status: status ?? this.status,
      cropHint: cropHint ?? this.cropHint,
      district: district ?? this.district,
      clientUuid: clientUuid ?? this.clientUuid,
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
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (diseaseId.present) {
      map['disease_id'] = Variable<String>(diseaseId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (top3.present) {
      map['top3'] = Variable<String>(top3.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cropHint.present) {
      map['crop_hint'] = Variable<String>(cropHint.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDiagnosesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('imagePath: $imagePath, ')
          ..write('diseaseId: $diseaseId, ')
          ..write('confidence: $confidence, ')
          ..write('top3: $top3, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('cropHint: $cropHint, ')
          ..write('district: $district, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientUuid,
    payload,
    type,
    status,
    retryCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int id;
  final String clientUuid;
  final String payload;
  final String type;
  final String status;
  final int retryCount;
  final DateTime createdAt;
  const OutboxData({
    required this.id,
    required this.clientUuid,
    required this.payload,
    required this.type,
    required this.status,
    required this.retryCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_uuid'] = Variable<String>(clientUuid);
    map['payload'] = Variable<String>(payload);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      clientUuid: Value(clientUuid),
      payload: Value(payload),
      type: Value(type),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      id: serializer.fromJson<int>(json['id']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      payload: serializer.fromJson<String>(json['payload']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'payload': serializer.toJson<String>(payload),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxData copyWith({
    int? id,
    String? clientUuid,
    String? payload,
    String? type,
    String? status,
    int? retryCount,
    DateTime? createdAt,
  }) => OutboxData(
    id: id ?? this.id,
    clientUuid: clientUuid ?? this.clientUuid,
    payload: payload ?? this.payload,
    type: type ?? this.type,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      id: data.id.present ? data.id.value : this.id,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      payload: data.payload.present ? data.payload.value : this.payload,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('payload: $payload, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clientUuid, payload, type, status, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.id == this.id &&
          other.clientUuid == this.clientUuid &&
          other.payload == this.payload &&
          other.type == this.type &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> id;
  final Value<String> clientUuid;
  final Value<String> payload;
  final Value<String> type;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.payload = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String clientUuid,
    required String payload,
    required String type,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       payload = Value(payload),
       type = Value(type);
  static Insertable<OutboxData> custom({
    Expression<int>? id,
    Expression<String>? clientUuid,
    Expression<String>? payload,
    Expression<String>? type,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (payload != null) 'payload': payload,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? clientUuid,
    Value<String>? payload,
    Value<String>? type,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      clientUuid: clientUuid ?? this.clientUuid,
      payload: payload ?? this.payload,
      type: type ?? this.type,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('payload: $payload, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedDiagnosesTable cachedDiagnoses = $CachedDiagnosesTable(
    this,
  );
  late final $OutboxTable outbox = $OutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedDiagnoses, outbox];
}

typedef $$CachedDiagnosesTableCreateCompanionBuilder =
    CachedDiagnosesCompanion Function({
      required String id,
      required String userId,
      Value<String?> imagePath,
      Value<String?> diseaseId,
      Value<double?> confidence,
      Value<String?> top3,
      Value<String> source,
      Value<String> status,
      Value<String?> cropHint,
      Value<String?> district,
      required String clientUuid,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CachedDiagnosesTableUpdateCompanionBuilder =
    CachedDiagnosesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> imagePath,
      Value<String?> diseaseId,
      Value<double?> confidence,
      Value<String?> top3,
      Value<String> source,
      Value<String> status,
      Value<String?> cropHint,
      Value<String?> district,
      Value<String> clientUuid,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CachedDiagnosesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedDiagnosesTable> {
  $$CachedDiagnosesTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diseaseId => $composableBuilder(
    column: $table.diseaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get top3 => $composableBuilder(
    column: $table.top3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropHint => $composableBuilder(
    column: $table.cropHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDiagnosesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedDiagnosesTable> {
  $$CachedDiagnosesTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diseaseId => $composableBuilder(
    column: $table.diseaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get top3 => $composableBuilder(
    column: $table.top3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropHint => $composableBuilder(
    column: $table.cropHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDiagnosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedDiagnosesTable> {
  $$CachedDiagnosesTableAnnotationComposer({
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

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get diseaseId =>
      $composableBuilder(column: $table.diseaseId, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get top3 =>
      $composableBuilder(column: $table.top3, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get cropHint =>
      $composableBuilder(column: $table.cropHint, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CachedDiagnosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedDiagnosesTable,
          CachedDiagnose,
          $$CachedDiagnosesTableFilterComposer,
          $$CachedDiagnosesTableOrderingComposer,
          $$CachedDiagnosesTableAnnotationComposer,
          $$CachedDiagnosesTableCreateCompanionBuilder,
          $$CachedDiagnosesTableUpdateCompanionBuilder,
          (
            CachedDiagnose,
            BaseReferences<
              _$AppDatabase,
              $CachedDiagnosesTable,
              CachedDiagnose
            >,
          ),
          CachedDiagnose,
          PrefetchHooks Function()
        > {
  $$CachedDiagnosesTableTableManager(
    _$AppDatabase db,
    $CachedDiagnosesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDiagnosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDiagnosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDiagnosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> diseaseId = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> top3 = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> cropHint = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDiagnosesCompanion(
                id: id,
                userId: userId,
                imagePath: imagePath,
                diseaseId: diseaseId,
                confidence: confidence,
                top3: top3,
                source: source,
                status: status,
                cropHint: cropHint,
                district: district,
                clientUuid: clientUuid,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> imagePath = const Value.absent(),
                Value<String?> diseaseId = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> top3 = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> cropHint = const Value.absent(),
                Value<String?> district = const Value.absent(),
                required String clientUuid,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDiagnosesCompanion.insert(
                id: id,
                userId: userId,
                imagePath: imagePath,
                diseaseId: diseaseId,
                confidence: confidence,
                top3: top3,
                source: source,
                status: status,
                cropHint: cropHint,
                district: district,
                clientUuid: clientUuid,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDiagnosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedDiagnosesTable,
      CachedDiagnose,
      $$CachedDiagnosesTableFilterComposer,
      $$CachedDiagnosesTableOrderingComposer,
      $$CachedDiagnosesTableAnnotationComposer,
      $$CachedDiagnosesTableCreateCompanionBuilder,
      $$CachedDiagnosesTableUpdateCompanionBuilder,
      (
        CachedDiagnose,
        BaseReferences<_$AppDatabase, $CachedDiagnosesTable, CachedDiagnose>,
      ),
      CachedDiagnose,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      required String clientUuid,
      required String payload,
      required String type,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      Value<String> clientUuid,
      Value<String> payload,
      Value<String> type,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                clientUuid: clientUuid,
                payload: payload,
                type: type,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientUuid,
                required String payload,
                required String type,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                clientUuid: clientUuid,
                payload: payload,
                type: type,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedDiagnosesTableTableManager get cachedDiagnoses =>
      $$CachedDiagnosesTableTableManager(_db, _db.cachedDiagnoses);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
}
