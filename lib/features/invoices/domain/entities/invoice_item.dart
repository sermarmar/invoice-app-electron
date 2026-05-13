import 'package:equatable/equatable.dart';

class InvoiceItem extends Equatable {
  final int? id;
  final int invoiceId;
  final String description;
  final double quantity;
  final double unitPrice;
  final double total;

  const InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    String? description,
    double? quantity,
    double? unitPrice,
    double? total,
  }) =>
      InvoiceItem(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        description: description ?? this.description,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        total: total ?? this.total,
      );

  @override
  List<Object?> get props => [id, invoiceId, description, quantity, unitPrice, total];
}
