import 'package:flutter/cupertino.dart';
import 'package:gig_buddy/src/features/event_detail/view/event_detail_view.dart';
import 'package:gig_buddy/src/features/friends/view/firends_view.dart';
import 'package:gig_buddy/src/features/home/view/home_view.dart';
import 'package:gig_buddy/src/features/login/view/email_otp/email_otp.dart';
import 'package:gig_buddy/src/features/login/view/login_view.dart';
import 'package:gig_buddy/src/features/onboarding/view/onboarding_view.dart';
import 'package:gig_buddy/src/features/profile/view/profile_view.dart';
import 'package:gig_buddy/src/features/search/view/search_view.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_service.dart';
import 'package:gig_buddy/src/features/settings/view/settings_view.dart';
import 'package:gig_buddy/src/features/user_profile/view/user_profile_view.dart';
import 'package:gig_buddy/src/http/dio/interface/i_dio_client.dart';
import 'package:gig_buddy/src/route/authentication_listener.dart';
import 'package:gig_buddy/src/route/nav_bar.dart';
import 'package:gig_buddy/src/route/sheel_route.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>();
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final SettingsController settingsController =
    SettingsController(SettingsService());

enum AppRoute {
  onBoardingView(path: '/onBoardingView'),
  homeView(path: '/homeView'),
  loginView(path: '/loginView'),
  emailOtpView(path: 'emailOtpView'),
  profileView(path: '/profileView'),
  userProfileView(path: '/userProfileView/:userId'),
  settingsView(path: '/settingsView'),
  friendsView(path: '/friendsView'),
  searchView(path: 'searchView'),
  eventDetailView(path: '/eventDetailsView/:eventId');

  const AppRoute({required this.path});

  final String path;

  String get location =>
      path.isNotEmpty && !path.startsWith('/') ? '/$path' : path;
}

final GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoute.homeView.path,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return ShellView(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoute.onBoardingView.path,
          name: AppRoute.onBoardingView.name,
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingView(),
        ),
        GoRoute(
          path: AppRoute.loginView.path,
          name: AppRoute.loginView.name,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginView(),
          routes: [
            GoRoute(
              path: AppRoute.emailOtpView.path,
              name: AppRoute.emailOtpView.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const EmailOtpView(),
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          builder: (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return ScaffoldWithNavBar(
              navigationShell: navigationShell,
              settingsController: settingsController,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.homeView.path,
                  name: AppRoute.homeView.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CupertinoPage<void>(
                    key: state.pageKey,
                    child: const HomeView(),
                  ),
                  redirect: (BuildContext context, GoRouterState state) {
                    if (!AuthenticationRouterListener
                        .currentAuthenticationStatus.isAuthenticated) {
                      return AppRoute.loginView.path;
                    }
                    return null;
                  },
                  routes: [
                    TransitionFadeGoRoute(
                      path: AppRoute.searchView.path,
                      name: AppRoute.searchView.name,
                      builder: (BuildContext context, GoRouterState state) {
                        final keywords = state.extra! as String;
                        return SearchView(keywords: keywords);
                      },
                    ),
                    GoRoute(
                      path: AppRoute.userProfileView.path,
                      name: AppRoute.userProfileView.name,
                      builder: (BuildContext context, GoRouterState state) {
                        return UserProfileView(
                          userId: state.pathParameters['userId']!,
                        );
                      },
                    ),
                    GoRoute(
                      path: AppRoute.eventDetailView.path,
                      name: AppRoute.eventDetailView.name,
                      builder: (BuildContext context, GoRouterState state) {
                        return EventDetailView(
                          eventId: state.pathParameters['eventId']!,
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.profileView.path,
                  name: AppRoute.profileView.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CupertinoPage<void>(
                    key: state.pageKey,
                    maintainState: false,
                    child: const ProfileView(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.settingsView.path,
                  name: AppRoute.settingsView.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CupertinoPage<void>(
                    key: state.pageKey,
                    child: SettingsView(
                      settingsController: settingsController,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.friendsView.path,
                  name: AppRoute.friendsView.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CupertinoPage<void>(
                    key: state.pageKey,
                    child: const FriendsView(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

GoRoute transitionGoRoute({
  required String path,
  required String name,
  required Widget Function(BuildContext, GoRouterState) pageBuilder,
  String? Function(dynamic state, dynamic redirect)? redirect,
  List<RouteBase>? routes,
  Duration transitionDuration = Duration.zero,
}) {
  return GoRoute(
    path: path,
    name: name,
    redirect: redirect,
    routes: routes ?? [],
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: transitionDuration,
      child: pageBuilder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    ),
  );
}

class TransitionFadeGoRoute extends GoRoute {
  TransitionFadeGoRoute({
    required super.path,
    required super.name,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoRoute>? routes,
  }) : super(
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: builder(context, state),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
          routes: routes ?? [],
        );
}
