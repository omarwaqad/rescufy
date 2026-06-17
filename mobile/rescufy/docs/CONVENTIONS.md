# Conventions

## Naming

* Screens → *Screen
* Cubits → *Cubit
* States → *State

---

## Architecture Rules

* UI must NOT call repositories directly
* UI → ViewModel (Cubit) → Repository → DataSource
* No business logic inside UI
* Cubits act as ViewModels

---

## SOLID Guidelines

### Single Responsibility
* Cubits handle state and flow
* Repositories handle data logic
* DataSources handle API/storage

### Dependency Inversion
* Cubits depend on repository interfaces
* No direct dependency on implementations

### Keep It Simple
* Avoid unnecessary layers
* Do not reintroduce UseCases
* Keep architecture readable and maintainable

---

## Navigation

* Use AppRoutes only
* No hardcoded route strings
* Navigation handled via AppRouter

---

## Dependency Injection

* Use GetIt
* Register all dependencies in injection_container.dart
* No manual instantiation inside UI

---

## Networking

* All API calls go through DioClient
* Handle errors using server response

---

## Folder Structure

* presentation/
    - views/
    - cubits/

* data/
    - repositories/
    - datasources/
    - models/

---

## Code Quality

* Keep widgets small
* Avoid large Cubits (split when needed)
* Keep logic readable

## Responsive

*use flutter_screenutil