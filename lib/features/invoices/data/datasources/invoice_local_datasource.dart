import '../../../../core/database/database.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../models/invoice_model.dart';

abstract interface class InvoiceLocalDatasource {
  Future<List<Invoice>> getAll();
  Future<Invoice> getById(int id);
  Future<Invoice> create(Invoice invoice);
  Future<Invoice> update(Invoice invoice);
  Future<void> delete(int id);
}

class InvoiceLocalDatasourceImpl implements InvoiceLocalDatasource {
  final AppDatabase _db;
  const InvoiceLocalDatasourceImpl(this._db);

  @override
  Future<List<Invoice>> getAll() async {
    final rows = await _db.select(_db.invoices).get();
    return Future.wait(rows.map((row) async {
      final items = await _itemsFor(row.id);
      return row.toEntity(items: items);
    }));
  }

  @override
  Future<Invoice> getById(int id) async {
    final row = await (_db.select(_db.invoices)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    final items = await _itemsFor(id);
    return row.toEntity(items: items);
  }

  @override
  Future<Invoice> create(Invoice invoice) async {
    final id = await _db.into(_db.invoices).insert(invoice.toCompanion());
    for (final item in invoice.items) {
      await _db.into(_db.invoiceItems).insert(
            item.copyWith(invoiceId: id).toCompanion(),
          );
    }
    return getById(id);
  }

  @override
  Future<Invoice> update(Invoice invoice) async {
    await (_db.update(_db.invoices)
          ..where((t) => t.id.equals(invoice.id!)))
        .write(invoice.toCompanion());
    await (_db.delete(_db.invoiceItems)
          ..where((t) => t.invoiceId.equals(invoice.id!)))
        .go();
    for (final item in invoice.items) {
      await _db.into(_db.invoiceItems).insert(
            item.copyWith(invoiceId: invoice.id!).toCompanion(),
          );
    }
    return getById(invoice.id!);
  }

  @override
  Future<void> delete(int id) => (_db.delete(_db.invoices)
        ..where((t) => t.id.equals(id)))
      .go();

  Future<List<InvoiceItem>> _itemsFor(int invoiceId) async {
    final rows = await (_db.select(_db.invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }
}
