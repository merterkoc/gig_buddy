import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/login/view/login_listener.dart';
import 'package:gig_buddy/src/features/login/view/login_view_mixin.dart';
import 'package:gig_buddy/src/features/login/widgets/login_buttons.dart';

final class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return LoginListener.listen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding/ob_1.jpg',
            fit: BoxFit.cover,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            colorBlendMode: BlendMode.color,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                  Colors.black87,
                ],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 20,
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Email'),
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                      ),
                      const Text('Password'),
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        controller: passwordController,
                        obscureText: true,
                        onChanged: (value) {},
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.submitEmail != current.submitEmail,
                        builder: (context, state) {
                          return LoginButtons.email(
                            isActive: true,
                            inProgress: state.submitEmail.status.isLoading,
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
                      const Text(
                        'or',
                        style: TextStyle(fontSize: 18),
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return LoginButtons.google(
                            inProgress: state
                                .signInWithGoogleRequest.status.isLoading,
                            isActive: true,
                            onPressed: () {
                              context
                                  .read<LoginBloc>()
                                  .add(const SignInWithGoogle());
                            },
                          );
                        },
                      ),
                      LoginButtons.email(
                        isActive: true,
                        logo: const Icon(Icons.person_add),
                        text: 'Sign up with Email',
                        onPressed: showSignupEmailSheet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
