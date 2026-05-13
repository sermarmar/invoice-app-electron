import '../../../../core/database/database.dart';
import '../../domain/entities/client.dart';
import '../models/client_model.dart';

abstract interface class ClientLocalDatasource {
  Future<List<Client>> getAll();
  Future<Client> create(Client client);
  Future<Client> update(Client client);
  Future<void> delete(int id);
}

class ClientLocalDatasourceImpl implements ClientLocalDatasource {
  final AppDatabase _db;
  const ClientLocalDatasourceImpl(this._db);

  @override
  Future<List<Client>> getAll() async {
    final rows = await _db.select(_db.clients).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<Client> create(Client client) async {
    final id = await _db.into(_db.clients).insert(client.toCompanion());
    final row = await (_db.select(_db.clients)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return row.toEntity();
  }

  @override
  Future<Client> update(Client client) async {
    await (_db.update(_db.clients)
          ..where((t) => t.id.equals(client.id!)))
        .write(client.toCompanion());
    final row = await (_db.select(_db.clients)
          ..where((t) => t.id.equals(client.id!)))
        .getSingle();
    return row.toEntity();
  }

  @override
  Future<void> delete(int id) => (_db.delete(_db.clients)
        ..where((t) => t.id.equals(id)))
      .go();
}
