import 'package:categorease/config/routes/app_router.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/service_locator.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final token = await sl<AuthStorage>().getAccessToken();
      if (token != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
      // context.push('/login');
    });
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: SvgPicture.asset(
            Assets.images.logoRounded,
          ),
        ),
      ),
    );
  }
}
