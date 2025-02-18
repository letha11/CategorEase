import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_room_event.dart';
part 'create_room_state.dart';

class CreateRoomBloc extends Bloc<CreateRoomEvent, CreateRoomState> {
  final RoomRepository _roomRepository;

  CreateRoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(CreateRoomInitial()) {
    on<CreateRoomRequested>(_onRequested);
  }

  void _onRequested(
      CreateRoomRequested event, Emitter<CreateRoomState> emit) async {
    emit(CreateRoomLoading());

    final response = await _roomRepository.create(
      roomName: event.roomName,
      usersId: [event.userId],
    );

    response.fold(
      (failure) => emit(CreateRoomError(failure)),
      (_) => emit(CreateRoomSuccess()),
    );
  }
}
