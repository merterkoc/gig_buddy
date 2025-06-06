import 'package:flutter/cupertino.dart'
    show CupertinoIcons, CupertinoSearchTextField;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_mini_card.dart';
import 'package:gig_buddy/src/features/home/view/home_view_state_mixin.dart';
import 'package:gig_buddy/src/features/home/widgets/shimmer_home.dart';
import 'package:gig_buddy/src/repository/event_repository.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    context.read<EventBloc>().add(const EventLoad(page: 0));
    context.read<EventBloc>().add(
          EventLoadNearCity(
            lat: LocationManager.position!.latitude,
            lng: LocationManager.position!.longitude,
            radius: 1000,
            limit: 10,
          ),
        );
    context.read<LoginBloc>().add(const FetchUserInfo());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () {
                context.goNamed(AppRoute.profileView.name);
              },
              child: IconButton(
                icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                onPressed: () {
                  context.goNamed(AppRoute.chatView.name);
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        buildWhen: (previous, current) => previous.events != current.events,
        builder: (context, state) {
          if (state.requestState.isLoading || state.events == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: SafeArea(
              bottom: false,
              child: Column(
                spacing: 1,
                children: [
                  CupertinoSearchTextField(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    controller: _controller,
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: onChangeKeyword,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state.nearCity?.isNotEmpty ?? false)
                    SizedBox(
                      height: 50,
                      child: buildNearCityList(state),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(child: buildPaginationSearch(state, context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ListView buildExplore(EventState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.events!.length,
      itemBuilder: (context, index) {
        return EventCard(
          title: state.events![index].name,
          subtitle: state.events![index].name,
          startDateTime: state.events![index].start,
          location: state.events![index].location,
          city: state.events![index].city,
          imageUrl: state.events![index].images.isNotEmpty
              ? state.events![index].images.first.url
              : null,
          distance: state.events![index].distance,
          isJoined: state.events![index].isJoined,
          onTap: () {
            context.goNamed(
              AppRoute.eventDetailView.name,
              pathParameters: {'eventId': state.events![index].id},
            );
          },
          avatars: state.events![index].participantAvatars,
          onJoinedChanged: (isJoined) {
            if (isJoined) {
              context.read<EventBloc>().add(JoinEvent(state.events![index].id));
            }
            context.read<EventBloc>().add(LeaveEvent(state.events![index].id));
          },
          venueName: state.events?[index].venueName ?? '',
        );
      },
    );
  }

  Widget buildPaginationSearch(EventState state, BuildContext context) {
    return BlocBuilder<PaginationEventBloc, PagingState<int, EventDetail>>(
      builder: (context, state) => PagedListView<int, EventDetail>(
        state: state,
        fetchNextPage: () => context.read<PaginationEventBloc>().add(
              FetchNextPaginationEvent(
                keyword: currentKeyword,
                selectedCity: selectedCity,
              ),
            ),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => EventMiniCard(
            title: item.name,
            subtitle: item.name,
            startDateTime: item.start,
            location: item.location,
            city: item.city,
            imageUrl: item.images.isNotEmpty ? item.images.first.url : null,
            distance: item.distance,
            isJoined: item.isJoined,
            onTap: () {
              context.goNamed(
                AppRoute.eventDetailView.name,
                pathParameters: {'eventId': item.id},
              );
            },
            venueName: item.venueName,
            avatars: item.participantAvatars,
            onJoinedChanged: (isJoined) {
              if (isJoined) {
                context.read<EventBloc>().add(JoinEvent(item.id));
              }
              context.read<EventBloc>().add(LeaveEvent(item.id));
            },
          ),
        ),
      ),
    );
  }

  Widget buildSearch(EventState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.searchEvents!.length,
      itemBuilder: (context, index) {
        return EventCard(
          title: state.searchEvents![index].name,
          subtitle: state.searchEvents![index].name,
          startDateTime: state.searchEvents![index].start,
          location: state.searchEvents![index].location,
          city: state.searchEvents![index].city,
          imageUrl: state.searchEvents![index].images.isNotEmpty
              ? state.searchEvents![index].images.first.url
              : null,
          distance: state.searchEvents![index].distance,
          isJoined: state.searchEvents![index].isJoined,
          onTap: () {
            context.goNamed(
              AppRoute.eventDetailView.name,
              pathParameters: {'eventId': state.searchEvents![index].id},
            );
          },
          venueName: state.searchEvents![index].venueName,
          avatars: state.searchEvents![index].participantAvatars,
          onJoinedChanged: (isJoined) {
            if (isJoined) {
              context
                  .read<EventBloc>()
                  .add(JoinEvent(state.searchEvents![index].id));
            }
            context
                .read<EventBloc>()
                .add(LeaveEvent(state.searchEvents![index].id));
          },
        );
      },
    );
  }

  Widget buildNearCityList(EventState state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.nearCity!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ChoiceChip.elevated(
            label: Text(
              state.nearCity![index].name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            showCheckmark: false,
            elevation: 0,
            pressElevation: 0,
            selected: selectedCity == state.nearCity![index],
            onSelected: (isSelected) {
              onSelectCity(state.nearCity![index]);
            },
          ),
        );
      },
    );
  }

  Widget buildSuggestions(
    BuildContext context,
    SearchController controller,
    EventState state,
  ) {
    return ListView.builder(
      itemCount: state.nearCity!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state.nearCity![index].name),
          onTap: () {
            controller
              ..clear()
              ..text = state.nearCity![index].name;
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }
}
