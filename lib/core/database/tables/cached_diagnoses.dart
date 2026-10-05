import 'package:drift/drift.dart';

class CachedDiagnoses extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get diseaseId => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get top3 => text().nullable()(); // JSON string
  TextColumn get source => text().withDefault(const Constant('on_device'))();
  TextColumn get status => text().withDefault(const Constant('auto'))();
  TextColumn get cropHint => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get clientUuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
