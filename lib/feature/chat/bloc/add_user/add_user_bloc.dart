import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/feature/search/repository/user_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/constants.dart';
import 'package:equatable/equatable.dart';

part 'add_user_event.dart';
part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final UserRepository _userRepository;
  final RoomRepository _roomRepository;
  final Room currentRoom;
  String? username;

  AddUserBloc({
    required UserRepository userRepository,
    required RoomRepository roomRepository,
    required this.currentRoom,
  })  : _userRepository = userRepository,
        _roomRepository = roomRepository,
        super(AddUserInitial()) {
    on<AddUserFetchUser>(_onFetchUser);
    on<AddUserFetchUserNextPage>(_onFetchUserNextPage);
    on<AddUserUpdateRoom>(_onUpdateRoom);
  }

  _onUpdateRoom(AddUserUpdateRoom event, Emitter<AddUserState> emit) async {
    if (state is! AddUserLoaded) return;

    final castedState = state as AddUserLoaded;
    castedState.copyWith(updatingStatus: Status.loading);

    final updatedUsersId = event.selectedUserIds +
        currentRoom.participants.map((e) => e.user.id).toList();

    final response = await _roomRepository.update(
      currentRoom.id,
      roomName: currentRoom.name,
      usersId: updatedUsersId,
    );

    response.fold(
      (l) => emit(castedState.copyWith(updatingStatus: Status.error)),
      (r) => {},
      // (r) => emit(castedState.copyWith(updatingStatus: Status.loaded)),
    );
    if (response.isLeft()) return;

    final updatedRoom = await _roomRepository.getById(currentRoom.id);

    updatedRoom.fold(
      (l) => emit(castedState.copyWith(updatingStatus: Status.error)),
      (r) => emit(castedState.copyWith(
        updatingStatus: Status.loaded,
        updatedRoom: r.data,
      )),
    );
  }

  _onFetchUser(AddUserFetchUser event, Emitter<AddUserState> emit) async {
    emit(AddUserLoading());

    username = event.username;
    final response = await _userRepository.getAllUser(username: username);

    response.fold(
      (l) => emit(AddUserError(failure: l)),
      (r) => emit(AddUserLoaded(
        users: r.copyWith(
          data: r.data
              .where((e) => !currentRoom.participants
                  .map((e) => e.user.username)
                  .contains(e.username))
              .toList(),
        ),
        nextPageStatus: Status.initial,
      )),
    );
  }

  _onFetchUserNextPage(
      AddUserFetchUserNextPage event, Emitter<AddUserState> emit) async {
    if (state is! AddUserLoaded) return;

    final castedState = state as AddUserLoaded;

    // no next page left
    if (castedState.users.next == null) return;

    emit(castedState.copyWith(nextPageStatus: Status.loading));

    final result = await _userRepository.getAllUser(
      page: castedState.users.next!,
      username: username,
    );

    result.fold(
      (l) => emit(castedState.copyWith(
        nextPageFailure: l,
        nextPageStatus: Status.error,
      )),
      (r) {
        emit(
          castedState.copyWith(
            nextPageStatus: Status.loaded,
            users: r.copyWith(
              data: castedState.users.data +
                  r.data
                      .where((e) => !currentRoom.participants
                          .map((e) => e.user.username)
                          .contains(e.username))
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
