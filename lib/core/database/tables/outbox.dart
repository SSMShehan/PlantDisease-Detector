import 'package:drift/drift.dart';

class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientUuid => text().unique()();
  TextColumn get payload => text()(); // JSON representation of the diagnosis/data
  TextColumn get type => text()(); // e.g., 'diagnosis', 'farm_log'
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, processing, synced, failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
