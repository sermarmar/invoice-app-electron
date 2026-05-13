import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';

extension InvoiceToCompanion on Invoice {
  InvoicesCompanion toCompanion() => InvoicesCompanion.insert(
        number: number,
        clientId: Value(clientId),
        date: date,
        dueDate: Value(dueDate),
        status: Value(status.name),
        subtotal: Value(subtotal),
        taxRate: Value(taxRate),
        total: Value(total),
        notes: Value(notes),
      );
}

extension InvoiceRowToEntity on InvoiceRow {
  Invoice toEntity({List<InvoiceItem> items = const []}) => Invoice(
        id: id,
        number: number,
        clientId: clientId,
        date: date,
        dueDate: dueDate,
        status: InvoiceStatus.values.byName(status),
        subtotal: subtotal,
        taxRate: taxRate,
        total: total,
        notes: notes,
        items: items,
      );
}

extension InvoiceItemToCompanion on InvoiceItem {
  InvoiceItemsCompanion toCompanion() => InvoiceItemsCompanion.insert(
        invoiceId: invoiceId,
        description: description,
        quantity: quantity,
        unitPrice: unitPrice,
        total: total,
      );
}

extension InvoiceItemRowToEntity on InvoiceItemRow {
  InvoiceItem toEntity() => InvoiceItem(
        id: id,
        invoiceId: invoiceId,
        description: description,
        quantity: quantity,
        unitPrice: unitPrice,
        total: total,
      );
}
