# Workspace Rules & Guidelines

## State Management
- If state management occurs, it should be preferred via Riverpod (Pod structure), unless it is strictly local state that doesn't need to be accessed outside its widget.
- UI components should be highly modular. Avoid monolithic widgets; extract components into their own files.
