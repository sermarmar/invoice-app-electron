import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/invoice.dart';

abstract interface class InvoiceRepository {
  Future<Either<Failure, List<Invoice>>> getAll();
  Future<Either<Failure, List<Invoice>>> getByUser(int userId);
  Future<Either<Failure, Invoice>> getById(int id);
  Future<Either<Failure, Invoice>> create(Invoice invoice);
  Future<Either<Failure, Invoice>> update(Invoice invoice);
  Future<Either<Failure, Unit>> delete(int id);
}
