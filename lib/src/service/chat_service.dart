import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/chat/chat_message.dart';
import 'model/chat/chat_room.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // Firebase Database'i URL ile başlat
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: FirebaseAuth.instance.app,
    databaseURL:
        'https://gigbuddy-dev-default-rtdb.europe-west1.firebasedatabase.app/',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Database referansları
  DatabaseReference get _chatsRef => _database.ref('chats');
  DatabaseReference get _messagesRef => _database.ref('messages');
  DatabaseReference get _userChatsRef => _database.ref('userChats');

  var cachingChatRooms = <Map<String, dynamic>>[];

  // İki kullanıcı arasında DM chat odası oluşturma veya mevcut olanı getirme
  // Sadece Firebase UID'leri kullanarak
  Future<String> createOrGetDirectMessageChat({
    required String currentUserId, // Firebase UID
    required String otherUserId, // Firebase UID
    required String otherUserName,
    String? otherUserAvatar,
    required String currentUserName, // Kendi kullanıcı adım
    String? currentUserAvatar, // Kendi avatarım
  }) async {
    try {
      print('ChatService: DM chat odası aranıyor...');

      // Önce mevcut DM chat odasını ara
      final existingChats = await _userChatsRef.child(currentUserId).get();
      if (existingChats.value != null) {
        for (final chatEntry in (existingChats.value as Map).entries) {
          final chatId = chatEntry.key.toString();
          final chatDetails = await getChatRoomDetails(chatId);

          if (chatDetails != null &&
              chatDetails['type'] == 'dm' &&
              chatDetails['participants'] != null) {
            final participants = chatDetails['participants'] as Map;
            if (participants.containsKey(otherUserId)) {
              print('ChatService: Mevcut DM chat odası bulundu: $chatId');
              return chatId;
            }
          }
        }
      }

      // Mevcut chat odası yoksa yeni oluştur
      print('ChatService: Yeni DM chat odası oluşturuluyor...');
      final chatId = _chatsRef.push().key!;
      final now = DateTime.now().millisecondsSinceEpoch;

      final chatData = {
        'type': 'dm',
        'createdAt': now,
        'participants': {
          currentUserId: {
            'userId': currentUserId,
            'name': currentUserName,
            'avatar': currentUserAvatar,
            'joinedAt': now,
            'role': 'member',
          },
          otherUserId: {
            'userId': otherUserId,
            'name': otherUserName,
            'avatar': otherUserAvatar,
            'joinedAt': now,
            'role': 'member',
          },
        },
      };

      // Chat odasını kaydet
      await _chatsRef.child(chatId).set(chatData);
      print('ChatService: Yeni DM chat odası oluşturuldu: $chatId');

      // Her iki kullanıcının chat listesine ekle
      await _userChatsRef.child(currentUserId).child(chatId).set({
        'lastRead': now,
        'unreadCount': 0,
        'muted': false,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'otherUserAvatar': otherUserAvatar,
      });

      // Diğer kullanıcının chat listesine ekle
      // Kendi kullanıcı adımı ve avatarımı kullan
      await _userChatsRef.child(otherUserId).child(chatId).set({
        'lastRead': now,
        'unreadCount': 0,
        'muted': false,
        'otherUserId': currentUserId,
        'otherUserName': currentUserName, // Kendi kullanıcı adım
        'otherUserAvatar': currentUserAvatar, // Kendi avatarım
      });

      print('ChatService: Kullanıcılar chat listesine eklendi');
      return chatId;
    } catch (e) {
      print('ChatService: DM chat odası oluşturulurken hata: $e');
      throw Exception('Chat odası oluşturulamadı: $e');
    }
  }

  // Basit test chat odası oluşturma
  Future<void> createTestChatRoom() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('ChatService: Kullanıcı giriş yapmamış');
      return;
    }

    try {
      print('ChatService: Test chat odası oluşturuluyor...');

      // Basit chat odası verisi
      final chatId = _chatsRef.push().key!;
      final now = DateTime.now().millisecondsSinceEpoch;

      final chatData = {
        'type': 'dm',
        'name': 'Test Chat',
        'createdAt': now,
        'participants': {
          currentUser.uid: {
            'userId': currentUser.uid,
            'joinedAt': now,
            'role': 'admin',
          },
          'test_firebase_uid_123': {
            'userId': 'test_firebase_uid_123',
            'joinedAt': now,
            'role': 'member',
          },
        },
      };

      // Chat odasını kaydet
      await _chatsRef.child(chatId).set(chatData);
      print('ChatService: Chat odası kaydedildi: $chatId');

      // Kullanıcının chat listesine ekle
      await _userChatsRef.child(currentUser.uid).child(chatId).set({
        'lastRead': now,
        'unreadCount': 0,
        'muted': false,
      });
      print('ChatService: Kullanıcı chat listesine eklendi');

      // Test mesajı ekle
      final messageId = _messagesRef.child(chatId).push().key!;
      final messageData = {
        'senderId': currentUser.uid,
        'text': 'Merhaba! Bu bir test mesajıdır.',
        'timestamp': now,
        'type': 'text',
        'status': {
          currentUser.uid: 'read',
          'test_firebase_uid_123': 'sent',
        },
      };

      await _messagesRef.child(chatId).child(messageId).set(messageData);
      print('ChatService: Test mesajı eklendi');

      // Son mesajı chat odasına ekle
      await _chatsRef.child(chatId).update({
        'lastMessage': messageData,
      });
      print('ChatService: Son mesaj güncellendi');
    } catch (e) {
      print('ChatService: Test chat odası oluşturulurken hata: $e');
    }
  }

  // Kullanıcının chat odalarını getirme - Son mesaj bilgileri ile
  Stream<List<Map<String, dynamic>>> getUserChatRooms() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('ChatService: Kullanıcı giriş yapmamış');
      return Stream.value([]);
    }

    print(
        'ChatService: getUserChatRooms başlatıldı - userId: ${currentUser.uid}');

    return _userChatsRef.child(currentUser.uid).onValue.asyncMap((event) async {
      print('ChatService: Stream event alındı');
      print('ChatService: Event snapshot value: ${event.snapshot.value}');

      final data = event.snapshot.value;
      if (data == null) {
        print('ChatService: Data null, boş liste döndürülüyor');
        return <Map<String, dynamic>>[];
      }

      if (data is Map) {
        final chatIds = data.keys.toList();
        print('ChatService: ${chatIds.length} chat ID bulundu: $chatIds');

        // Her chat odası için detay bilgilerini al
        final chatRooms = <Map<String, dynamic>>[];
        for (final chatId in chatIds) {
          final chatData = data[chatId] as Map? ?? {};

          // Chat odası detaylarını al
          final chatDetails = await getChatRoomDetails(chatId.toString());
          final lastMessage = chatDetails?['lastMessage'] as Map?;

          // Chat listesi verisini birleştir
          final combinedData = Map<String, dynamic>.from(chatData);
          if (lastMessage != null) {
            combinedData['lastMessage'] = lastMessage;

            // Son mesajın gönderen kişisini belirle
            final lastMessageSenderId = lastMessage['senderId'] as String?;
            if (lastMessageSenderId != null) {
              // Son mesajı kimin gönderdiğini belirle
              final isMyMessage = lastMessageSenderId == currentUser.uid;
              combinedData['isMyMessage'] = isMyMessage;

              // Son mesajı gönderen kişinin adını belirle
              if (isMyMessage) {
                // Ben gönderdim, diğer kullanıcının adını göster
                combinedData['lastMessageSenderName'] =
                    combinedData['otherUserName'];
              } else {
                // Başkası gönderdi, onun adını göster
                // Chat odası katılımcılarından kullanıcı adını al
                final participants = chatDetails?['participants'] as Map?;
                if (participants != null &&
                    participants.containsKey(lastMessageSenderId)) {
                  final participantData =
                      participants[lastMessageSenderId] as Map?;
                  final participantName = participantData?['name'] as String?;
                  combinedData['lastMessageSenderName'] =
                      participantName ?? combinedData['otherUserName'];
                } else {
                  combinedData['lastMessageSenderName'] =
                      combinedData['otherUserName'];
                }
              }

              // Debug için log
              print('ChatService: Chat ID: $chatId');
              print('ChatService: Current user UID: ${currentUser.uid}');
              print(
                  'ChatService: Last message sender ID: $lastMessageSenderId');
              print('ChatService: Is my message: $isMyMessage');
              print(
                  'ChatService: Last message sender name: ${combinedData['lastMessageSenderName']}');
            }
          }

          chatRooms.add({
            'id': chatId.toString(),
            'data': combinedData,
          });
        }

        // Son mesaj zamanına göre sırala (en yeni üstte)
        chatRooms.sort((a, b) {
          final aLastMessage = a['data']['lastMessage'] as Map?;
          final bLastMessage = b['data']['lastMessage'] as Map?;

          final aTime = aLastMessage?['timestamp'] as int? ?? 0;
          final bTime = bLastMessage?['timestamp'] as int? ?? 0;

          return bTime.compareTo(aTime); // En yeni üstte
        });

        cachingChatRooms = chatRooms.toList();
        return chatRooms;
      }

      print('ChatService: Beklenmeyen data tipi: ${data.runtimeType}');
      return <Map<String, dynamic>>[];
    });
  }

  // Chat odası detaylarını getirme
  Future<Map<Object?, Object?>?> getChatRoomDetails(String chatId) async {
    try {
      final snapshot = await _chatsRef.child(chatId).get();
      final data = snapshot.value as Map<Object?, Object?>?;
      return data;
    } catch (e) {
      print('ChatService: Chat odası detayları alınırken hata: $e');
      return null;
    }
  }

  // Chat odasındaki mesajları getirme
  Stream<List<Map<Object?, Object?>>> getChatMessages(String chatId) {
    return _messagesRef
        .child(chatId)
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) return <Map<String, dynamic>>[];

      if (data is Map) {
        final messages = <Map<Object?, Object?>>[];
        for (final entry in data.entries) {
          final messageData = entry.value as Map<Object?, Object?>;
          messageData['id'] = entry.key;
          messages.add(messageData);
        }

        // Zaman sırasına göre sırala
        messages.sort((a, b) {
          final aTime = a['timestamp'] as int? ?? 0;
          final bTime = b['timestamp'] as int? ?? 0;
          return aTime.compareTo(bTime);
        });

        return messages;
      }

      return <Map<String, dynamic>>[];
    });
  }

  // Mesaj gönderme
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Kullanıcı giriş yapmamış');

    try {
      final messageRef = _messagesRef.child(chatId).push();
      final messageId = messageRef.key!;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Chat odası detaylarından diğer kullanıcıyı bul
      final chatRoomDetails = await getChatRoomDetails(chatId);
      final otherUserId = chatRoomDetails?['participants'] != null
          ? (chatRoomDetails!['participants'] as Map)
              .keys
              .where((id) => id.toString() != currentUser.uid)
              .firstOrNull
              ?.toString()
          : null;

      final messageData = {
        'senderId': currentUser.uid,
        'text': text,
        'timestamp': now,
        'type': 'text',
        'status': {
          currentUser.uid: 'sent',
          if (otherUserId != null) otherUserId: 'delivered',
        },
      };

      await messageRef.set(messageData);
      print('ChatService: Mesaj gönderildi: $messageId');

      // Son mesajı chat odasına güncelle
      await _chatsRef.child(chatId).update({
        'lastMessage': messageData,
      });

      // Kullanıcı chat listesindeki son mesaj bilgisini güncelle
      await _userChatsRef.child(currentUser.uid).child(chatId).update({
        'lastMessage': messageData,
        'lastMessageTime': now,
        'unreadCount': 0, // Kendi mesajımızı okumuş sayılırız
      });

      // Diğer kullanıcının chat listesindeki son mesaj bilgisini güncelle
      if (chatRoomDetails != null && chatRoomDetails['participants'] != null) {
        final participants = chatRoomDetails['participants'] as Map;
        for (final participantId in participants.keys) {
          if (participantId.toString() != currentUser.uid) {
            // Mevcut unread count'u al ve 1 artır
            final currentUnreadSnapshot = await _userChatsRef
                .child(participantId.toString())
                .child(chatId)
                .child('unreadCount')
                .get();
            final currentUnread = currentUnreadSnapshot.value as int? ?? 0;

            await _userChatsRef
                .child(participantId.toString())
                .child(chatId)
                .update({
              'lastMessage': messageData,
              'lastMessageTime': now,
              'unreadCount': currentUnread + 1,
            });
            print(
                'ChatService: Diğer kullanıcının unread count artırıldı: ${currentUnread + 1}');
            break;
          }
        }
      }
    } catch (e) {
      print('ChatService: Mesaj gönderilirken hata: $e');
      throw Exception('Mesaj gönderilemedi: $e');
    }
  }

  // Mesajları okundu olarak işaretle
  Future<void> markMessagesAsRead(String chatId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      print(
          'ChatService: Mesajlar okundu olarak işaretleniyor - Chat ID: $chatId');

      // Chat odasındaki tüm mesajları al
      final messagesSnapshot = await _messagesRef.child(chatId).get();
      if (messagesSnapshot.value == null) return;

      final messages = messagesSnapshot.value as Map;
      final now = DateTime.now().millisecondsSinceEpoch;
      bool hasUpdates = false;

      // Her mesaj için status'u güncelle
      for (final messageEntry in messages.entries) {
        final messageId = messageEntry.key.toString();
        final messageData = messageEntry.value as Map;
        final status = messageData['status'] as Map? ?? {};

        // Eğer bu mesajı ben göndermedim ve henüz okunmamışsa, okundu olarak işaretle
        final senderId = messageData['senderId'] as String?;
        if (senderId != null &&
            senderId != currentUser.uid &&
            status[currentUser.uid] != 'read') {
          status[currentUser.uid] = 'read';
          messageData['status'] = status;

          // Mesajı güncelle
          await _messagesRef.child(chatId).child(messageId).update({
            'status': status,
          });

          hasUpdates = true;
          print(
              'ChatService: Mesaj okundu olarak işaretlendi - Message ID: $messageId');
        }
      }

      // Eğer güncelleme yapıldıysa, kullanıcının chat listesindeki unread count'u sıfırla
      if (hasUpdates) {
        await _userChatsRef.child(currentUser.uid).child(chatId).update({
          'unreadCount': 0,
          'lastRead': now,
        });
        print('ChatService: Unread count sıfırlandı');
      }
    } catch (e) {
      print('ChatService: Mesajlar okundu olarak işaretlenirken hata: $e');
    }
  }

  // Mesaj silme fonksiyonu (gelecekte kullanılacak)
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Kullanıcı giriş yapmamış');

    try {
      // Mesajın var olup olmadığını ve kullanıcının sahibi olup olmadığını kontrol et
      final messageSnapshot =
          await _messagesRef.child(chatId).child(messageId).get();
      if (messageSnapshot.value == null) {
        throw Exception('Mesaj bulunamadı');
      }

      final messageData = messageSnapshot.value as Map;
      final senderId = messageData['senderId'] as String?;

      if (senderId != currentUser.uid) {
        throw Exception('Bu mesajı silme yetkiniz yok');
      }

      // Mesajı sil (soft delete - sadece deleted flag'i ekle)
      await _messagesRef.child(chatId).child(messageId).update({
        'deleted': true,
        'deletedAt': DateTime.now().millisecondsSinceEpoch,
      });

      print('ChatService: Mesaj silindi: $messageId');
    } catch (e) {
      print('ChatService: Mesaj silinirken hata: $e');
      throw Exception('Mesaj silinemedi: $e');
    }
  }

  // Toplam okunmamış mesaj sayısını getir
  Stream<int> getTotalUnreadCount() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(0);
    }

    return _userChatsRef.child(currentUser.uid).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) {
        print('ChatService: getTotalUnreadCount - data null');
        return 0;
      }

      int totalUnread = 0;
      if (data is Map) {
        print(
            'ChatService: getTotalUnreadCount - ${data.length} chat odası bulundu');
        for (final chatEntry in data.entries) {
          final chatId = chatEntry.key;
          final chatData = chatEntry.value as Map? ?? {};
          final unreadCount = chatData['unreadCount'] as int? ?? 0;
          print('ChatService: Chat $chatId - unreadCount: $unreadCount');
          totalUnread += unreadCount;
        }
      } else {
        print(
            'ChatService: getTotalUnreadCount - data Map değil: ${data.runtimeType}');
      }

      print('ChatService: Toplam okunmamış mesaj sayısı: $totalUnread');
      return totalUnread;
    });
  }

  // Belirli bir chat odasının okunmamış mesaj sayısını getir
  Stream<int> getUnreadCountForChat(String chatId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(0);
    }

    return _userChatsRef
        .child(currentUser.uid)
        .child(chatId)
        .child('unreadCount')
        .onValue
        .map((event) {
      final unreadCount = event.snapshot.value as int? ?? 0;
      print(
          'ChatService: Chat $chatId için okunmamış mesaj sayısı: $unreadCount');
      return unreadCount;
    });
  }

  // Test amaçlı: Belirli bir chat odasının unread count'unu artır
  Future<void> incrementUnreadCount(String chatId, int increment) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final currentUnreadSnapshot = await _userChatsRef
          .child(currentUser.uid)
          .child(chatId)
          .child('unreadCount')
          .get();
      final currentUnread =
          currentUnreadSnapshot.value as Map<Object?, Object?>? ?? {};
      final currentUnreadCount = currentUnread['count'] as int? ?? 0;
      final newUnreadCount = currentUnreadCount + increment;
      await _userChatsRef.child(currentUser.uid).child(chatId).update({
        'unreadCount': {
          'count': newUnreadCount,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        },
      });

      print(
          'ChatService: Unread count artırıldı: $currentUnreadCount -> $newUnreadCount');
    } catch (e) {
      print('ChatService: Unread count artırılırken hata: $e');
      rethrow;
    }
  }
}

// List karşılaştırma yardımcı fonksiyonu
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
