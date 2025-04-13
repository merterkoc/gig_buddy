import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/containers/surface_container.dart';
import 'package:gig_buddy/src/service/model/buddy_requests/buddy_requests.dart';

class BuddyRequestCard extends StatefulWidget {
  const BuddyRequestCard({
    required this.buddyRequests,
    this.onAccept,
    super.key,
  });

  final BuddyRequests buddyRequests;
  final VoidCallback? onAccept;

  @override
  State<BuddyRequestCard> createState() => _BuddyRequestCardState();
}

class _BuddyRequestCardState extends State<BuddyRequestCard> {
  late bool isAccept;

  @override
  void initState() {
    isAccept = widget.buddyRequests.isAccepted;
    super.initState();
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
              child: ElevatedButton(
                onPressed: isAccept
                    ? null
                    : () {
                        setState(() {
                          isAccept = true;
                        });
                        widget.onAccept?.call();
                      },
                child: Text(
                  isAccept ? 'Accepted' : 'Accept',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
