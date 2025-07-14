import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';

class NotificationOverlay extends StatefulWidget {
  final Widget child;
  final Stream<Map<String, dynamic>> notificationStream;

  const NotificationOverlay({
    super.key,
    required this.child,
    required this.notificationStream,
  });

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic>? _currentNotification;
  Timer? _hideTimer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Üstten başla
      end: Offset.zero, // Normal pozisyon
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Notification stream'i dinle
    widget.notificationStream.listen(_showNotification);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showNotification(Map<String, dynamic> notification) {
    if (_isVisible) {
      // Eğer zaten bir notification gösteriliyorsa, önce onu gizle
      _hideNotification().then((_) {
        _displayNotification(notification);
      });
    } else {
      _displayNotification(notification);
    }
  }

  void _displayNotification(Map<String, dynamic> notification) {
    setState(() {
      _currentNotification = notification;
    });

    // Animasyonları başlat
    _slideController.forward();
    _fadeController.forward();

    setState(() {
      _isVisible = true;
    });

    // 4 saniye sonra otomatik gizle
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      _hideNotification();
    });
  }

  Future<void> _hideNotification() async {
    if (!_isVisible) return;

    // Animasyonları geri al
    await _slideController.reverse();
    await _fadeController.reverse();

    setState(() {
      _isVisible = false;
      _currentNotification = null;
    });
  }

  void _onNotificationTap() {
    _hideTimer?.cancel();
    _hideNotification();

    // Notification'a tıklandığında yapılacak işlemler
    if (_currentNotification != null) {
      final type = _currentNotification!['type'] as String?;

      switch (type) {
        case 'chat':
          // Chat'e git
          final chatId = _currentNotification!['chatId'] as String?;
          if (chatId != null) {
            // Navigator ile chat detail'e git
            // context.pushNamed(AppRoute.chatDetailView.name, pathParameters: {'chatId': chatId});
          }
          break;
        case 'event':
          // Event'e git
          final eventId = _currentNotification!['eventId'] as String?;
          if (eventId != null) {
            // Navigator ile event detail'e git
            // context.pushNamed(AppRoute.eventDetailView.name, pathParameters: {'eventId': eventId});
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isVisible && _currentNotification != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildNotificationCard(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationCard() {
    final notification = _currentNotification!;
    final title = notification['title'] as String? ?? 'Bildirim';
    final body = notification['body'] as String? ?? '';
    final type = notification['type'] as String? ?? 'general';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onNotificationTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getNotificationIcon(type),
                      color: _getNotificationColor(type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (body.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Close button
                  IconButton(
                    onPressed: _hideNotification,
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'chat':
        return Colors.blue;
      case 'event':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'event':
        return Icons.event_outlined;
      case 'system':
        return Icons.notifications_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
