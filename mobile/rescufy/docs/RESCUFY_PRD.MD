# Rescufy Product Requirements Document

## 1. Product Overview

### Product Name

Rescufy

### Description

Rescufy is a mobile emergency response application for two active mobile roles:

- Patients/general users who request an ambulance for themselves or report an emergency for someone else.
- Paramedics/ambulance drivers who receive emergency assignments, review patient and case context, accept or reject requests, navigate to the patient, broadcast their live location, and update case progress.

The current Flutter application includes authentication, role-based routing, emergency request creation, GPS-based location detection, medical profile management, paramedic real-time workflows, and bilingual English/Arabic UI support.

### Vision

Rescufy aims to reduce emergency response friction by connecting people in distress with paramedics through fast location capture, real-time dispatch, and immediately available medical context.

### Problem Statement

During emergencies, users may be panicked, injured, unable to communicate clearly, or unable to remember critical medical information. Paramedics need fast dispatch, accurate location, case severity, medical risk context, and live status coordination to respond effectively.

Rescufy addresses this by allowing users to request help with minimal steps while giving paramedics a structured emergency workflow.

### Current Product Caveats

- Real-time workflows are designed around SignalR, but dependency injection currently registers `MockSignalRService`. The production hub URL exists in code, but the real service is not currently wired.
- User-side live ambulance tracking is implied by the UI after request submission, but the current "Track" action routes to request history rather than a true live tracking screen.
- Notifications are represented in UI labels/icons, but no push notification provider, local notification handling, or notification screen is implemented.
- Admin access is not supported in the mobile app. The app includes an admin-blocked dialog that directs admins to a web dashboard.

## 2. Goals and KPIs

| Goal | KPI |
| --- | --- |
| Reduce dispatch delay | Time from request submission to paramedic receiving the request |
| Improve emergency request reliability | Request creation success rate |
| Improve real-time operational reliability | SignalR connection success rate, reconnect success rate, event delivery latency |
| Improve paramedic response speed | Time from incoming request to accept/reject decision |
| Improve patient safety | Percentage of emergency requests with complete medical profile data |
| Increase user trust | Successful confirmation rate, low location failure rate, clear status visibility |
| Improve response outcomes | Case completion rate, average response time, cancellation/rejection rate |

## 3. User Personas

### Patient / General User

**Context:** A person in a high-stress medical emergency, either requesting help for themselves/family or reporting an incident they witnessed.

**Needs:**

- Request help quickly.
- Auto-detect accurate location.
- Describe what happened in plain language.
- Maintain critical medical information before emergencies happen.
- Receive confirmation that help is coming.

**Pain points:**

- Panic and limited ability to type.
- Uncertainty about exact address.
- Inability to remember medications, allergies, or chronic conditions.
- Anxiety after submitting a request without clear tracking/status.

### Ambulance Driver / Paramedic

**Context:** A field responder receiving emergency assignments while on shift.

**Needs:**

- Receive emergency requests in real time.
- Know severity, patient details, emergency type, location, assigned hospital, and medical risks.
- Accept or reject assignments quickly.
- Navigate to patient location.
- Broadcast live location and update case status.

**Pain points:**

- Incomplete medical context.
- Delayed assignment visibility.
- GPS inaccuracies.
- Poor connectivity during response.
- Lack of clarity when a request is cancelled or reassigned.

### Admin / Dispatcher

**Assumption:** Admin/dispatcher exists outside this mobile app, likely in a web dashboard. The mobile app blocks admin access.

**Needs:**

- Monitor incoming emergency requests.
- Assign or supervise ambulances.
- Track active cases and response metrics.
- Manage operational users and coverage.

**Pain points:**

- No mobile admin workflow is currently implemented.
- Dispatcher capabilities are not visible in this Flutter project.

## 4. Features and Functional Requirements

### 4.1 Authentication and Role-Based Access

**Description:** Users can register, login, restore sessions, logout, and reset passwords using OTP. JWT tokens are stored in secure storage. Role data is decoded from backend/JWT payload and routed to either the user experience or paramedic experience.

**Roles supported in mobile:**

- `user`
- `paramedic`
- `ambulanceDriver`, mapped internally to paramedic

**User story:** As a user or paramedic, I want to securely log in and be routed to the correct app experience for my role.

**Acceptance criteria:**

- User can login with email and password.
- User can register with name, email, username, password, national ID, age, gender, and optional profile image.
- Auth token and user data are saved in secure storage.
- Existing session can be restored from stored JWT.
- User role determines the home route.
- User can start password reset, verify OTP, and set a new password.
- Admin users are blocked from mobile access and directed to the web dashboard.

