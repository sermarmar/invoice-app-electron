import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/client.dart';

abstract interface class ClientRepository {
  Future<Either<Failure, List<Client>>> getAll();
  Future<Either<Failure, Client>> create(Client client);
  Future<Either<Failure, Client>> update(Client client);
  Future<Either<Failure, Unit>> delete(int id);
}
