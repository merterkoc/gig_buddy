import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_controller.dart';
import 'package:gig_buddy/src/features/settings/helpers/settings_service.dart';
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
          child: CupertinoFormSection(
            backgroundColor: Theme.of(context).colorScheme.background,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            header: Text(context.l10.settings_view_title,
                style: Theme.of(context).textTheme.headlineSmall),
            margin: const EdgeInsets.only(top: 10),
            children: <Widget>[
              CupertinoFormRow(
                prefix: PrefixWidget(
                  icon: settingsController.themeMode == Brightness.light
                      ? CupertinoIcons.sun_max
                      : CupertinoIcons.moon_stars_fill,
                  title: context.l10.settings_view_theme,
                  color: settingsController.themeMode == Brightness.light
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onPrimary,
                ),
                child: CupertinoButton(
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => goRouter.pop(),
                          child: Text(context.l10.cancel),
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController
                                  .updateThemeMode(Brightness.light);
                              goRouter.pop();
                            },
                            child: Text(context.l10.settings_view_theme_light),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController
                                  .updateThemeMode(Brightness.dark);
                              goRouter.pop();
                            },
                            child: Text(context.l10.settings_view_theme_dark),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              settingsController.setDefaultThemeMode();
                              goRouter.pop();
                            },
                            child: Text(context.l10.settings_view_theme_system),
                          ),
                        ],
                        title: Text(context.l10.settings_view_theme_select),
                      ),
                    );
                  },
                  child: const Text('Change '),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrefixWidget extends StatelessWidget {
  const PrefixWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.color});

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4.0)),
          child: Icon(icon, color: CupertinoColors.white),
        ),
        const SizedBox(width: 15),
        Text(title),
      ],
    );
  }
}
