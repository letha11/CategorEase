import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:categorease/feature/chat/bloc/chat_bloc.dart';
import 'package:categorease/feature/chat/repository/chat_repository.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void initServiceLocator() {
  sl.registerLazySingleton<AppLogger>(
    () => AppLoggerImpl(),
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

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => HomeBloc(
      roomRepository: sl(),
      categoryRepository: sl(),
      authStorage: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatBloc(
      chatRepository: sl(),
    ),
  );
}
