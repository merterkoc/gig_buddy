import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/service/model/interest/interest_dto.dart';

class UserInterests extends StatefulWidget {
  const UserInterests({
    required this.interests,
    required this.userInterests,
    super.key,
  });

  final List<InterestDto> interests;
  final List<InterestDto> userInterests;

  @override
  State<UserInterests> createState() => _UserInterestsState();
}

class _UserInterestsState extends State<UserInterests> {
  @override
  void initState() {
    super.initState();
  }

  void _changeInterest(InterestDto interest, String operation) {
    context.read<LoginBloc>().add(
          PatchUserInterests(
            operation,
            interestDto: interest,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: widget.interests
          .map(
            (e) => ActionChip(
              backgroundColor: widget.userInterests.contains(e)
                  ? Theme.of(context).colorScheme.surfaceContainerHigh
                  : null,
              label: Text(e.name),
              onPressed: () {
                final isRemove = widget.userInterests.contains(e);
                _changeInterest(e, isRemove ? 'remove' : 'add');
              },
            ),
          )
          .toList(),
    );
  }
}
