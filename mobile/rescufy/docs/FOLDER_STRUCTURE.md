# Folder Structure

This document describes the current repository structure and the purpose of the main folders.

## Root

```text
rescufy/
|- android/                  Native Android project
|- assets/                   Static app assets
|- docs/                     Project documentation
|- ios/                      Native iOS project
|- lib/                      Main Flutter application source
|- test/                     Automated tests
|- .dart_tool/               Generated Dart/Flutter tooling files
|- build/                    Generated build output
|- .idea/                    IDE project settings
|- .agents/                  Local agent and workflow metadata
|- pubspec.yaml              Flutter package manifest
|- pubspec.lock              Resolved package versions
|- README.md                 Project overview
```

## Assets

```text
assets/
|- fonts/                    Custom fonts
|- images/                   Raster image assets
|- svgs/                     SVG icons and illustrations
```

## Documentation

```text
docs/
|- ARCHITECTURE.md           Architecture overview
|- AUTH_FLOW.md              Authentication flow reference
|- AUTH_HANDOFF.md           Auth implementation notes
|- CONVENTIONS.md            Project conventions
|- FOLDER_STRUCTURE.md       This document
|- PROGRESS.MD               Progress tracking
|- RESCUFY_PRD.MD            Product requirements
|- ROUTES.md                 Route map
|- STATE_MANAGEMENT.md       Cubit and state management notes
```

## Application Source

```text
lib/
|- core/                     App-wide infrastructure and shared foundations
|  |- constants/             Shared constant values
|  |- cubit/                 Global app-level cubits
|  |  |- locale/             Language state management
|  |  |- theme/              Theme mode state management
|  |- di/                    Dependency injection setup
|  |- helpers/               Utility helpers used across features
|  |- navigation/            Router and route definitions
|  |- network/               HTTP client and API configuration
|  |  |- endpoints/          API endpoint definitions
|  |- services/              External and platform-facing services
|  |  |- signalr/            Real-time connection services
|  |- theme/                 Design tokens and theme styling
|- data/                     Data access and concrete implementations
|  |- datasources/           Local and remote data providers
|  |  |- local/              Secure storage and local persistence
|  |  |- remote/             API-facing remote data sources
|  |- mappers/               Model/entity mapping helpers
|  |- models/                API and storage models
|  |  |- medical_profile/    Medical and profile-related models
|  |- repositories/          Repository implementations
|- domain/                   Core business contracts and entities
|  |- core/                  Shared domain-level primitives
|  |- entities/              Domain entities
|  |- repositories/          Repository abstractions
|- l10n/                     Localization source files
|- presentation/             UI screens, cubits, and feature widgets
|  |- auth/                  Authentication feature
|  |  |- cubit/              Auth feature state management
|  |  |- views/              Auth screens
|  |  |- widgets/            Auth-specific UI pieces
|  |- onboarding/            Onboarding flow
|  |  |- widgets/            Onboarding UI parts
|  |- paramedic/             Paramedic-facing features
|  |  |- active_case/        Active emergency case flow
|  |  |- dashboard/          Paramedic dashboard
|  |  |- history/            Request history for paramedics
|  |  |- incoming_request/   Incoming request handling
|  |  |- paramedic_shell/    Paramedic navigation shell
|  |  |- profile/            Paramedic profile screens
|  |- settings/              App settings
|  |  |- language/           Language settings UI
|  |- splash/                App startup and entry flow
|  |- user/                  User-facing features
|  |  |- history/            User request history
|  |  |- home/               User home dashboard
|  |  |- profile/            User profile and medical info
|  |  |- request/            Emergency request flow
|  |  |- shell/              User navigation shell
|- shared/                   Reusable UI and shared utilities
|  |- utils/                 Cross-feature utility helpers
|  |- widgets/               Reusable widgets
|  |  |- buttons/            Shared button components
|  |  |- common/             General-purpose widgets
|  |  |- dialogs/            Shared dialog components
|  |  |- inputs/             Shared input fields
|  |  |- navigation/         Shared navigation widgets
```

## Platform Folders

```text
android/                     Android runner, Gradle config, and native setup
ios/                         iOS runner, Xcode config, and native setup
```

## Generated and Local-Only Folders

These folders are usually not edited directly as part of feature work:

```text
.dart_tool/                  Flutter and Dart generated metadata
build/                       Compiled build output
.idea/                       IDE-specific settings
.agents/                     Local automation and agent metadata
```
