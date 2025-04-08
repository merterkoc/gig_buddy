import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/avatar_image/avatar_image.dart';
import 'package:gig_buddy/src/features/profile/widgets/user_interests.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<LoginBloc>()
      ..add(const FetchUserInfo())
      ..add(const FetchAllInterests());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            buildUserImage(),
            buildUserName(),
            buildUserInterests(),
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
        return AvatarImage(
          imageUrl: state.user!.userImage,
          width: 210,
          height: 210,
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
