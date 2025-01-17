import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/home/presentation/home_page.dart';
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
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
  ],
);
