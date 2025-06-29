import 'package:flutter/material.dart';

class GigTextButton extends StatelessWidget {
  const GigTextButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.child,
    this.isExpanded = false,
    this.padding,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.onSurface;

    final button = TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
