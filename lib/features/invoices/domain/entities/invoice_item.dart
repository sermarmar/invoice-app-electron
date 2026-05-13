import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String name;
  final double price;
  final int units;
  final int invoiceId;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.units,
    required this.invoiceId,
  });

  double get subtotal => price * units;

  Product copyWith({
    int? id,
    String? name,
    double? price,
    int? units,
    int? invoiceId,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        units: units ?? this.units,
        invoiceId: invoiceId ?? this.invoiceId,
      );

  @override
  List<Object?> get props => [id, name, price, units, invoiceId];
}
