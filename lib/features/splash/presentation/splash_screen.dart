import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:looksy_client/core/theme/app_theme.dart';
import 'package:looksy_client/features/auth/bloc/auth_bloc_fixed.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Navigate to the appropriate screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      // If already authenticated, go to home page
      context.go('/');
    } else {
      // If not authenticated, still go to home page
      // User can access Home and Search without authentication
      context.go('/');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2F1), // Teal rangining juda och varianti
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with fade-in and scale animation
              FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withAlpha(76),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.spa,
                        size: 80,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name with fade-in animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Looksy',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tagline with fade-in animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Go\'zallik saloni bron qilish ilovasi',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              FadeTransition(
                opacity: _animation,
                child: SpinKitDoubleBounce(
                  color: AppTheme.primaryColor,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
