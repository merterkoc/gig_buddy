import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/util/snackbar/custom_snackbar.dart';

mixin LoginListener {
  static BlocListener<LoginBloc, LoginState> listen({required Widget child}) {
    return BlocListener<LoginBloc, LoginState>(
      listener: verifyTokenRequestStateChanged,
      listenWhen: (previous, current) =>
          previous.verifyIDTokenRequest.status !=
          current.verifyIDTokenRequest.status,
      child: child,
    );
  }

  static void verifyTokenRequestStateChanged(
    BuildContext context,
    LoginState state,
  ) {
    if (state.verifyIDTokenRequest.status.isError) {
      TopSnackBar.showError(
          context, '${state.verifyIDTokenRequest.displayMessage}');
    }
  }
}
