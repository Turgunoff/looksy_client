import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthStateModel extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? error;

  const AuthStateModel({
    this.status = AuthStatus.initial,
    this.userId,
    this.error,
  });

  AuthStateModel copyWith({
    AuthStatus? status,
    String? userId,
    String? error,
  }) {
    return AuthStateModel(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, userId, error];
}
