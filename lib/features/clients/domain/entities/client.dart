import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final int? id;
  final String name;
  final String? nif;
  final String? address;
  final String? email;
  final String? phone;

  const Client({
    this.id,
    required this.name,
    this.nif,
    this.address,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, nif, address, email, phone];
}
