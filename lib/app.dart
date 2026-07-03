import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';
import 'package:saabi_mobile/shared/theme/app_theme.dart';
import 'package:saabi_mobile/shared/theme/logic/theme_pod.dart';

/// Root application widget.
///
/// Wraps [ProviderScope] for Riverpod, [MaterialApp.router] for GoRouter,
/// and [FTheme] for ForUI theming.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _SaabiApp());
  }
}

class _SaabiApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDark = ref.watch(themeModeProvider).value ?? true;

    return MaterialApp.router(
      routerConfig: router,
      title: 'Saabi Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark ? const Color(0xFF050505) : const Color(0xFFFAFAFA),
      ),
      builder: (context, child) => FTheme(
        data: isDark ? SaabiTheme.dark : SaabiTheme.light,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
