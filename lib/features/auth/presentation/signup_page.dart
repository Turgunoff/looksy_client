import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:looksy_client/core/theme/app_theme.dart';
import 'package:looksy_client/features/auth/bloc/auth_bloc_fixed.dart';
import 'package:looksy_client/features/auth/bloc/auth_event.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
        SignupRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phoneNumber:
              _phoneNumberController.text.isEmpty
                  ? null
                  : _phoneNumberController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ro\'yxatdan o\'tish')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AuthLoading;
          });

          if (state is Authenticated) {
            context.go('/');
          } else if (state is Unauthenticated) {
            if (state.model.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.model.error!),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.model.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.model.message!),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Looksy',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'To\'liq ism',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, to\'liq ismingizni kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Telefon raqami (ixtiyoriy)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone, color: AppTheme.primaryColor),
                    hintText: '+998 XX XXX XX XX',
                  ),
                  keyboardType: TextInputType.phone,
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
                    if (value.length < 6) {
                      return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Parolni tasdiqlang',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, parolni tasdiqlang';
                    }
                    if (value != _passwordController.text) {
                      return 'Parollar mos kelmadi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
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
                          : Text('Ro\'yxatdan o\'tish'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Allaqachon hisobingiz bormi?'),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text('Kirish'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
