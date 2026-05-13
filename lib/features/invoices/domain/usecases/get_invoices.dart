import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetInvoices implements UseCase<List<Invoice>, int> {
  final InvoiceRepository repository;
  const GetInvoices(this.repository);

  @override
  Future<Either<Failure, List<Invoice>>> call(int userId) =>
      repository.getByUser(userId);
}
