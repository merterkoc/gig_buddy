import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

import 'package:go_router/go_router.dart';

class AvatarStackWidget extends StatelessWidget {
  const AvatarStackWidget({required this.avatars, super.key});

  final List<EventParticipantModel> avatars;

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(maxCoverage: 0.3, minCoverage: 0.1);
    final newAvatars = avatars.where((e) => e.userImage != null&& e.userImage!.isNotEmpty).toList();
    return SizedBox(
      height: 42,
      child: WidgetStack(
        positions: settings,
        stackedWidgets: [
          for (final avatar in newAvatars)
            InkWell(
              onTap: () {
                context.pushNamed(
                  AppRoute.userProfileView.name,
                  pathParameters: {
                    'userId': avatar.userId,
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Image.network(
                  avatar.userImage ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
        buildInfoWidget: (int surplus, BuildContext context) {
          return Center(
            child: Text(
              '+$surplus',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        },
      ),
    );
  }
}
