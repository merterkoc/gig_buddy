import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/friends/widgets/buddy_request_card.dart';
import 'package:logger/logger.dart';

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
                      BlocBuilder<BuddyBloc, BuddyState>(
                        buildWhen: (previous, current) =>
                            previous.buddyRequests != current.buddyRequests,
                        builder: (context, state) {
                          state.buddyRequests.data
                              ?.map((buddyRequest) =>
                                  Logger().i(buddyRequest.status.name))
                              .toList();
                          if (state.buddyRequests.status.isError) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Failed to get buddy requests',
                                ),
                                const SizedBox(height: 10),
                                GigElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<BuddyBloc>()
                                        .add(const GetBuddyRequests());
                                  },
                                  child: const Text('Try again'),
                                ),
                              ],
                            );
                          } else if (!state.buddyRequests.status.isSuccess) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final loggedUser =
                              context.read<LoginBloc>().state.user;
                          final myBuddyRequests = state.buddyRequests.data!
                              .where(
                                (buddyRequest) =>
                                    buddyRequest.sender.email !=
                                    loggedUser?.email,
                              )
                              .toList();
                          return ListView.builder(
                            itemCount: myBuddyRequests.length,
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
                                onReject: () {
                                  context.read<BuddyBloc>().add(
                                        RejectBuddyRequest(
                                          buddyRequestId: buddyRequest.id,
                                        ),
                                      );
                                },
                                onBlock: () {
                                  context.read<BuddyBloc>().add(
                                        BlockBuddyRequest(
                                          buddyRequestId: buddyRequest.id,
                                        ),
                                      );
                                },
                              );
                            },
                          );
                        },
                      ),
                      BlocBuilder<BuddyBloc, BuddyState>(
                        buildWhen: (previous, current) =>
                            previous.buddyRequests.status !=
                            current.buddyRequests.status,
                        builder: (context, state) {
                          if (state.buddyRequests.status.isError) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Failed to get buddy requests',
                                ),
                                const SizedBox(height: 10),
                                GigElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<BuddyBloc>()
                                        .add(const GetBuddyRequests());
                                  },
                                  child: const Text('Try again'),
                                ),
                              ],
                            );
                          } else if (!state.buddyRequests.status.isSuccess) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final loggedUser =
                              context.read<LoginBloc>().state.user;
                          final myBuddyRequests = state.buddyRequests.data!
                              .where(
                                (buddyRequest) =>
                                    buddyRequest.sender.email ==
                                    loggedUser?.email,
                              )
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
      ),
    );
  }
}
