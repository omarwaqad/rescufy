# Rescufy Development Progress

## ✅ Completed Features

### Authentication
- [x] Login
- [x] Register
- [x] JWT storage (Secure Storage)
- [x] Role-based routing
- [x] Forgot password + OTP + reset

---

### Emergency Requests
- [x] Create emergency request
- [x] GPS location detection
- [x] Reverse geocoding
- [x] Request submission to backend
- [x] Basic success/failure handling

---

### Paramedic System
- [x] Dashboard UI
- [x] Availability toggle
- [x] Incoming request screen
- [x] Accept / Reject request
- [x] Active case screen
- [x] Status updates (Arrived, Treatment, Completed)

---

### Medical Profile
- [x] Profile fetch (API + Hive cache)
- [x] Update profile
- [x] Profile image upload/delete
- [x] Medications CRUD
- [x] Allergies CRUD
- [x] Chronic diseases CRUD
- [x] Emergency contacts CRUD

---

### Core System
- [x] Clean architecture (core/data/domain/presentation)
- [x] Cubit state management
- [x] Dio API layer
- [x] Hive local storage
- [x] Localization (EN/AR)
- [x] Theme switching

---

## ⚠️ Partially Implemented

### Real-Time System (SignalR)
- [x] Real SignalR services connected
- [x] MockSignalRService removed
- [x] Notification hub event handling
- [x] Ambulance hub method invocation
- [x] SignalR reconnect state handling

---

### Tracking
- [ ] User-side live ambulance tracking
- [x] Paramedic location broadcasting via Ambulance hub
- [ ] ETA updates in real-time

---

### History
- [ ] User request history (real API)
- [ ] Paramedic case history (connected to backend)

---

## ❌ Not Implemented Yet

### Notifications
- [x] Notification SignalR hub connection
- [x] In-app notification event streams
- [ ] Push notifications (FCM)
- [ ] Local notifications
- [ ] Notification screen

---

### Emergency Enhancements
- [ ] Cancel emergency request (user side)
- [ ] Retry failed request
- [ ] Offline fallback

---

### Reliability & Safety
- [ ] HTTPS instead of HTTP
- [ ] Request idempotency
- [x] SignalR reconnect handling
- [ ] Error recovery flows

---

### UX Improvements
- [ ] Real tracking screen
- [ ] Better post-request confirmation UI
- [ ] Loading/error states polish

---

### Advanced Features
- [ ] Smart ambulance dispatching
- [ ] Hospital integration
- [ ] Voice emergency trigger
- [ ] Panic button mode

---

## 🚀 Current Focus

- [x] Replace MockSignalRService with real implementation
- [ ] Implement live tracking screen
- [ ] Add push notifications

---

## 🧠 Notes

- Admin panel handled externally (web dashboard)
- Real-time system is the biggest gap right now
- Tracking + notifications = critical for demo quality

## 🚑 Real-Time Integration (NEW BACKEND)

### Notification Hub
- [x] Connect to /hubs/notifications
- [x] Handle ReceiveNotification
- [x] Handle RequestCreated
- [x] Handle StatusChanged
- [x] Handle AmbulanceReassigned
- [x] Handle RequestCancelled
- [x] Handle ReportAdded
- [x] Handle NewRequest
- [x] Handle RequestUpdated
- [x] Handle ReceiveEmergencyRequest
- [ ] Show local/push notifications

---

### Ambulance Hub
- [x] Connect to /hubs/ambulance
- [x] Implement JoinRequestGroup
- [x] Implement LeaveRequestGroup
- [x] Implement UpdateLocation (driver)
- [x] Implement AcceptRequest
- [x] Handle ReceiveLocationUpdate

---

### Tracking System
- [x] Join request group in active case flow
- [ ] Real-time map updates
- [x] Leave group on dispose

---

## 🔌 SignalR Refactor Notes

- Added separate `NotificationSignalRService` and `AmbulanceSignalRService`.
- Added structured models for notification events, status changes, and ambulance location updates.
- Added shared authenticated SignalR connection factory using bearer token headers and automatic reconnect.
- Dashboard now listens to notification hub emergency request and cancellation streams.
- Incoming request acceptance now invokes `AcceptRequest` on the ambulance hub.
- Active case now joins/leaves ambulance request groups, broadcasts driver location through `UpdateLocation`, and listens to notification status changes.
- Backend contract does not expose SignalR methods for reject/refuse or paramedic-driven status updates; those actions now need REST endpoints or backend hub support if product requires them.
