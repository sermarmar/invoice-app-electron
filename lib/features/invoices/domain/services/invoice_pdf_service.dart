import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/invoice.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../users/domain/entities/user.dart';

class InvoicePdfService {
  Future<Uint8List> generate({
    required Invoice invoice,
    required User user,
    required Client client,
  }) async {
    final doc = pw.Document();
    final regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Arial.ttf'));
    final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Arial-Bold.ttf'));

    final subtotal = invoice.products.fold<double>(0, (s, p) => s + p.subtotal);
    final iva = subtotal * 0.21;
    final retencion = subtotal * 0.19;
    final total = subtotal + iva - retencion;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header: emisor + FACTURA
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        user.fullName,
                        style: pw.TextStyle(font: boldFont, fontSize: 16),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text('NIF: ${user.dni}',
                          style: pw.TextStyle(font: regularFont, fontSize: 10)),
                      if (user.address != null)
                        pw.Text('Dirección: ${user.address}',
                            style: pw.TextStyle(font: regularFont, fontSize: 10)),
                      if (user.postalCode != null)
                        pw.Text('CP: ${user.postalCode}',
                            style: pw.TextStyle(font: regularFont, fontSize: 10)),
                      if (user.phone != null)
                        pw.Text('Teléfono: ${user.phone}',
                            style: pw.TextStyle(font: regularFont, fontSize: 10)),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'FACTURA',
                      style: pw.TextStyle(font: boldFont, fontSize: 24),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Nº ${invoice.invoiceId.toString().padLeft(3, '0')}',
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                    pw.Text(
                      'Fecha: ${invoice.date}',
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 12),
            pw.Divider(color: PdfColor.fromHex('#3366E8'), thickness: 2),
            pw.SizedBox(height: 12),

            // Cliente
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Cliente:',
                          style: pw.TextStyle(font: boldFont, fontSize: 11)),
                      pw.Text(client.name,
                          style: pw.TextStyle(font: regularFont, fontSize: 10)),
                    ],
                  ),
                ),
                if (client.dni != null)
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('CIF:',
                            style: pw.TextStyle(font: boldFont, fontSize: 11)),
                        pw.Text(client.dni!,
                            style: pw.TextStyle(font: regularFont, fontSize: 10)),
                      ],
                    ),
                  ),
                if (client.address != null)
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Dirección:',
                            style: pw.TextStyle(font: boldFont, fontSize: 11)),
                        pw.Text(
                          [client.address, client.postalCode]
                              .whereType<String>()
                              .join(', '),
                          style: pw.TextStyle(font: regularFont, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Tabla productos
            pw.Table(
              border: pw.TableBorder(
                bottom: const pw.BorderSide(width: 0.5),
                horizontalInside: const pw.BorderSide(
                  width: 0.5,
                  color: PdfColors.grey300,
                ),
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FlexColumnWidth(),
                2: const pw.FixedColumnWidth(80),
                3: const pw.FixedColumnWidth(80),
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                  children: [
                    _cell('Cantidad', bold: true, font: boldFont),
                    _cell('Concepto', bold: true, font: boldFont),
                    _cell('Precio unit.', bold: true, font: boldFont, align: pw.TextAlign.right),
                    _cell('Total', bold: true, font: boldFont, align: pw.TextAlign.right),
                  ],
                ),
                // Rows
                for (final p in invoice.products)
                  pw.TableRow(
                    children: [
                      _cell('${p.units}', font: regularFont),
                      _cell(p.name, font: regularFont),
                      _cell('${p.price.toStringAsFixed(2)} €', font: regularFont, align: pw.TextAlign.right),
                      _cell('${p.subtotal.toStringAsFixed(2)} €', font: regularFont, align: pw.TextAlign.right),
                    ],
                  ),
              ],
            ),

            pw.SizedBox(height: 24),

            // Totales (alineados a la derecha)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.SizedBox(
                width: 220,
                child: pw.Column(
                  children: [
                    _totalRow('Subtotal', subtotal, regularFont),
                    _totalRow('IVA (21%)', iva, regularFont),
                    _totalRow('Retención (19%)', -retencion, regularFont),
                    pw.Divider(thickness: 0.5),
                    _totalRow('TOTAL', total, boldFont, large: true),
                  ],
                ),
              ),
            ),

            pw.Spacer(),

            // Pie: cuenta bancaria
            pw.Divider(thickness: 0.5),
            pw.Text(
              'Cuenta bancaria: ${user.account}',
              style: pw.TextStyle(font: regularFont, fontSize: 9),
            ),
          ],
        ),
      ),
    );

    return doc.save();
  }

  pw.Widget _cell(
    String text, {
    required pw.Font font,
    bool bold = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 10),
      ),
    );
  }

  pw.Widget _totalRow(String label, double amount, pw.Font font, {bool large = false}) {
    final size = large ? 13.0 : 10.0;
    final color = large ? PdfColor.fromHex('#1A4DCC') : PdfColors.black;
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: size, color: color)),
          pw.Text(
            '${amount.toStringAsFixed(2)} €',
            style: pw.TextStyle(font: font, fontSize: size, color: color),
          ),
        ],
      ),
    );
  }
}
