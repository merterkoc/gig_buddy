part of 'buddy_bloc.dart';

@immutable
class BuddyState extends Equatable {
  const BuddyState({
    required this.buddyRequests,
    required this.acceptBuddyRequest,
    required this.rejectBuddyRequest,
    required this.blockBuddyRequest,
  });

  factory BuddyState.initial() {
    return BuddyState(
      buddyRequests: ResponseEntity.initial(),
      acceptBuddyRequest: const {},
      rejectBuddyRequest: const {},
      blockBuddyRequest: const {},
    );
  }

  final ResponseEntity<List<BuddyRequests>> buddyRequests;
  final Map<String, ResponseEntity<void>> acceptBuddyRequest;
  final Map<String, ResponseEntity<void>> rejectBuddyRequest;
  final Map<String, ResponseEntity<void>> blockBuddyRequest;

  BuddyState copyWith({
    ResponseEntity<List<BuddyRequests>>? buddyRequests,
    Map<String, ResponseEntity<void>>? acceptBuddyRequest,
    Map<String, ResponseEntity<void>>? rejectBuddyRequest,
    Map<String, ResponseEntity<void>>? blockBuddyRequest,
  }) {
    return BuddyState(
      buddyRequests: buddyRequests ?? this.buddyRequests,
      acceptBuddyRequest: acceptBuddyRequest ?? this.acceptBuddyRequest,
      rejectBuddyRequest: rejectBuddyRequest ?? this.rejectBuddyRequest,
      blockBuddyRequest: blockBuddyRequest ?? this.blockBuddyRequest,
    );
  }

  @override
  List<Object?> get props => [
        buddyRequests,
        acceptBuddyRequest,
        rejectBuddyRequest,
        blockBuddyRequest,
      ];
}
