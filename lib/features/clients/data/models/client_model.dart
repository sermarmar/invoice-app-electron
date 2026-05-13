import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/client.dart';

extension ClientToCompanion on Client {
  ClientsCompanion toCompanion() => ClientsCompanion.insert(
        name: name,
        dni: Value(dni),
        address: Value(address),
        postalCode: Value(postalCode),
        phone: Value(phone),
      );
}

extension ClientRowToEntity on ClientRow {
  Client toEntity() => Client(
        id: id,
        name: name,
        dni: dni,
        address: address,
        postalCode: postalCode,
        phone: phone,
      );
}
