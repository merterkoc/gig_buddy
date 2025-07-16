import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/helper/chat/chat_helper.dart';
import 'package:go_router/go_router.dart';

import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';

class BuddyRequestCard extends StatefulWidget {
  const BuddyRequestCard({
    required this.buddyRequests,
    this.onAccept,
    this.onReject,
    super.key,
  });

  final BuddyRequests buddyRequests;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  State<BuddyRequestCard> createState() => _BuddyRequestCardState();
}

class _BuddyRequestCardState extends State<BuddyRequestCard> {
  late BuddyRequestStatus status;

  @override
  void initState() {
    status = widget.buddyRequests.status;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BuddyRequestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    status = widget.buddyRequests.status;
  }

  @override
  Widget build(BuildContext context) {
    final eventImageUrl = widget.buddyRequests.event.images.isNotEmpty
        ? widget.buddyRequests.event.images.first.url
        : null;
    final senderImage = widget.buddyRequests.sender.userImage;
    final receiverImage = widget.buddyRequests.receiver.userImage;
    final loggedUser = context.read<LoginBloc>().state.user;
    final isCurrentUserSender =
        loggedUser?.email == widget.buddyRequests.sender.email;

    return SurfaceContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(0),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (eventImageUrl != null && eventImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                eventImageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Details
                Text(
                  widget.buddyRequests.event.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (widget.buddyRequests.event.location != null)
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.buddyRequests.event.location!.latitude,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                if (widget.buddyRequests.event.city != null &&
                    widget.buddyRequests.event.city!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.location_city,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.buddyRequests.event.city}, ${widget.buddyRequests.event.country ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // User Details Section
                Row(
                  children: [
                    // Sender Avatar and Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isCurrentUserSender
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: senderImage.isNotEmpty
                                      ? Image.network(
                                          senderImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.person,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                        )
                                      : Icon(Icons.person,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.buddyRequests.sender.username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isCurrentUserSender
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : null,
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

                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),

                    // Receiver Avatar and Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              context.pushNamed(
                                AppRoute.userProfileView.name,
                                pathParameters: {
                                  'userId': widget.buddyRequests.receiver.id,
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.buddyRequests.receiver.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: !isCurrentUserSender
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : null,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: !isCurrentUserSender
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: receiverImage.isNotEmpty
                                        ? Image.network(
                                            receiverImage,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.person,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                          )
                                        : Icon(Icons.person,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                ),
                              ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = widget.buddyRequests.status;

    if (widget.onAccept != null) {
      if (status == BuddyRequestStatus.accepted) {
        return BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.user != current.user ||
              previous.requestState != current.requestState,
          listener: (context, state) {
            if (!state.requestState.isLoading &&
                state.user != null &&
                state.requestState.isSuccess) {
              ChatHelper.startChat(context, state.user!);
            }
          },
          child: GigElevatedButton(
            onPressed: () {
              context
                  .read<ProfileBloc>()
                  .add(FetchUserProfile(widget.buddyRequests.sender.id));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.chat_bubble_2, size: 18),
                const SizedBox(width: 8),
                Text(context.l10.button_message),
              ],
            ),
          ),
        );
      } else if (status == BuddyRequestStatus.rejected) {
        return Row(
          children: [
            Icon(CupertinoIcons.xmark_circle, color: Colors.red),
            SizedBox(width: 8),
            Text(context.l10.status_rejected_sent,
                style: TextStyle(color: Colors.red)),
          ],
        );
      } else if (status == BuddyRequestStatus.pending) {
        return Row(
          children: [
            Expanded(
              child: GigElevatedButton(
                onPressed: widget.onReject,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.xmark, size: 18),
                    const SizedBox(width: 6),
                    Text(context.l10.button_reject),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GigElevatedButton(
                onPressed: widget.onAccept,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.check_mark, size: 18),
                    const SizedBox(width: 6),
                    Text(context.l10.button_accept),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    // Eğer onAccept null ise (sent requests tab'ında), sadece durumu göster
    return _buildStatusIndicator(context, status);
  }

  Widget _buildStatusIndicator(
      BuildContext context, BuddyRequestStatus status) {
    switch (status) {
      case BuddyRequestStatus.accepted:
        return Row(
          children: [
            Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(context.l10.status_accepted,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        );
      case BuddyRequestStatus.rejected:
        return Row(
          children: [
            Icon(CupertinoIcons.xmark_circle, color: Colors.red),
            SizedBox(width: 8),
            Text(context.l10.status_rejected_sent,
                style: TextStyle(color: Colors.red)),
          ],
        );
      case BuddyRequestStatus.pending:
        return Row(
          children: [
            Icon(Icons.schedule,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6)),
            const SizedBox(width: 8),
            Text(context.l10.status_pending,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6))),
          ],
        );
      case BuddyRequestStatus.blocked:
        return Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 8),
            Text(context.l10.status_rejected_sent,
                style: const TextStyle(color: Colors.red)),
          ],
        );
    }
  }
}