### 4.2 Emergency Request Creation

**Description:** Users can create an emergency request for themselves/family or report an emergency for others. The app captures a description, detects current GPS location, reverse-geocodes an address, and submits the request to the backend.

**User story:** As a patient or bystander, I want to send an emergency request with my location so help can be dispatched quickly.

**Functional requirements:**

- User can choose between "Request Ambulance" and "Report Emergency".
- App detects high-accuracy location using device GPS.
- App reverse-geocodes latitude/longitude into a readable address.
- User must provide an emergency description.
- User can optionally provide number of affected people.
- Backend request includes:
  - Description
  - Self-case flag
  - Latitude
  - Longitude
  - Address
  - People count, if provided

**Acceptance criteria:**

- Request form starts location detection automatically.
- Submit is blocked if location is unavailable.
- Submit is blocked if description is empty.
- User can refresh location detection.
- Successful submission displays ambulance ID and ETA when returned.
- If backend response does not include ambulance ID or ETA, fallback display values are currently used.
- Failed submission displays a clear error message.

### 4.3 Emergency Request Cancel / Update

**Description:** The real-time layer includes a request cancellation event for paramedics, and user history mock data includes cancelled requests.

**User story:** As a user, I want to cancel an emergency request if it was submitted by mistake or no longer needed.

**Acceptance criteria:**

- **Current state:** Not implemented for users in the mobile app.
- **Assumption:** Backend or dispatcher may emit cancellation events to paramedics through SignalR.
- Future implementation should allow user-side cancellation while request is pending or before arrival.

### 4.4 Paramedic Dashboard and Availability

**Description:** Paramedics have a dashboard that shows online availability and SignalR connection state. Incoming requests are pushed to the dashboard and open the incoming request review screen.

**User story:** As a paramedic, I want to control my availability and receive emergency requests while online.

**Functional requirements:**

- Display availability status.
- Allow paramedic to toggle online/offline availability.
- Display SignalR state:
  - Disconnected
  - Connecting
  - Connected
  - Reconnecting
- Listen for incoming emergency request events.
- Clear incoming request after review flow finishes.

**Acceptance criteria:**

- Dashboard initializes real-time connection.
- Incoming request opens the review screen.
- Request cancellation clears pending request state.
- Connection failure displays an inline error.

### 4.5 Incoming Request Review

**Description:** Paramedics review emergency assignments before accepting or rejecting. The request includes patient details, emergency type, severity, address, assigned hospital, AI summary, allergies, chronic diseases, current medications, and blood type when available.

**User story:** As a paramedic, I want to review the patient and emergency context before accepting the case.

**Functional requirements:**

- Show severity badge.
- Show case ID.
- Show patient name, age, gender.
- Show emergency type and description.
- Show patient address and approximate distance.
- Show assigned hospital.
- Show clinical snapshot:
  - AI summary
  - Allergies
  - Chronic diseases
  - Current medications
  - Blood type
- Allow accept.
- Allow reject with reason.
- Respond to cancellation event.

**Acceptance criteria:**

- Accept invokes SignalR `AcceptRequest`.
- Reject invokes SignalR `RefuseRequest`.
- Accepted request navigates to active case.
- Rejected or cancelled request returns to paramedic shell.
- Errors are displayed as snackbars.

### 4.6 Active Case Workflow

**Description:** After accepting a request, paramedics enter an active case screen. The app joins a live case group, receives case updates, broadcasts paramedic location every 3 seconds, displays patient and case data, and allows status progression.

**User story:** As a paramedic, I want to update my progress through the emergency response lifecycle so the system and stakeholders know the case status.

**Case statuses:**

- Pending
- On The Way
- Arrived
- Treatment Started
- Completed

**Functional requirements:**

- Join case-specific SignalR group.
- Listen for `CaseUpdated` events.
- Broadcast paramedic GPS location every 3 seconds.
- Display live status message and last updated time.
- Show patient location and paramedic current coordinates.
- Open external navigation to patient coordinates through Google Maps.
- Allow status updates:
  - Arrived
  - Start Treatment
  - Complete Case

**Acceptance criteria:**

- Case group join failure shows an error view.
- Location broadcast starts only when case channel is ready.
- Status update invokes SignalR `UpdateStatus`.
- Status UI updates after receiving case update event.
- Completed case allows return to dashboard.

### 4.7 Tracking and Location

