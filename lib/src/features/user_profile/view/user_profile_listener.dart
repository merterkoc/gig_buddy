import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

mixin UserProfileListener {
  static MultiBlocListener listen(
      {required Widget child, required RefreshController refreshController}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.requestState != current.requestState,
          listener: (context, state) {
            if (state.requestState.isError) {
              refreshController.refreshFailed();
            }
            else if (state.requestState.isSuccess) {
              refreshController.refreshCompleted();
            }
          },
          child: child,
        ),
      ],
      child: child,
    );
  }
}
