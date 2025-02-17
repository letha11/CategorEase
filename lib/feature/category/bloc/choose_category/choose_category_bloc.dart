import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/chat/repository/room_reactive_repository.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/constants.dart';
import 'package:equatable/equatable.dart';

part 'choose_category_event.dart';
part 'choose_category_state.dart';

class ChooseCategoryBloc
    extends Bloc<ChooseCategoryEvent, ChooseCategoryState> {
  final CategoryRepository _categoryRepository;
  final RoomRepository _roomRepository;
  final RoomReactiveRepository _roomReactiveRepository;
  final Room currentRoom;

  ChooseCategoryBloc({
    required CategoryRepository categoryRepository,
    required RoomReactiveRepository roomReactiveRepository,
    required RoomRepository roomRepository,
    required this.currentRoom,
  })  : _categoryRepository = categoryRepository,
        _roomReactiveRepository = roomReactiveRepository,
        _roomRepository = roomRepository,
        super(CCInitial()) {
    on<ChooseCategoryFetchCategories>(_onFetchCategories);
    on<ChooseCategoryUpdateRoom>(_onUpdateRoom);
  }

  void _onUpdateRoom(
    ChooseCategoryUpdateRoom event,
    Emitter<ChooseCategoryState> emit,
  ) async {
    if (state is! CCInitialLoaded) return;

    final castedState = state as CCInitialLoaded;
    emit(castedState.copyWith(
      updateStatus: Status.loading,
    ));

    final updatedCategoriesId =
        event.selectedCategories.map((e) => e.id).toList();

    final response = await _roomRepository.update(
      currentRoom.id,
      roomName: currentRoom.name,
      usersId: currentRoom.participants.map((p) => p.user.id).toList(),
      categoriesId: updatedCategoriesId,
    );

    response.fold(
      (l) => emit(
        castedState.copyWith(updateStatus: Status.error, updateFailure: l),
      ),
      (r) => {},
    );

    if (response.isLeft()) return;

    _roomReactiveRepository.updateRoom(currentRoom.copyWith(
      categories: event.selectedCategories,
    ));

    emit(
      castedState.copyWith(updateStatus: Status.loaded),
    );
  }

  _onFetchCategories(
    ChooseCategoryFetchCategories event,
    Emitter<ChooseCategoryState> emit,
  ) async {
    emit(CCInitialLoading());

    final response = await _categoryRepository.getAllAssociated();

    response.fold(
      (l) => emit(CCInitialError(failure: l)),
      (r) => emit(CCInitialLoaded(
        categories: r.data ?? [],
      )),
    );
  }
}
