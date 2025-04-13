import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/common/widgets/avatar_stack_widget/avatar_stack_widget.dart';
import 'package:gig_buddy/src/service/model/event/event.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  late final EventModel? _eventDetail;

  @override
  void initState() {
    context.read<EventBloc>().add(FetchEventById(widget.eventId));
    _eventDetail = context.read<EventBloc>().state.allEvents.firstWhere(
          (element) => element.id == widget.eventId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_eventDetail!.name)),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(

          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEventImage(),
            buildParticipantAvatars(),
            buildEventDetail(),
          ],
        ),
      ),
    );
  }

  Widget buildEventImage() {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) =>
          previous.selectedEventDetail != current.selectedEventDetail ||
          previous.requestState != current.requestState,
      builder: (context, state) {
        if (state.selectedEventDetail == null) {
          return const SizedBox();
        } else if (state.requestState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final eventDetail = state.selectedEventDetail!;
        return Expanded(
          child: CarouselView(
            itemExtent: 380,
            itemSnapping: true,
            children: [
              for (var i = 0; i < eventDetail.images.length; i++)
                Image.network(eventDetail.images[i].url, fit: BoxFit.cover),
            ],
          ),
        );
      },
    );
  }

  Widget buildParticipantAvatars() {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) =>
          previous.selectedEventDetail != current.selectedEventDetail ||
          previous.requestState != current.requestState,
      builder: (context, state) {
        if (state.selectedEventDetail == null) {
          return const SizedBox();
        }
        final eventDetail = state.selectedEventDetail!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            if (eventDetail.participantAvatars != null)
              AvatarStackWidget(
                avatars: eventDetail.participantAvatars!,
              ),
          ],
        );
      },
    );
  }

  Widget buildEventDetail() {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) =>
          previous.selectedEventDetail != current.selectedEventDetail ||
          previous.requestState != current.requestState,
      builder: (context, state) {
        if (state.selectedEventDetail == null) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.selectedEventDetail!.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              state.selectedEventDetail!.location ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              state.selectedEventDetail!.distance ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              state.selectedEventDetail!.city ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              state.selectedEventDetail!.country ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (state.selectedEventDetail!.venueName != null)
              Text(
                state.selectedEventDetail!.venueName!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        );
      },
    );
  }
}
