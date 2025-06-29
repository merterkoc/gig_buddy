import 'package:flutter/material.dart';

class PlayCard extends StatelessWidget {
  const PlayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 0.9],
          transform: const GradientRotation(0.5),
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
            Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/onboarding/ob_1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text('IF PERFORMANCE HALL',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
