import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/constants/app_size.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_mini_card.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:gig_buddy/src/service/model/suggest/suggest_dto.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VenueDetailView extends StatefulWidget {
  const VenueDetailView({
    required this.venue,
    super.key,
  });

  final Venue venue;

  @override
  State<VenueDetailView> createState() => _VenueDetailViewState();
}

class _VenueDetailViewState extends State<VenueDetailView> {
  Venue? _venue;

  @override
  void initState() {
    _venue = widget.venue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(
            spacing: AppSpacing.md,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.venue.name,
                      style: Theme.of(context).textTheme.displaySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (widget.venue.distance != null)
                    Text(
                      '${widget.venue.distance?.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    '${widget.venue.city.name} • ${widget.venue.country.name}',
                  ),
                ],
              ),
              Expanded(
                child: buildPaginationSearch(
                  context.read<EventBloc>().state,
                  context,
                  widget.venue.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildPaginationSearch(
  EventState state,
  BuildContext context,
  String venueId,
) {
  return BlocBuilder<VenueDetailPaginationBloc,
      Map<String, PagingState<int, EventDetail>>>(
    builder: (context, state) => PagedListView<int, EventDetail>(
      state: state[venueId] ?? PagingState<int, EventDetail>(),
      fetchNextPage: () => context.read<VenueDetailPaginationBloc>().add(
            FetchNextPaginationEvent<VenueDetailPaginationBloc>(
              venueId,
              venueId: venueId,
              bloc: context.read<VenueDetailPaginationBloc>(),
            ),
          ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return BlocBuilder<EventAvatarsCubit, EventAvatarsState>(
            buildWhen: (previous, current) =>
                previous.seenImages != current.seenImages,
            builder: (context, eventAvatarsState) {
              return EventMiniCard(
                id: item.id,
                title: item.name,
                subtitle: item.name,
                startDateTime: item.start,
                location: item.location,
                city: item.city,
                imageUrl: item.images.isNotEmpty ? item.images.first.url : null,
                distance: item.distance,
                isJoined: (eventAvatarsState.seenImages[item.id] ?? []).any(
                  (participantAvatars) =>
                      participantAvatars.userId ==
                      context.read<LoginBloc>().state.user!.id,
                ),
                onTap: () {
                  context.pushNamed(
                    AppRoute.eventDetailView.name,
                    extra: item,
                    pathParameters: {
                      'eventId': item.id,
                    },
                  );
                },
                venueName: item.venue!.name,
                avatars: [
                  ...eventAvatarsState.seenImages[item.id] ?? [],
                  ...(item.participantAvatars?.where((element) =>
                          element.userId !=
                          context.read<LoginBloc>().state.user!.id) ??
                      [])
                ],
                onJoinedChanged: (isJoined) {
                  if (isJoined) {
                    context
                        .read<EventBloc>()
                        .add(JoinEvent(venueId, eventId: item.id));
                  } else {
                    context
                        .read<EventBloc>()
                        .add(LeaveEvent(venueId, eventId: item.id));
                  }
                },
              );
            },
          );
        },
      ),
    ),
  );
}
