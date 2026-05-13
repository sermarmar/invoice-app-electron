part of 'client_bloc.dart';

sealed class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

final class ClientInitial extends ClientState {
  const ClientInitial();
}

final class ClientLoading extends ClientState {
  const ClientLoading();
}

final class ClientLoaded extends ClientState {
  final List<Client> clients;
  const ClientLoaded(this.clients);

  @override
  List<Object?> get props => [clients];
}

final class ClientError extends ClientState {
  final String message;
  const ClientError(this.message);

  @override
  List<Object?> get props => [message];
}
