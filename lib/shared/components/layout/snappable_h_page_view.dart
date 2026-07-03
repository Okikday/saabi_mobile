import 'package:flutter/material.dart';

class SnappableHPageView extends StatefulWidget {
  const SnappableHPageView({
    super.key,
    required this.itemCount,
    required this.builder,
    this.viewPortFraction,
    this.onPageChanged,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) builder;
  final void Function(int index)? onPageChanged;
  final double? viewPortFraction;

  @override
  State<SnappableHPageView> createState() => _SnappableHPageViewState();
}

class _SnappableHPageViewState extends State<SnappableHPageView> {
  late final PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: widget.viewPortFraction ?? 1.0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: widget.onPageChanged,
      controller: pageController,
      itemCount: widget.itemCount,
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      padEnds: false,
      itemBuilder: widget.builder,
    );
  }
}
