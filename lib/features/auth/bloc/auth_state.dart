import 'package:equatable/equatable.dart';
import 'package:looksy_client/features/auth/models/auth_state_model.dart';

abstract class AuthState extends Equatable {
  final AuthStateModel model;

  const AuthState(this.model);

  @override
  List<Object?> get props => [model];
}

class AuthInitial extends AuthState {
  AuthInitial() : super(const AuthStateModel());
}

class AuthLoading extends AuthState {
  const AuthLoading(AuthStateModel model) : super(model);
}

class Authenticated extends AuthState {
  const Authenticated(AuthStateModel model) : super(model);
}

class Unauthenticated extends AuthState {
  Unauthenticated({String? error, String? message})
    : super(
        AuthStateModel(
          status: AuthStatus.unauthenticated,
          error: error,
          message: message,
        ),
      );
}
