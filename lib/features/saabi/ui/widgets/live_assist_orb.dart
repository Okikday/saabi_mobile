import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/features/saabi/providers/live_assist_pod.dart';

class LiveAssistOrbOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const LiveAssistOrbOverlay({super.key, required this.child});

  @override
  ConsumerState<LiveAssistOrbOverlay> createState() => _LiveAssistOrbOverlayState();
}

class _LiveAssistOrbOverlayState extends ConsumerState<LiveAssistOrbOverlay> {
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liveAssistProvider);

    return Stack(
      children: [
        widget.child,
        if (state.isEnabled)
          Positioned(
            left: _position?.dx,
            right: _position == null ? 24 : null,
            bottom: _position?.dy == null ? 100 : null,
            top: _position?.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position = Offset(
                    (_position?.dx ?? (MediaQuery.of(context).size.width - 80)) + details.delta.dx,
                    (_position?.dy ?? (MediaQuery.of(context).size.height - 180)) + details.delta.dy,
                  );
                });
              },
              onTap: () {
                final notifier = ref.read(liveAssistProvider.notifier);
                if (state.isListening) {
                  notifier.stopListening();
                } else {
                  notifier.startListening();
                }
              },
              child: _OrbWidget(isListening: state.isListening),
            ),
          ),
      ],
    );
  }
}

class _OrbWidget extends StatelessWidget {
  final bool isListening;

  const _OrbWidget({required this.isListening});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.theme.colors.primary,
        boxShadow: [
          BoxShadow(
            color: context.theme.colors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: isListening ? 8 : 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isListening ? HugeIconsStroke.mic01 : HugeIconsStroke.micOff01,
          color: context.theme.colors.primaryForeground,
          size: 28,
        ),
      ),
    ).animate(target: isListening ? 1 : 0).scaleXY(end: 1.1, duration: 300.ms).then().shimmer(
      duration: 1.seconds,
      color: Colors.white24,
    );
  }
}
