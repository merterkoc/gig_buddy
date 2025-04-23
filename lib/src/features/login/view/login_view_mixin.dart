import 'package:flutter/material.dart';
import 'package:gig_buddy/src/features/login/view/login_view.dart';

mixin LoginViewMixin on State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
}
