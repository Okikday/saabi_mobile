# Cache Progress

This file records context a future model should know before making changes.
Last updated: 2026-07-03

---

## App Shell (Completed)

### What was built
- `lib/app.dart` — root `App` widget. Uses `ProviderScope` → `MaterialApp.router` → `FTheme` wrapper. **No FApp class exists in ForUI 0.23.x.**
- `lib/main.dart` — bootstraps `App`, no longer references the old `web_clone` shell.
- `lib/shared/theme/app_theme.dart` — `SaabiTheme` abstract class with `dark` and `light` static getters returning `FThemeData`.
- `lib/features/main/ui/screens/main_shell_view.dart` - `MainScreen` is completely state driven (`MainPod`) via `PageView`, not dependent on GoRouter for tab switching.

### ForUI 0.23.x API Notes (critical for future models)

- **No `FApp` widget** — use `MaterialApp.router` + `FTheme` wrapper in the `builder` param.
- **`FThemeData` constructor**: takes `colors: FColors(...)` and `touch: bool`. No `materialTheme` or `colorScheme` params.
- **`FColors` constructor**: takes `brightness`, `systemOverlayStyle`, `barrier`, `background`, `foreground`, `primary`, `primaryForeground`, `secondary`, `secondaryForeground`, `muted`, `mutedForeground`, `destructive`, `destructiveForeground`, `error`, `errorForeground`, `card`, `border`.
- **`FTypography`**: has `display` and `body` fields of type `FTypeface`. Use `FTypeface.inherit(colors: colors, touch: touch, fontFamily: '...')` to set a custom font.
- **`FScaffold`**: takes `child` (required Widget), `header` (optional Widget), `footer` (optional Widget), `sidebar` (optional Widget). **No `content` param.**

### Routing

- No `ShellRoute` anymore. Main routing is handled at `lib/shared/routes/src/main_route.dart`.
- Tab navigation is strictly handled by Riverpod (`MainPod`) and `PageView`.
- Routes enum has: `splash`, `onboarding`, `main`, `creditDetail`, `emptyState`, `testScreen`.

### Splash

- `lib/features/splash.dart` — branded fade-in, 1.5 s delay, then `Routes.main.go(...)`. Auth redirect logic is intentionally commented out — auth is handled last per product direction.

### Tab screens

- `lib/features/home/ui/screens/home_view.dart` — Central dashboard. Includes Wallet Balance, Credit Score Gauge, Quick Actions.
- `lib/features/saabi/ui/screens/saabi_view.dart` — AI financial assistant. Natural language tasks.
- `lib/features/rounds/ui/screens/rounds_view.dart` — Savings Circles (Ajo/Esusu).

### Detail Screens

- `lib/features/credit/ui/screens/credit_detail_view.dart` — Full detailed view of the Credit Score. Pushed from the `HomeView`.

### What's next
1. Build real content in each tab view.
2. Auth flow (sign-in / onboarding) — explicitly deferred to last.
3. Incorporate actual API logic and endpoints.
