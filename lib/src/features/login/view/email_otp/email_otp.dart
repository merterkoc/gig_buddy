import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';

class EmailOtpView extends StatelessWidget {
  const EmailOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email OTP', style: TextStyle(fontSize: 18)),
        actions: [
          BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                previous.submitEmail != current.submitEmail ||
                previous.verifyEmailOtpRequestState !=
                    current.verifyEmailOtpRequestState,
            builder: (context, state) {
              return TextButton(
                onPressed: state.submitEmail.status.isLoading
                    ? null
                    : () => context.read<LoginBloc>(),
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (state.verifyEmailOtpRequestState.isLoading)
                      const CircularProgressIndicator.adaptive()
                    else
                      const Text('Verify OTP'),
                  ],
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter OTP',
              ),
              SizedBox(height: 20),
              Center(
                child: TextField(),
              ),
              SizedBox(height: 20),
              Text(
                'Please check your email for OTP. If you did not receive OTP, please check your spam folder.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
