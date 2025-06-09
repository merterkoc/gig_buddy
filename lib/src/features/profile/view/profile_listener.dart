import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/util/snackbar/custom_snackbar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

mixin ProfileListener {
  static MultiBlocListener listen({
    required Widget child,
    required RefreshController refreshController,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EventBloc, EventState>(
          listenWhen: (previous, current) =>
              previous.requestState != current.requestState,
          listener: (context, state) {
            profileRequestStateChanged(context, state, refreshController);
          },
          child: child,
        ),
      ],
      child: child,
    );
  }

  static void profileRequestStateChanged(
    BuildContext context,
    EventState state,
    RefreshController refreshController,
  ) {
    if (state.requestState.isError) {
      TopSnackBar.showError(
        context,
        'Failed to fetch profile. Please try again.',
      );
      refreshController
        ..refreshCompleted()
        ..loadComplete();
    } else if (state.requestState.isSuccess) {
      refreshController
        ..refreshCompleted()
        ..loadComplete();
    }
  }
}
