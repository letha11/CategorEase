part of 'add_user_room_cubit.dart';

class AddUserRoomCubitState extends Equatable {
  final List<int> selectedUsers;

  const AddUserRoomCubitState({required this.selectedUsers});

  // copyWith
  AddUserRoomCubitState copyWith({
    List<int>? selectedUsers,
  }) {
    return AddUserRoomCubitState(
        selectedUsers: selectedUsers ?? this.selectedUsers);
  }

  @override
  List<Object> get props => [
        selectedUsers,
      ];
}
