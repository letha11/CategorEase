import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/feature/category/choose_category.dart';
import 'package:categorease/feature/setting/widgets/setting_item.dart';
import 'package:categorease/feature/setting/widgets/setting_wrapper.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            25.heightMargin,
            SettingWrapper(
              children: [
                SettingItem(
                  title: 'Logout Account',
                  titleOnly: true,
                  color: AppTheme.errorColor,
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
