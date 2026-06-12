# State Management

State management is handled using **Bloc (Cubit)**.

## Auth

* LoginCubit
* RegisterCubit
* ForgotPasswordCubit
* VerifyResetOtpCubit
* ResetPasswordCubit

## User

* EmergencyRequestCubit
* ProfileCubit

## Paramedic

* DashboardCubit
* ActiveCaseCubit
* HistoryCubit
* ProfileCubit

## Global

* LocaleCubit (language)
* ThemeCubit (theme)

---

## Rules

* Each feature has its own Cubit
* Cubits call UseCases, not repositories directly
* UI listens via BlocBuilder / BlocListener
