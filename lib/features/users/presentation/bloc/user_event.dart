part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

final class LoadUsers extends UserEvent {
  const LoadUsers();
}

final class CreateUserEvent extends UserEvent {
  final User user;
  const CreateUserEvent(this.user);
  @override
  List<Object?> get props => [user];
}
