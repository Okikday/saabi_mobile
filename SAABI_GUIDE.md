# Saabi Plus Handoff Guide

This document is the working handoff for the Saabi Plus project. A new model should read this first, then consult the linked project docs and memory notes before making changes.

## Primary References

- [rules.md](rules.md) is the source of truth for architecture, widget conventions, documentation style, and repository behavior.
- [PROJECT_INIT.md](PROJECT_INIT.md) lists the initial copied/created files and their paths.
- [memories/repo/saabi_mobile.md](/memories/repo/saabi_mobile.md) contains durable repo-scoped notes and should be updated when project assumptions change.
- Flutter-specific skill guidance should be followed whenever relevant, especially for app structure, UI, layout, theming, tests, and Flutter package usage.
- The app should use ForUI for all visible UI going forward.

## Product Direction

- This is Saabi Plus, the identity and intelligence layer the informal economy is missing.
- It turns cashflow data (via WhatsApp & Nomba) into credit, savings circles, and a verified marketplace.
- The UI should stay simple, practical, and intuitive without tribal biases.
- Nomba APIs (Virtual Accounts, Collections, Transfers) power the financial backend. 
- There are no Gigs or Jobs in this version of the product.

## App Structure (3 Tabs)

The baseline app uses a `PageView` managed by a Riverpod Notifier (`MainPod`), NOT nested GoRouter `ShellRoute`.

1. **Home**: Dashboard. Wallet balance, live Credit Score gauge, Quick Actions (Send, Receive, Transfer), and Recent Transactions.
2. **Saabi**: The AI financial assistant. Natural-language interactions, transfers ("Send 5k to Adewale"), credit queries, expense tracking.
3. **Rounds**: Group savings circles (Ajo/Esusu/Adashe). Users can create/join groups to build trust score and credit history.

*Note: The Credit Score detail is a separate screen pushed from the Home tab, not a top-level tab.*

## UI System

- Use a modern premium dark mode by default, with light and dark theme support prepared from the start.
- Use the Saabi palette as the color source:
  - `darkBg` = `#050505`
  - `cardBg` = `#0D0D0D`
  - `accent` = `#E45D00`
  - `accentHover` = `#CC5200`
  - `premiumWhite` = `#FAFAFA`
- Current semantic color tokens live in [lib/shared/theme/src/app_colors.dart](lib/shared/theme/src/app_colors.dart).
- ForUI should be used for buttons, text fields, bottom sheets, cards, and other core controls whenever it already provides the needed component.
- If a custom widget exists for redundancy or compatibility, keep it only if it still compiles cleanly and does not fight the ForUI direction.
- Cards should prefer subtle borders over shadows.
- Buttons should generally be flat, low-elevation, and practical.
- Text fields should favor a filled style with a 12px radius.
- Typography direction: Space Grotesk for headers and numbers, Inter for body text.

## Architecture Rules

- Follow the folder and widget conventions in `rules.md`.
- Keep widgets small and reusable. Avoid duplicate UI elements.
- State-driven tab switching uses Riverpod `MainPod`, tracking `tabIndex`.
- Split a widget into private helpers when that improves clarity, but avoid unnecessary fragmentation.
- Prefer deterministic placement of screens, logic, and reusable UI.
- Use the modular feature layout when adding new product areas.
- Prefer `dart_mappable` for data models if a model is needed.
- Do not introduce `freezed`.

## Current App Shape

- The current app entrypoint is `lib/main.dart` which launches `App`.
- ForUI root structure uses `MaterialApp.router` + `FTheme`. 
- The existing core app files are:
  - [lib/app.dart](lib/app.dart)
  - [lib/main.dart](lib/main.dart)
  - [lib/features/splash.dart](lib/features/splash.dart)
  - [lib/features/main/ui/screens/main_shell_view.dart](lib/features/main/ui/screens/main_shell_view.dart) (PageView & Bottom Nav)

## Initial File Map

Use [PROJECT_INIT.md](PROJECT_INIT.md) for the full file inventory. The important groups are:

- App shell and splash.
- Shared layout, buttons, inputs, sheets, indicators.
- Shared dialogs and error page.
- Shared routing.
- Shared theme and semantic colors.
- Core helpers for assets, constants, Hive, storage paths, and UI utilities.
- Legacy `lib/dev/web_clone` files should be ignored.

## Working Rules For Future Changes

1. Before editing, inspect the current file contents if there is any chance they changed since the last pass.
2. Fix compile errors from the root cause, not by layering more temporary workarounds.
3. Prefer native ForUI widgets over custom wrappers when a suitable ForUI control exists.
4. Keep custom wrappers only when they still make sense for compatibility or redundancy.
5. Replace any stale `AppColors` references with the local semantic palette in `lib/shared/theme/src/app_colors.dart`.
6. Keep the app simple; avoid over-building navigation or nested dashboards.
7. Avoid duplicate elements (e.g. Wallet vs Home). Integrate logically.

## Validation Workflow

- After each meaningful edit, run the cheapest relevant validation for the touched slice.
- Prefer focused analyzer or test checks before broad workspace validation.
- If a first check fails, fix the same slice immediately and rerun the same check before widening scope.
- Do not leave the workspace in a broken state unless a genuine blocker prevents recovery.

## Documentation Maintenance

- Keep this guide updated as the project evolves.
- If a new architectural decision is made, add it here and, if relevant, in [memories/repo/saabi_mobile.md](/memories/repo/saabi_mobile.md).
- If new initial files are added, update [PROJECT_INIT.md](PROJECT_INIT.md).
- If theme tokens change, update both the guide and [lib/shared/theme/src/app_colors.dart](lib/shared/theme/src/app_colors.dart) notes.

## Notes For The Next Model

- Read this file, `rules.md`, `cache_progress.md` and `PROJECT_INIT.md` before editing anything.
- Check the repo memory note for persisted context.
- Follow Flutter skill guidance when the task concerns Flutter widgets, layout, testing, or theming.
- Tab management is State-driven, not Route-driven.
- Keep the UI simple and practical.
- Keep documentation current as you go.