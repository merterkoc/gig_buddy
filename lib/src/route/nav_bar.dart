import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    ? const Icon(CupertinoIcons.house_fill)
                    : const Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 1
                    ? const Icon(CupertinoIcons.person_fill)
                    : const Icon(CupertinoIcons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 2
                    ? const Icon(CupertinoIcons.gear_alt_fill)
                    : const Icon(CupertinoIcons.gear),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: navigationShell.currentIndex == 3
                    ? const Icon(CupertinoIcons.person_3_fill)
                    : const Icon(CupertinoIcons.person_3),
                label: 'Friends',
              ),
            ],
          ),
        ],
      ),
    );
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
