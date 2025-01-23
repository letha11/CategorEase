import 'package:categorease/feature/category/choose_category.dart';
import 'package:categorease/feature/category/create_category.dart';
import 'package:categorease/feature/category/cubit/choose_category/choose_category_cubit.dart';
import 'package:categorease/feature/category/cubit/create_category/create_category_cubit.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:categorease/feature/home/cubit/home_page/home_page_cubit.dart';
import 'package:categorease/feature/room/create_room.dart';
import 'package:categorease/feature/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../feature/home/home_page.dart';
import '../../feature/authentication/presentation/login_page.dart';
import '../../feature/authentication/presentation/register_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<HomePageCubit>(
        create: (context) => HomePageCubit(),
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

        return BlocProvider<ChatRoomCubit>(
          create: (context) => ChatRoomCubit(),
          child: ChatRoom(),
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
