part of 'buddy_bloc.dart';

@immutable
class BuddyState extends Equatable {
  const BuddyState({
    required this.createBuddyRequest,
    required this.buddyRequests,
    required this.acceptBuddyRequest,
    required this.rejectBuddyRequest,
    required this.blockBuddyRequest,
    required this.currentCreateBuddyRequestEventId,
  });

  factory BuddyState.initial() {
    return BuddyState(
      createBuddyRequest: ResponseEntity.initial(),
      buddyRequests: ResponseEntity.initial(),
      acceptBuddyRequest: const {},
      rejectBuddyRequest: const {},
      blockBuddyRequest: const {},
      currentCreateBuddyRequestEventId: '',
    );
  }

  final ResponseEntity<void> createBuddyRequest;
  final ResponseEntity<List<BuddyRequests>> buddyRequests;
  final Map<String, ResponseEntity<void>> acceptBuddyRequest;
  final Map<String, ResponseEntity<void>> rejectBuddyRequest;
  final Map<String, ResponseEntity<void>> blockBuddyRequest;
  final String currentCreateBuddyRequestEventId;

  BuddyState copyWith({
    ResponseEntity<void>? createBuddyRequest,
    ResponseEntity<List<BuddyRequests>>? buddyRequests,
    Map<String, ResponseEntity<void>>? acceptBuddyRequest,
    Map<String, ResponseEntity<void>>? rejectBuddyRequest,
    Map<String, ResponseEntity<void>>? blockBuddyRequest,
    String? currentCreateBuddyRequestEventId,
  }) {
    return BuddyState(
      createBuddyRequest: createBuddyRequest ?? this.createBuddyRequest,
      buddyRequests: buddyRequests ?? this.buddyRequests,
      acceptBuddyRequest: acceptBuddyRequest ?? this.acceptBuddyRequest,
      rejectBuddyRequest: rejectBuddyRequest ?? this.rejectBuddyRequest,
      blockBuddyRequest: blockBuddyRequest ?? this.blockBuddyRequest,
      currentCreateBuddyRequestEventId: currentCreateBuddyRequestEventId ??
          this.currentCreateBuddyRequestEventId,
    );
  }

  @override
  List<Object?> get props => [
        createBuddyRequest,
        buddyRequests,
        acceptBuddyRequest,
        rejectBuddyRequest,
        blockBuddyRequest,
        currentCreateBuddyRequestEventId,
      ];
}
