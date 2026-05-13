import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/client.dart';

extension ClientToCompanion on Client {
  ClientsCompanion toCompanion() => ClientsCompanion.insert(
        name: name,
        nif: Value(nif),
        address: Value(address),
        email: Value(email),
        phone: Value(phone),
      );
}

extension ClientRowToEntity on ClientRow {
  Client toEntity() => Client(
        id: id,
        name: name,
        nif: nif,
        address: address,
        email: email,
        phone: phone,
      );
}
