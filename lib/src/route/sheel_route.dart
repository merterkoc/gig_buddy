import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/http/dio/interface/i_dio_client.dart';
import 'package:gig_buddy/src/route/router.dart';

class ShellView extends StatefulWidget {
  const ShellView({required this.child, super.key});

  final Widget child;

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView>
    with AutomaticKeepAliveClientMixin<ShellView>, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.authenticationStatus != current.authenticationStatus,
          listener: (context, state) {
            if (state.authenticationStatus.isAuthenticated) {
              goRouter.goNamed(AppRoute.homeView.name);
            } else if (state.authenticationStatus.isUnauthenticated) {
              goRouter.goNamed(AppRoute.loginView.name);
            }
          },
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: widget.child,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    debugPrint('didChangePlatformBrightness');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resume();
      case AppLifecycleState.detached:
        detached;
      case AppLifecycleState.hidden:
        hidden;
      case AppLifecycleState.inactive:
        inactive;
      case AppLifecycleState.paused:
        paused;
    }
  }

  void resume() {
    debugPrint('AppLifecycleState.resumed');
  }

  void detached() {}

  void hidden() {}

  void inactive() {}

  void paused() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
}
