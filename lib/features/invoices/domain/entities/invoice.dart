import 'package:equatable/equatable.dart';
import 'invoice_item.dart';

enum InvoiceStatus { draft, sent, paid }

class Invoice extends Equatable {
  final int? id;
  final String number;
  final int? clientId;
  final String date;
  final String? dueDate;
  final InvoiceStatus status;
  final double? subtotal;
  final double? taxRate;
  final double? total;
  final String? notes;
  final List<InvoiceItem> items;

  const Invoice({
    this.id,
    required this.number,
    this.clientId,
    required this.date,
    this.dueDate,
    this.status = InvoiceStatus.draft,
    this.subtotal,
    this.taxRate,
    this.total,
    this.notes,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
        id, number, clientId, date, dueDate,
        status, subtotal, taxRate, total, notes, items,
      ];
}
