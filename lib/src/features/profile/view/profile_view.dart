import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
          _refreshCompleter!.complete();
        }
      },
      child: ProfileListener.listen(
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            centerTitle: true,
            actionsPadding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            surfaceTintColor: Colors.transparent,
            leadingWidth: 90,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: buildUserImage(),
            ),
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
                                const Text(
                                  'You have not joined any events yet.',
                                ),
                                const SizedBox(height: 20),
                                GigElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<EventBloc>()
                                        .add(const GetMyEvents());
                                  },
                                  child: const Text('Try again'),
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
            : 'Not set';

        final gender =
            state.user!.gender != null ? state.user!.gender!.value : 'Not set';

        return Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              subtitle: Wrap(
                children: [
                  Chip(
                    avatar: const Icon(Icons.cake),
                    label: Text(
                      birthdate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Chip(
                    avatar: state.user!.gender == Gender.male
                        ? const Icon(Icons.male)
                        : state.user!.gender == Gender.other
                            ? const Icon(Icons.transgender)
                            : const Icon(Icons.female),
                    label: Text(
                      gender,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              title: Text(context.read<LoginBloc>().state.user!.username),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 0,
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodySmall,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.goNamed(
                  AppRoute.profileUserDetailEditView.name,
                );
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.account_circle),
              title: Text(
                'Gig Buddy ID',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                state.user!.id,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 0,
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodySmall,
              trailing: const Icon(Icons.content_copy_sharp, size: 16),
              onTap: () {
                Clipboard.setData(ClipboardData(text: state.user!.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.email),
              title: Text(
                context.localizations.profile_view_email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                state.user!.email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    previous.emailVerificationRequestState !=
                    current.emailVerificationRequestState,
                builder: (context, state) {
                  if (state.emailVerificationRequestState.isLoading) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (state.emailVerificationRequestState.isSuccess) {
                    return const VerificationButton(
                    );
                  }
                  return FutureBuilder<bool>(
                    future: AuthManager.isEmailVerified(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case true:
                            return Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          case false:
                            return GigElevatedButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(VerifyEmail());
                              },
                              child: const Text('Verify'),
                            );
                          case null:
                            throw UnimplementedError();
                        }
                      }
                      return const CircularProgressIndicator.adaptive();
                    },
                  );
                },
              ),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 0,
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodySmall,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                context.localizations.profile_view_creation_date,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                DateUtil.getDate(state.user!.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 0,
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodySmall,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.person),
              title: Text(
                context.localizations.profile_view_interests,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Wrap(
                spacing: 4,
                children: state.user!.interests!
                    .map(
                      (e) => Chip(
                        padding: EdgeInsets.zero,
                        label: Text(
                          e.name,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    )
                    .toList(),
              ),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 0,
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodySmall,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.goNamed(
                  AppRoute.profileUserInterestsView.name,
                );
              },
            ),
          ],
        );
      },
    );
  }
}class VerificationButton extends StatefulWidget {
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
      child: Text(_isButtonEnabled
          ? 'Verify Now'
          : 'Waiting for resend ${_remainingSeconds}s'),
    );
  }
}