import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage(
      {required this.imageUrl, super.key, this.width, this.height});

  final double? width;
  final double? height;

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedAvatarStack(
      height: width,
      width: height,
      avatars: [
        NetworkImage(imageUrl),
      ],
    );
  }
}
