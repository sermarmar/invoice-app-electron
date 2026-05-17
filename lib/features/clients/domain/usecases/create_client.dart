import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class CreateClient implements UseCase<Client, Client> {
  final ClientRepository repository;
  const CreateClient(this.repository);

  @override
  Future<Either<Failure, Client>> call(Client params) =>
      repository.create(params);
}
