import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/user.dart';

extension UserToCompanion on User {
  UsersCompanion toCompanion() => UsersCompanion.insert(
        username: username,
        name: name,
        apellidos: apellidos,
        dni: dni,
        account: account,
        address: Value(address),
        postalCode: Value(postalCode),
        phone: Value(phone),
      );
}

extension UserRowToEntity on UserRow {
  User toEntity() => User(
        id: id,
        username: username,
        name: name,
        apellidos: apellidos,
        dni: dni,
        account: account,
        address: address,
        postalCode: postalCode,
        phone: phone,
      );
}