**Description:** Location is central to the product. Users send their detected location with emergency requests. Paramedics broadcast their location during active cases and can navigate to patient coordinates.

**User story:** As an emergency responder, I want accurate patient location and navigation so I can reach the patient faster.

**Functional requirements:**

- User-side high-accuracy GPS location capture.
- User-side reverse geocoded address.
- Paramedic-side periodic location broadcast.
- External Google Maps navigation.

**Acceptance criteria:**

- Location permission denied results in clear user-facing error.
- GPS service disabled results in clear user-facing error.
- Coordinates are included in emergency request payload.
- Paramedic location broadcast does not send patient location.
- Active case UI displays whether location broadcasting is live.

### 4.8 Medical Profile

**Description:** Users maintain a medical profile that can improve emergency response quality. The profile and related medical data are fetched remotely and cached locally in Hive.

**User story:** As a patient, I want my medical history stored so paramedics can understand risks quickly during an emergency.

**Profile fields:**

- Blood type
- Weight in kg
- Height in cm
- Pregnancy status
- Medical notes
- Profile image

**Medical data categories:**

- Medications
- Allergies
- Chronic diseases
- Past surgeries
- Emergency contacts

**Functional requirements:**

- Load profile from remote API.
- Restore cached profile immediately when available.
- Update profile basics.
- Upload/delete profile image.
- Validate profile image type: jpg, jpeg, png, webp.
- Validate profile image size: max 5 MB.
- Add/update/delete medications.
- Add/update/delete allergies.
- Add/update/delete chronic diseases.
- Add/update/delete past surgeries.
- Add/update/delete emergency contacts.
- Fall back to cached medical data when remote fetch fails and local data exists.

**Acceptance criteria:**

- Profile screen displays user data from auth state and profile API/cache.
- Medical sections reflect remote data when available.
- Mutations update remote API first, then local cache.
- Errors are displayed without crashing.
- Emergency contact call action is currently a UI snackbar only.

### 4.9 Request and Case History

**Description:** User and paramedic history screens exist, but current displayed data is mock/static in the UI.

**User story:** As a user or paramedic, I want to review previous requests/cases and response details.

**Acceptance criteria:**

- **Current state:** User request history and paramedic case history are visual/static examples.
- Paramedic REST endpoint exists for case history, but current paramedic history UI does not consume it.
- Future implementation should fetch real history from backend and support details, filters, and status timelines.

### 4.10 Notifications

**Description:** Notification labels and a notification icon appear in the user UI. No push notification or local notification implementation is present.

**User story:** As a user, I want to receive alerts when my emergency request changes status.

**Acceptance criteria:**

- **Current state:** Notification UI entry exists only.
- **Gap:** No Firebase Cloud Messaging, local notification plugin, notification data source, or notification screen is implemented.
- Future implementation should support:
  - Request created
  - Ambulance assigned
  - Paramedic en route
  - Paramedic arrived
  - Request cancelled
  - Case completed

### 4.11 Localization, Theme, and Settings

**Description:** The app supports English and Arabic localization, theme switching, and language selection.

**User story:** As a user, I want the app in my preferred language and display theme.

**Acceptance criteria:**

- English and Arabic are supported locales.
- Locale is managed by `LocaleCubit`.
- Theme is managed by `ThemeCubit`.
- Paramedic profile includes theme toggle.
- User profile includes language navigation.

## 5. User Flows

### 5.1 Emergency Request Flow

1. User logs in or restores session.
2. User lands on user home.
3. User selects:
   - Request Ambulance
   - Report Emergency
4. App opens emergency form and detects location.
5. User enters emergency description.
6. User optionally enters number of affected people.
7. User submits request.
8. Backend creates emergency request.
9. App displays request success with ambulance ID and ETA.
10. User chooses to return home or open tracking/history.

### 5.2 Paramedic Incoming Request Flow

1. Paramedic logs in or restores session.
2. App routes paramedic to paramedic shell/dashboard.
3. Dashboard initializes SignalR connection.
4. Paramedic toggles availability.
5. Server pushes incoming emergency request.
6. App opens incoming request screen.
7. Paramedic reviews patient, location, severity, hospital, and clinical snapshot.
8. Paramedic accepts or rejects.
9. Accepted request opens active case.
10. Rejected/cancelled request returns paramedic to dashboard.

### 5.3 Active Case and Tracking Flow

1. Paramedic accepts request.
2. Active case screen initializes.
3. App joins case group.
4. App starts broadcasting paramedic location every 3 seconds.
5. Paramedic opens Google Maps navigation if needed.
6. Paramedic updates status:
   - Arrived
   - Treatment Started
   - Completed
