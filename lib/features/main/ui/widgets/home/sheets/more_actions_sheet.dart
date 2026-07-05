import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Displays additional quick actions in a bottom sheet.
void showMoreActionsSheet(BuildContext context) {
  showFSheet(context: context, side: FLayout.btt, builder: (context) => const _MoreActionsSheet());
}

class _MoreActionsSheet extends StatelessWidget {
  const _MoreActionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text(
                'More Options',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                children: [
                  _MoreTile(icon: Icons.phone_android_rounded, label: 'Airtime', onTap: () {}),
                  _MoreTile(icon: Icons.wifi_rounded, label: 'Data', onTap: () {}),
                  _MoreTile(icon: Icons.receipt_rounded, label: 'Bills', onTap: () {}),
                  _MoreTile(icon: Icons.history_rounded, label: 'History', onTap: () {}),
                  _MoreTile(icon: Icons.savings_rounded, label: 'Save', onTap: () {}),
                  _MoreTile(icon: Icons.school_rounded, label: 'Loan', onTap: () {}),
                  _MoreTile(icon: Icons.qr_code_rounded, label: 'QR Pay', onTap: () {}),
                  _MoreTile(icon: Icons.card_giftcard_rounded, label: 'Rewards', onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.theme.colors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.theme.colors.border),
            ),
            child: Icon(icon, color: context.theme.colors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.foreground),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
