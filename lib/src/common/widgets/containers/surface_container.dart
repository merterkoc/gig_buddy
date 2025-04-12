import 'package:flutter/material.dart';

class SurfaceContainer extends StatelessWidget {
  const SurfaceContainer({
    super.key,
    this.child,
    this.isExpanded = false,
    this.alignment,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.all(8),
    this.color,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final bool isExpanded;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (child is SizedBox) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: margin,
      alignment: alignment,
      padding: padding,
      width: isExpanded == true ? double.infinity : null,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}
