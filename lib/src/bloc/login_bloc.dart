import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gig_buddy/src/bloc/model/authentication_status.dart';
import 'package:gig_buddy/src/bloc/model/request_state.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<SubmitEmail>(
      (event, emit) async {
        emit(state.copyWith(emailOtpRequestState: RequestState.loading));
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(state.copyWith(emailOtpRequestState: RequestState.success));
      },
    );
    on<ChangeEmail>((event, emit) => emit(state.copyWith(email: event.email)));
    on<ChangeEmailOTP>(
      (event, emit) => emit(state.copyWith(password: event.emailOtp)),
    );
    on<VerifyEmailOTP>(
      (event, emit) async {
        emit(state.copyWith(verifyEmailOtpRequestState: RequestState.loading));
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(
          state.copyWith(
            verifyEmailOtpRequestState: RequestState.success,
            authenticationStatus: AuthenticationStatus.authenticated,
          ),
        );
      },
    );
  }
}
