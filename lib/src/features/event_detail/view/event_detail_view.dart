import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/widgets/avatar_stack_widget/avatar_stack_widget.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  late final EventDetail? _eventDetail;

  @override
  void initState() {
    context.read<EventBloc>().add(FetchEventById(widget.eventId));
    _eventDetail = context
        .read<PaginationEventBloc>()
        .state
        .pages!
        .map((e) => e.firstWhere((element) => element.id == widget.eventId))
        .first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              shape: const CircleBorder(),
            ),
            icon: const Icon(
              Icons.share,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            shape: const CircleBorder(),
          ),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEventImage(),
          buildParticipantAvatars(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: buildEventDetail(),
          ),
        ],
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
          child: Image.network(eventDetail.images[0].url, fit: BoxFit.cover),
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
              style: Theme.of(context).textTheme.headlineLarge,
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
