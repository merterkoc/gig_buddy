import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/util/snackbar/custom_snackbar.dart';
import 'package:go_router/go_router.dart';

mixin EmailLoginListener {
  static MultiBlocListener listen({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.verifyIDTokenRequest.status !=
              current.verifyIDTokenRequest.status,
          listener: verifyTokenRequestStateChanged,
          child: child,
        ),
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.submitEmail.status != current.submitEmail.status,
          listener: submitEmailRequestStateChanged,
          child: child,
        ),
      ],
      child: child,
    );
  }

  static void verifyTokenRequestStateChanged(
    BuildContext context,
    LoginState state,
  ) {
    if (state.verifyIDTokenRequest.status.isSuccess) {
      context.pop();
    } else if (state.verifyIDTokenRequest.status.isError) {
      TopSnackBar.showError(
        context,
        '${state.verifyIDTokenRequest.displayMessage}',
      );
    }
  }

  static void submitEmailRequestStateChanged(
    BuildContext context,
    LoginState state,
  ) {
    if (state.submitEmail.status.isError) {
      TopSnackBar.showError(
        context,
        state.submitEmail.displayMessage ??
            'Failed to login. Please try again.',
      );
    }
  }
}
