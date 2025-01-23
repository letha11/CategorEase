import 'dart:io';

import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:categorease/utils/extension.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: AppTheme.colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: Platform.isIOS ? 60 : 20,
                    left: 16,
                    child: const AppBackButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 37),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(Assets.images.logoRounded),
                    ),
                  ),
                ],
              ),
            ),
            34.heightMargin,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.heightMargin,
                        const TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                          ),
                        ),
                        16.heightMargin,
                        Text(
                          'Username',
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.heightMargin,
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'Choose a username',
                          ),
                        ),
                        16.heightMargin,
                        Text(
                          'Password',
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.heightMargin,
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '**********',
                          ),
                        ),
                        16.heightMargin,
                        Text(
                          'Confirm Password',
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.heightMargin,
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '**********',
                          ),
                        ),
                      ],
                    ),
                  ),
                  27.heightMargin,
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign Up',
                    ),
                  ),
                  67.heightMargin
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
