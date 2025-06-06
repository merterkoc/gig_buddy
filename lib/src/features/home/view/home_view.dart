import 'package:flutter/cupertino.dart'
    show CupertinoIcons, CupertinoSearchTextField;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_mini_card.dart';
import 'package:gig_buddy/src/features/home/view/home_view_state_mixin.dart';
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            return EventMiniCard(
              id: item.id,
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
                  extra: item,
                  pathParameters: {
                    'eventId': item.id,
                  },
                );
              },
              venueName: item.venueName,
              avatars: item.participantAvatars,
              onJoinedChanged: (isJoined) {
                if (isJoined) {
                  context.read<EventBloc>().add(JoinEvent(item.id));
                } else {
                  context.read<EventBloc>().add(LeaveEvent(item.id));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildNearCityList(EventState state) {
    return BlocBuilder<PaginationEventBloc, PagingState<int, EventDetail>>(
      builder: (context, pagingState) {
        return Opacity(
          opacity: pagingState.isLoading ? 0.5 : 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.nearCity!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip.elevated(
                  label: pagingState.isLoading &&
                          selectedCity == state.nearCity![index]
                      ? const SizedBox(
                          width: 50,
                          child: CircularProgressIndicator.adaptive())
                      : Text(
                          state.nearCity![index].name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  showCheckmark: false,
                  elevation: 0,
                  pressElevation: 0,
                  disabledColor: Colors.transparent,
                  selected: selectedCity == state.nearCity![index],
                  onSelected: pagingState.isLoading
                      ? null
                      : (isSelected) {
                          onSelectCity(state.nearCity![index]);
                        },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
