import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/avatar_image/avatar_image.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_buddy/src/common/firebase/service/presence_service.dart';
import 'dart:async';

class UserAvatarWidget extends StatefulWidget {
  const UserAvatarWidget(
      {required this.userId, required this.userImage, super.key});

  final String userId;
  final String userImage;

  @override
  State<UserAvatarWidget> createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget> {
  final presenceService = PresenceService();
  late final StreamSubscription<Map<String, String>> _presenceSubscription;
  String _userState = 'offline';

  @override
  void initState() {
    super.initState();
    _presenceSubscription = presenceService.presenceStream.listen((presence) {
      final newState = presence[widget.userId];
      if (newState != null && newState != _userState) {
        setState(() {
          _userState = newState;
        });
      }
    });
    presenceService.listenToUser(widget.userId);
  }

  @override
  void dispose() {
    presenceService.cancelUser(widget.userId);
    _presenceSubscription.cancel();
    super.dispose();
  }

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
              widget.userImage,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _userState == 'online'
                ? Colors.greenAccent.shade400
                : Colors.grey,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: AvatarImage(
          imageUrl: widget.userImage,
          width: 210,
          height: 210,
        ),
      ),
    );
  }
}
