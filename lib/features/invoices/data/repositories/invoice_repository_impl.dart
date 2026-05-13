import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDatasource _datasource;
  const InvoiceRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Invoice>>> getAll() async {
    try {
      return Right(await _datasource.getAll());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Invoice>>> getByUser(int userId) async {
    try {
      return Right(await _datasource.getByUser(userId));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Invoice>> getById(int id) async {
    try {
      return Right(await _datasource.getById(id));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Invoice>> create(Invoice invoice) async {
    try {
      return Right(await _datasource.create(invoice));
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
