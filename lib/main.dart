import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/service_locator.dart' as service_locator;

void main() async {
  Intl.defaultLocale = 'en_US';

  await initializeDateFormatting('en_US', null);

  service_locator.initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<HomeBloc>()..add(FetchDataHome()),
          ),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is! AuthSuccess) return;

            if (state.isLoggedIn) {
              appRouter.go('/home');
            } else {
              appRouter.go('/login');
            }
          },
          child: MaterialApp.router(
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
          ),
        ),
      ),
    );
  }
}
