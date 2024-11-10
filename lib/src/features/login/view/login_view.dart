import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gig_buddy/src/bloc/login_bloc.dart';
import 'package:gig_buddy/src/bloc/model/request_state.dart';
import 'package:gig_buddy/src/common/widgets/logo/logo.dart';
import 'package:gig_buddy/src/features/login/widgets/login_buttons.dart';
import 'package:gig_buddy/src/route/router.dart';

final class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Logo(),
              const SizedBox(height: 20),
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<LoginBloc>().add(ChangeEmail(email: value));
                },
                // style: const TextStyle(color: Colors.black),
                // decoration: const InputDecoration(
                //   enabledBorder: UnderlineInputBorder(),
                //   focusedBorder: UnderlineInputBorder(),
                //   hintText: 'E-mail',
                // ),
                // cursorColor: Colors.black,
              ),
              const SizedBox(height: 10),
              BlocListener<LoginBloc, LoginState>(
                listenWhen: (previous, current) =>
                    previous.emailOtpRequestState !=
                    current.emailOtpRequestState,
                listener: (context, state) {
                  if (state.emailOtpRequestState.isSuccess) {
                    goRouter.goNamed(
                      AppRoute.emailOtpView.name,
                    );
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.emailOtpRequestState !=
                          current.emailOtpRequestState ||
                      previous.email != current.email,
                  builder: (context, state) {
                    return LoginButtons.email(
                      isActive: true,
                      inProgress: state.emailOtpRequestState.isLoading,
                      onPressed: () {
                        if (state.email == null || state.email!.isEmpty) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          context.read<LoginBloc>().add(SubmitEmail());
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                child: Text(
                  'or',
                ),
              ),
              const SizedBox(height: 20),
              const LoginButtons.facebook(),
              const LoginButtons.google(),
              const LoginButtons.apple(
                isActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
