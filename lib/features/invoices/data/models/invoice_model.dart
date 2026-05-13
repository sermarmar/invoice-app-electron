import '../../../../core/database/database.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';

extension InvoiceToCompanion on Invoice {
  InvoicesCompanion toCompanion() => InvoicesCompanion.insert(
        invoiceId: invoiceId,
        userId: userId,
        clientId: clientId,
        date: date,
        total: total,
      );
}

extension InvoiceRowToEntity on InvoiceRow {
  Invoice toEntity({List<Product> products = const []}) => Invoice(
        id: id,
        invoiceId: invoiceId,
        userId: userId,
        clientId: clientId,
        date: date,
        total: total,
        products: products,
      );
}

extension ProductToCompanion on Product {
  ProductsCompanion toCompanion() => ProductsCompanion.insert(
        name: name,
        price: price,
        units: units,
        invoiceId: invoiceId,
      );
}

extension ProductRowToEntity on ProductRow {
  Product toEntity() => Product(
        id: id,
        name: name,
        price: price,
        units: units,
        invoiceId: invoiceId,
      );
}
