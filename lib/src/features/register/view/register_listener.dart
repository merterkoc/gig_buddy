import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/util/snackbar/custom_snackbar.dart';
import 'package:go_router/go_router.dart';

mixin RegisterListener {
  static BlocListener<LoginBloc, LoginState> listen({required Widget child}) {
    return BlocListener<LoginBloc, LoginState>(
      listener: createAccountRequestStateChanged,
      listenWhen: (previous, current) =>
          previous.createAccountRequest.status !=
          current.createAccountRequest.status,
      child: child,
    );
  }

  static void createAccountRequestStateChanged(
    BuildContext context,
    LoginState state,
  ) {
    if (state.createAccountRequest.status.isError) {
      TopSnackBar.showError(
          context, '${state.createAccountRequest.displayMessage}');
    } else if (state.createAccountRequest.status.isSuccess) {
      context.pop();
    }
  }
}
