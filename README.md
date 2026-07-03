# Saabi Plus

Saabi Plus is the identity and intelligence layer the informal economy is missing. For millions of informal traders, cashflow and transactional data remain invisible to modern financial systems. Saabi Plus uses AI to turn this unstructured financial behavior into verified credit, seamless group savings, and intelligent transfers.

## Core Features

- **Saabi (AI Agent):** A smart assistant that lives in your chat, understanding natural language intents (e.g., "Send 10k to Okikiola") and transforming them into seamless, multi-step transaction UI flows.
- **Credit Score:** As users make transfers, save in circles, and interact with the app, their credit score is dynamically calculated, bridging the gap between informal cash flow and formalized lending.
- **Rounds (Ajo/Esusu/Adashe):** A dedicated group savings feature allowing users to form savings circles, track payouts, and manage their turns transparently.
- **Smart Transfers:** A professional, PalmPay-inspired transfer flow that breaks down sending money into intuitive steps (Recipient, Amount/Remark, Reminder, and Payment Summary).

## Architecture & Tech Stack

- **Framework:** Flutter
- **Routing:** `go_router` shell architecture for seamless tab switching.
- **State Management:** `flutter_riverpod` combined with custom `KCachedNotifier` for persistent, synchronous state (e.g., Theme configuration).
- **UI System:** `forui` design system, featuring highly customized dark and light semantic themes, smooth micro-animations (`AnimatedContainer`, `AnimatedSwitcher`), and glassmorphism.
- **Local Storage:** `hive` for lightweight persistent storage (e.g., `themeMode`, `lastPausedRoute`).

## Getting Started

1. Run `flutter pub get` to install dependencies.
2. Run `flutter run` to launch the application.
