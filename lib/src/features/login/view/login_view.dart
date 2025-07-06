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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withValues(
                              alpha: 0.9,
                            ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 20,
                        children: [
                          const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
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
                            text: 'Login with Email',
                            onPressed: showLoginWithEmailSheet,
                          ),
                        ],
                      ),
                    ),
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
