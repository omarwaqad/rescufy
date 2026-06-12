# Authentication Flow

## Current State

* Token-based authentication
* Token stored using secure storage
* User session restored on app start

---

## Login Flow (MVVM)

1. User enters email and password
2. LoginCubit manages form state and validation
3. UI calls AuthCubit.login(...)
4. AuthCubit (ViewModel):
   - validates input
   - emits loading state
   - calls AuthRepository
5. Repository calls remote data source
6. Remote data source performs API request
7. Server response is returned
8. Repository maps response to User or Failure
9. AuthCubit emits:
   - AuthAuthenticated on success
   - AuthFailure on error
10. UI reacts:
- Navigate on success
- Show snackbar on error

---

## Register Flow

1. RegisterCubit manages form state
2. UI calls AuthCubit.register(...)
3. AuthCubit validates input
4. Calls AuthRepository
5. Repository → DataSource → API
6. Response returned and handled
7. AuthCubit emits result

---

## Session Restore Flow

1. App starts at Splash
2. Splash calls AuthCubit.restoreSession()
3. AuthCubit calls repository
4. Repository reads token from secure storage
5. If token exists:
   - user is reconstructed
   - emit AuthAuthenticated
6. If not:
   - emit AuthUnauthenticated

---

## Logout Flow

1. UI triggers logout
2. AuthCubit calls repository.logout()
3. Repository clears token from storage
4. AuthCubit emits AuthUnauthenticated
5. UI navigates to Login

---

## User Roles

* User → requests emergency help
* Paramedic → handles active cases