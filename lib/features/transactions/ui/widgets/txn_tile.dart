import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class TxnData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final bool isDebit;

  const TxnData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.isDebit,
  });
}

class TxnTile extends StatelessWidget {
  const TxnTile({super.key, required this.data});
  
  final TxnData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.theme.colors.foreground, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: data.isDebit ? const Color(0xFFF44336) : const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
