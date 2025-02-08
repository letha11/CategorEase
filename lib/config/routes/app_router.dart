import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/feature/category/choose_category.dart';
import 'package:categorease/feature/category/create_category.dart';
import 'package:categorease/feature/category/cubit/choose_category/choose_category_cubit.dart';
import 'package:categorease/feature/category/cubit/create_category/create_category_cubit.dart';
import 'package:categorease/feature/chat/bloc/chat_bloc.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/cubit/home_page/home_page_cubit.dart';
import 'package:categorease/feature/room/create_room.dart';
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
          const SearchPage(),
    ),
    GoRoute(
      path: '/create-category',
      builder: (context, state) => BlocProvider<CreateCategoryCubit>(
        create: (context) => CreateCategoryCubit(),
        child: CreateCategory(),
      ),
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
      path: '/create-room',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateRoom();
      },
    )
  ],
);
