import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

/// Shows a bottom sheet to find and join a savings circle by invite code.
void showJoinCircleSheet(BuildContext context) {
  showFSheet(context: context, side: FLayout.btt, builder: (context) => const _JoinCircleSheet());
}

class _JoinCircleSheet extends StatefulWidget {
  const _JoinCircleSheet();

  @override
  State<_JoinCircleSheet> createState() => _JoinCircleSheetState();
}

class _JoinCircleSheetState extends State<_JoinCircleSheet> {
  String _code = '';
  bool _searching = false;
  bool _found = false;

  Future<void> _search() async {
    if (_code.trim().isEmpty) return;
    setState(() => _searching = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _searching = false;
      _found = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text(
            'Join a Circle',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the invite code from a circle admin.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 24),
          FTextField(
            control: FTextFieldControl.managed(onChange: (v) => setState(() => _code = v.text)),
            label: const Text('Invite Code'),
            hint: 'e.g. MKT-2025-XB7',
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            child: _found
                ? _FoundCircleCard(
                    onJoin: () {
                      Navigator.of(context).pop();
                      Routes.circleDetail.push(context);
                    },
                  )
                : const SizedBox(width: double.infinity),
          ),
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: _found ? null : (_searching ? null : _search),
              child: _searching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_found ? 'Circle Found ✓' : 'Find Circle'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundCircleCard extends StatelessWidget {
  const _FoundCircleCard({required this.onJoin});
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 18),
              const SizedBox(width: 8),
              Text(
                'Circle Found',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: const Color(0xFF4CAF50), fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'NextGen Savings Circle',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '8 of 10 slots filled • ₦25,000/week',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onJoin,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Join Now',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
