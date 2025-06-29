import 'package:flutter/material.dart';

class GigActionButton extends StatelessWidget {
  const GigActionButton({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
