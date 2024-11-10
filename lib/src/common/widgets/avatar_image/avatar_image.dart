import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedAvatarStack(
      height: 210,
      width: 210,
      avatars: [
        NetworkImage(imageUrl),
      ],
    );
  }
}
