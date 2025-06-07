import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';

class BuddyRequestCard extends StatefulWidget {
  const BuddyRequestCard({
    required this.buddyRequests,
    this.onAccept,
    this.onReject,
    this.onBlock,
    super.key,
  });

  final BuddyRequests buddyRequests;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onBlock;

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
    return SurfaceContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        spacing: 30,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.buddyRequests.event.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.buddyRequests.sender.username,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onAccept != null)
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) {
                  if (status == BuddyRequestStatus.accepted) {
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.errorContainer,
                        ), // Change border color here
                      ),
                      onPressed: widget.onAccept,
                      child: Text(
                        'Remove request',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    );
                  } else if (status == BuddyRequestStatus.rejected) {
                    return Text(
                      'Request rejected',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.errorContainer,
                      ),
                    );
                  } else if (status == BuddyRequestStatus.pending) {
                    return Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                            ), // Change border color here
                          ),
                          onPressed: widget.onReject,
                          child: Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ), // Change border color here
                          ),
                          onPressed: () {
                            widget.onBlock?.call();
                            setState(() {
                              status = BuddyRequestStatus.accepted;
                            });
                          },
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
        ],
      ),
    );
  }
}
