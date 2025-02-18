import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/feature/category/bloc/choose_category/choose_category_bloc.dart';
import 'package:categorease/feature/category/bloc/create_category/create_category_bloc.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/chat/bloc/add_user/add_user_bloc.dart';
import 'package:categorease/feature/chat/bloc/chat_room/chat_bloc.dart';
import 'package:categorease/feature/chat/bloc/chat_room_detail/bloc/chat_room_detail_bloc.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/chat/repository/chat_repository.dart';
import 'package:categorease/feature/chat/repository/participant_repository.dart';
import 'package:categorease/feature/chat/repository/room_reactive_repository.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/room/bloc/create_room/create_room_bloc.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/feature/search/bloc/search_bloc.dart';
import 'package:categorease/feature/search/repository/user_repository.dart';
import 'package:categorease/utils/websocket_helper.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void initServiceLocator() {
  sl.registerLazySingleton<AppLogger>(
    () => AppLoggerImpl(),
  );
  sl.registerLazySingleton<WebsocketHelper>(
    () => WebsocketHelper(),
  );

  sl.registerLazySingleton<AuthStorage>(
    () => AuthStorageImpl(),
  );
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authStorage: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dioClient: sl(),
      authStorage: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(
      dioClient: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      dioClient: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      dioClient: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<ParticipantRepository>(
    () => ParticipantRepositoryImpl(
      dioClient: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      dioClient: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<RoomReactiveRepository>(
    () => RoomReactiveRepositoryImpl(),
  );

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => HomeBloc(
      roomReactiveRepository: sl(),
      participantRepository: sl(),
      roomRepository: sl(),
      categoryRepository: sl(),
      websocketHelper: sl(),
      authStorage: sl(),
    ),
  );
  sl.registerFactoryParam<ChatBloc, ChatRoomArgs, void>(
    (args, _) => ChatBloc(
      args: args,
      chatRepository: sl(),
      roomRepository: sl(),
      roomReactiveRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => CreateCategoryBloc(
      categoryRepository: sl(),
      roomRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => SearchBloc(
      userRepository: sl(),
    ),
  );
  sl.registerFactoryParam<ChatRoomDetailBloc, Room, void>(
    (room, _) => ChatRoomDetailBloc(
      roomRepository: sl(),
      roomReactiveRepository: sl(),
      room: room,
    ),
  );
  sl.registerFactoryParam<AddUserBloc, Room, void>(
    (currentRoom, _) => AddUserBloc(
      roomReactiveRepository: sl(),
      userRepository: sl(),
      roomRepository: sl(),
      currentRoom: currentRoom,
    ),
  );
  sl.registerFactoryParam<ChooseCategoryBloc, Room, void>(
    (currentRoom, _) => ChooseCategoryBloc(
      categoryRepository: sl(),
      roomRepository: sl(),
      roomReactiveRepository: sl(),
      currentRoom: currentRoom,
    ),
  );
  sl.registerFactory(
    () => CreateRoomBloc(
      roomRepository: sl(),
    ),
  );
}
