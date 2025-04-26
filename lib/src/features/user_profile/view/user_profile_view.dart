import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card_profile.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/common/widgets/user/user_avatar_widget.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});

  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(FetchUserProfile(widget.userId));
    context.read<EventBloc>().add(GetEventsByUserId(widget.userId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: buildUserName()),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.requestState != current.requestState,
          builder: (BuildContext context, ProfileState state) {
            if (state.requestState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.requestState.isError) {
              return const Center(child: Text('Error'));
            }
            if (state.requestState.isSuccess) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Center(
                  child: Column(
                    spacing: 20,
                    children: [
                      buildUserImage(),
                      buildUserLocation(),
                      buildUserInterests(),
                      buildUserEvents(),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Unknown'));
          },
        ),
      ),
    );
  }

  Widget buildUserImage() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.user == null) {
          return const SizedBox(
            width: 210,
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return UserAvatarWidget(
          userImage: state.user!.userImage,
        );
      },
    );
  }

  BlocBuilder<ProfileBloc, ProfileState> buildUserName() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.user == null) {
          return const SizedBox.shrink();
        }
        return Text(
          state.user!.username,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  SurfaceContainer buildUserLocation() {
    return SurfaceContainer(
      isExpanded: true,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.user == null) {
            return const SizedBox(
              width: 210,
              height: 210,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Ankara',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SurfaceContainer buildUserInterests() {
    return SurfaceContainer(
      isExpanded: true,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.user == null) {
            return const SizedBox(
              width: 210,
              height: 210,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (state.user!.interests.isEmpty) const Text('No interests'),
              Wrap(
                spacing: 10,
                children: state.user!.interests.map((interest) {
                  return Chip(
                    label: Text(interest.name),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  BlocBuilder<EventBloc, EventState> buildUserEvents() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state.currentProfileEventsRequestState.isLoading) {
          return const SizedBox(
            width: 210,
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.currentProfileEventsRequestState.isError) {
          return Center(
            child: Column(
              children: [
                const Text('Error'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<EventBloc>()
                        .add(GetEventsByUserId(widget.userId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return SurfaceContainer(
          isExpanded: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              const Text(
                'Users going to this event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.currentProfileEvents!.length,
                itemBuilder: (context, index) {
                  return EventCardProfile(
                    title: state.events![index].name,
                    subtitle: state.events![index].name,
                    startDateTime: state.events![index].start,
                    location: state.events![index].location,
                    imageUrl: state.events![index].images.isNotEmpty
                        ? state.events![index].images.first.url
                        : null,
                    distance: state.events![index].distance,
                    isJoined: state.events![index].isJoined,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.eventDetailView.name,
                        pathParameters: {'eventId': state.events![index].id},
                      );
                    },
                    onJoinedChanged: (isJoined) {
                      if (isJoined) {
                        context
                            .read<EventBloc>()
                            .add(JoinEvent(state.events![index].id));
                      }
                      context
                          .read<EventBloc>()
                          .add(LeaveEvent(state.events![index].id));
                    },
                    onMatchChanged: (isMatched) {
                      context.read<BuddyBloc>().add(
                            CreateBuddyRequest(
                              eventId: state.events![index].id,
                              receiverId: widget.userId,
                            ),
                          );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
