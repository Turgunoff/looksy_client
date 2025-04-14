import 'package:equatable/equatable.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthStateModel extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? error;
  final String? message;

  const AuthStateModel({
    this.status = AuthStatus.initial,
    this.userId,
    this.error,
    this.message,
  });

  AuthStateModel copyWith({
    AuthStatus? status,
    String? userId,
    String? error,
    String? message,
  }) {
    return AuthStateModel(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, userId, error, message];
}
