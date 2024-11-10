import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/authentication/auth_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';

mixin GlobalListener {
  static BlocListener<AuthBloc, AuthState> listen({required Widget child}) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
        } else if (state is AuthAuthenticated) {
        } else if (state is AuthUnauthenticated) {
          context.read<EventBloc>().add(const InitState());
        } else {}
      },
      child: child,
    );
  }
}
