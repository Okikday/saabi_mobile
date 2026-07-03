# Progress

## Current Focus
- Built out the new tab structure (Home, Saabi, Rounds) driven by PageView/MainPod state rather than routing.
- Integrated wallet and credit score onto the Home tab.

## Done
- Repo rules and ForUI guidance captured in [SAABI_GUIDE.md](SAABI_GUIDE.md).
- Initial copied file inventory captured in [PROJECT_INIT.md](PROJECT_INIT.md).
- Shared semantic colors were restored in [lib/shared/theme/src/app_colors.dart](lib/shared/theme/src/app_colors.dart).
- Stale shared-layer compile errors were cleared.
- ForUI-based app shell built and wired:
  - [lib/app.dart](lib/app.dart) — MaterialApp.router + FTheme with SaabiTheme.dark.
  - [lib/main.dart](lib/main.dart) — bootstraps `App`.
  - [lib/shared/theme/app_theme.dart](lib/shared/theme/app_theme.dart) — `SaabiTheme` with `FColors` + `FTypography` (Inter body / Space Grotesk display).
  - [lib/features/splash.dart](lib/features/splash.dart) — branded splash with fade-in animation, navigates to `/main`.
  - [lib/features/main/ui/screens/main_shell_view.dart](lib/features/main/ui/screens/main_shell_view.dart) — shell with `PageView` for tab switching, driven by `MainPod` state.
  - [lib/shared/routes/src/main_route.dart](lib/shared/routes/src/main_route.dart) — Main route registered.
  - [lib/shared/routes/app_router.dart](lib/shared/routes/app_router.dart) — main shell route registered.
  - Tab screens created: [home_view.dart](lib/features/home/ui/screens/home_view.dart), [rounds_view.dart](lib/features/rounds/ui/screens/rounds_view.dart), [saabi_view.dart](lib/features/saabi/ui/screens/saabi_view.dart).
  - Credit score detail screen created: [credit_detail_view.dart](lib/features/credit/ui/screens/credit_detail_view.dart) (pushed from Home view).
- Restructured architecture implemented successfully, completely removing duplicate wallet and chat logic.
- `flutter analyze` passes with no issues.

## In Progress
- (nothing active)

## Next
- Add real backend content integration to Home, Rounds, Saabi views.
- Wire auth flow (sign-in, onboarding) — auth is handled last per project direction.
- Keep the progress file updated after each meaningful step.
