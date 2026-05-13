import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices.dart';
import '../../domain/usecases/create_invoice.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoices getInvoices;
  final CreateInvoice createInvoice;

  InvoiceBloc({required this.getInvoices, required this.createInvoice})
      : super(const InvoiceInitial()) {
    on<LoadInvoices>(_onLoad);
    on<CreateInvoiceEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadInvoices event, Emitter<InvoiceState> emit) async {
    emit(const InvoiceLoading());
    final result = await getInvoices(const NoParams());
    result.fold(
      (failure) => emit(InvoiceError(failure.message)),
      (invoices) => emit(InvoiceLoaded(invoices)),
    );
  }

  Future<void> _onCreate(
    CreateInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final result = await createInvoice(event.invoice);
    result.fold(
      (failure) => emit(InvoiceError(failure.message)),
      (_) => add(const LoadInvoices()),
    );
  }
}
