import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_datasource.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDatasource _datasource;
  const ClientRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Client>>> getAll() async {
    try {
      return Right(await _datasource.getAll());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Client>> create(Client client) async {
    try {
      return Right(await _datasource.create(client));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Client>> update(Client client) async {
    try {
      return Right(await _datasource.update(client));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) async {
    try {
      await _datasource.delete(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
