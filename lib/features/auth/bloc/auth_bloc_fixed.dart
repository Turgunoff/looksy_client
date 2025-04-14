import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/auth/bloc/auth_event.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:looksy_client/features/auth/models/auth_state_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient _supabaseClient;

  AuthBloc({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient,
      super(AuthInitial()) {
    on<CheckAuthState>(_onCheckAuthState);
    on<LoginRequested>(_onLoginRequested);
    on<LoginAsGuestRequested>(_onLoginAsGuestRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthState(
    CheckAuthState event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      final session = _supabaseClient.auth.currentSession;

      if (session != null) {
        emit(
          Authenticated(
            AuthStateModel(
              status: AuthStatus.authenticated,
              userId: session.user.id,
            ),
          ),
        );
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      // This is a placeholder for actual Supabase authentication
      // In a real app, you would use Supabase auth methods
      // final response = await _supabaseClient.auth.signInWithPassword(
      //   email: event.email,
      //   password: event.password,
      // );

      // For demo purposes, we'll just simulate a successful login
      emit(
        Authenticated(
          AuthStateModel(
            status: AuthStatus.authenticated,
            userId: 'simulated-user-id',
          ),
        ),
      );
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLoginAsGuestRequested(
    LoginAsGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      // In a real app, you might use Supabase anonymous auth or similar
      // For demo purposes, we'll just simulate a guest login
      emit(
        Authenticated(
          AuthStateModel(
            status: AuthStatus.authenticated,
            userId: 'guest-user-id',
          ),
        ),
      );
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(AuthStateModel(status: AuthStatus.initial)));

    try {
      // In a real app, you would sign out from Supabase
      // await _supabaseClient.auth.signOut();

      emit(Unauthenticated());
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }
}
