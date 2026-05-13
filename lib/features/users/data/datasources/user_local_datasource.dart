import '../../../../core/database/database.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract interface class UserLocalDatasource {
  Future<List<User>> getAll();
  Future<User> getById(int id);
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final AppDatabase _db;
  const UserLocalDatasourceImpl(this._db);

  @override
  Future<List<User>> getAll() async {
    final rows = await _db.select(_db.users).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<User> getById(int id) async {
    final row = await (_db.select(_db.users)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return row.toEntity();
  }
}
