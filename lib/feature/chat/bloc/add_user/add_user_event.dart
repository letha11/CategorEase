part of 'add_user_bloc.dart';

sealed class AddUserEvent extends Equatable {
  const AddUserEvent();

  @override
  List<Object> get props => [];
}

class AddUserUpdateRoom extends AddUserEvent {
  final List<int> selectedUserIds;

  const AddUserUpdateRoom({required this.selectedUserIds});
}

class AddUserFetchUser extends AddUserEvent {
  final String username;

  const AddUserFetchUser({required this.username});
}

class AddUserFetchUserNextPage extends AddUserEvent {}
