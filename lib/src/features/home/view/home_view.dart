import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card.dart';
import 'package:gig_buddy/src/service/model/event/event.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    context.read<EventBloc>().add(const EventLoad(page: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                      onChanged: (value) {
                        context.read<EventBloc>().add(
                              EventSearch(value),
                            );
                      },
                    ),
                    BlocBuilder<EventBloc, EventState>(
                      builder: (context, state) {
                        if (state.searchEvents?.isNotEmpty ?? false) {
                          return buildSearch(state);
                        }
                        return buildExplore(state);
                      },
                    ),
                  ],
                ),
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
          imageUrl: state.events![index].images.isNotEmpty
              ? state.events![index].images.first
              : null,
          distance: state.events![index].distance,
          isJoined: state.events![index].isJoined ?? false,
          onTap: () {
            //context.push(EventDetailRoute(event: state.searchEvents![index]));
          },
          avatars: state.events![index].participantAvatars,
          onJoinedChanged: (isJoined) {
            if (isJoined) {
              context.read<EventBloc>().add(JoinEvent(state.events![index].id));
            }
            context.read<EventBloc>().add(LeaveEvent(state.events![index].id));
          },
        );
      },
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
          imageUrl: state.searchEvents![index].images.isNotEmpty
              ? state.searchEvents![index].images.first
              : null,
          distance: state.searchEvents![index].distance,
          isJoined: state.searchEvents![index].isJoined ?? false,
          onTap: () {
            //context.push(EventDetailRoute(event: state.searchEvents![index]));
          },
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
}
