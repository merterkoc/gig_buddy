import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event/event.dart';
import 'package:go_router/go_router.dart';

class EventDetailCard extends StatefulWidget {
  const EventDetailCard({
    required this.isJoined,
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.location,
    this.startDateTime,
    this.endDate,
    this.type,
    this.distance,
    this.onTap,
    this.onJoinedChanged,
    this.avatars,
  });

  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? location;
  final String? startDateTime;
  final String? endDate;
  final String? type;
  final String? distance;
  final VoidCallback? onTap;
  final bool isJoined;
  final ValueChanged<bool>? onJoinedChanged;
  final List<EventParticipantModel>? avatars;

  @override
  State<EventDetailCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventDetailCard> {
  late bool isJoined;

  @override
  void initState() {
    isJoined = widget.isJoined;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEventImage(context),
          buildEventDetailInfo(context),
        ],
      ),
    );
  }

  Padding buildEventDetailInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subtitle ?? '',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                widget.location ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                widget.startDateTime ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                widget.endDate ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AnimatedAvatarStack(
                  height: 40,
                  infoWidgetBuilder: (context, info) {
                    return InkWell(
                      onTap: () {
                        // Örneğin profil sayfasına yönlendir:
                        print('adsfadfsgasdf');
                      },
                      child: info.widget,
                    );
                  },
                  avatars: _buildAvatars(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isJoined = !isJoined;
                  });
                  widget.onJoinedChanged?.call(isJoined);
                },
                child: Text(isJoined ? 'Leave' : 'Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stack buildEventImage(BuildContext context) {
    return Stack(
      children: [
        if (widget.imageUrl != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            height: 240,
            width: double.infinity,
          ),
        if (widget.startDateTime != null)
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.startDateTime!,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.title ?? '',
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  List<NetworkImage> _buildAvatars() {
    final seenUrls = <String>{};

    return widget.avatars?.where((e) {
      final url = e.userImage ?? '';
      if (seenUrls.contains(url)) return false;
      seenUrls.add(url);
      return true;
    }).map((e) => NetworkImage(e.userImage ?? '')).toList() ?? [];
  }
}
