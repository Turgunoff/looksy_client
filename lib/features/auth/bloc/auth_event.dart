import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthState extends AuthEvent {
  const CheckAuthState();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginAsGuestRequested extends AuthEvent {
  const LoginAsGuestRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String? phoneNumber;

  const SignupRequested({
    required this.email,
    required this.password,
    required this.fullName,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, fullName, phoneNumber];
}

class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

class AppleLoginRequested extends AuthEvent {
  const AppleLoginRequested();
}

class FacebookLoginRequested extends AuthEvent {
  const FacebookLoginRequested();
}

class TelegramLoginRequested extends AuthEvent {
  const TelegramLoginRequested();
}
