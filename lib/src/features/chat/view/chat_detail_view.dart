import 'package:flutter/material.dart';
import 'package:gig_buddy/src/common/widgets/cached_avatar_image.dart';
import 'package:gig_buddy/src/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';

class ChatDetailView extends StatefulWidget {
  final String chatId;

  const ChatDetailView({super.key, required this.chatId});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mesajları okundu olarak işaretle
    _markMessagesAsRead();

    // Yeni mesajlar geldiğinde en üste kaydır (reverse: true kullandığımız için)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Mesajları okundu olarak işaretle
  void _markMessagesAsRead() async {
    try {
      await ChatService().markMessagesAsRead(widget.chatId);
    } catch (e) {
      print('Mesajlar okundu olarak işaretlenirken hata: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: StreamBuilder<Map<Object?, Object?>?>(
          stream: Stream.fromFuture(
              ChatService().getChatRoomDetails(widget.chatId)),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final chatData = snapshot.data!;
              final currentUser = FirebaseAuth.instance.currentUser;

              // Chat odası katılımcılarından diğer kullanıcının bilgilerini al
              String? otherUserName;
              String? otherUserAvatar;

              final participants = chatData['participants'] as Map?;
              if (participants != null && currentUser != null) {
                for (final participantId in participants.keys) {
                  if (participantId.toString() != currentUser.uid) {
                    final participantData = participants[participantId] as Map?;
                    otherUserName =
                        participantData?['name'] as String? ?? 'Chat';
                    otherUserAvatar = participantData?['avatar'] as String?;
                    break;
                  }
                }
              }

              return Row(
                children: [
                  if (otherUserAvatar != null && otherUserAvatar.isNotEmpty)
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(otherUserAvatar),
                    )
                  else
                    CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      otherUserName ?? 'Chat',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              );
            }
            return Text('Chat ${widget.chatId}');
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<Object?, Object?>>>(
                stream: ChatService().getChatMessages(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  final messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            context.l10.chat_no_messages_in_room,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                messages[messages.length - 1 - index];
                            final isMe = message['senderId']?.toString() ==
                                currentUser?.uid;

                            return _MessageBubble(
                              message: message,
                              isMe: isMe,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final textController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: context.l10.chat_message_hint,
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(context, textController),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(context, textController),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(
      BuildContext context, TextEditingController controller) async {
    final message = controller.text.trim();
    controller.clear();
    if (message.isNotEmpty) {
      try {
        await ChatService().sendMessage(
          chatId: widget.chatId,
          text: message.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<Object?, Object?> message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final text = message['text']?.toString() ?? '';
    final timestamp = message['timestamp'];
    final time = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp as int)
        : DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(time),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildMessageStatus(message),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}.${time.month}.${time.year}';
    }
  }

  // Mesaj durumunu göster
  Widget _buildMessageStatus(Map<Object?, Object?> message) {
    final status = message['status'] as Map?;
    if (status == null) {
      return Icon(Icons.schedule, size: 16, color: Colors.white70);
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Icon(Icons.schedule, size: 16, color: Colors.white70);
    }

    // Önce diğer kullanıcıların status'ünü kontrol et (read varsa onu göster)
    for (final entry in status.entries) {
      final uid = entry.key.toString();
      final value = entry.value?.toString();

      if (uid != currentUser.uid && value == 'read') {
        return Icon(Icons.done_all_rounded,
            size: 16, weight: 900, color: Colors.white); // Karşı taraf okudu
      }
    }

    // Sonra kendi durumunu kontrol et
    final myStatus = status[currentUser.uid] as String?;
    switch (myStatus) {
      case 'sent':
        return Icon(Icons.done, size: 16, color: Colors.white70);
      case 'delivered':
        return Icon(Icons.done_all, size: 16, color: Colors.white70);
      case 'read':
        return Icon(Icons.done_all, size: 16, color: Colors.blue.shade300);
      default:
        return Icon(Icons.schedule, size: 16, color: Colors.white70);
    }
  }
}
