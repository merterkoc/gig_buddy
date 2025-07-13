import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/chat_service.dart';
import 'package:go_router/go_router.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final Future<void> Function() refreshCallback;
  late Completer<void> _refreshCompleter = Completer<void>();
  List<Map<String, dynamic>>? _cachedChatRooms;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    refreshCallback = refreshChatRooms;
    _cachedChatRooms = ChatService().cachingChatRooms;
    _refreshCompleter.complete(); // İlk yükleme için
  }

  Future<void> refreshChatRooms() async {
    _refreshCompleter = Completer<void>();
    _cachedChatRooms = null; // Cache'i temizle
    setState(() {
      _isInitialized = false;
    });

    // Kısa bir gecikme ekle (refresh animasyonu için)
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
      _refreshCompleter.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(context.l10.chat_title),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatService().getUserChatRooms(),
        builder: (context, snapshot) {
          // İlk yükleme sırasında loading göster
          if (((snapshot.connectionState == ConnectionState.waiting &&
                  !_isInitialized) &&
              !snapshot.hasData)&& ChatService().cachingChatRooms.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final chatRooms = snapshot.data ?? [];

          // Cache'e kaydet (sadece ilk kez)
          if (_cachedChatRooms == null && chatRooms.isNotEmpty) {
            _cachedChatRooms = List.from(chatRooms);
          }

          // Eğer cache varsa ve yeni data yoksa cache'i kullan
          final displayChatRooms =
              chatRooms.isNotEmpty ? chatRooms : (_cachedChatRooms ?? []);

          if (displayChatRooms.isEmpty) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: refreshCallback,
                ),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10.chat_no_messages,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: refreshCallback,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chatRoom = displayChatRooms[index];
                    final chatId = chatRoom['id']?.toString() ?? '';
                    final chatData =
                        chatRoom['data'] != null ? chatRoom['data'] as Map : {};

                    // Kullanıcı bilgilerini al
                    final otherUserName =
                        chatData['otherUserName'] as String? ??
                            'Bilinmeyen Kullanıcı';
                    final otherUserAvatar =
                        chatData['otherUserAvatar'] as String?;
                    final lastMessage = chatData['lastMessage'] as Map?;
                    final lastMessageText =
                        lastMessage?['text'] as String? ?? '';
                    final lastMessageTime = lastMessage?['timestamp'] as int?;
                    final lastMessageSenderId =
                        lastMessage?['senderId'] as String?;
                    final unreadCount = chatData['unreadCount'] as int? ?? 0;

                    // Mesaj gönderen kişiyi belirle
                    final isMyMessage =
                        chatData['isMyMessage'] as bool? ?? false;
                    final lastMessageSenderName =
                        chatData['lastMessageSenderName'] as String? ??
                            otherUserName;
                    final messagePrefix = isMyMessage ? 'Sen: ' : '';

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: otherUserAvatar != null &&
                                    otherUserAvatar.isNotEmpty
                                ? NetworkImage(otherUserAvatar)
                                : null,
                            child: otherUserAvatar == null ||
                                    otherUserAvatar.isEmpty
                                ? Icon(
                                    Icons.person,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  )
                                : null,
                          ),
                          title: Text(
                            otherUserName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (lastMessageText.isNotEmpty)
                                Text(
                                  '$messagePrefix$lastMessageText',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                ),
                              if (lastMessageTime != null)
                                Text(
                                  _formatTime(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          lastMessageTime)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                ),
                            ],
                          ),
                          trailing: StreamBuilder<int>(
                            stream: ChatService().getUnreadCountForChat(chatId),
                            builder: (context, unreadSnapshot) {
                              final currentUnreadCount =
                                  unreadSnapshot.data ?? unreadCount;

                              if (currentUnreadCount > 0) {
                                return Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    currentUnreadCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          onTap: () {
                            // Go Router ile chat detail'e git
                            context.pushNamed(AppRoute.chatDetailView.name,
                                pathParameters: {'chatId': chatId});
                          },
                        ),
                        if (index < displayChatRooms.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  },
                  childCount: displayChatRooms.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Şimdi';
        }
        return '${difference.inMinutes} dk';
      }
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün';
    } else {
      return '${time.day}.${time.month}.${time.year}';
    }
  }
}
