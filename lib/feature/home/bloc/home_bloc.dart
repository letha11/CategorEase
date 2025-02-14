import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/chat/repository/participant_repository.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/constants.dart';
import 'package:categorease/utils/websocket_helper.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RoomRepository _roomRepository;
  final CategoryRepository _categoryRepository;
  final ParticipantRepository _participantRepository;
  final AuthStorage _authStorage;
  final WebsocketHelper _websocketHelper;
  late PaginationApiResponse<Room> _savedResponse;
  int? savedCategoryId;

  HomeBloc({
    required RoomRepository roomRepository,
    required CategoryRepository categoryRepository,
    required ParticipantRepository participantRepository,
    required AuthStorage authStorage,
    required WebsocketHelper websocketHelper,
  })  : _roomRepository = roomRepository,
        _categoryRepository = categoryRepository,
        _participantRepository = participantRepository,
        _websocketHelper = websocketHelper,
        _authStorage = authStorage,
        super(HomeInitial()) {
    on<FetchDataHome>(_onFetchData);
    on<FetchDataHomeNext>(_onFetchDataNext);
    on<UpdateLastChatRoom>(_onUpdateLastChatRoom);
    on<UpdateLastViewedRoom>(_onUpdateLastViewedRoom);
    on<FilterHomeByCategory>(_onFilterHomeByCategory);
  }

  void _onFilterHomeByCategory(
      FilterHomeByCategory event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    savedCategoryId = event.categoryId;

    emit(currentState.copyWith(
      rooms: currentState.rooms.copyWith(data: []),
      nextPageStatus: Status.loading,
    ));

    // if (event.categoryId == null || event.categoryId == 0) {
    //   emit(currentState.copyWith(rooms: _savedResponse));
    //   return;
    // }

    final result =
        await _roomRepository.getAllAssociated(categoryId: event.categoryId);

    await result.fold(
      (l) async => emit(currentState.copyWith(
        nextPageStatus: Status.error,
        nextPageFailure: l,
      )),
      (r) async {
        final websocketModels = await _addWebsocketModel(r.data, state);
        _startListening(websocketModels);

        emit(
          currentState.copyWith(
            nextPageStatus: Status.loaded,
            nextPageFailure: null,
            rooms: r,
            websocketModels: websocketModels,
          ),
        );
      },
    );
  }

  void _onUpdateLastViewedRoom(
      UpdateLastViewedRoom event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    bool error = false;
    final currentState = state as HomeLoaded;

    final updatedRooms = currentState.rooms.data.map((room) {
      if (room.id == event.roomId) {
        return room.copyWith(
          unreadMessageCount: 0,
        );
      }
      return room;
    }).toList();

    emit(
      currentState.copyWith(
        rooms: currentState.rooms.copyWith(
          data: updatedRooms,
        ),
      ),
    );

    final result = await _participantRepository.updateLastView(event.roomId);

    result.fold(
      (l) =>
          error = true, // FIXME: still don't know what to do when error occured
      (r) {},
    );

    if (error) return;
  }

  void _onUpdateLastChatRoom(
      UpdateLastChatRoom event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    late Room updatedRoom;

    final updatedRooms = currentState.rooms.data.map((room) {
      if (room.id == event.roomId) {
        return room.copyWith(
          lastChat: event.lastChat,
          unreadMessageCount: room.unreadMessageCount + 1,
        );
      }

      return room;
    }).toList();

    updatedRoom = updatedRooms.firstWhere((room) => room.id == event.roomId);
    updatedRooms.removeWhere((room) => room.id == updatedRoom.id);
    updatedRooms.insert(0, updatedRoom);

    emit(
      currentState.copyWith(
        rooms: currentState.rooms.copyWith(data: updatedRooms),
      ),
    );
  }

  void _onFetchDataNext(
      FetchDataHomeNext event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) {
      return;
    }
    final HomeLoaded castedState = state as HomeLoaded;

    // Means that there is no next page left (we are at the end of the page)
    if (castedState.rooms.next == null) {
      return;
    }

    final int nextPage = castedState.rooms.next!;

    emit(
      castedState.copyWith(
        nextPageStatus: Status.loading,
      ),
    );

    final result = await _roomRepository.getAllAssociated(
      page: nextPage,
      categoryId: savedCategoryId,
    );

    await result.fold(
      (l) async => emit(
        castedState.copyWith(
          nextPageStatus: Status.error,
          nextPageFailure: l,
        ),
      ),
      (r) async {
        final newWebsocketModels = await _addWebsocketModel(r.data, state);
        final newData = r.copyWith(
          data: castedState.rooms.data + r.data,
        );
        _startListening(newWebsocketModels);

        emit(
          castedState.copyWith(
            nextPageStatus: Status.loaded,
            websocketModels: newWebsocketModels,
            rooms: newData,
          ),
        );

        _savedResponse = newData;
      },
    );
  }

  void _onFetchData(FetchDataHome event, Emitter<HomeState> emit) async {
    late PaginationApiResponse<Room> currentRooms;
    List<Category>? currentCategories;
    emit(HomeLoading());

    final categoryResponse = await _categoryRepository.getAllAssociated();

    categoryResponse.fold(
      (l) => emit(HomeError(l)),
      (r) => currentCategories = r.data,
    );

    if (state is HomeError) return;

    final roomResponse = await _roomRepository.getAllAssociated();

    roomResponse.fold(
      (l) {
        emit(HomeError(l));
      },
      (r) {
        currentRooms = r;
        _savedResponse = r;
      },
    );

    if (state is HomeError) return;

    final authenticatedUser = await _authStorage.getAuthenticatedUser();

    if (authenticatedUser == null) {
      emit(HomeError(const UnauthorizedFailure()));
      return;
    }

    List<WebsocketModel> websocketModels =
        await _addWebsocketModel(currentRooms.data);

    _startListening(websocketModels);

    emit(HomeLoaded(
      rooms: currentRooms,
      categories: currentCategories,
      websocketModels: websocketModels,
      authenticatedUser: authenticatedUser,
    ));
  }

  void _startListening(List<WebsocketModel> websocketModels) {
    for (int i = 0; i < websocketModels.length; i++) {
      if (websocketModels[i].listened) {
        continue;
      } else {
        websocketModels[i] = websocketModels[i].copyWith(listened: true);
      }

      websocketModels[i].broadcastStream.listen((data) {
        if (data is! String) return;
        if (state is! HomeLoaded) return;

        Map<String, dynamic> parsedData = jsonDecode(data);
        parsedData.addEntries([const MapEntry('id', 0)]);
        add(UpdateLastChatRoom(
          roomId: websocketModels[i].roomId,
          lastChat: Chat.fromJson(parsedData),
        ));
      });
    }
  }

  /// This function will add a new websocket if the connection not existed yet
  /// depending on the [roomId] of the [WebsocketModel] instance within the bloc state
  Future<List<WebsocketModel>> _addWebsocketModel(
    List<Room> data, [
    HomeState? state,
  ]) async {
    List<WebsocketModel> websocketModels;
    if (state == null) {
      websocketModels = [];
    } else {
      websocketModels = (state as HomeLoaded).websocketModels ?? [];
    }

    for (final room in data) {
      if (websocketModels.any((element) => element.roomId == room.id)) {
        continue;
      }

      final accessToken = await _authStorage.getAccessToken();
      final channel = await _websocketHelper.connect(room.id, accessToken!);
      final model = WebsocketModel(roomId: room.id, channel: channel);

      websocketModels.add(model);
    }

    return websocketModels;
  }
}
