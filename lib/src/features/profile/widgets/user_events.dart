import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:go_router/go_router.dart';

class UserEvents extends StatelessWidget {
  const UserEvents({
    required this.events,
    super.key,
  });

  final List<EventDetail> events;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return EventCard(
          title: events[index].name,
          subtitle: events[index].name,
          startDateTime: events[index].start,
          location: events[index].location,
          distance: events[index].distance,
          isJoined: events[index].isJoined,
          onTap: () {
            context.pushNamed(
              AppRoute.eventDetailView.name,
              pathParameters: {'eventId': events[index].id},
            );
          },
          avatars: events[index].participantAvatars,
          onJoinedChanged: (isJoined) {
            if (isJoined) {
              context.read<EventBloc>().add(JoinEvent(events[index].id));
            }
            context.read<EventBloc>().add(LeaveEvent(events[index].id));
          },
          venueName: events[index].venueName,
        );
      },
    );
  }
}
