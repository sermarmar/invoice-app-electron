import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;
  const UserRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<User>>> getAll() async {
    try {
      return Right(await _datasource.getAll());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getById(int id) async {
    try {
      return Right(await _datasource.getById(id));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> create(User user) async {
    try {
      return Right(await _datasource.create(user));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
