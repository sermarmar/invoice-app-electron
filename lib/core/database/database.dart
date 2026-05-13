import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('ClientRow')
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nif => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
}

@DataClassName('InvoiceRow')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text().unique()();
  IntColumn get clientId => integer().nullable().references(Clients, #id)();
  TextColumn get date => text()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  RealColumn get subtotal => real().nullable()();
  RealColumn get taxRate => real().nullable()();
  RealColumn get total => real().nullable()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('InvoiceItemRow')
class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId =>
      integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
  TextColumn get description => text()();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get total => real()();
}

@DriftDatabase(tables: [Clients, Invoices, InvoiceItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  // En web: in-memory solo para preview (sin persistencia)
  if (kIsWeb) return NativeDatabase.memory();

  return driftDatabase(
    name: 'app',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );
}
