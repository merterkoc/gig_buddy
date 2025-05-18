import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/user/user_avatar_widget.dart';
import 'package:gig_buddy/src/features/profile/widgets/user_events.dart';
import 'package:gig_buddy/src/features/profile/widgets/user_interests.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<LoginBloc>().add(const FetchAllInterests());
    context.read<EventBloc>().add(const GetMyEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<LoginBloc>().add(const Logout());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: [
            buildUserImage(),
            buildUserName(),
            buildUserInterests(),
            BlocBuilder<EventBloc, EventState>(
              buildWhen: (previous, current) =>
                  previous.myEvents != current.myEvents ||
                  previous.requestState != current.requestState,
              builder: (context, state) {
                if (state.requestState.isError) {
                  return Center(
                    child: Column(
                      children: [
                        const Text('You have not joined any events yet.'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<EventBloc>().add(const GetMyEvents());
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  );
                }
                if (state.myEvents == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return UserEvents(events: state.myEvents!);
              },
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildUserImage() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.user == null) {
          return const SizedBox(
            width: 210,
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return UserAvatarWidget(
          userImage: state.user!.userImage,
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
          return const Center(child: CircularProgressIndicator());
        }
        return Text(
          state.user!.username,
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> buildUserInterests() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.user != current.user ||
          previous.interests != current.interests,
      builder: (context, state) {
        if (state.interests.isEmpty) {
          return const CircularProgressIndicator();
        }
        return UserInterests(
          interests: state.interests,
          userInterests: state.user?.interests ?? [],
        );
      },
    );
  }
}
