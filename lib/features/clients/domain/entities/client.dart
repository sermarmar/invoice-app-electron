import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final int? id;
  final String name;
  final String? dni;
  final String? address;
  final String? postalCode;
  final String? phone;

  const Client({
    this.id,
    required this.name,
    this.dni,
    this.address,
    this.postalCode,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, dni, address, postalCode, phone];
}
