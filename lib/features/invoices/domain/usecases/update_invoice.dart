import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class UpdateInvoice implements UseCase<Invoice, Invoice> {
  final InvoiceRepository repository;
  const UpdateInvoice(this.repository);

  @override
  Future<Either<Failure, Invoice>> call(Invoice params) =>
      repository.update(params);
}
