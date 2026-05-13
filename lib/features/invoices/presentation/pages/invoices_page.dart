import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../users/domain/entities/user.dart';
import '../bloc/invoice_bloc.dart';
import '../widgets/invoice_card.dart';

class InvoicesPage extends StatelessWidget {
  final User user;
  const InvoicesPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvoiceBloc>()..add(LoadInvoices(userId: user.id!)),
      child: _InvoicesView(user: user),
    );
  }
}

class _InvoicesView extends StatelessWidget {
  final User user;
  const _InvoicesView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.fullName),
            Text(
              'NIF: ${user.dni}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: navegar a crear factura
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva factura'),
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) => switch (state) {
          InvoiceInitial() || InvoiceLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          InvoiceError(:final message) => Center(child: Text(message)),
          InvoiceLoaded(:final invoices) when invoices.isEmpty => const Center(
              child: Text('No hay facturas todavía'),
            ),
          InvoiceLoaded(:final invoices) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => InvoiceCard(invoice: invoices[i]),
            ),
        },
      ),
    );
  }
}
