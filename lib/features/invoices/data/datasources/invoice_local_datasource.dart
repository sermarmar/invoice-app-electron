import '../../../../core/database/database.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../models/invoice_model.dart';

abstract interface class InvoiceLocalDatasource {
  Future<List<Invoice>> getAll();
  Future<List<Invoice>> getByUser(int userId);
  Future<Invoice> getById(int id);
  Future<Invoice> create(Invoice invoice);
  Future<void> delete(int id);
}

class InvoiceLocalDatasourceImpl implements InvoiceLocalDatasource {
  final AppDatabase _db;
  const InvoiceLocalDatasourceImpl(this._db);

  @override
  Future<List<Invoice>> getAll() async {
    final rows = await _db.select(_db.invoices).get();
    return Future.wait(rows.map((r) async => r.toEntity(products: await _productsFor(r.id))));
  }

  @override
  Future<List<Invoice>> getByUser(int userId) async {
    final rows = await (_db.select(_db.invoices)
          ..where((t) => t.userId.equals(userId)))
        .get();
    return Future.wait(rows.map((r) async => r.toEntity(products: await _productsFor(r.id))));
  }

  @override
  Future<Invoice> getById(int id) async {
    final row = await (_db.select(_db.invoices)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return row.toEntity(products: await _productsFor(id));
  }

  @override
  Future<Invoice> create(Invoice invoice) async {
    final id = await _db.into(_db.invoices).insert(invoice.toCompanion());
    for (final p in invoice.products) {
      await _db.into(_db.products).insert(p.copyWith(invoiceId: id).toCompanion());
    }
    return getById(id);
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.invoices)..where((t) => t.id.equals(id))).go();

  Future<List<Product>> _productsFor(int invoiceId) async {
    final rows = await (_db.select(_db.products)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }
}
