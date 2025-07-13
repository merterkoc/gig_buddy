import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/chat_service.dart';
import 'package:gig_buddy/src/service/model/public_user/public_user_dto.dart';
import 'package:go_router/go_router.dart';

class ChatHelper {
  factory ChatHelper() => _instance;
  ChatHelper._internal();

  static final ChatHelper _instance = ChatHelper._internal();
  static Future<void> startChat(BuildContext context, PublicUserDto user) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş yapmanız gerekiyor')),
      );
      return;
    }

    try {
      // Chat odası oluştur veya mevcut olanı getir
      // Sadece Firebase UID'leri kullan
      final otherUserFirebaseUid = user.firebaseUid;
      if (otherUserFirebaseUid == null || otherUserFirebaseUid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu kullanıcı ile mesajlaşamazsınız')),
        );
        return;
      }

      // Kendi kullanıcı bilgilerimi LoginBloc'tan al
      final currentUserProfile = context.read<LoginBloc>().state.user;
      if (currentUserProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bilgileriniz alınamadı')),
        );
        return;
      }

      final chatId = await ChatService().createOrGetDirectMessageChat(
        currentUserId: currentUser.uid,
        otherUserId: otherUserFirebaseUid,
        otherUserName: user.username,
        otherUserAvatar: user.userImage.isNotEmpty ? user.userImage : null,
        currentUserName: currentUserProfile.username,
        currentUserAvatar: currentUserProfile.userImage.isNotEmpty
            ? currentUserProfile.userImage
            : null,
      );


      // Chat detay sayfasına git
      context.pushNamed(
        AppRoute.chatDetailView.name,
        pathParameters: {'chatId': chatId},
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chat başlatılamadı: $e')),
      );
    }
  }
}
