part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class SubmitEmail extends LoginEvent {}

final class ChangeEmail extends LoginEvent {
  const ChangeEmail({required this.email});

  final String email;
}

final class ChangeEmailOTP extends LoginEvent {
  const ChangeEmailOTP({required this.emailOtp});

  final String emailOtp;
}

final class VerifyEmailOTP extends LoginEvent {}
