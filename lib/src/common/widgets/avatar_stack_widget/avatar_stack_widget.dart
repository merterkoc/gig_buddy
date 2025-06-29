import 'dart:async';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/firebase/service/presence_service.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

import 'package:go_router/go_router.dart';

class AvatarStackWidget extends StatefulWidget {
  const AvatarStackWidget({required this.avatars, super.key});

  final List<EventParticipantModel> avatars;

  @override
  State<AvatarStackWidget> createState() => _AvatarStackWidgetState();
}

class _AvatarStackWidgetState extends State<AvatarStackWidget> {

  final presenceService = PresenceService();

  late final  StreamSubscription<Map<String, String>> _presenceSubscription;

  Map<String, String> _userStates = {};

  @override
  void initState() {
    _presenceSubscription = presenceService.presenceStream.listen((presence) {
      setState(() {
        _userStates = presence;
      });
    });
    presenceService.listenToUsers(widget.avatars.map((e) => e.userId).toList());
    super.initState();
  }

  @override
  void dispose() {
    presenceService.cancelUsers(widget.avatars.map((e) => e.userId).toList());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(maxCoverage: 0.3, minCoverage: 0.1);
    final newAvatars = {
      for (final e in widget.avatars)
        if (e.userImage != null && e.userImage!.isNotEmpty) e.userId: e
    }.values.toList();
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
              child: Container(
                decoration:  avatar.userId != context.read<LoginBloc>().state.user!.id ? BoxDecoration(
                  border: Border.all(
                    color: _userStates[avatar.userId] == 'online'
                        ? Colors.greenAccent.shade400
                        : Colors.grey,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ) : null,
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
