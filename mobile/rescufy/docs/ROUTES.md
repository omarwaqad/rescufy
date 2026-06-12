# Routes

## Core

| Route       | Screen           |
| ----------- | ---------------- |
| /           | Splash           |
| /onboarding | OnBoardingScreen |
| /login      | LoginScreen      |
| /signup     | RegisterScreen   |

## Password Reset

| Route             | Screen               |
| ----------------- | -------------------- |
| /forgot-password  | ForgotPasswordScreen |
| /verify-reset-otp | VerifyResetOtpScreen |
| /reset-password   | ResetPasswordScreen  |

## Role-Based Navigation

After login, navigation depends on user type:

* Normal User → /user-home
* Paramedic → /paramedic

This logic is handled during app startup (Splash logic).


## User Module

| Route           | Screen               |
| --------------- | -------------------- |
| /user-home      | HomeScreen           |
| /emergency-form | EmergencyFormBuilder |
| /user/history   | RequestHistoryScreen |
| /user/profile   | ProfileScreen        |
| /language       | LanguageScreen       |

## Paramedic Module

| Route                  | Screen                    |
| ---------------------- | ------------------------- |
| /paramedic             | ParamedicNavigationScreen |
| /paramedic/dashboard   | DashboardScreen           |
| /paramedic/active-case | ActiveCaseScreen          |

---

## Notes

* All routes are defined in AppRoutes
* Navigation is handled via AppRouter only
* Arguments are passed using RouteSettings
