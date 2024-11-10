import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/avatar_image/avatar_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<LoginBloc>().add(const FetchUserInfo());
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
          children: [
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.user == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AvatarImage(imageUrl: state.user!.userImage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
