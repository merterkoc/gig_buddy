import 'package:flutter/cupertino.dart';
import 'dart:ui';
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
    required this.controller,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final SettingsController settingsController;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(
            child: navigationShell,
          ),
          _buildAppleMusicStyleNavBar(context),
        ],
      ),
    );
  }

  Widget _buildAppleMusicStyleNavBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1250, sigmaY: 1250,tileMode: TileMode.repeated),
        child: Container(
          decoration: BoxDecoration(
            color: settingsController.themeMode == Brightness.dark
                ? const Color(0xFF1C1C1E).withValues(alpha: 0.2)
                : const Color(0xFFFFFFFF).withValues(alpha: 0.2),
            border: Border(
              top: BorderSide(
                color: settingsController.themeMode == Brightness.dark
                    ? const Color(0xFF38383A).withValues(alpha: 0.9)
                    : const Color(0xFFE5E5EA).withValues(alpha: 0.9),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              height: 60, // Reduced height to prevent overflow
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    index: 0,
                    icon: navigationShell.currentIndex == 0
                        ? CupertinoIcons.wand_stars
                        : CupertinoIcons.wand_stars_inverse,
                    label: context.l10.nav_nar_home,
                  ),
                  _buildNavItem(
                    context,
                    index: 1,
                    icon: CupertinoIcons.music_mic,
                    label: context.l10.nav_nar_settings,
                  ),
                  _buildNavItem(
                    context,
                    index: 2,
                    icon: navigationShell.currentIndex == 2
                        ? CupertinoIcons.heart_solid
                        : CupertinoIcons.heart,
                    label: context.l10.nav_nar_friends,
                  ),
                  _buildNavItem(
                    context,
                    index: 3,
                    icon: null, // Custom profile icon
                    label: context.l10.nav_nar_profile,
                    isProfile: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    IconData? icon,
    required String label,
    bool isProfile = false,
  }) {
    final isActive = navigationShell.currentIndex == index;
    final activeColor = settingsController.themeMode == Brightness.dark
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.secondary;
    final inactiveColor = settingsController.themeMode == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Container(
        height: 120, // Reduced height to prevent overflow
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive
              ? (settingsController.themeMode == Brightness.dark
                  ? activeColor.withValues(alpha: 0.2)
                  : activeColor.withValues(alpha: 0.1))
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isProfile)
              buildProfileIcon(context)
            else
              Icon(
                icon,
                size: 28,
                color: isActive ? activeColor : inactiveColor,
              ),
          ],
        ),
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
            return Icon(
              Icons.person,
              size: 28,
              color: navigationShell.currentIndex == 3
                  ? (settingsController.themeMode == Brightness.dark
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.secondary)
                  : (settingsController.themeMode == Brightness.dark
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface),
            );
          }
          return SizedBox(
            width: 28,
            height: 28,
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                context.read<LoginBloc>().state.user!.userImage,
              ),
              backgroundColor: Colors.transparent,
            ),
          );
        },
      );
    }
    return Icon(
      navigationShell.currentIndex == 3
          ? CupertinoIcons.person_fill
          : CupertinoIcons.person,
      size: 24,
      color: navigationShell.currentIndex == 3
          ? (settingsController.themeMode == Brightness.dark
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondary)
          : (settingsController.themeMode == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurface),
    );
  }

  void _onTap(BuildContext context, int index) {
    // if (index == 3 &&
    //     !context.read<AuthenticationBloc>().state.status.isAuthenticated) {
    //   goRouter.pushNamed(AppRoute.loginView.name);
    //   return;
    // }
    if (index == 0 && navigationShell.currentIndex == 0) {
      scrollToTop();
    } else {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  void scrollToTop() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
