import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/theme/material_theme.dart';
import 'package:gig_buddy/src/theme/pink/pink_theme.dart';
import 'package:gig_buddy/src/theme/util.dart';

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
        final textTheme = createTextTheme(context, 'Exo', 'Exo 2');
        MaterialTheme theme;
        theme = PinkMaterialTheme(textTheme);
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginBloc(),
            ),
            BlocProvider(
              create: (context) => EventBloc(
                EventRepository(),
              )..add(const EventLoad(page: 0)),
              lazy: false,
            ),
          ],
          child: MaterialApp.router(
            backButtonDispatcher: goRouter.backButtonDispatcher,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            title: 'Space',
            color: Colors.blue,
            theme: settingsController.themeMode == Brightness.light
                ? theme.light()
                : theme.dark(),
          ),
        );
      },
    );
  }
}
