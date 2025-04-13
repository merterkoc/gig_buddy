import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/friends/widgets/buddy_request_card.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  void initState() {
    context.read<BuddyBloc>().add(const GetBuddyRequests());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Got Requests'),
              Tab(text: 'Sent Requests'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    // İlk sekme
                    BlocBuilder<BuddyBloc, BuddyState>(
                      builder: (context, state) {
                        final loggedUser = context.read<LoginBloc>().state.user;
                        final myBuddyRequests = state.buddyRequests
                            .where(
                              (buddyRequest) =>
                                  buddyRequest.sender.email !=
                                  loggedUser?.email,
                            )
                            .toList();
                        return ListView.builder(
                          itemCount:myBuddyRequests.length,
                          itemBuilder: (context, index) {
                            final buddyRequest = myBuddyRequests[index];
                            return BuddyRequestCard(
                              buddyRequests: buddyRequest,
                              onAccept: () {
                                context.read<BuddyBloc>().add(
                                      AcceptBuddyRequest(
                                        buddyRequestId: buddyRequest.id,
                                      ),
                                    );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // İkinci sekme (aynı liste)
                    BlocBuilder<BuddyBloc, BuddyState>(
                      builder: (context, state) {
                        final loggedUser = context.read<LoginBloc>().state.user;
                        final myBuddyRequests = state.buddyRequests
                            .where((buddyRequest) =>
                                buddyRequest.sender.email == loggedUser?.email)
                            .toList();
                        return ListView.builder(
                          itemCount: myBuddyRequests.length,
                          itemBuilder: (context, index) {
                            final buddyRequest = myBuddyRequests[index];
                            return BuddyRequestCard(
                              buddyRequests: buddyRequest,

                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
