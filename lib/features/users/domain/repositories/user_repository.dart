import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract interface class UserRepository {
  Future<Either<Failure, List<User>>> getAll();
  Future<Either<Failure, User>> getById(int id);
}
