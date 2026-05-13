part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

final class LoadInvoices extends InvoiceEvent {
  const LoadInvoices();
}

final class CreateInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;
  const CreateInvoiceEvent(this.invoice);

  @override
  List<Object?> get props => [invoice];
}
