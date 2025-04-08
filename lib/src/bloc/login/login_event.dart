part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class LoginInitState extends LoginEvent {
  const LoginInitState();
}

final class CreateAccount extends LoginEvent {
  const CreateAccount(
      {required this.email, required this.password, this.image});

  final String email;
  final String password;
  final XFile? image;
}

final class SubmitEmail extends LoginEvent {
  const SubmitEmail({required this.email, required this.password});

  final String email;
  final String password;
}

final class ChangeEmail extends LoginEvent {
  const ChangeEmail({required this.email});

  final String email;
}

final class ChangePassword extends LoginEvent {
  const ChangePassword({required this.password});

  final String password;
}

final class ChangeEmailOTP extends LoginEvent {
  const ChangeEmailOTP({required this.emailOtp});

  final String emailOtp;
}

final class VerifyIDToken extends LoginEvent {
  const VerifyIDToken({required this.token});

  final String token;
}

class Logout extends LoginEvent {
  const Logout();
}

class FetchUserInfo extends LoginEvent {
  const FetchUserInfo();
}

class FetchAllInterests extends LoginEvent {
  const FetchAllInterests();
}

class PatchUserInterests extends LoginEvent {
  const PatchUserInterests(
    this.operation, {
    required this.interestDto,
  }) : assert(operation == 'add' || operation == 'remove', 'Invalid operation');

  final InterestDto interestDto;
  final String operation;
}
