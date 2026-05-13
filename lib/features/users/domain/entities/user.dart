import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String username;
  final String name;
  final String apellidos;
  final String dni;
  final String account;
  final String? address;
  final String? postalCode;
  final String? phone;

  const User({
    this.id,
    required this.username,
    required this.name,
    required this.apellidos,
    required this.dni,
    required this.account,
    this.address,
    this.postalCode,
    this.phone,
  });

  String get fullName => '$name $apellidos';

  @override
  List<Object?> get props =>
      [id, username, name, apellidos, dni, account, address, postalCode, phone];
}
