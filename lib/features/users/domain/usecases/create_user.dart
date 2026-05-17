import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUser implements UseCase<User, User> {
  final UserRepository repository;
  const CreateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(User params) => repository.create(params);
}
