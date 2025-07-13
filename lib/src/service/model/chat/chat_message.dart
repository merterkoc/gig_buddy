enum MessageType { text, image, file }

enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final MessageAttachment? attachment;
  final Map<String, MessageStatus> status; // userId -> status

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.attachment,
    required this.status,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderId: (map['senderId'] as String?) ?? '',
      text: (map['text'] as String?) ?? '',
      timestamp:
          DateTime.fromMillisecondsSinceEpoch((map['timestamp'] as int?) ?? 0),
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MessageType.text,
      ),
      attachment: map['attachment'] != null
          ? MessageAttachment.fromMap(
              Map<String, dynamic>.from(map['attachment'] as Map))
          : null,
      status: (map['status'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              MessageStatus.values.firstWhere(
                (e) => e.toString().split('.').last == value,
                orElse: () => MessageStatus.sent,
              ),
            ),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.toString().split('.').last,
      'attachment': attachment?.toMap(),
      'status': status.map(
        (key, value) => MapEntry(key, value.toString().split('.').last),
      ),
    };
  }

  bool isReadBy(String userId) {
    return status[userId] == MessageStatus.read;
  }

  bool isDeliveredTo(String userId) {
    return status[userId] == MessageStatus.delivered ||
        status[userId] == MessageStatus.read;
  }
}

class MessageAttachment {
  final String url;
  final String name;
  final int size; // bytes
  final String? mimeType;

  MessageAttachment({
    required this.url,
    required this.name,
    required this.size,
    this.mimeType,
  });

  factory MessageAttachment.fromMap(Map<String, dynamic> map) {
    return MessageAttachment(
      url: (map['url'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      size: (map['size'] as int?) ?? 0,
      mimeType: map['mimeType'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'name': name,
      'size': size,
      'mimeType': mimeType,
    };
  }

  bool get isImage => mimeType?.startsWith('image/') ?? false;
  bool get isFile => !isImage;

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
