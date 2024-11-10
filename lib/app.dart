import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login_bloc.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/theme.dart';

class GigBuddyApp extends StatelessWidget {
  const GigBuddyApp({
    required this.settingsController,
    super.key,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return BlocProvider(
          create: (context) => LoginBloc(),
          child: MaterialApp.router(
            backButtonDispatcher: goRouter.backButtonDispatcher,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            title: 'Space',
            color: Colors.blue,
            darkTheme: ThemeData(
              colorScheme: MaterialTheme.darkScheme(),
            ),
            themeMode: ThemeMode.system,
            theme: ThemeData(
              colorScheme: MaterialTheme.lightScheme(),
            ),
          ),
        );
      },
    );
  }
}
