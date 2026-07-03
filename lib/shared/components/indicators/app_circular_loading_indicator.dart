// import 'package:flutter/widgets.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:kickin_utilities/kickin_utilities.dart';
// import 'package:saabi_mobile/core/assets/assets.gen.dart';

// class AppCircularLoadingIndicator extends StatelessWidget {
//   final double dimension;
//   final bool isLoading;
//   final Widget? child;
//   const AppCircularLoadingIndicator({super.key, this.dimension = 48, this.isLoading = true, this.child});

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       final loader = Center(
//         child: Image.asset(
//           Assets.icons.loading,
//           width: dimension,
//           height: dimension,
//         ).animate(onComplete: (controller) => controller.repeat()).rotate(duration: 2000.0.inMs, begin: 1, end: 0),
//       );
//       if (child == null) return loader;
//       return Stack(
//         children: [
//           IgnorePointer(child: child!),
//           loader,
//         ],
//       );
//     }
//     return child ?? const SizedBox.shrink();
//   }
// }
