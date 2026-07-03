// import 'package:flutter/material.dart';

// /// A widget that animates smoothly between two child widgets
// class SwapAnimator extends StatefulWidget {
//   final Widget oldWidget;
//   final Widget newWidget;
//   final bool showNew;
//   final Duration duration;
//   final Curve curve;

//   const SwapAnimator({
//     super.key,
//     required this.oldWidget,
//     required this.newWidget,
//     required this.showNew,
//     this.duration = const Duration(milliseconds: 600),
//     this.curve = Curves.easeInOut,
//   });

//   @override
//   State<SwapAnimator> createState() => _SwapAnimatorState();
// }

// class _SwapAnimatorState extends State<SwapAnimator> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: widget.duration, vsync: this);
//     _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

//     if (widget.showNew) {
//       _controller.value = 1.0;
//     }
//   }

//   @override
//   void didUpdateWidget(SwapAnimator oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.showNew != oldWidget.showNew) {
//       if (widget.showNew) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     }
//     if (widget.duration != oldWidget.duration) {
//       _controller.duration = widget.duration;
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             // Old widget (fades out and scales down)
//             Opacity(
//               opacity: 1.0 - _animation.value,
//               child: Transform.scale(scale: 1.0 - (_animation.value * 0.1), child: widget.oldWidget),
//             ),
//             // New widget (fades in and scales up)
//             Opacity(
//               opacity: _animation.value,
//               child: Transform.scale(scale: 0.9 + (_animation.value * 0.1), child: widget.newWidget),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
