import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';

class EventCardProfile extends StatefulWidget {
  const EventCardProfile({
    required this.isJoined,
    required this.id,
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
    this.onMatchChanged,
  });

  final String id;
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
  final ValueChanged<bool>? onMatchChanged;

  @override
  State<EventCardProfile> createState() => _EventCardProfileState();
}

class _EventCardProfileState extends State<EventCardProfile> {
  late bool isJoined;
  late bool isMatched;

  @override
  void initState() {
    isJoined = widget.isJoined;
    isMatched = widget.isJoined;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: SurfaceContainer(
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
              Text(
                DateUtil.getDate(widget.startDateTime!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<BuddyBloc, BuddyState>(
                  builder: (context, state) {
                    return GigElevatedButton(
                      onPressed:
                          state.currentCreateBuddyRequestEventId == widget.id
                              ? null
                              : () {
                                  setState(() {
                                    isMatched = !isMatched;
                                  });
                                  widget.onMatchChanged?.call(isMatched);
                                },
                      child: state.currentCreateBuddyRequestEventId != ''
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Text(
                              isMatched ? 'Leave' : 'Match',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
