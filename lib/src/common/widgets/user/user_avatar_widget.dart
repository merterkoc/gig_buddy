import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/avatar_image/avatar_image.dart';
import 'package:go_router/go_router.dart';

class UserAvatarWidget extends StatelessWidget {

  const UserAvatarWidget({required this.userImage, super.key});
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog<void>(
          context: context,
          builder: (_) => GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Image.network(
              userImage,
            ),
          ),
        );
      },
      child: AvatarImage(
        imageUrl: userImage,
        width: 210,
        height: 210,
      ),
    );
  }
}
