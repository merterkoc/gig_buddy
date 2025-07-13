import 'dart:async';

import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/firebase/manager/auth_manager.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:gig_buddy/src/common/widgets/cached_avatar_image.dart';
import 'package:gig_buddy/src/features/profile/view/profile_listener.dart';
import 'package:gig_buddy/src/features/profile/widgets/user_events.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final RefreshCallback refreshCallback;
  late Completer<void>? _refreshCompleter;

  @override
  void initState() {
    context.read<LoginBloc>().add(const FetchAllInterests());
    refreshEvent();
    refreshCallback = refreshEvent;
    super.initState();
  }

  Future<void> refreshEvent() {
    _refreshCompleter = Completer<void>();
    context.read<EventBloc>().add(const GetMyEvents());
    context.read<LoginBloc>().add(const FetchUserInfo());
    return _refreshCompleter!.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listenWhen: (previous, current) =>
          previous.myEvents != current.myEvents ||
          previous.requestState != current.requestState,
      listener: (context, state) {
        if (!state.requestState.isLoading) {
          _refreshCompleter?.complete();
        }
      },
      child: ProfileListener.listen(
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            centerTitle: true,
            leadingWidth: 56,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.pencil),
              onPressed: () {
                context.goNamed(AppRoute.profileUserDetailEditView.name);
              },
            ),
            actionsPadding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            surfaceTintColor: Colors.transparent,
            title: Text(context.read<LoginBloc>().state.user!.username),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<LoginBloc>().add(const Logout());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: refreshCallback,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    buildUserDetails(),
                    BlocBuilder<EventBloc, EventState>(
                      buildWhen: (previous, current) =>
                          previous.myEvents != current.myEvents ||
                          previous.requestState != current.requestState,
                      builder: (context, state) {
                        if (state.requestState.isError) {
                          return Center(
                            child: Column(
                              children: [
                                Text(
                                  context
                                      .l10.you_have_not_joined_any_events_yet,
                                ),
                                const SizedBox(height: 20),
                                GigElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<EventBloc>()
                                        .add(const GetMyEvents());
                                  },
                                  child: Text(context.l10.try_again),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state.myEvents == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return UserEvents(events: state.myEvents!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildUserImage() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.user == null || state.user!.userImage.isEmpty) {
          return const SizedBox(
            width: 210,
            height: 210,
            child: Center(
              child: Icon(Icons.person_2_rounded),
            ),
          );
        }
        return CircleAvatar(
          backgroundImage: NetworkImage(state.user!.userImage),
          radius: 48,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildCachedUserImage() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.user?.userImage != current.user?.userImage,
      builder: (context, state) {
        if (state.user == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state.user == null || state.user!.userImage.isEmpty) {
          return Center(
            child: Column(
              spacing: 8,
              children: [
                GigElevatedButton(
                  onPressed: () {
                    goRouter.pushNamed(AppRoute.profileUserDetailEditView.name);
                  },
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    context.l10.profile_view_fetch_image,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        return CachedAvatarImage(
          imageUrl: state.user!.userImage,
          radius: 50,
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildUserName() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.user?.username != current.user?.username,
      builder: (context, state) {
        if (state.user == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Text(
          state.user!.username,
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildUserDetails() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.user != current.user ||
          previous.user!.birthdate != current.user!.birthdate,
      builder: (context, state) {
        if (state.user == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final birthdate = state.user!.birthdate != null
            ? DateUtil.getBirthDate(state.user!.birthdate!)
            : context.l10.no_set;

        final gender = state.user!.gender != null
            ? state.user!.gender!.value
            : context.l10.no_set;

        return Column(
          children: [
            // User Avatar and Basic Info Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildCachedUserImage(),
                  const SizedBox(height: 16),
                  buildUserName(),
                  const SizedBox(height: 8),
                  // Birthdate and Gender Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (state.user!.birthdate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cake,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                birthdate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      if (state.user!.gender != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.user!.gender == Gender.male
                                    ? Icons.male
                                    : state.user!.gender == Gender.other
                                        ? Icons.transgender
                                        : Icons.female,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                gender,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // User Details Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Email Section
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      context.l10.profile_view_email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    subtitle: Text(
                      state.user!.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    trailing: BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.emailVerificationRequestState !=
                          current.emailVerificationRequestState,
                      builder: (context, state) {
                        if (state.emailVerificationRequestState.isLoading) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          );
                        } else if (state
                            .emailVerificationRequestState.isSuccess) {
                          return const VerificationButton();
                        }
                        return FutureBuilder<bool>(
                          future: AuthManager.isEmailVerified(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data) {
                                case true:
                                  return Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  );
                                case false:
                                  return GigElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(VerifyEmail());
                                    },
                                    child: Text(
                                      context.l10.profile_view_verify_email,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                case null:
                                  throw UnimplementedError();
                              }
                            }
                            return const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),

                  // Gig Buddy ID Section
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.badge_outlined,
                        size: 20,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      context.l10.profile_view_gig_buddy_id,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    subtitle: Text(
                      state.user!.id,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.content_copy_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: state.user!.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10.copy_to_clipboard),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        );
                      },
                    ),
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),

                  // Creation Date Section
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    title: Text(
                      context.l10.profile_view_creation_date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    subtitle: Text(
                      DateUtil.getDate(state.user!.createdAt, context),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  context.l10.profile_view_interests,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: state.user!.interests!
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              e.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
                onTap: () {
                  context.goNamed(AppRoute.profileUserInterestsView.name);
                },
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }
}

class VerificationButton extends StatefulWidget {
  const VerificationButton({super.key});

  @override
  State<VerificationButton> createState() => _VerificationButtonState();
}

class _VerificationButtonState extends State<VerificationButton> {
  int _remainingSeconds = 30;
  Timer? _timer;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _isButtonEnabled = false;
    _remainingSeconds = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onButtonPressed() {
    context.read<LoginBloc>().add(VerifyEmail());
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return GigElevatedButton(
      onPressed: _isButtonEnabled ? _onButtonPressed : null,
      child: Text(
        _isButtonEnabled
            ? context.l10.profile_view_verify_now
            : context.l10.profile_view_verify_email_waiting(_remainingSeconds),
      ),
    );
  }
}
