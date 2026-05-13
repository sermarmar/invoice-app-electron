import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class CreateInvoice implements UseCase<Invoice, Invoice> {
  final InvoiceRepository repository;
  const CreateInvoice(this.repository);

  @override
  Future<Either<Failure, Invoice>> call(Invoice params) =>
      repository.create(params);
}
