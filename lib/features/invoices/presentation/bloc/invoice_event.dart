part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

final class LoadInvoices extends InvoiceEvent {
  final int userId;
  const LoadInvoices({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class CreateInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;
  const CreateInvoiceEvent(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

final class UpdateInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;
  const UpdateInvoiceEvent(this.invoice);

  @override
  List<Object?> get props => [invoice];
}
