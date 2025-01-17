import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  )),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 37),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset('assets/images/logo-rounded.svg'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.heightMargin,
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'Username',
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
                      ],
                    ),
                  ),
                  27.heightMargin,
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
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
                    icon: SvgPicture.asset('assets/images/google-logo.svg'),
                    label: const Text('Login with Google'),
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
