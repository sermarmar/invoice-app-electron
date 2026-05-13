import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/usecases/update_invoice.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoices getInvoices;
  final CreateInvoice createInvoice;
  final UpdateInvoice updateInvoice;

  int? _currentUserId;

  InvoiceBloc({
    required this.getInvoices,
    required this.createInvoice,
    required this.updateInvoice,
  }) : super(const InvoiceInitial()) {
    on<LoadInvoices>(_onLoad);
    on<CreateInvoiceEvent>(_onCreate);
    on<UpdateInvoiceEvent>(_onUpdate);
  }

  Future<void> _onLoad(LoadInvoices event, Emitter<InvoiceState> emit) async {
    _currentUserId = event.userId;
    emit(const InvoiceLoading());
    final result = await getInvoices(event.userId);
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
      (_) => add(LoadInvoices(userId: _currentUserId!)),
    );
  }

  Future<void> _onUpdate(
    UpdateInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    final result = await updateInvoice(event.invoice);
    result.fold(
      (failure) => emit(InvoiceError(failure.message)),
      (_) => add(LoadInvoices(userId: _currentUserId!)),
    );
  }
}
