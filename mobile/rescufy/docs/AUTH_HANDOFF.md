# Auth Handoff

This file summarizes the authentication implementation using MVVM architecture.

---

## Architecture

The auth flow follows:

UI → Cubit (ViewModel) → Repository → DataSource → API

* Cubits act as ViewModels
* Business logic is handled inside Cubits
* No UseCase layer

---

## Responsibilities

### AuthCubit (ViewModel)

Handles:
- login
- register
- restore session
- logout
- authentication state
- current user

---

### LoginCubit

Handles:
- email/password state
- validation
- UI-related state (visibility, errors)

---

### RegisterCubit

Handles:
- form inputs
- validation
- UI state

---

## Login Flow

1. UI updates LoginCubit
2. UI calls AuthCubit.login(...)
3. AuthCubit validates input
4. Calls AuthRepository
5. Repository calls remote data source
6. Data source performs API request
7. Response returned
8. AuthCubit emits state
9. UI reacts

---

## Session Persistence

* Token stored in secure storage
* User cached locally
* Session restored on app launch

---

## Navigation

Handled via:
- AppRouter
- RoleHomeRouteMapper

---

## DI

Registered in:
core/di/injection_container.dart

Includes:
- Dio
- DataSources
- Repositories
- Cubits

---

## Notes

* UI contains no business logic
* Cubits act as single source of truth for state
* Repository abstracts data access