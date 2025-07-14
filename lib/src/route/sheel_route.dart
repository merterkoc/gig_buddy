import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/notification_overlay.dart';
import 'package:gig_buddy/src/route/authentication_listener.dart';
import 'package:gig_buddy/src/route/global_listener/global_listener.dart';
import 'package:gig_buddy/src/service/notification_service.dart';

class ShellView extends StatefulWidget {
  const ShellView({required this.child, super.key});

  final Widget child;

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView>
    with
        AutomaticKeepAliveClientMixin<ShellView>,
        WidgetsBindingObserver,
        GlobalListener {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationOverlay(
      notificationStream: NotificationService().foregroundNotificationStream,
      child: GlobalListener.listen(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: widget.child,
        ),
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
    AuthenticationRouterListener.listen();
  }
}
