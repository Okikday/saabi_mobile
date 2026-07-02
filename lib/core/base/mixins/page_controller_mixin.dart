import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

mixin PageControllerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
