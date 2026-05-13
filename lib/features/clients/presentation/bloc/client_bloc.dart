import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/get_clients.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final GetClients getClients;

  ClientBloc({required this.getClients}) : super(const ClientInitial()) {
    on<LoadClients>(_onLoad);
  }

  Future<void> _onLoad(LoadClients event, Emitter<ClientState> emit) async {
    emit(const ClientLoading());
    final result = await getClients(const NoParams());
    result.fold(
      (failure) => emit(ClientError(failure.message)),
      (clients) => emit(ClientLoaded(clients)),
    );
  }
}
