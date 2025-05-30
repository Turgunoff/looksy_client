import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:looksy_client/core/theme/app_theme.dart';
import 'package:looksy_client/features/auth/bloc/auth_bloc_fixed.dart';
import 'package:looksy_client/features/auth/bloc/auth_event.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:looksy_client/features/auth/presentation/widgets/social_login_buttons.dart';
import 'dart:developer' as dev;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleGoogleLogin() {
    context.read<AuthBloc>().add(const GoogleLoginRequested());
  }

  void _handleAppleLogin() {
    context.read<AuthBloc>().add(const AppleLoginRequested());
  }

  void _handleFacebookLogin() {
    context.read<AuthBloc>().add(const FacebookLoginRequested());
  }

  void _handleTelegramLogin() {
    context.read<AuthBloc>().add(const TelegramLoginRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Looksy - Kirish'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AuthLoading;
          });

          dev.log('Auth state: $state');

          if (state is Authenticated) {
            dev.log('Authenticated: ${state.model.userId}');
            // Navigate to home page
            context.go('/');
          } else if (state is Unauthenticated) {
            if (state.model.error != null) {
              dev.log('Authentication error: ${state.model.error}');
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.model.error!),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.model.message != null) {
              dev.log('Authentication message: ${state.model.message}');
              // Show info message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.model.message!),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Looksy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, email kiriting';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Noto\'g\'ri email formati';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Parol',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: AppTheme.primaryColor),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, parol kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child:
                      _isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text('Kirish'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hisobingiz yo\'qmi?'),
                    TextButton(
                      onPressed: () {
                        context.push('/signup');
                      },
                      child: Text('Ro\'yxatdan o\'tish'),
                    ),
                  ],
                ),

                SocialLoginButtons(
                  onGooglePressed: _handleGoogleLogin,
                  onApplePressed: _handleAppleLogin,
                  onFacebookPressed: _handleFacebookLogin,
                  onTelegramPressed: _handleTelegramLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
