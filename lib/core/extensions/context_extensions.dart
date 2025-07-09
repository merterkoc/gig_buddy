import 'package:flutter/widgets.dart';
import 'package:gig_buddy/core/localization/gig_buddy_localizations.dart';

extension BuildContextExtensions on BuildContext {
  /// Returns the closest [Localizations] in the widget tree.
  AppLocalizations get l10 => AppLocalizations.of(this)!;
}
