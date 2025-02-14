import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/feature/category/bloc/create_category_bloc.dart';
import 'package:categorease/feature/category/choose_category.dart';
import 'package:categorease/feature/category/create_category.dart';
import 'package:categorease/feature/category/cubit/choose_category/choose_category_cubit.dart';
import 'package:categorease/feature/category/cubit/create_category/create_category_cubit.dart';
import 'package:categorease/feature/chat/bloc/chat_room/chat_bloc.dart';
import 'package:categorease/feature/chat/bloc/chat_room_detail/bloc/chat_room_detail_bloc.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/chat/chat_room_detail.dart';
import 'package:categorease/feature/chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:categorease/feature/home/cubit/home_page/home_page_cubit.dart';
import 'package:categorease/feature/room/create_room.dart';
import 'package:categorease/feature/search/bloc/search_bloc.dart';
import 'package:categorease/feature/search/search_page.dart';
import 'package:categorease/feature/setting/setting_page.dart';
import 'package:categorease/utils/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../feature/home/home_page.dart';
import '../../feature/authentication/login_page.dart';
import '../../feature/authentication/register_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) {
        return const SettingPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
        create: (context) => AuthBloc(
          authRepository: sl<AuthRepository>(),
        ),
        child: RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomePageCubit(),
          ),
        ],
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/choose-category',
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<ChooseCategoryCubit>(
        create: (context) => ChooseCategoryCubit(),
        child: const ChooseCategory(),
      ),
    ),
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<SearchBloc>(
        create: (context) => sl(),
        child: const SearchPage(),
      ),
    ),
    GoRoute(
      path: '/create-category',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CreateCategoryCubit>(
              create: (context) => CreateCategoryCubit(),
            ),
            BlocProvider<CreateCategoryBloc>(
              create: (context) => sl(),
            ),
          ],
          child: const CreateCategory(),
        );
      },
    ),
    GoRoute(
      path: '/chat-room/:room_id',
      builder: (BuildContext context, GoRouterState state) {
        final roomId = state.pathParameters['room_id'];

        assert(state.extra != null, '`extra` is required');
        assert(state.extra is ChatRoomArgs, '`extra` must be ChatRoomArgs');
        assert(roomId != null, 'Room ID path parameter is required');
        final args = state.extra! as ChatRoomArgs;

        return MultiBlocProvider(
          providers: [
            BlocProvider<ChatRoomCubit>(
              create: (context) => ChatRoomCubit(),
            ),
            BlocProvider<ChatBloc>(
              create: (context) => sl<ChatBloc>(param1: args),
            ),
          ],
          child: ChatRoom(
            roomId: args.roomId,
          ),
        );
      },
    ),
    GoRoute(
        path: '/chat-room-detail',
        builder: (context, state) {
          assert(state.extra != null, '`extra` is required');
          assert(state.extra is ChatRoomDetailArgs,
              '`extra` must be ChatRoomDetail');
          final args = state.extra! as ChatRoomDetailArgs;

          return BlocProvider<ChatRoomDetailBloc>(
            create: (context) => sl(param1: args.room),
            child: const ChatRoomDetail(),
          );
        }),
    GoRoute(
      path: '/create-room',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateRoom();
      },
    ),
  ],
);
