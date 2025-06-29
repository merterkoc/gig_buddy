import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/event_avatars/event_avatars_cubit.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/constants/app_size.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:gig_buddy/src/common/widgets/avatar_stack_widget/avatar_stack_widget.dart';
import 'package:gig_buddy/src/common/widgets/buttons/join_leave_button.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({
    required this.eventDetail,
    super.key,
  });

  final EventDetail eventDetail;

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  late List<EventParticipantModel> avatars;
  late bool isJoined;

  @override
  void initState() {
    // context.read<EventBloc>().add(FetchEventById(widget.eventDetail.id));
    avatars = widget.eventDetail.participantAvatars ?? [];
    isJoined = widget.eventDetail.isJoined;
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
        spacing: AppSpacing.lg,
        children: [
          buildEventImage(),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEventDateAndLocation(),
                  buildEventLinks(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child:
                            BlocBuilder<EventAvatarsCubit, EventAvatarsState>(
                          buildWhen: (previous, current) =>
                              previous.seenImages != current.seenImages,
                          builder: (context, state) {
                            avatars = [
                              ...state.seenImages[widget.eventDetail.id] ?? [],
                              ...(widget.eventDetail.participantAvatars?.where(
                                      (element) =>
                                          element.userId !=
                                          context
                                              .read<LoginBloc>()
                                              .state
                                              .user!
                                              .id) ??
                                  [])
                            ];
                            return buildParticipantAvatars();
                          },
                        ),
                      ),
                    ],
                  ),
                  buildEventDetail(),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventImage() {
    return Expanded(
      child: Hero(
        tag: widget.eventDetail.id,
        child: Image.network(
          widget.eventDetail.images[0].url,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildParticipantAvatars() {
    if (avatars.isEmpty) {
      return const SizedBox(
        height: 42,
        child: Text('No participants'),
      );
    }
    return AvatarStackWidget(
      avatars: avatars,
    );
  }

  Widget buildEventDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.eventDetail.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          widget.eventDetail.location ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(
          widget.eventDetail.distance ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(
          widget.eventDetail.city ?? '',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          widget.eventDetail.country ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        if (widget.eventDetail.venue.name.isNotEmpty)
          GigElevatedButton(
            onPressed: () {
              context.pushNamed(
                AppRoute.venueDetailView.name,
                extra: widget.eventDetail.venue,
              );
            },
            child: Text(
              widget.eventDetail.venue.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }

  Widget buildJoinButton() {
    return BlocBuilder<EventAvatarsCubit, EventAvatarsState>(
      buildWhen: (previous, current) =>
          previous.seenImages != current.seenImages,
      builder: (context, state) {
        isJoined = (state.seenImages[widget.eventDetail.id] ?? []).any(
          (participantAvatars) =>
              participantAvatars.userId ==
              context.read<LoginBloc>().state.user!.id,
        );
        return JoinLeaveButton(
          isJoined: isJoined,
          onChanged: (isJoined) {
            setState(() {
              final userProfile = context.read<LoginBloc>().state.user;

              if (isJoined) {
                avatars = List.of(avatars)
                  ..add(
                    EventParticipantModel(
                      userId: userProfile!.id,
                      userImage: userProfile.userImage,
                    ),
                  );
                context
                    .read<EventBloc>()
                    .add(JoinEvent('homepage', eventId: widget.eventDetail.id));
              } else {
                avatars = List.of(avatars)
                  ..removeWhere((element) => element.userId == userProfile!.id);
                context.read<EventBloc>().add(
                    LeaveEvent('homepage', eventId: widget.eventDetail.id));
              }
            });
          },
        );
      },
    );
  }

  Widget buildEventDateAndLocation() {
    return Row(
      children: [
        Text(
          DateUtil.getDate(widget.eventDetail.start),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        Text(
          widget.eventDetail.city ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Row buildEventLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTicketButton(),
        buildJoinButton(),
      ],
    );
  }

  GigElevatedButton buildTicketButton() {
    return GigElevatedButton(
      onPressed: () {
        final parse = Uri.parse(widget.eventDetail.ticketUrl);
        launchUrl(parse);
      },
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          const Icon(
            CupertinoIcons.tickets,
            size: 20,
          ),
          Text(
            'Tickets',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
