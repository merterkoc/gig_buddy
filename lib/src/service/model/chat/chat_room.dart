import 'chat_message.dart';

enum ChatType { dm, group }

class ChatRoom {
  final String id;
  final ChatType type;
  final String? name; // Sadece grup sohbetleri için
  final DateTime createdAt;
  final Map<String, ChatParticipant> participants;
  final ChatMessage? lastMessage;

  ChatRoom({
    required this.id,
    required this.type,
    this.name,
    required this.createdAt,
    required this.participants,
    this.lastMessage,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map, String id) {
    return ChatRoom(
      id: id,
      type: ChatType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => ChatType.dm,
      ),
      name: map['name'] as String?,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map['createdAt'] as int?) ?? 0),
      participants: (map['participants'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
                key,
                ChatParticipant.fromMap(
                    Map<String, dynamic>.from(value as Map))),
          ) ??
          {},
      lastMessage: map['lastMessage'] != null
          ? ChatMessage.fromMap(
              Map<String, dynamic>.from(map['lastMessage'] as Map), '')
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'participants':
          participants.map((key, value) => MapEntry(key, value.toMap())),
      'lastMessage': lastMessage?.toMap(),
    };
  }

  bool isDirectMessage() => type == ChatType.dm;
  bool isGroupChat() => type == ChatType.group;

  String getDisplayName(String currentUserId) {
    if (isGroupChat()) {
      return name ?? 'Grup Sohbeti';
    } else {
      // DM için diğer kullanıcının adını döndür
      final otherParticipant = participants.entries
          .firstWhere((entry) => entry.key != currentUserId);
      return otherParticipant.value.displayName ?? 'Kullanıcı';
    }
  }
}

class ChatParticipant {
  final String userId;
  final DateTime joinedAt;
  final String role; // "admin", "member"
  final DateTime? lastSeen;
  final String? displayName;
  final String? avatarUrl;

  ChatParticipant({
    required this.userId,
    required this.joinedAt,
    this.role = 'member',
    this.lastSeen,
    this.displayName,
    this.avatarUrl,
  });

  factory ChatParticipant.fromMap(Map<String, dynamic> map) {
    return ChatParticipant(
      userId: (map['userId'] as String?) ?? '',
      joinedAt:
          DateTime.fromMillisecondsSinceEpoch((map['joinedAt'] as int?) ?? 0),
      role: (map['role'] as String?) ?? 'member',
      lastSeen: map['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int)
          : null,
      displayName: map['displayName'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
      'role': role,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isOnline =>
      lastSeen != null && DateTime.now().difference(lastSeen!).inMinutes < 5;
}
