import 'dart:io';

import 'package:categorease/config/routes/app_router.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/widgets/back_button.dart';
import 'package:categorease/utils/widgets/error_text.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:categorease/utils/extension.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
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
                            child: Hero(
                              tag: 'logo',
                              child:
                                  SvgPicture.asset(Assets.images.logoRounded),
                            ),
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
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.heightMargin,
                              Text(
                                'Username',
                                style: AppTheme.textTheme.titleSmall,
                              ),
                              10.heightMargin,
                              TextFormField(
                                controller: _usernameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Your username',
                                ),
                              ),
                              16.heightMargin,
                              Text(
                                'Password',
                                style: AppTheme.textTheme.titleSmall,
                              ),
                              10.heightMargin,
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: '**********',
                                ),
                              ),
                              16.heightMargin,
                              Text(
                                'Confirm Password',
                                style: AppTheme.textTheme.titleSmall,
                              ),
                              10.heightMargin,
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Password does not match';
                                  } else if (value!.isEmpty) {
                                    return 'Please enter your confirmation password';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: '**********',
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.heightMargin,
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthFailed) {
                              return ErrorText(state.message ??
                                  'Something went wrong, please try again later');
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                        17.heightMargin,
                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            context.read<AuthBloc>().add(RegisterEvent(
                                  _usernameController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                ));
                          },
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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const LoadingOverlay();
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
