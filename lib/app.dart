import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/localization/gig_buddy_localizations.dart';
import 'package:gig_buddy/src/bloc/authentication/auth_bloc.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event/pagination_event_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/repository/buddy_repository.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/repository/identity_repository.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/notification_service.dart';
import 'package:gig_buddy/src/common/widgets/notification_overlay.dart';
import 'package:gig_buddy/src/theme/blue/blue_theme.dart';
import 'package:gig_buddy/src/theme/material_theme.dart';
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
        theme = BlueMaterialTheme(textTheme);
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
              create: (context) => PaginationEventBloc(
                eventRepository: EventRepository(),
                loginBloc: context.read<LoginBloc>(),
              ),
            ),
            BlocProvider(
              create: (context) => HomePagePaginationBloc(
                eventRepository: EventRepository(),
                loginBloc: context.read<LoginBloc>(),
              ),
            ),
            BlocProvider(
              create: (context) => VenueDetailPaginationBloc(
                eventRepository: EventRepository(),
                loginBloc: context.read<LoginBloc>(),
              ),
            ),
            BlocProvider(create: (context) => EventAvatarsCubit()),
            BlocProvider(
              create: (context) => EventBloc(
                EventRepository(),
                context.read<HomePagePaginationBloc>(),
                context.read<VenueDetailPaginationBloc>(),
                context.read<EventAvatarsCubit>(),
                context.read<LoginBloc>(),
              ),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            backButtonDispatcher: goRouter.backButtonDispatcher,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              final languageCode = supportedLocales.firstWhere(
                (l) => l.languageCode == locale?.languageCode,
                orElse: () => supportedLocales.first,
              );
              return languageCode;
            },
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.app_title,
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