7. App receives live case update events and updates UI.
8. Completed case returns to dashboard.

## 6. Non-Functional Requirements

### Low Latency

- Incoming emergency request events should appear within 1-3 seconds under normal network conditions.
- Case status updates should propagate within 1-3 seconds.
- Paramedic location broadcast interval is currently 3 seconds.

### High Availability

- Emergency request API and SignalR hub must be treated as critical infrastructure.
- The app should gracefully handle API downtime and communicate failure clearly.
- Production deployment should monitor request creation, event delivery, and hub reconnects.

### Fault Tolerance

- Location permission denial must not crash the app.
- GPS disabled state must show actionable error.
- API timeout must show clear error.
- SignalR reconnecting state must be visible.
- Cached profile/medical data should be used when remote fetch fails.

### Data Security and Privacy

- JWT token and user auth data are stored in `FlutterSecureStorage`.
- Medical profile data is cached locally in Hive.
- Production APIs must use HTTPS. Current REST base URL uses `http://back23-4.runasp.net`, which is not acceptable for production medical/auth traffic.
- Medical data access must be role-scoped.
- Paramedic location is broadcast during active cases only.
- Patient location must only be used for emergency response and authorized case handling.

### Scalability

- SignalR backend must support:
  - Many concurrent paramedics
  - Many simultaneous emergency requests
  - Per-case groups
  - Reconnect storms
  - High-frequency location updates
- REST backend must handle concurrent profile and medical data reads during emergencies.

### Reliability

- Emergency request creation should be idempotent or protected against duplicate taps/retries.
- Accept/reject operations should prevent duplicate handling of the same request.
- Status updates should be ordered and auditable.

### Accessibility and Localization

- Emergency flows should remain usable under stress.
- Arabic and English should remain fully supported.
- Critical buttons should have clear labels and adequate touch targets.

## 7. Technical Overview

### Architecture Style

The project follows a layered architecture similar to Clean Architecture:

- `lib/core`: infrastructure and cross-cutting app services.
- `lib/data`: models, remote/local data sources, repository implementations.
- `lib/domain`: entities and repository contracts.
- `lib/presentation`: UI, Cubits, screens, role-specific modules.
- `lib/shared`: reusable widgets and shared UI helpers.

There are no strict use case/interactor classes; presentation Cubits call repositories directly.

### State Management

The app uses Cubit/Bloc through `flutter_bloc`.

Key Cubits include:

- `AuthCubit`
- `LoginCubit`
- `RegisterCubit`
- `ForgotPasswordCubit`
- `VerifyResetOtpCubit`
- `ResetPasswordCubit`
- `ProfileCubit`
- `EmergencyRequestCubit`
- `DashboardCubit`
- `IncomingRequestCubit`
- `ActiveCaseCubit`
- `ThemeCubit`
- `LocaleCubit`

### API Structure

The app uses `DioClient` with:

- Base URL: `http://back23-4.runasp.net`
- 30-second connect timeout
- 30-second receive timeout
- Bearer token auth interceptor
- Request/response logging interceptor

Primary endpoint groups:

- Auth: `/api/Auth/*`
- Emergency request: `/api/Request`
- Profile: `/api/profile`
- Medical data: `/api/MedicalData/*`
- Paramedic: `/api/paramedic/*`

### Local Storage

- `FlutterSecureStorage`: auth token and user data.
- `Hive`: profile, medications, allergies, chronic diseases, emergency contacts, past surgeries.
- `SharedPreferences`: locale/language settings.

### Real-Time Mechanism

Real-time communication is designed through SignalR.

Inbound events:

- `ReceiveEmergencyRequest`
- `RequestCancelled`
- `CaseGroupJoined`
- `CaseUpdated`

Outbound events:

- `AcceptRequest`
- `RefuseRequest`
- `JoinCaseGroup`
- `SendLocation`
- `UpdateStatus`

**Current state:** `MockSignalRService` is registered in dependency injection. The real `SignalRService` setup is present as TODO code.

## 8. Dependencies

### Backend APIs

