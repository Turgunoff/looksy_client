import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/auth/bloc/auth_event.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:looksy_client/features/auth/models/auth_state_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'dart:developer' as dev;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient _supabaseClient;

  AuthBloc({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient,
      super(AuthInitial()) {
    on<CheckAuthState>(_onCheckAuthState);
    on<LoginRequested>(_onLoginRequested);
    on<LoginAsGuestRequested>(_onLoginAsGuestRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SignupRequested>(_onSignupRequested);
  }

  Future<void> _onCheckAuthState(
    CheckAuthState event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      dev.log('Checking auth state');
      final session = _supabaseClient.auth.currentSession;

      if (session != null) {
        dev.log('User is authenticated: ${session.user.id}');
        emit(
          Authenticated(
            AuthStateModel(
              status: AuthStatus.authenticated,
              userId: session.user.id,
            ),
          ),
        );
      } else {
        dev.log('User is not authenticated');
        emit(Unauthenticated());
      }
    } catch (e) {
      dev.log('Error checking auth state: $e');
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      dev.log('Login requested: ${event.email}');

      // Use Supabase authentication
      final response = await _supabaseClient.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );

      dev.log(
        'Login response: ${response.user != null ? 'Success' : 'Failed'}',
      );

      if (response.user != null) {
        dev.log('User ID: ${response.user!.id}');
        emit(
          Authenticated(
            AuthStateModel(
              status: AuthStatus.authenticated,
              userId: response.user!.id,
            ),
          ),
        );
      } else {
        dev.log('Login failed: No user returned');
        emit(Unauthenticated(error: 'Login failed'));
      }
    } catch (e) {
      dev.log('Login error: $e');
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLoginAsGuestRequested(
    LoginAsGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      dev.log('Guest login requested');
      // For guest login, we'll just emit an authenticated state with a guest flag
      // In a real app, you might want to create a temporary account or use anonymous auth

      // Try to sign out first if there's any existing session
      try {
        await _supabaseClient.auth.signOut();
      } catch (e) {
        dev.log('Error signing out before guest login: $e');
        // Continue anyway
      }

      dev.log('Guest login successful');
      emit(
        Authenticated(
          AuthStateModel(
            status: AuthStatus.authenticated,
            userId: 'guest-user-id',
            message: 'Mehmon sifatida kirish muvaffaqiyatli',
          ),
        ),
      );
    } catch (e) {
      dev.log('Guest login error: $e');
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      dev.log('Logout requested');
      // Sign out from Supabase
      await _supabaseClient.auth.signOut();
      dev.log('Logout successful');

      emit(Unauthenticated(message: 'Muvaffaqiyatli chiqish'));
    } catch (e) {
      dev.log('Logout error: $e');
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      dev.log('Signup requested: ${event.email}, ${event.fullName}');

      // Create a new user with Supabase
      final response = await _supabaseClient.auth.signUp(
        email: event.email,
        password: event.password,
        data: {'full_name': event.fullName, 'phone_number': event.phoneNumber},
      );

      dev.log(
        'Signup response: ${response.user != null ? 'Success' : 'Failed'}',
      );

      if (response.user != null) {
        dev.log('New user ID: ${response.user!.id}');
        emit(
          Authenticated(
            AuthStateModel(
              status: AuthStatus.authenticated,
              userId: response.user!.id,
            ),
          ),
        );
      } else {
        dev.log('Signup requires email confirmation');
        // User might need to confirm email
        emit(Unauthenticated(message: 'Iltimos, emailingizni tasdiqlang'));
      }
    } catch (e) {
      dev.log('Signup error: $e');
      emit(Unauthenticated(error: e.toString()));
    }
  }
}
