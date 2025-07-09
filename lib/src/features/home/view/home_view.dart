import 'dart:async';

import 'package:flutter/cupertino.dart'
    show
        CupertinoIcons,
        CupertinoSearchTextField,
        CupertinoSliverRefreshControl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/other/try_again.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event/pagination_event_bloc.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_mini_card.dart';
import 'package:gig_buddy/src/features/home/view/home_view_state_mixin.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  final TextEditingController _controller = TextEditingController();
  late final RefreshCallback refreshCallback;
  late Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    refreshCallback = refreshHomePageEvent;
    fetchData();
    context.read<LoginBloc>().add(const FetchUserInfo());

    super.initState();
  }

  void fetchData() {
    context.read<EventBloc>().add(const EventLoad(page: 0));
    context.read<EventBloc>().add(
          EventLoadNearCity(
            lat: LocationManager.position!.latitude,
            lng: LocationManager.position!.longitude,
            radius: 1000,
            limit: 10,
          ),
        );
    context.read<EventBloc>().add(
          Suggests(
            lat: LocationManager.position!.latitude,
            lng: LocationManager.position!.longitude,
          ),
        );
  }

  Future<void> refreshHomePageEvent() {
    _refreshCompleter = Completer<void>();
    fetchData();
    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listenWhen: (previous, current) => previous.events != current.events,
      listener: (context, state) {
        if (!state.requestState.isLoading) {
          _refreshCompleter.complete();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: false,
          title: Text(
            context.l10.app_title,
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
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: SafeArea(
                bottom: false,
                child: CustomScrollView(
                  controller: widget.scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: refreshCallback,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CupertinoSearchTextField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            controller: _controller,
                            onSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            placeholder: context.l10.search_placeholder,
                            onChanged: onChangeKeyword,
                          ),
                          if (state.nearCity?.isNotEmpty ?? false)
                            SizedBox(
                              height: 50,
                              child: buildNearCityList(state),
                            ),
                          Text(
                            context.l10.home_view_title_1,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          buildVenueSuggests(state, context),
                          Text(
                            context.l10.home_view_title_2,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    BlocBuilder<HomePagePaginationBloc,
                        Map<String, PagingState<int, EventDetail>>>(
                      builder: (context, pageState) {
                        return PagedSliverList<int, EventDetail>(
                          builderDelegate:
                              PagedChildBuilderDelegate<EventDetail>(
                            animateTransitions: true,
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            firstPageProgressIndicatorBuilder: (context) =>
                                const Center(
                                    child:
                                        CircularProgressIndicator.adaptive()),
                            newPageProgressIndicatorBuilder: (context) =>
                                const Center(
                                    child:
                                        CircularProgressIndicator.adaptive()),
                            itemBuilder: (context, item, index) {
                              return BlocBuilder<EventAvatarsCubit,
                                  EventAvatarsState>(
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
                                    imageUrl: item.images.isNotEmpty
                                        ? item.images.first.url
                                        : null,
                                    distance: item.distance,
                                    isJoined: (eventAvatarsState
                                                .seenImages[item.id] ??
                                            [])
                                        .any(
                                      (participantAvatars) =>
                                          participantAvatars.userId ==
                                          context
                                              .read<LoginBloc>()
                                              .state
                                              .user!
                                              .id,
                                    ),
                                    onTap: () {
                                      context.goNamed(
                                        AppRoute.eventDetailView.name,
                                        extra: item,
                                        pathParameters: {'eventId': item.id},
                                      );
                                    },
                                    venueName: item.venue!.name,
                                    avatars: [
                                      ...eventAvatarsState
                                              .seenImages[item.id] ??
                                          [],
                                      ...(item.participantAvatars ?? []),
                                    ],
                                    onJoinedChanged: (isJoined) {
                                      if (isJoined) {
                                        context.read<EventBloc>().add(
                                              JoinEvent(
                                                'homepage',
                                                eventId: item.id,
                                              ),
                                            );
                                      } else {
                                        context.read<EventBloc>().add(
                                              LeaveEvent(
                                                'homepage',
                                                eventId: item.id,
                                              ),
                                            );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          state: pageState['homepage'] ??
                              PagingState<int, EventDetail>(),
                          fetchNextPage: () {
                            context.read<HomePagePaginationBloc>().add(
                                  FetchNextPaginationEvent<
                                      HomePagePaginationBloc>(
                                    'homepage',
                                    selectedCity: selectedCity,
                                    keyword: currentKeyword,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildNearCityList(EventState state) {
    return BlocBuilder<HomePagePaginationBloc,
        Map<String, PagingState<int, EventDetail>>>(
      builder: (context, pageState) {
        final pagingState =
            pageState['homepage'] ?? PagingState<int, EventDetail>();
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
                          child: CircularProgressIndicator.adaptive(),
                        )
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

  Widget buildVenueSuggests(EventState state, BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) => previous.suggest != current.suggest,
      builder: (context, state) {
        final items = state.suggest.data?.embedded.venues ?? [];
        if ((state.suggest.status.isLoading || state.suggest.status.isError) &&
            items.isEmpty) {
          return TryAgain(
            isLoading: state.suggest.status.isLoading,
            onPressed: () {
              context.read<EventBloc>().add(
                    Suggests(
                      lat: LocationManager.position!.latitude,
                      lng: LocationManager.position!.longitude,
                    ),
                  );
            },
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.separated(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              item.city.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${item.distance?.toStringAsFixed(1)} km',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${context.l10.venue_suggests_upcoming_events}: ${item.upcomingEvents?.total}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            GigElevatedButton(
                              onPressed: () {
                                context.goNamed(
                                  AppRoute.venueDetailView.name,
                                  extra: item,
                                );
                              },
                              child: Text(
                                context.l10.venue_suggests_detail_button,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
