import 'package:flutter/cupertino.dart';
import 'package:gig_buddy/src/features/login/view/email_login/view/email_login_view.dart';
import 'package:gig_buddy/src/features/login/view/login_view.dart';
import 'package:gig_buddy/src/features/register/view/register_view.dart';

mixin LoginViewMixin on State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  Future<void> showLoginWithEmailSheet() async {
    await showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (BuildContext context) {
        return const EmailLoginView();
      },
    );
  }
}
