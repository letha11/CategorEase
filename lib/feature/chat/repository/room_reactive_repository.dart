import 'dart:async';

import 'package:categorease/feature/room/model/room.dart';

abstract class RoomReactiveRepository {
  Stream<Room> get stream;
  void updateRoom(Room room);
}

class RoomReactiveRepositoryImpl implements RoomReactiveRepository {
  final StreamController<Room> _streamController =
      StreamController<Room>.broadcast();

  @override
  Stream<Room> get stream => _streamController.stream;

  @override
  void updateRoom(Room room) async {
    _streamController.sink.add(room);
  }
}
