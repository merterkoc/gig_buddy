import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/helper/chat/chat_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/avatar_image/avatar_image.dart';
import 'package:gig_buddy/src/common/widgets/cards/event_card_profile.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';
import 'package:gig_buddy/src/service/model/public_user/public_user_dto.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:gig_buddy/src/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});

  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    context.read<ProfileBloc>().add(FetchUserProfile(widget.userId));
    context.read<EventBloc>().add(GetEventsByUserId(widget.userId));
    super.initState();
  }

  Future<void> refreshCallback() async {
    _refreshCompleter = Completer<void>();
    context.read<ProfileBloc>().add(FetchUserProfile(widget.userId));
    context.read<EventBloc>().add(GetEventsByUserId(widget.userId));
    return _refreshCompleter!.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.requestState != current.requestState,
      listener: (context, state) {
        if (!state.requestState.isLoading &&
            _refreshCompleter?.isCompleted == false) {
          _refreshCompleter?.complete();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: buildUserName(),
          forceMaterialTransparency: true,
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.user == null) return const SizedBox.shrink();

                return IconButton(
                  icon: const Icon(Icons.message_outlined),
                  onPressed: () => ChatHelper.startChat(context, state.user!),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.requestState != current.requestState,
          builder: (BuildContext context, ProfileState state) {
            if (state.requestState.isLoading && state.user == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state.requestState.isError) {
              return const Center(child: Text('Error'));
            }

            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: refreshCallback,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      buildUserDetails(state),
                      const SizedBox(height: 20),
                      buildUserEvents(),
                    ],
                  ),
                ),
              ],
            );
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
            width: 120,
            height: 120,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state.user!.userImage.isEmpty) {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_2_rounded,
              size: 60,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
          );
        }

        return CircleAvatar(
          backgroundImage: NetworkImage(state.user!.userImage),
          radius: 60,
          backgroundColor: Colors.transparent,
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
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        );
      },
    );
  }

  Widget buildUserDetails(ProfileState state) {
    if (state.user == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final birthdate = state.user!.birthdate != null
        ? DateUtil.getBirthDate(state.user!.birthdate!)
        : context.l10.no_set;

    final gender = state.user!.gender != null
        ? state.user!.gender!.value
        : context.l10.no_set;

    return Column(
      children: [
        // User Avatar and Basic Info Section
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildUserImage(),
              const SizedBox(height: 16),
              buildUserName(),
              const SizedBox(height: 8),
              // Birthdate and Gender Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (state.user!.birthdate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cake,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            birthdate,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  if (state.user!.gender != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.user!.gender == Gender.male
                                ? Icons.male
                                : state.user!.gender == Gender.other
                                    ? Icons.transgender
                                    : Icons.female,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            gender,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // User Details Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Gig Buddy ID Section
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  context.l10.profile_view_gig_buddy_id,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                subtitle: Text(
                  state.user!.id,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'monospace',
                      ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.content_copy_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: state.user!.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10.copy_to_clipboard),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    );
                  },
                ),
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),

              // Creation Date Section
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
                title: Text(
                  context.l10.profile_view_creation_date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                subtitle: Text(
                  DateUtil.getDate(state.user!.createdAt, context),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Interests Section
        if (state.user!.interests.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.favorite_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                context.l10.profile_view_interests,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: state.user!.interests
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            e.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      ],
    );
  }

  Widget buildUserEvents() {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) =>
          previous.currentProfileEvents != current.currentProfileEvents ||
          previous.requestState != current.requestState,
      builder: (context, state) {
        if (state.requestState.isError) {
          return Center(
            child: Column(
              children: [
                Text(
                  context.l10.you_have_not_joined_any_events_yet,
                ),
                const SizedBox(height: 20),
                GigElevatedButton(
                  onPressed: () {
                    context
                        .read<EventBloc>()
                        .add(GetEventsByUserId(widget.userId));
                  },
                  child: Text(context.l10.try_again),
                ),
              ],
            ),
          );
        }
        if (state.currentProfileEvents == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state.currentProfileEvents!.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  size: 48,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10.you_have_not_joined_any_events_yet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Etkinlikler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.currentProfileEvents!.length,
              itemBuilder: (context, index) {
                final event = state.currentProfileEvents![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: EventCardProfile(
                    userId: widget.userId,
                    id: event.id,
                    title: event.name,
                    subtitle: event.name,
                    startDateTime: event.start,
                    location: event.location,
                    imageUrl:
                        event.images.isNotEmpty ? event.images.first.url : null,
                    distance: event.distance,
                    isJoined: event.isJoined,
                    isMatched: event.isMatched!,
                    buddyRequestStatus: event.buddyRequestStatus,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.eventDetailView.name,
                        extra: event,
                        pathParameters: {'eventId': event.id},
                      );
                    },
                    onMatchChanged: (isMatched) {
                      context.read<BuddyBloc>().add(
                            CreateBuddyRequest(
                              eventId: event.id,
                              receiverId: widget.userId,
                            ),
                          );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
