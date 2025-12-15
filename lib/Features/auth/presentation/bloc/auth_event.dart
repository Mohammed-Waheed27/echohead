part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final UserType? userType;

  const LoginRequested({
    required this.username,
    required this.password,
    this.userType,
  });

  @override
  List<Object?> get props => [username, password, userType];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;
  final UserType userType;
  final String? companyPassword;

  const RegisterRequested({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.userType,
    this.companyPassword,
  });

  @override
  List<Object?> get props => [
        username,
        password,
        confirmPassword,
        userType,
        companyPassword,
      ];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

