import 'package:kickin_utilities/kickin_utilities.dart';
import 'package:flutter/material.dart';

class AnimatedSizing extends StatelessWidget {
  final Duration? duration;
  final Curve? curve;
  final Widget child;
  const AnimatedSizing({super.key, this.duration, this.curve, required this.child});
  factory AnimatedSizing.fast({required Widget child}) {
    return AnimatedSizing(duration: 400.inMs, child: child);
  }

  factory AnimatedSizing.normal({required Widget child}) {
    return AnimatedSizing(child: child);
  }

  factory AnimatedSizing.slow({required Widget child}) {
    return AnimatedSizing(duration: 1000.inMs, child: child);
  }
  @override
  Widget build(BuildContext context) =>
      AnimatedSize(duration: duration ?? 700.inMs, curve: curve ?? KCurves.defaultIosSpring, child: child);
}

class Soome extends Curve {}
