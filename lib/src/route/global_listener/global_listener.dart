import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/authentication/auth_bloc.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';

mixin GlobalListener {
  static BlocListener<AuthBloc, AuthState> listen({required Widget child}) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
        } else if (state is AuthAuthenticated) {
        } else if (state is AuthUnauthenticated) {
          context.read<EventBloc>().add(const EventInitState());
          context.read<LoginBloc>().add(const LoginInitState());
          context.read<BuddyBloc>().add(const BuddyInitState());
        } else {}
      },
      child: child,
    );
  }
}
