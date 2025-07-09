import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';

class JoinLeaveButton extends StatefulWidget {
  const JoinLeaveButton({
    required this.isJoined,
    required this.onChanged,
    super.key,
  });

  @override
  State<JoinLeaveButton> createState() => _JoinLeaveButtonState();
  final bool isJoined;
  final ValueChanged<bool> onChanged;
}

class _JoinLeaveButtonState extends State<JoinLeaveButton> {
  late bool isJoined;
  late List<EventParticipantModel>? avatars;

  @override
  void initState() {
    isJoined = widget.isJoined;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JoinLeaveButton oldWidget) {
    if (widget.isJoined != oldWidget.isJoined) {
      setState(() {
        isJoined = widget.isJoined;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GigElevatedButton(
      onPressed: () {
        setState(() {
          isJoined = !isJoined;
        });
        widget.onChanged(isJoined);
      },
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Icon(
            isJoined ? CupertinoIcons.minus_circle : CupertinoIcons.plus_circle,
            size: 20,
          ),
          Text(
            isJoined ? context.l10.event_mini_card_leave_button : context.l10.event_mini_card_join_button,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
