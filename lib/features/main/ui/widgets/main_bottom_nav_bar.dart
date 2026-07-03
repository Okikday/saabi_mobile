import 'package:forui/forui.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar for the main shell — Home, Saabi, Rounds.
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTapItem,
  });

  final int currentIndex;
  final void Function(int index) onTapItem;

  static const _labels = ['Home', 'Saabi', 'Rounds'];
  static const _icons = [
    Icons.home_outlined,
    Icons.auto_awesome_outlined,
    Icons.group_outlined,
  ];
  static const _activeIcons = [
    Icons.home_rounded,
    Icons.auto_awesome_rounded,
    Icons.group_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
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
    );
  }
}
