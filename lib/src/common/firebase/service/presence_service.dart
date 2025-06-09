import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class PresenceService {
  final Map<String, StreamSubscription<DatabaseEvent>> _subscriptions = {};
  final Map<String, String> _userStates = {}; // UID → "online" / "offline"

  final _presenceController = StreamController<Map<String, String>>.broadcast();

  Stream<Map<String, String>> get presenceStream => _presenceController.stream;

  void listenToUsers(List<String> userIds) {
    for (final uid in userIds) {
      if (_subscriptions.containsKey(uid)) continue;

      final ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://gigbuddy-dev-default-rtdb.europe-west1.firebasedatabase.app/',
      ).ref('presence/$uid');

      final sub = ref.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        final state = data?['state'] ?? 'offline';
        print('Online status changed for $uid to $state');
        _userStates[uid] = state.toString();
        _presenceController.add(Map.from(_userStates));
      });

      _subscriptions[uid] = sub;
    }
  }
  void listenToUser(String uid) {
    if (_subscriptions.containsKey(uid)) return;

    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      'https://gigbuddy-dev-default-rtdb.europe-west1.firebasedatabase.app/',
    ).ref('presence/$uid');

    final sub = ref.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      final state = data?['state'] ?? 'offline';

      _userStates[uid] = state.toString();
      _presenceController.add(Map.from(_userStates));
    });

    _subscriptions[uid] = sub;
  }

  void cancelUsers(List<String> userIds) {
    for (final uid in userIds) {
      if (!_subscriptions.containsKey(uid)) continue;
      _subscriptions[uid]!.cancel();
      _subscriptions.remove(uid);
    }
  }

  void cancelUser(String uid) {
    if (!_subscriptions.containsKey(uid)) return;
    _subscriptions[uid]!.cancel();
    _subscriptions.remove(uid);
  }

  void cancelAll() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
    _userStates.clear();
    _presenceController.add({});
  }

  void dispose() {
    cancelAll();
    _presenceController.close();
  }
}