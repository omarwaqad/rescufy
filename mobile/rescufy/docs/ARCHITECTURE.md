# Architecture

The project follows a simplified **MVVM (Model-View-ViewModel)** approach using Cubit as the ViewModel.

---

## Layers

### 1. Presentation Layer (View + ViewModel)

* Contains UI and Cubits (acting as ViewModels)
* Handles user interaction, state, and validation
* Triggers data operations through repositories

Flow:
UI → ViewModel (Cubit) → Repository

---

### 2. Data Layer

* Contains:
  - Repository interfaces and implementations
  - Remote data sources (API via Dio)
  - Local data sources (secure storage)
  - Models and mappers

Flow:
ViewModel → Repository → DataSource → API

---

## Removed Domain Layer

* UseCases were removed to simplify the architecture
* Business logic is handled inside ViewModels (Cubits)
* Repository interfaces are kept for abstraction

---

## State Management

* Bloc (Cubit-based)
* Each feature has a ViewModel (Cubit)

Examples:
* AuthCubit (ViewModel)
* LoginCubit (form state)
* RegisterCubit
* EmergencyRequestCubit

---

## Dependency Injection

* Managed using GetIt
* Keeps layers loosely coupled
* ViewModels depend on repository abstractions

Flow:
Cubit → Repository → DataSource → Dio

* No direct instantiation inside UI or Cubits
* All dependencies registered in:
  core/di/injection_container.dart

---

## Navigation

* Centralized routing via:
  AppRouter
  AppRoutes

* No hardcoded route strings

---

## Network Layer

* Dio client
* Auth interceptor for token handling
* Error handling based on server response

---

## App Startup Flow

* Entry point: Splash Route (/)

Flow:

1. Splash checks if token exists
2. If NOT authenticated → Login
3. If authenticated:
  - User → User Home
  - Paramedic → Paramedic Shell