# Workspace Rules & Guidelines

## State Management
- If state management occurs, it should be preferred via Riverpod (Pod structure), unless it is strictly local state that doesn't need to be accessed outside its widget.
- UI components should be highly modular. Avoid monolithic widgets; extract components into their own files.
- The rules should be in the project's root rules.md, and you can combine that with the flutter skills.

## UI Widgets Framework
- ALWAYS prefer using `forui` widgets (like `FTextField`, `FButton`, `FCard`, etc.) over native Flutter Material widgets whenever possible. This prevents layout issues (like `RenderFlex` errors inside forms) and ensures strict alignment with the project's UI design system.
