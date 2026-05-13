import 'package:equatable/equatable.dart';
import 'invoice_item.dart';

class Invoice extends Equatable {
  final int? id;
  final int invoiceId;
  final int userId;
  final int clientId;
  final String date;
  final double total;
  final List<Product> products;

  const Invoice({
    this.id,
    required this.invoiceId,
    required this.userId,
    required this.clientId,
    required this.date,
    required this.total,
    this.products = const [],
  });

  /// Subtotal antes de IVA y retención.
  double get subtotal => products.fold(0, (sum, p) => sum + p.subtotal);
  double get iva => subtotal * 0.21;
  double get retencion => subtotal * 0.19;
  double get totalCalculado => subtotal + iva - retencion;

  @override
  List<Object?> get props => [id, invoiceId, userId, clientId, date, total, products];
}
