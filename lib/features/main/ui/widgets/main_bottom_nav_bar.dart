import 'package:forui/forui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/shared/components/layout/app_padding.dart';

/// Bottom navigation bar for the main shell — Home, Saabi, Rounds.
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key, required this.currentIndex, required this.onTapItem});

  final int currentIndex;
  final void Function(int index) onTapItem;

  static const _labels = ['Home', 'Saabi', 'Rounds'];
  static const _icons = [HugeIconsStroke.home01, HugeIconsStroke.aiMagic, HugeIconsStroke.userGroup];
  static const _activeIcons = [HugeIconsSolid.home01, HugeIconsSolid.aiMagic, HugeIconsSolid.userGroup];

  @override
  Widget build(BuildContext context) {
    return BottomPadding(
      withHeight: 4,
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              constraints: BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                color: context.theme.colors.card.withValues(alpha: 0.8),
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: context.theme.colors.mutedForeground.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              clipBehavior: .antiAlias,
              child: BackdropFilter(
                filter: .blur(sigmaX: 2, sigmaY: 2),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: List.generate(3, (i) {
                      final isActive = i == currentIndex;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTapItem(i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isActive ? _activeIcons[i] : _icons[i],
                                color: isActive ? context.theme.colors.primary : context.theme.colors.mutedForeground,
                                size: 22,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _labels[i],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                  color: isActive ? context.theme.colors.primary : context.theme.colors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
