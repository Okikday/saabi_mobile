import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saabi_mobile/core/base/extensions/src/extension_on_provider.dart';
import 'package:saabi_mobile/features/main/providers/main_pod.dart';
import 'package:saabi_mobile/features/main/ui/widgets/main_bottom_nav_bar.dart';
import 'package:saabi_mobile/shared/theme/src/app_colors.dart';

/// Root screen wrapping all 3 main tabs via [PageView].
///
/// Tab switching is state-driven (via [MainPod]), not route-driven.
/// The [PageController] animates between pages, and [MainPod.me] tracks
/// the current index. Routes are reserved for pushing detail screens.
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with AutomaticKeepAliveClientMixin {
  final pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageController.addListener(_pageListener);
  }

  void _pageListener() {
    MainPod.me.not(ref).setTabIndex(pageController.page?.round() ?? 0);
  }

  @override
  void dispose() {
    pageController.removeListener(_pageListener);
    pageController.dispose();
    super.dispose();
  }

  void _animateToTab(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(MainPod.me, (previous, next) {
      if (previous?.tabIndex != next.tabIndex) {
        final isScrolling = pageController.position.isScrollingNotifier.value;
        if (!isScrolling) _animateToTab(next.tabIndex);
      }
    });

    final screens = MainPod.me.select((s) => s.screens).watch(ref);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: PageView(
        controller: pageController,
        children: screens,
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final tabIndex = MainPod.me.select((s) => s.tabIndex).watch(ref);
          return MainBottomNavBar(
            currentIndex: tabIndex,
            onTapItem: (index) {
              if (MainPod.me.read(ref).tabIndex == index) {
                // Tapping the active tab scrolls to top
                PrimaryScrollController.of(context).animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              }
              _animateToTab(index);
              MainPod.me.not(ref).setTabIndex(index);
            },
          );
        },
      ),
    );
  }
}
