import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/get_clients.dart';
import '../../domain/usecases/create_client.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final GetClients getClients;
  final CreateClient createClient;

  ClientBloc({required this.getClients, required this.createClient})
      : super(const ClientInitial()) {
    on<LoadClients>(_onLoad);
    on<CreateClientEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadClients event, Emitter<ClientState> emit) async {
    emit(const ClientLoading());
    final result = await getClients(const NoParams());
    result.fold(
      (failure) => emit(ClientError(failure.message)),
      (clients) => emit(ClientLoaded(clients)),
    );
  }

  Future<void> _onCreate(
      CreateClientEvent event, Emitter<ClientState> emit) async {
    final result = await createClient(event.client);
    result.fold(
      (failure) => emit(ClientError(failure.message)),
      (_) => add(const LoadClients()),
    );
  }
}
