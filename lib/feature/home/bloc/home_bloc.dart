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
    on<UpdateLastChatRoom>(_onUpdateLastChatRoom);
    on<UpdateLastViewedRoom>(_onUpdateLastViewedRoom);
  }

  void _onUpdateLastViewedRoom(
      UpdateLastViewedRoom event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    bool error = false;
    final currentState = state as HomeLoaded;

    final updatedRooms = currentState.rooms?.map((room) {
      if (room.id == event.roomId) {
        return room.copyWith(
          unreadMessageCount: 0,
        );
      }
      return room;
    }).toList();
    emit(currentState.copyWith(rooms: updatedRooms));

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

    final updatedRooms = currentState.rooms?.map((room) {
      if (room.id == event.roomId) {
        return room.copyWith(
          lastChat: event.lastChat,
          unreadMessageCount: room.unreadMessageCount + 1,
        );
      }
      return room;
    }).toList();

    updatedRooms!.sort(
      (a, b) => (b.lastChat?.createdAt ?? DateTime(0)).compareTo(
        a.lastChat?.createdAt ?? DateTime(0),
      ),
    );

    emit(currentState.copyWith(rooms: updatedRooms));
  }

  void _onFetchData(FetchDataHome event, Emitter<HomeState> emit) async {
    List<Room>? currentRooms;
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
      (r) => currentRooms = r.data,
    );

    if (state is HomeError) return;

    final authenticatedUser = await _authStorage.getAuthenticatedUser();

    if (authenticatedUser == null) {
      emit(HomeError(const UnauthorizedFailure()));
      return;
    }

    List<WebsocketModel> websocketModels = [];

    for (final room in currentRooms!) {
      final accessToken = await _authStorage.getAccessToken();
      final channel = await _websocketHelper.connect(room.id, accessToken!);
      final model = WebsocketModel(roomId: room.id, channel: channel);
      model.broadcastStream.listen((data) {
        if (data is! String) return;
        if (state is! HomeLoaded) return;

        Map<String, dynamic> parsedData = jsonDecode(data);
        parsedData.addEntries([const MapEntry('id', 0)]);
        add(UpdateLastChatRoom(
          roomId: room.id,
          lastChat: Chat.fromJson(parsedData),
        ));
      });

      websocketModels.add(model);
    }

    emit(HomeLoaded(
      rooms: currentRooms,
      categories: currentCategories,
      websocketModels: websocketModels,
      authenticatedUser: authenticatedUser,
    ));
  }
}
