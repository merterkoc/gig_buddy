import 'package:flutter/material.dart';

class GigElevatedButton extends StatelessWidget {
  const GigElevatedButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.child,
    this.isExpanded = false,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.onSurface;

    final  button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: borderColor),

      ),
      child: isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(borderColor),
              ),
            )
          : child,
    );

    return isExpanded ? SizedBox.expand(child: button) : button;
  }
}
