import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

/// Notifications screen — live reminders, circle updates, transaction alerts.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Notifications'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: _NotificationsContent(),
    );
  }
}

class _NotificationsContent extends StatelessWidget {
  static const _items = [
    _NotifData(
      icon: Icons.savings_rounded,
      iconColor: Color(0xFF4CAF50),
      title: 'Contribution Due Today',
      body: 'Your ₦20,000 contribution to Market Traders Fund is due today.',
      time: 'Just now',
      isUnread: true,
    ),
    _NotifData(
      icon: Icons.swap_horiz_rounded,
      iconColor: Color(0xFF2196F3),
      title: 'Transfer Received',
      body: 'You received ₦15,000 from Mama K.',
      time: '2h ago',
      isUnread: true,
    ),
    _NotifData(
      icon: Icons.star_rounded,
      iconColor: Color(0xFFFF9800),
      title: 'Credit Score Updated',
      body: 'Your credit score improved to 720. You can now borrow up to ₦150,000.',
      time: '1d ago',
      isUnread: false,
    ),
    _NotifData(
      icon: Icons.group_rounded,
      iconColor: Color(0xFF9C27B0),
      title: 'New Member Joined',
      body: 'Adewale joined the NextGen Savings Circle.',
      time: '2d ago',
      isUnread: false,
    ),
    _NotifData(
      icon: Icons.celebration_rounded,
      iconColor: Color(0xFF4CAF50),
      title: 'Payout Successful',
      body: 'Chinedu successfully cashed out ₦500,000 from Market Traders Fund.',
      time: '3d ago',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _items.where((n) => n.isUnread).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.theme.colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$unread unread',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.theme.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ..._items.map((item) => _NotifTile(data: item)),
        ],
      ),
    );
  }
}

class _NotifData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const _NotifData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.data});
  final _NotifData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: data.isUnread
            ? context.theme.colors.primary.withValues(alpha: 0.05)
            : context.theme.colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: data.isUnread
              ? context.theme.colors.primary.withValues(alpha: 0.2)
              : context.theme.colors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.theme.colors.foreground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (data.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.theme.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
