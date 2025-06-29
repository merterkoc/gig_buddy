import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';
import 'package:go_router/go_router.dart';

class EventCardProfile extends StatefulWidget {
  const EventCardProfile({
    required this.userId,
    required this.isJoined,
    required this.isMatched,
    required this.id,
    super.key,
    this.buddyRequestStatus,
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

  final String userId;
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
  final bool isMatched;
  final BuddyRequestStatus? buddyRequestStatus;
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
    isMatched = widget.isMatched;
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
                child: BlocListener<BuddyBloc, BuddyState>(
                  listenWhen: (previous, current) =>
                      previous.createBuddyRequest.status !=
                      current.createBuddyRequest.status,
                  listener: (context, state) {
                    if (state.createBuddyRequest.status.isSuccess) {
                      context
                          .read<EventBloc>()
                          .add(GetEventsByUserId(widget.userId));
                    }
                  },
                  child: BlocBuilder<EventBloc, EventState>(
                    buildWhen: (previous, current) =>
                        previous.currentProfileEventsRequestState !=
                        current.currentProfileEventsRequestState,
                    builder: (context, eventState) {
                      return BlocBuilder<BuddyBloc, BuddyState>(
                        builder: (context, buddyState) {
                          return GigElevatedButton(
                            isLoading: eventState
                                    .currentProfileEventsRequestState
                                    .isLoading ||
                                buddyState.currentCreateBuddyRequestEventId ==
                                    widget.id,
                            onPressed:
                                buddyState.currentCreateBuddyRequestEventId ==
                                            widget.id ||
                                        widget.buddyRequestStatus ==
                                            BuddyRequestStatus.accepted ||
                                        widget.buddyRequestStatus ==
                                            BuddyRequestStatus.rejected ||
                                        widget.buddyRequestStatus ==
                                            BuddyRequestStatus.pending
                                    ? null
                                    : matchButtonPressed,
                            child: buddyState
                                        .currentCreateBuddyRequestEventId !=
                                    ''
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : buildBuddyShipButton(context),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void matchButtonPressed() {
    showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You will not be able to join this event.'),
          actions: [
            GigElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            GigElevatedButton(
              onPressed: () {
                setState(() {
                  isMatched = !isMatched;
                });
                widget.onMatchChanged?.call(isMatched);
                context.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Text buildBuddyShipButton(BuildContext context) {
    if (widget.buddyRequestStatus == null) {
      return Text(
        'Match',
        style: Theme.of(context).textTheme.bodySmall,
      );
    } else if (widget.buddyRequestStatus == BuddyRequestStatus.accepted) {
      return Text(
        'Accepted',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    } else if (widget.buddyRequestStatus == BuddyRequestStatus.rejected) {
      return Text(
        'Rejected',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    return Text(
      widget.buddyRequestStatus?.name ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
