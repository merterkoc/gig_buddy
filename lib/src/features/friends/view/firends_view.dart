import 'dart:async';

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/bloc/buddy/buddy_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/features/friends/widgets/buddy_request_card.dart';
import 'package:gig_buddy/src/service/model/enum/buddy_request_status.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  int _selectedIndex = 0;
  BuddyRequestStatus? _gotRequestsFilter;
  BuddyRequestStatus? _sentRequestsFilter;
  late final Future<void> Function() refreshCallback;
  late Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    refreshCallback = refreshBuddyRequests;
    fetchData();
    super.initState();
  }

  void fetchData() {
    context.read<BuddyBloc>().add(const GetBuddyRequests());
  }

  Future<void> refreshBuddyRequests() {
    _refreshCompleter = Completer<void>();
    fetchData();
    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuddyBloc, BuddyState>(
      listenWhen: (previous, current) =>
          previous.buddyRequests.status != current.buddyRequests.status,
      listener: (context, state) {
        if (!state.buddyRequests.status.isLoading) {
          _refreshCompleter.complete();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Text(
            context.l10.gig_buddy_title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              cupertino.CupertinoSliverRefreshControl(
                onRefresh: refreshCallback,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: cupertino.CupertinoSlidingSegmentedControl<int>(
                        groupValue: _selectedIndex,
                        onValueChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              _selectedIndex = value;
                            });
                          }
                        },
                        children: {
                          0: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              context.l10.got_requests,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          1: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              context.l10.sent_requests,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        },
                      ),
                    ),
                    // Filter Chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildFilterChips(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              if (_selectedIndex == 0)
                _buildGotRequestsSliver()
              else
                _buildSentRequestsSliver(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final currentFilter =
        _selectedIndex == 0 ? _gotRequestsFilter : _sentRequestsFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: context.l10.filter_all,
            isSelected: currentFilter == null,
            onTap: () {
              setState(() {
                if (_selectedIndex == 0) {
                  _gotRequestsFilter = null;
                } else {
                  _sentRequestsFilter = null;
                }
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: context.l10.filter_pending,
            isSelected: currentFilter == BuddyRequestStatus.pending,
            onTap: () {
              setState(() {
                if (_selectedIndex == 0) {
                  _gotRequestsFilter = BuddyRequestStatus.pending;
                } else {
                  _sentRequestsFilter = BuddyRequestStatus.pending;
                }
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: context.l10.filter_accepted,
            isSelected: currentFilter == BuddyRequestStatus.accepted,
            onTap: () {
              setState(() {
                if (_selectedIndex == 0) {
                  _gotRequestsFilter = BuddyRequestStatus.accepted;
                } else {
                  _sentRequestsFilter = BuddyRequestStatus.accepted;
                }
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: context.l10.filter_rejected,
            isSelected: currentFilter == BuddyRequestStatus.rejected,
            onTap: () {
              setState(() {
                if (_selectedIndex == 0) {
                  _gotRequestsFilter = BuddyRequestStatus.rejected;
                } else {
                  _sentRequestsFilter = BuddyRequestStatus.rejected;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGotRequestsSliver() {
    return BlocBuilder<BuddyBloc, BuddyState>(
      buildWhen: (previous, current) =>
          previous.buddyRequests != current.buddyRequests,
      builder: (context, state) {
        if (state.buddyRequests.status.isError) {
          return SliverToBoxAdapter(
            child: _buildErrorState(context),
          );
        }

        final loggedUser = context.read<LoginBloc>().state.user;
        var myBuddyRequests = state.buddyRequests.data
                ?.where(
                  (buddyRequest) =>
                      buddyRequest.sender.email != loggedUser?.email,
                )
                .toList() ??
            [];

        // Filtreleme uygula
        if (_gotRequestsFilter != null) {
          myBuddyRequests = myBuddyRequests
              .where((request) => request.status == _gotRequestsFilter)
              .toList();
        }

        // Eğer veri yoksa ve yükleme durumundaysa loading göster
        if (myBuddyRequests.isEmpty && state.buddyRequests.status.isLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        // Eğer veri yoksa ve yükleme tamamlandıysa empty state göster
        if (myBuddyRequests.isEmpty && state.buddyRequests.status.isSuccess) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(context, context.l10.no_incoming_requests),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final buddyRequest = myBuddyRequests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BuddyRequestCard(
                  buddyRequests: buddyRequest,
                  onAccept: () =>
                      _showAcceptConfirmation(context, buddyRequest.id),
                  onReject: () =>
                      _showRejectConfirmation(context, buddyRequest.id),
                ),
              );
            },
            childCount: myBuddyRequests.length,
          ),
        );
      },
    );
  }

  Widget _buildSentRequestsSliver() {
    return BlocBuilder<BuddyBloc, BuddyState>(
      buildWhen: (previous, current) =>
          previous.buddyRequests.status != current.buddyRequests.status,
      builder: (context, state) {
        if (state.buddyRequests.status.isError) {
          return SliverToBoxAdapter(
            child: _buildErrorState(context),
          );
        }

        final loggedUser = context.read<LoginBloc>().state.user;
        var myBuddyRequests = state.buddyRequests.data
                ?.where(
                  (buddyRequest) =>
                      buddyRequest.sender.email == loggedUser?.email,
                )
                .toList() ??
            [];

        // Filtreleme uygula
        if (_sentRequestsFilter != null) {
          myBuddyRequests = myBuddyRequests
              .where((request) => request.status == _sentRequestsFilter)
              .toList();
        }

        // Eğer veri yoksa ve yükleme durumundaysa loading göster
        if (myBuddyRequests.isEmpty && state.buddyRequests.status.isLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        // Eğer veri yoksa ve yükleme tamamlandıysa empty state göster
        if (myBuddyRequests.isEmpty && state.buddyRequests.status.isSuccess) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(context, context.l10.no_sent_requests),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final buddyRequest = myBuddyRequests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BuddyRequestCard(
                  buddyRequests: buddyRequest,
                ),
              );
            },
            childCount: myBuddyRequests.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(context.l10.failed_to_get_buddy_requests),
          const SizedBox(height: 10),
          GigElevatedButton(
            onPressed: () {
              context.read<BuddyBloc>().add(const GetBuddyRequests());
            },
            child: Text(context.l10.try_again),
          ),
        ],
      ),
    );
  }

  void _showAcceptConfirmation(BuildContext context, String buddyRequestId) {
    showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10.alert_accept_title),
          content: Text(context.l10.alert_accept_message),
          actions: [
            GigElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10.cancel),
            ),
            GigElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BuddyBloc>().add(
                      AcceptBuddyRequest(
                        buddyRequestId: buddyRequestId,
                      ),
                    );
              },
              child: Text(context.l10.button_accept),
            ),
          ],
        );
      },
    );
  }

  void _showRejectConfirmation(BuildContext context, String buddyRequestId) {
    showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10.alert_reject_title),
          content: Text(context.l10.alert_reject_message),
          actions: [
            GigElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10.cancel),
            ),
            GigElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BuddyBloc>().add(
                      RejectBuddyRequest(
                        buddyRequestId: buddyRequestId,
                      ),
                    );
              },
              child: Text(context.l10.button_reject),
            ),
          ],
        );
      },
    );
  }
}
