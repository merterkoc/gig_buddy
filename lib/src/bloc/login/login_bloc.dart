import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/common/util/image_util.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/http/dio/model/response_entity.dart';
import 'package:gig_buddy/src/repository/identity_repository.dart';
import 'package:gig_buddy/src/service/model/interest/interest_dto.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authManager, this._identityRepository)
      : super(LoginState.initial()) {
    on<LoginInitState>(_onInit);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<CreateAccount>(_onCreateAccount);
    on<SubmitEmail>(_onSubmitEmail);
    on<VerifyIDToken>(_onVerifyIDToken);
    on<Logout>(_onLogout);
    on<FetchUserInfo>(_onFetchUserInfo);
    on<FetchAllInterests>(_onFetchAllInterests);
    on<PatchUserInterests>(_onPatchUserInterests, transformer: sequential());
  }

  final AuthManager _authManager;
  final IdentityRepository _identityRepository;

  Future<void> _onInit(LoginInitState event, Emitter<LoginState> emit) async {
    emit(LoginState.initial());
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(signInWithGoogleRequest: ResponseEntity.loading()));
    try {
      final response = await _authManager.signInWithGoogle();
      final credential =
          GoogleAuthProvider.credential(idToken: response.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.getIdToken().then((value) {
        add(VerifyIDToken(token: value!));
      });
      emit(state.copyWith(signInWithGoogleRequest: ResponseEntity.success()));
    } on Exception {
      emit(state.copyWith(signInWithGoogleRequest: ResponseEntity.error()));
      rethrow;
    }
  }

  Future<void> _onCreateAccount(
    CreateAccount event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(createAccountRequest: ResponseEntity.loading()));
    try {
      final response = await _identityRepository.create(
        email: event.email,
        password: event.password,
        rePassword: event.rePassword,
        image: event.image != null
            ? await ImageHelper.pathToUINT8List(event.image!.path)
            : null,
      );
      emit(
        state.copyWith(createAccountRequest: response),
      );

      if (response.isOk) {
        add(SubmitEmail(email: event.email, password: event.password));
      }
    } on Exception {
      emit(state.copyWith(createAccountRequest: ResponseEntity.error()));
      rethrow;
    }
  }

  Future<void> _onSubmitEmail(
    SubmitEmail event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(submitEmail: ResponseEntity.loading()));
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
      emit(state.copyWith(submitEmail: ResponseEntity.error()));
      rethrow;
    }
  }

  Future<void> _onVerifyIDToken(
    VerifyIDToken event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(verifyIDTokenRequest: ResponseEntity.loading()));
    try {
      final response = await _identityRepository.verifyIDToken(
        event.token,
      );
      await _identityRepository
          .setToken(OAuth2Token(accessToken: response.data!.token));
      emit(
        state.copyWith(
          submitEmail: ResponseEntity.success(),
          verifyIDTokenRequest: response,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          submitEmail: ResponseEntity.error(),
          verifyIDTokenRequest: ResponseEntity.error(
            displayMessage: 'Failed to verify your sign in. Please try again.',
          ),
        ),
      );
    }
  }

  Future<void> _onLogout(Logout event, Emitter<LoginState> emit) async {
    await _identityRepository.logout();
    _authManager.logout();
  }

  Future<void> _onFetchUserInfo(
    FetchUserInfo event,
    Emitter<LoginState> emit,
  ) async {
    final responseEntity = await _identityRepository.getUserInfo();
    if (responseEntity.isOk) {
      final user =
          UserDto.fromJson(responseEntity.data as Map<String, dynamic>);
      emit(state.copyWith(user: user));
    }
  }

  Future<void> _onFetchAllInterests(
    FetchAllInterests event,
    Emitter<LoginState> emit,
  ) async {
    final responseEntity = await _identityRepository.getAllInterests();
    if (responseEntity.isOk) {
      final interestsJson = (responseEntity.data
          as Map<String, dynamic>)['interests'] as List<dynamic>;
      final data = interestsJson
          .map((e) => InterestDto.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      emit(state.copyWith(interests: data));
    }
  }

  Future<void> _onPatchUserInterests(
    PatchUserInterests event,
    Emitter<LoginState> emit,
  ) async {
    final oldState = state.user!.interests!.toList(growable: true);
    try {
      final userInterests = state.user!.interests!.toList(growable: true);
      if (event.operation == 'add') {
        userInterests.add(event.interestDto);
      } else if (event.operation == 'remove') {
        userInterests.remove(event.interestDto);
      }
      emit(
        state.copyWith(user: state.user!.copyWith(interests: userInterests)),
      );
      final responseEntity = await _identityRepository.patchUserInterests(
        event.interestDto.id,
        event.operation,
      );
      if (!responseEntity.isOk) {
        throw Exception(
          'Failed to patch user interests with status code'
          ' ${responseEntity.statusCode} and message '
          '${responseEntity.message} and interest id '
          '${event.interestDto.id}, and operation ${event.operation}, '
          'and data ${responseEntity.data}',
        );
      }
    } on Exception {
      emit(state.copyWith(user: state.user!.copyWith(interests: oldState)));
      rethrow;
    }
  }
}
