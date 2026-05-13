import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetClients implements UseCase<List<Client>, NoParams> {
  final ClientRepository repository;
  const GetClients(this.repository);

  @override
  Future<Either<Failure, List<Client>>> call(NoParams params) =>
      repository.getAll();
}
