import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/logo/logo.dart';
import 'package:gig_buddy/src/features/login/view/login_listener.dart';
import 'package:gig_buddy/src/features/login/view/login_view_mixin.dart';
import 'package:gig_buddy/src/features/login/widgets/login_buttons.dart';
import 'package:gig_buddy/src/route/router.dart';

final class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return LoginListener.listen(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Form(
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Email'),
                    TextFormField(
                      autofillHints: const [AutofillHints.email],
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    const Text('Password'),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.submitEmail != current.submitEmail,
                      builder: (context, state) {
                        return LoginButtons.email(
                          isActive: true,
                          inProgress: state.submitEmail.isLoading,
                          onPressed: () {
                            context.read<LoginBloc>().add(
                                  SubmitEmail(
                                    password: passwordController.text,
                                    email: emailController.text,
                                  ),
                                );
                          },
                        );
                      },
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
                    const Align(
                      child: Text(
                        'or',
                      ),
                    ),
                    LoginButtons.email(
                      isActive: true,
                      logo: const Icon(Icons.person_add),
                      inProgress: false,
                      text: 'Sign up with Email',
                      onPressed: () {
                        goRouter.pushNamed(
                          AppRoute.registerView.name,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
