import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_mini_card.dart';
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
    return BlocBuilder<EventAvatarsCubit, EventAvatarsState>(
      buildWhen: (previous, current) =>
          previous.seenImages != current.seenImages,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return EventMiniCard(
              id: events[index].id,
              title: events[index].name,
              subtitle: events[index].name,
              startDateTime: events[index].start,
              location: events[index].location,
              distance: events[index].distance,
              imageUrl: events[index].images.isNotEmpty
                  ? events[index].images.first.url
                  : null,
              isJoined: (state.seenImages[events[index].id] ?? []).any(
                (participantAvatars) =>
                    participantAvatars.userId ==
                    context.read<LoginBloc>().state.user!.id,
              ),
              onTap: () {
                context.pushNamed(
                  AppRoute.eventDetailView.name,
                  extra: events[index],
                  pathParameters: {'eventId': events[index].id},
                );
              },
              avatars:[
                ...state.seenImages[events[index].id] ?? [],
                ...(events[index].participantAvatars?.where((element) =>
                        element.userId !=
                        context.read<LoginBloc>().state.user!.id) ??
                    [])
              ],
              onJoinedChanged: (isJoined) {
                if (isJoined) {
                  context
                      .read<EventBloc>()
                      .add(JoinEvent('homepage', eventId: events[index].id));
                }
                context
                    .read<EventBloc>()
                    .add(LeaveEvent('homepage', eventId: events[index].id));
              },
              venueName: events[index].venue.name,
            );
          },
        );
      },
    );
  }
}
