import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';

import 'package:gig_buddy/src/common/widgets/avatar_stack_widget/avatar_stack_widget.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    required this.isJoined,
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.location,
    this.city,
    this.startDateTime,
    this.endDate,
    this.type,
    this.distance,
    this.onTap,
    this.onJoinedChanged,
    this.avatars,
    this.venueName,
  });

  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? location;
  final String? city;
  final String? startDateTime;
  final String? endDate;
  final String? type;
  final String? distance;
  final VoidCallback? onTap;
  final bool isJoined;
  final ValueChanged<bool>? onJoinedChanged;
  final List<EventParticipantModel>? avatars;
  final String? venueName;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
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
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEventImage(context),
            buildEventDetailInfo(context),
          ],
        ),
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
                widget.endDate ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AvatarStackWidget(
                  avatars: widget.avatars ?? [],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateUtil.getDate(widget.startDateTime!),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 38),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.venueName ?? ' ',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
