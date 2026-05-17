import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('UserRow')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get name => text()();
  TextColumn get apellidos => text()();
  TextColumn get dni => text().unique()();
  TextColumn get account => text().unique()();
  TextColumn get address => text().nullable()();
  TextColumn get postalCode => text().nullable()();
  TextColumn get phone => text().nullable()();
}

@DataClassName('ClientRow')
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dni => text().nullable().unique()();
  TextColumn get address => text().nullable()();
  TextColumn get postalCode => text().nullable()();
  TextColumn get phone => text().nullable()();
}

@DataClassName('InvoiceRow')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get clientId => integer().references(Clients, #id)();
  TextColumn get date => text()();
  RealColumn get total => real()();
}

@DataClassName('ProductRow')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  IntColumn get units => integer()();
  IntColumn get invoiceId =>
      integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
}

@DriftDatabase(tables: [Users, Clients, Invoices, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
        },
      );

  Future<void> _seed() async {}
}

QueryExecutor _openConnection() {
  if (kIsWeb) return NativeDatabase.memory();

  return driftDatabase(
    name: 'app',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );
}
