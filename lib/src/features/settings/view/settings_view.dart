import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/modal/action_sheet.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/route/router.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({
    required this.settingsController,
    super.key,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Theme'),
                  CupertinoButton(
                    onPressed: () {
                      CupertinoAction.showModalPopup(
                        context,
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: goRouter.pop,
                          child: const Text('Cancel'),
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController
                                  .updateThemeMode(Brightness.light);
                              goRouter.pop();
                            },
                            child: const Text('Light'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController
                                  .updateThemeMode(Brightness.dark);
                              goRouter.pop();
                            },
                            child: const Text('Dark'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController.setDefaultThemeMode();
                              goRouter.pop();
                            },
                            child: const Text('System'),
                          ),
                        ],
                        title: const Text('Select Theme'),
                      );
                    },
                    child: const Text('Change '),
                  ),
                ],
              ),
              const Spacer(),
              CupertinoButton(
                onPressed: () {
                  context.read<LoginBloc>().add(const Logout());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
