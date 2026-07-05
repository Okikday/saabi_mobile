# Saabi Plus

Saabi Plus is the identity and intelligence layer the informal economy is missing. For millions of informal traders, cashflow and transactional data remain invisible to modern financial systems. Saabi Plus uses AI to turn this unstructured financial behavior into verified credit, seamless group savings, and intelligent transfers.

## Core Features

- **Saabi (AI Agent):** A smart assistant that lives in your chat, understanding natural language intents (e.g., "Send 10k to Okikiola", "Check my balance", "Verify this receipt"). It transforms conversational requests into seamless, multi-step, dynamic transaction UI flows locally and securely.
- **Credit Score:** As users make transfers, save in circles, and interact with the app, their credit score is dynamically calculated. This bridges the gap between informal cash flow and formalized lending, creating a reliable metric for creditworthiness.
- **Rounds (Ajo/Esusu/Adashe):** A dedicated group savings feature allowing users to form savings circles, track payouts, and manage their turns transparently. This brings the traditional informal savings structure into a formalized, trackable digital ledger.
- **Smart Transfers:** A professional, multi-step transaction flow that breaks down sending money into intuitive, highly styled steps (Recipient, Amount, Description, and Payment Summary). All backed by state-of-the-art UI elements including glassmorphism, dynamic animations, and intuitive error handling.
- **Actionable Transaction History:** Robust and searchable transaction tracking enabling instant insights into spending behavior.
- **Offline/On-Device Intelligence:** Fallbacks for NLP capabilities via Regex ensure that Saabi remains functional across devices (including macOS compatibility) when ML Kits are unsupported or offline.

## Nomba API Integration

Saabi Plus heavily leverages the robust **Nomba API** to power its entire financial infrastructure and secure processing:
- **Transfers API:** Facilitates seamless, instantaneous peer-to-peer and bank transfers initiated through the AI chat or standard UI. It powers the core movement of capital.
- **Virtual Accounts API:** Automates and powers the Rounds (Ajo) feature. It handles the creation of isolated virtual accounts for circles, allowing automated recurring deposits from group members into a centralized circle vault.
- **Identity & Verification:** Validates informal user identities and ties them to verified financial data using Nomba's ecosystem, powering the intelligence layer.

## Architecture & Tech Stack

- **Framework:** Flutter
- **Routing:** `go_router` shell architecture for seamless tab switching and deeplinking.
- **State Management:** `flutter_riverpod` combined with custom Pods (e.g., `TransactionFlowPod`) for predictable, scalable state tracking, alongside `KCachedNotifier` for persistent, synchronous state (e.g., Theme configuration).
- **UI System:** Custom design system heavily utilizing `forui`, featuring highly customized dark and light semantic themes, smooth micro-animations (`AnimatedContainer`, `AnimatedSwitcher`), and deep glassmorphic layers.
- **Local Storage:** `isar` for structured local relational data (like Chat Sessions and Intents) and `hive` for lightweight persistent key-value storage.

## Getting Started

1. Run `flutter pub get` to install dependencies.
2. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate routing and Isar schema code.
3. Run `flutter run` to launch the application.
