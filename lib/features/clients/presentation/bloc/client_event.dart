part of 'client_bloc.dart';

sealed class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

final class LoadClients extends ClientEvent {
  const LoadClients();
}

final class CreateClientEvent extends ClientEvent {
  final Client client;
  const CreateClientEvent(this.client);
  @override
  List<Object?> get props => [client];
}
