import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/bloc/authentication/auth_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/widgets/user/user_avatar_widget.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    required this.settingsController,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(
            child: navigationShell,
          ),
          CupertinoTabBar(
            onTap: (index) => _onTap(context, index),
            currentIndex: navigationShell.currentIndex,
            activeColor: settingsController.themeMode == Brightness.dark
                ? Colors.white
                : Colors.blue,
            items: [
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 0
                    ? const Icon(CupertinoIcons.wand_stars)
                    : const Icon(CupertinoIcons.wand_stars_inverse),
                label: context.localizations.nav_nar_home,
              ),
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 1
                    ? const Icon(CupertinoIcons.music_mic)
                    : const Icon(CupertinoIcons.music_mic),
                label: context.localizations.nav_nar_settings,
              ),
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 2
                    ? const Icon(CupertinoIcons.heart_solid)
                    : const Icon(CupertinoIcons.heart),
                label: context.localizations.nav_nar_friends,
              ),
              BottomNavigationBarItem(
                icon: buildProfileIcon(context),
                label: context.localizations.nav_nar_profile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileIcon(BuildContext context) {
    final authenticationBloc = context.read<AuthBloc>();
    if (authenticationBloc.state is AuthAuthenticated) {
      return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.user != current.user,
        builder: (context, state) {
          if (state.user == null || state.user!.userImage.isEmpty) {
            return const Icon(Icons.person);
          }
          return SizedBox(
            width: 28,
            height: 28,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                context.read<LoginBloc>().state.user!.userImage,
              ),
              backgroundColor: Colors.transparent,
            ),
          );
        },
      );
    }
    return navigationShell.currentIndex == 3
        ? const Icon(CupertinoIcons.person_fill)
        : const Icon(CupertinoIcons.person);
  }

  void _onTap(BuildContext context, int index) {
    // if (index == 3 &&
    //     !context.read<AuthenticationBloc>().state.status.isAuthenticated) {
    //   goRouter.pushNamed(AppRoute.loginView.name);
    //   return;
    // }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
