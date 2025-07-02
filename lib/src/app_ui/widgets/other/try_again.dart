import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({
    required this.onPressed,
    this.text,
    this.isLoading = false,
    super.key,
  });

  final String? text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(text ?? context.localizations.something_went_wrong),
        ),
        const SizedBox(height: 20),
        GigElevatedButton(
          onPressed: onPressed,
          isLoading: isLoading,
          child: Text(context.localizations.try_again),
        ),
      ],
    );
  }
}
