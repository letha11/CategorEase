import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/authentication/bloc/auth_bloc.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/error_text.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 37),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Hero(
                          tag: 'logo',
                          child: SvgPicture.asset(Assets.images.logoRounded)),
                    ),
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
                            Text(
                              'Username',
                              style: AppTheme.textTheme.titleSmall,
                            ),
                            10.heightMargin,
                            TextFormField(
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Username',
                              ),
                            ),
                            16.heightMargin,
                            Text(
                              'Password',
                              style: AppTheme.textTheme.titleSmall,
                            ),
                            10.heightMargin,
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
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
                                'Invalid username or password');
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      17.heightMargin,
                      ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          context.read<AuthBloc>().add(LoginEvent(
                              _usernameController.text,
                              _passwordController.text));
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                      15.heightMargin,
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: AppTheme.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: ' Sign up',
                                style: AppTheme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      25.heightMargin,
                      const Divider(
                        color: AppTheme.primaryInput,
                      ),
                      25.heightMargin,
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset(Assets.icons.googleLogo),
                        label: const Text('Login with Google'),
                      ),
                      67.heightMargin
                    ],
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer(
              bloc: context.read<AuthBloc>(),
              listener: (context, state) {
                if (state is AuthSuccess) {
                  context.go('/home');
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) return const LoadingOverlay();

                return const SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
