import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_user_room_state.dart';

class AddUserRoomCubit extends Cubit<AddUserRoomCubitState> {
  AddUserRoomCubit() : super(const AddUserRoomCubitState(selectedUsers: []));

  void toggleSelectedUsers(int userId) {
    // Creating a new instance of list since if we use the same list variable
    // it will not trigger rebuild since the memory are still the same.
    final List<int> selectedUsers = List<int>.from(state.selectedUsers);

    if (selectedUsers.contains(userId)) {
      selectedUsers.remove(userId);
    } else {
      selectedUsers.add(userId);
    }

    emit(state.copyWith(selectedUsers: selectedUsers));
  }
}
