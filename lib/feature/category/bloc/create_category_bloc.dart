import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/constants.dart';
import 'package:categorease/utils/extension.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryBlocState> {
  final CategoryRepository _categoryRepository;
  final RoomRepository _roomRepository;

  CreateCategoryBloc(
      {required CategoryRepository categoryRepository,
      required RoomRepository roomRepository})
      : _categoryRepository = categoryRepository,
        _roomRepository = roomRepository,
        super(const CreateCategoryBlocState()) {
    on<CreateCategoryCreate>(_onCreateCategoryCreate);
    on<CreateCategoryFetchRoom>(_onCreateCategoryFetchRoom);
    on<CreateCategoryFetchNextRoom>(_onCreateCategoryFetchNextRoom);
  }

  Future<void> _onCreateCategoryFetchNextRoom(CreateCategoryFetchNextRoom event,
      Emitter<CreateCategoryBlocState> emit) async {
    if (!state.roomStatus.isLoaded) return;
    if (state.rooms == null) return;
    if (state.rooms!.next == null) return;

    final int nextPage = state.rooms!.next!;

    emit(state.copyWith(roomStatus: Status.loading));

    final response = await _roomRepository.getAllAssociated(
      page: nextPage,
    );

    response.fold(
      (l) => state.copyWith(
        roomFailure: l,
        roomStatus: Status.error,
      ),
      (r) => emit(state.copyWith(
        rooms: r.copyWith(
          data: state.rooms!.data + r.data,
        ),
        roomStatus: Status.loaded,
      )),
    );
  }

  Future<void> _onCreateCategoryFetchRoom(CreateCategoryFetchRoom event,
      Emitter<CreateCategoryBlocState> emit) async {
    emit(state.copyWith(roomStatus: Status.loading));

    final response = await _roomRepository.getAllAssociated();

    response.fold(
      (l) => state.copyWith(
        roomFailure: l,
        roomStatus: Status.error,
      ),
      (r) => emit(state.copyWith(
        rooms: r,
        roomStatus: Status.loaded,
      )),
    );
  }

  _onCreateCategoryCreate(
      CreateCategoryCreate event, Emitter<CreateCategoryBlocState> emit) async {
    emit(state.copyWith(createCategoryStatus: Status.loading));

    if (event.roomIds.isEmpty) {
      emit(
        state.copyWith(
          failure: const Failure(message: 'Rooms must be selected at least 1'),
          isRoomEmpty: true,
        ),
      );
      return;
    }

    final response = await _categoryRepository.create(
      name: event.name,
      roomIds: event.roomIds,
      hexColor: event.color,
    );

    response.fold(
      (l) => emit(
        state.copyWith(failure: l, createCategoryStatus: Status.error),
      ),
      (r) => emit(
        state.copyWith(createCategoryStatus: Status.loaded),
      ),
    );
  }
}
