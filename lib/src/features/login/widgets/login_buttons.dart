import 'package:flutter/material.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons.apple({
    super.key,
    this.isActive = false,
    this.text = 'Sign in with Apple',
    this.logo = const Icon(Icons.apple_outlined),
    this.onPressed,
    this.inProgress = false,
  });

  const LoginButtons.email({
    super.key,
    this.isActive = false,
    this.text = 'Sign in with Email',
    this.logo = const Icon(Icons.email),
    this.onPressed,
    this.inProgress = false,
  });

  const LoginButtons.facebook({
    super.key,
    this.isActive = false,
    this.text = 'Sign in with Facebook',
    this.logo = const Icon(Icons.facebook_outlined),
    this.onPressed,
    this.inProgress = false,
  });

  const LoginButtons.google({
    super.key,
    this.isActive = false,
    this.text = 'Sign in with Google',
    this.logo = const Icon(Icons.g_mobiledata),
    this.onPressed,
    this.inProgress = false,
  });

  final Icon logo;
  final String text;
  final bool isActive;
  final VoidCallback? onPressed;
  final bool inProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: logo,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.black,
          foregroundColor: Colors.white,
          overlayColor: Colors.white.withValues(alpha: 0.5),
          animationDuration: Duration.zero,
          shadowColor: Colors.black,
          backgroundColor: Colors.black,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: !isActive || inProgress ? null : onPressed,
        label: inProgress
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(),
              )
            : Text(text),
      ),
    );
  }
}
