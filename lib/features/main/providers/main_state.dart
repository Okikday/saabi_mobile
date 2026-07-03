import 'package:flutter/material.dart';
import 'package:saabi_mobile/features/main/ui/screens/tabs/home_tab.dart';
import 'package:saabi_mobile/features/main/ui/screens/tabs/rounds_tab.dart';
import 'package:saabi_mobile/features/main/ui/screens/tabs/saabi_tab.dart';

/// State for the main shell — holds tab index, screens, and init status.
class MainState {
  final bool isLoading;
  final int tabIndex;
  final bool hasInitialized;
  final List<Widget> screens;

  MainState({this.isLoading = false, this.tabIndex = 0, this.hasInitialized = false}) : screens = _mainScreens;

  MainState._({required this.isLoading, required this.tabIndex, required this.hasInitialized, required this.screens});

  MainState copyWith({bool? isLoading, int? tabIndex, bool? hasInitialized}) {
    return MainState._(
      isLoading: isLoading ?? this.isLoading,
      tabIndex: tabIndex ?? this.tabIndex,
      hasInitialized: hasInitialized ?? this.hasInitialized,
      screens: screens,
    );
  }

  static const List<Widget> _mainScreens = [HomeTab(), SaabiTab(), RoundsTab()];
}
