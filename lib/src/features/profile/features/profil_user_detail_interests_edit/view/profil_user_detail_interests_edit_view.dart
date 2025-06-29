import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/profile/features/profil_user_detail_interests_edit/widgets/user_interests.dart';

class ProfileUserDetailInterestsEditView extends StatelessWidget {
  const ProfileUserDetailInterestsEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interests', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                buildUserInterests(),
              ],
            ),
          ),
        ),
      ),
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
