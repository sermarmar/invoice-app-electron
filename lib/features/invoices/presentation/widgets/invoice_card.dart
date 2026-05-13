import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../clients/data/datasources/client_local_datasource.dart';
import '../../../users/domain/entities/user.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/services/invoice_pdf_service.dart';
import '../../../../injection_container.dart';
import '../bloc/invoice_bloc.dart';
import '../pages/create_invoice_page.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final User user;

  const InvoiceCard({super.key, required this.invoice, required this.user});

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final clientDs = sl<ClientLocalDatasource>();
      final clients = await clientDs.getAll();
      final client = clients.firstWhere((c) => c.id == invoice.clientId);
      final bytes = await InvoicePdfService().generate(
        invoice: invoice,
        user: user,
        client: client,
      );
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'factura_${invoice.invoiceId.toString().padLeft(3, '0')}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el PDF: $e')),
        );
      }
    }
  }

  void _edit(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    final state = bloc.state;
    final count = state is InvoiceLoaded ? state.invoices.length : 0;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: CreateInvoicePage(
            user: user,
            nextInvoiceNumber: count + 1,
            invoice: invoice,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Factura ${invoice.invoiceId.toString().padLeft(3, '0')}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(invoice.date, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Text(
              '${invoice.total.toStringAsFixed(2)} €',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'Editar factura',
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.twilightIndigo,
              onPressed: () => _edit(context),
            ),
            IconButton(
              tooltip: 'Descargar PDF',
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              color: AppColors.mutedTeal,
              onPressed: () => _downloadPdf(context),
            ),
          ],
        ),
      ),
    );
  }
}
