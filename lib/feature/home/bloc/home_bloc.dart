import 'package:bloc/bloc.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RoomRepository _roomRepository;
  final CategoryRepository _categoryRepository;
  final AuthStorage _authStorage;

  HomeBloc({
    required RoomRepository roomRepository,
    required CategoryRepository categoryRepository,
    required AuthStorage authStorage,
  })  : _roomRepository = roomRepository,
        _categoryRepository = categoryRepository,
        _authStorage = authStorage,
        super(HomeInitial()) {
    on<FetchDataHome>(_onFetchData);
  }

  void _onFetchData(FetchDataHome event, Emitter<HomeState> emit) async {
    List<Room>? currentRooms;
    List<Category>? currentCategories;
    emit(HomeLoading());

    late final Either<Failure, PaginationApiResponse<Room>> roomResponse;
    late final Either<Failure, ApiResponse<List<Category>>> categoryResponse;
    late final User authenticatedUser;
    await Future.wait([
      _roomRepository.getAllAssociated().then((val) => roomResponse = val),
      _categoryRepository
          .getAllAssociated()
          .then((val) => categoryResponse = val),
      _authStorage
          .getAuthenticatedUser()
          .then((user) => authenticatedUser = user!),
    ]);

    categoryResponse.fold(
      /// FIXME: I still don't know on how to tackle this, but currently
      /// I think that the app should care most about the rooms instead of the
      /// categories since, so it's better to show the error in the room list (sorry category)
      (l) {},
      (r) => currentCategories = r.data,
    );

    roomResponse.fold(
      (l) => emit(HomeError(l)),
      (r) {
        currentRooms = r.data;
        emit(HomeLoaded(
          rooms: currentRooms,
          categories: currentCategories,
          authenticatedUser: authenticatedUser,
        ));
      },
    );
  }
}
