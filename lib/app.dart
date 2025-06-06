import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/authentication/auth_bloc.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/repository/buddy_repository.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/repository/identity_repository.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/theme/default/default_theme.dart';
import 'package:gig_buddy/src/theme/green/green_theme.dart';
import 'package:gig_buddy/src/theme/material_theme.dart';
import 'package:gig_buddy/src/theme/orange/orange_theme.dart';
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
        theme = DefaultMaterialTheme(textTheme);
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (context) => AuthBloc(),
            ),
            BlocProvider(
              create: (context) => BuddyBloc(BuddyRepository()),
            ),
            BlocProvider(
              create: (context) => ProfileBloc(IdentityRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  LoginBloc(AuthManager(), IdentityRepository()),
            ),
            BlocProvider(
              create: (context) => EventBloc(EventRepository()),
            ),
            BlocProvider(
              create: (context) => PaginationEventBloc(
                eventRepository: EventRepository(),
              ),
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
