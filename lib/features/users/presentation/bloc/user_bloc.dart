import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final CreateUser createUser;

  UserBloc({required this.getUsers, required this.createUser})
      : super(const UserInitial()) {
    on<LoadUsers>(_onLoad);
    on<CreateUserEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    final result = await getUsers(const NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _onCreate(CreateUserEvent event, Emitter<UserState> emit) async {
    final result = await createUser(event.user);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }
}
