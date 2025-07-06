import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card_profile.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/common/widgets/user/user_avatar_widget.dart';
import 'package:gig_buddy/src/features/user_profile/view/user_profile_listener.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});

  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    context.read<ProfileBloc>().add(FetchUserProfile(widget.userId));
    context.read<EventBloc>().add(GetEventsByUserId(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileListener.listen(
      refreshController: _refreshController,
      child: Scaffold(
        appBar: AppBar(title: buildUserName()),
        body: SmartRefresher(
          physics: const ClampingScrollPhysics(),
          onRefresh: () async {
            context.read<ProfileBloc>().add(FetchUserProfile(widget.userId));
          },
          controller: _refreshController,
          child: SingleChildScrollView(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.requestState != current.requestState,
              builder: (BuildContext context, ProfileState state) {
                if (state.requestState.isSuccess) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Center(
                      child: Column(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildUserImage(),
                          buildUserLocation(),
                          buildUserInterests(),
                          buildUserEvents(),
                        ],
                      ),
                    ),
                  );
                } else if (state.requestState.isLoading && state.user == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (state.requestState.isError) {
                  return const Center(child: Text('Error'));
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
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
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        return UserAvatarWidget(
          userId: state.user!.id,
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
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          return Row(
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
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localizations.profile_view_interests,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 20),
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
                itemCount: state.currentProfileEvents?.length ?? 0,
                itemBuilder: (context, index) {
                  return EventCardProfile(
                    userId: widget.userId,
                    id: state.currentProfileEvents![index].id,
                    title: state.currentProfileEvents![index].name,
                    subtitle: state.currentProfileEvents![index].name,
                    startDateTime: state.currentProfileEvents![index].start,
                    location: state.currentProfileEvents![index].location,
                    imageUrl: state
                            .currentProfileEvents![index].images.isNotEmpty
                        ? state.currentProfileEvents![index].images.first.url
                        : null,
                    distance: state.currentProfileEvents![index].distance,
                    isJoined: state.currentProfileEvents![index].isJoined,
                    isMatched: state.currentProfileEvents![index].isMatched!,
                    buddyRequestStatus:
                        state.currentProfileEvents![index].buddyRequestStatus,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.eventDetailView.name,
                        extra: state.currentProfileEvents![index],
                        pathParameters: {
                          'eventId': state.currentProfileEvents![index].id,
                        },
                      );
                    },
                    onMatchChanged: (isMatched) {
                      context.read<BuddyBloc>().add(
                            CreateBuddyRequest(
                              eventId: state.currentProfileEvents![index].id,
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