- `http://back23-4.runasp.net/api/Auth/login`
- `http://back23-4.runasp.net/api/Auth/register`
- `http://back23-4.runasp.net/api/Auth/logout`
- `http://back23-4.runasp.net/api/Auth/forget-password`
- `http://back23-4.runasp.net/api/Auth/verify-reset-password-otp`
- `http://back23-4.runasp.net/api/Auth/reset-password`
- `http://back23-4.runasp.net/api/Request`
- `http://back23-4.runasp.net/api/profile`
- `http://back23-4.runasp.net/api/profile/image`
- `http://back23-4.runasp.net/api/MedicalData/medications`
- `http://back23-4.runasp.net/api/MedicalData/allergies`
- `http://back23-4.runasp.net/api/MedicalData/chronic-diseases`
- `http://back23-4.runasp.net/api/MedicalData/past-surgeries`
- `http://back23-4.runasp.net/api/MedicalData/emergency-contacts`
- `http://back23-4.runasp.net/api/paramedic/incoming-requests`
- `http://back23-4.runasp.net/api/paramedic/case-history`
- `http://back23-4.runasp.net/api/paramedic/requests/{requestId}/accept`
- `http://back23-4.runasp.net/api/paramedic/requests/{requestId}/reject`
- `http://back23-4.runasp.net/api/paramedic/requests/{requestId}/status`

### SignalR Hub

- `https://api.rescufy.io/hubs/emergency`

### Flutter/Platform Dependencies

- `flutter_bloc` / `bloc`
- `dio`
- `get_it`
- `dartz`
- `equatable`
- `hive` / `hive_flutter`
- `shared_preferences`
- `flutter_secure_storage`
- `jwt_decoder`
- `geolocator`
- `geocoding`
- `signalr_netcore`
- `image_picker`
- `url_launcher`
- `flutter_screenutil`
- `flutter_localizations`

## 9. Risks and Edge Cases

### Network Loss During Emergency

Risk: User submits an emergency request and loses connectivity.  
Mitigation: Add retry, request draft persistence, emergency hotline fallback, and clear failure state.

### SignalR Disconnects

Risk: Paramedic misses incoming request or status update.  
Mitigation: Production SignalR reconnect monitoring, fallback polling, visible connection warnings.

### Real Service Not Wired

Risk: App appears functional in demo but does not receive production real-time events.  
Mitigation: Replace `MockSignalRService` in dependency injection before release.

### Driver Ignores Request

Risk: Incoming request is not accepted or rejected.  
Mitigation: Add timeout, auto-escalation, reassignment, dispatcher alert.

### GPS Inaccuracy

Risk: Ambulance navigates to wrong location.  
Mitigation: Show confidence/accuracy, allow manual location correction, share nearby landmarks.

### Location Permission Denied

Risk: User cannot submit emergency request.  
Mitigation: Provide permission guidance and alternative manual address flow.

### Multiple Simultaneous Requests

Risk: Paramedic receives new request while already active.  
Mitigation: Availability should be server-controlled during active case; queue/reassignment rules needed.

### Duplicate Request Submission

Risk: User taps submit multiple times or network retries duplicate requests.  
Mitigation: Disable submit during request, add backend idempotency keys.

### Medical Data Staleness

Risk: Cached medical profile is outdated.  
Mitigation: Display last updated time and encourage profile review.

### Sensitive Data Exposure

Risk: Medical/auth traffic over HTTP.  
Mitigation: Enforce HTTPS, certificate validation, secure backend configuration, audit logs.

### Notification Gaps

Risk: User misses status changes if app is backgrounded.  
Mitigation: Add push notifications and local notification handling.

## 10. Future Improvements

### Production Readiness

- Wire real SignalR hub into dependency injection.
- Replace HTTP REST base URL with HTTPS.
- Add observability for API failures, SignalR reconnects, and event latency.
- Add automated tests for critical emergency flows.

### Emergency Flow Enhancements

- User-side live ambulance tracking.
- User-side cancel request.
- Manual address correction when GPS fails.
- Emergency hotline fallback with location sharing.
- Duplicate request protection.

### Dispatch Intelligence

- Smart dispatching based on distance, availability, severity, traffic, and hospital capacity.
- Auto-reassignment when paramedic does not respond.
- Dispatcher escalation for critical cases.

### Medical and Hospital Integration

- Hospital handoff flow.
- Receiving hospital readiness alerts.
- Structured vitals and triage notes.
- Consent-based sharing of medical profile.

### Notifications

- Push notifications for request lifecycle events.
- Critical alert mode for paramedics.
- Notification history screen.

### Accessibility and Safety

- Voice emergency trigger.
- Panic button flow.
- Minimal input emergency mode.
- Larger emergency controls and improved accessibility labels.

### Admin / Dispatcher

- Web dashboard integration visibility from mobile.
- Dispatcher assignment status shown to users and paramedics.
- Case audit timeline.
