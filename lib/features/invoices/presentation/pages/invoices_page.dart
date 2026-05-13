import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/invoice_bloc.dart';
import '../widgets/invoice_card.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvoiceBloc>()..add(const LoadInvoices()),
      child: const _InvoicesView(),
    );
  }
}

class _InvoicesView extends StatelessWidget {
  const _InvoicesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facturas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navegar a formulario nueva factura
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) => switch (state) {
          InvoiceInitial() || InvoiceLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          InvoiceError(:final message) => Center(
              child: Text(message),
            ),
          InvoiceLoaded(:final invoices) when invoices.isEmpty => const Center(
              child: Text('No hay facturas todavía'),
            ),
          InvoiceLoaded(:final invoices) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) => InvoiceCard(
                invoice: invoices[index],
              ),
            ),
        },
      ),
    );
  }
}
