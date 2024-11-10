import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/common/util/image_util.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/repository/identity_repository.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authManager, this._identityRepository)
      : super(const LoginState()) {
    on<CreateAccount>(_onCreateAccount);
    on<SubmitEmail>(_onSubmitEmail);
    on<VerifyIDToken>(_onVerifyIDToken);
    on<Logout>(_onLogout);
    on<FetchUserInfo>(_onFetchUserInfo);
  }

  final AuthManager _authManager;
  final IdentityRepository _identityRepository;

  Future<void> _onCreateAccount(
    CreateAccount event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(createAccountRequestState: RequestState.loading));
    try {
      final response = await _identityRepository.create(
        email: event.email,
        password: event.password,
        image: event.image != null
            ? await ImageHelper.pathToUINT8List(event.image!.path)
            : null,
      );
      if (response.isOk) {
        return emit(
            state.copyWith(createAccountRequestState: RequestState.success));
      }
      throw Exception(
        'Register failed with status code ${response.statusCode} and message ${response.message}',
      );
    } on Exception {
      emit(state.copyWith(createAccountRequestState: RequestState.error));
      rethrow;
    }
  }

  Future<void> _onSubmitEmail(
    SubmitEmail event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(submitEmail: RequestState.loading));
    try {
      final response = await _authManager.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (response.user == null) {
        throw Exception('User is null');
      }
      await FirebaseAuth.instance.currentUser!.getIdToken().then((value) {
        add(VerifyIDToken(token: value!));
      });
    } on Exception {
      emit(state.copyWith(submitEmail: RequestState.error));
      rethrow;
    }
  }

  Future<void> _onVerifyIDToken(
      VerifyIDToken event, Emitter<LoginState> emit) async {
    emit(state.copyWith(verifyIDTokenRequestState: RequestState.loading));
    try {
      final response = await _identityRepository.verifyIDToken(
        event.token,
      );
      await _identityRepository
          .setToken(OAuth2Token(accessToken: response.data!.token));
      emit(
        state.copyWith(
          submitEmail: RequestState.success,
          verifyIDTokenRequestState: RequestState.success,
        ),
      );
    } on Exception {
      emit(state.copyWith(verifyIDTokenRequestState: RequestState.error));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<LoginState> emit) async {
    await _identityRepository.logout();
    _authManager.logout();
  }

  Future<void> _onFetchUserInfo(
      FetchUserInfo event, Emitter<LoginState> emit) async {
    final responseEntity = await _identityRepository.getUserInfo();
    if (responseEntity.isOk) {
      final user =
          UserDto.fromJson(responseEntity.data as Map<String, dynamic>);
      emit(state.copyWith(user: user));
    }
  }
}
