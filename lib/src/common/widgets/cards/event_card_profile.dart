import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';

class EventCardProfile extends StatefulWidget {
  const EventCardProfile({
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

  @override
  State<EventCardProfile> createState() => _EventCardProfileState();
}

class _EventCardProfileState extends State<EventCardProfile> {
  late bool isJoined;

  @override
  void initState() {
    isJoined = widget.isJoined;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceContainer(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      isExpanded: true,
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        spacing: 10,
        children: [
          buildEventImage(context),
          Expanded(
            flex: 2,
            child: buildEventDetailInfo(context),
          ),
        ],
      ),
    );
  }

  Widget buildEventImage(BuildContext context) {
    return Flexible(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl ?? ''),
            fit: BoxFit.cover,
          ),
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
              if (widget.location != null && widget.location!.isNotEmpty)
                Text(
                  widget.location!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
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
}
