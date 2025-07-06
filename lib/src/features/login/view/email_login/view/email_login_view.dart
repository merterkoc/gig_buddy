import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/login/view/email_login/view/email_login_listener.dart';
import 'package:gig_buddy/src/features/login/view/login_listener.dart';
import 'package:gig_buddy/src/features/login/widgets/login_buttons.dart';
import 'package:gig_buddy/src/features/register/view/register_view.dart';
import 'package:go_router/go_router.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({super.key});

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return EmailLoginListener.listen(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Future<void> showSignupEmailSheet() async {
    context.pop();
    await showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (BuildContext context) {
        return const RegisterView();
      },
    );
  }
}
