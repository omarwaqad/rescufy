# Rescufy Frontend - Project Folder Structure

## Project Root Configuration

```
├── components.json                 # shadcn/ui configuration
├── eslint.config.js               # ESLint configuration for code quality
├── tsconfig.json                  # Main TypeScript configuration
├── tsconfig.app.json              # TypeScript config for app source
├── tsconfig.node.json             # TypeScript config for build tools
├── package.json                   # Project dependencies and scripts
├── vite.config.ts                 # Vite build configuration
├── tailwind.config.js             # Tailwind CSS configuration (dark mode enabled)
├── vercel.json                    # Vercel deployment configuration
├── index.html                     # HTML entry point
├── README.md                      # Project documentation
├── public/                        # Static assets
└── src/                           # Main application source code
```

---

## Source Structure (`src/`)

### 1. **animation/**
Reusable animation utilities and motion configurations.
```
animation/
└── motion.ts                      # Framer Motion preset animations
```

### 2. **app/**
Core application infrastructure (routing, state, layout, authentication).
```
app/
├── layouts/
│   └── AdminLayout.tsx            # Main layout wrapper for admin pages (navbar + sidebar)
├── provider/
│   └── AuthContext.tsx            # React context for authentication state (login, logout, user data)
├── routes/
│   ├── Router.tsx                 # Main route configuration (all pages and nested routes)
│   ├── AuthRoute.tsx              # Route wrapper for unauthenticated pages (auth flow)
│   └── ProtectedRoute.tsx         # Route wrapper for authenticated pages (role-based access)
└── store/
    └── store.ts                   # Redux store configuration (if applicable)
```

### 3. **assets/**
Static files (images, icons, etc.).
```
assets/
└── images/
    └── authImages/                # Images used in authentication flows
```

### 4. **components/**
Global shared UI components used across the application.
```
components/
├── AdminNavBar.tsx                # Top navigation bar with user profile, theme toggle, notifications
├── Footer.tsx                     # Footer component
├── SideBar.tsx                    # Sidebar navigation for admin dashboard
├── NotFound.tsx                   # 404 not found page
└── ui/
    └── sonner.tsx                 # Sonner toast notification wrapper
```

### 5. **config/**
Configuration files for API clients and environment setup.
```
config/
└── api.config.ts                  # Axios instance configuration (base URL, interceptors)
```

### 6. **docs/**
Project documentation and guides.
```
docs/
├── AUTH_CONTEXT_GUIDE.md          # Guide on using AuthContext and authentication flow
├── CHUNK_SIZE_PLAN.md             # Documentation on chunk size strategy
├── HOSPITAL_DATA_FILTERING.md     # Hospital data filtering logic and rules
├── REQUEST_MAPPERS_GUIDE.md       # Request data mapping utilities
├── REQUESTS_FEATURE.md            # Requests feature documentation
├── TOKEN_LOCALSTORAGE_USAGE.md    # Token storage and management in localStorage
├── ZLibreries.md                  # External libraries and dependencies reference
└── ZNotes.md                      # Miscellaneous project notes
```

### 7. **features/**
Feature-based modules organized by business domain (following clean architecture).

#### **7.1 ambulancesManagement/**
Manage ambulance fleet, assignments, and tracking.
```
ambulancesManagement/
├── components/                    # Reusable UI components (AmbulanceCard, AmbulanceFleetSkeleton, etc.)
├── hooks/                         # Custom hooks (useAmbulances, useAmbulanceDetails, etc.)
├── pages/                         # Full page components (AllAmbulances page)
├── schemas/                       # Validation schemas (Zod/Yup) for ambulance forms
├── types/                         # TypeScript interfaces and types
└── utils/                         # Helper functions and mappers
```

#### **7.2 analytics/**
Analytics dashboard and reporting.
```
analytics/
└── pages/                         # Analytics dashboard page
```

#### **7.3 auth/**
Authentication feature (sign-in, sign-up, forgot-password, reset-password).
```
auth/
├── components/                    # UI components (SignInForm, ResetPasswordForm, HeroSection, etc.)
│   └── AuthForm/                  # Multi-step form components (EmailStep, OtpStep, ResetPasswordStep)
├── data/                          # Mock data or API responses for auth
├── hooks/                         # Custom hooks (useAuth, useLogin, etc.)
├── pages/                         # Full pages (SignIn, ResetPassword, etc.)
├── roles/                         # Role definitions and permissions
├── store/                         # Auth state management
├── types/                         # User, auth, and credentials types
└── utils/                         # Auth utilities (validators, formatters)
```

#### **7.4 dashboard/**
Admin dashboard overview and statistics.
```
dashboard/
├── components/                    # Dashboard widgets (AlertsPanel, StatsCard, Charts, etc.)
├── hooks/                         # Custom hooks for dashboard data
└── pages/                         # Main dashboard page
```

#### **7.5 hospitalDashboard/**
Hospital-specific dashboard for hospital admins.
```
hospitalDashboard/
├── components/                    # Hospital dashboard widgets
├── data/                          # Hospital data utilities
└── pages/                         # Hospital dashboard page
```

#### **7.6 hospitalProfile/**
Hospital profile viewing and management.
```
hospitalProfile/
├── components/                    # Profile components (ProfileCard, BedCapacity, etc.)
├── hooks/                         # Custom hooks (useHospitalProfile, etc.)
├── pages/                         # Hospital profile page
└── types/                         # Hospital-specific types
```

#### **7.7 hospitalsManagement/**
Admin panel for managing hospitals (CRUD operations).
```
hospitalsManagement/
├── components/                    # Reusable UI components (HospitalCard, HospitalsListSkeleton, etc.)
├── data/                          # Hospital data utilities
├── hooks/                         # Custom hooks (useHospitals, useHospitalForm, etc.)
├── pages/                         # All hospitals page, hospital detail page
├── schemas/                       # Validation schemas for hospital forms
├── types/                         # Hospital types and interfaces
└── utils/                         # Helpers and mappers for hospital data
```

#### **7.8 notifications/**
Notifications center and management.
```
notifications/
├── components/                    # Notification widgets and list
├── data/                          # Notification data and mock data
├── hooks/                         # Custom hooks (useNotifications, etc.)
├── index.ts                       # Notifications module entry point
├── types/                         # Notification types
└── utils/                         # Notification utilities
```

#### **7.9 requestDetails/**
Individual request detail view and operations.
```
requestDetails/
├── components/                    # Detail components (RequestInfo, Timeline, Actions, etc.)
├── hooks/                         # Custom hooks (useRequestDetails, etc.)
├── pages/                         # Request details page
└── types/                         # Request detail-specific types
```

#### **7.10 requests/**
Request management (viewing, filtering, tracking ambulance requests).
```
requests/
├── components/                    # Reusable components
│   ├── RequestList.tsx            # List of requests with RequestListSkeleton
│   ├── RequestItem.tsx            # Individual request card
│   ├── AllRequests.tsx            # Admin request board (grid + mobile routing to details)
│   ├── RequestDetailsPanel.tsx    # Desktop-only insights panel (hidden on mobile)
│   └── hospital/
│       ├── HospitalAllRequests.tsx # Hospital request list view
│       └── HospitalsRequestsSkeleton.tsx # Skeleton loader for hospital requests table
├── data/                          # Request mock data and mappers
├── hooks/                         # Custom hooks (useRequests, useRequestFilter, etc.)
├── pages/                         # Request list page
├── store/                         # Request state management (Redux)
├── types/                         # Request types and enums
└── utils/                         # Request helpers and formatters
```

#### **7.11 settings/**
User settings and preferences.
```
settings/
├── components/                    # Settings form components
├── hooks/                         # Custom hooks (useSettings, etc.)
├── pages/                         # Settings page
├── schemas/                       # Validation schemas for settings forms
└── types/                         # Settings types
```

#### **7.12 users/**
User management (admin panel for user CRUD).
```
users/
├── components/                    # User list and form components
├── hooks/                         # Custom hooks (useUsers, etc.)
├── pages/                         # Users management page
├── schemas/                       # Validation schemas for user forms
└── types/                         # User types and roles
```

### 8. **i18n/**
Internationalization (i18n) configuration and providers.
```
i18n/
├── config.ts                      # i18next configuration (languages, namespace)
├── index.ts                       # i18n initialization
├── LanguageProvider.tsx           # React context provider for language switching
└── useLanguage.ts                 # Custom hook to access current language
```

### 9. **locales/**
Translation files for multiple languages.
```
locales/
├── ar/                            # Arabic translations
│   ├── ambulances.json            # Ambulance feature translations
│   ├── auth.json                  # Authentication translations
│   ├── common.json                # Common/shared translations
│   ├── dashboard.json             # Dashboard translations
│   ├── hospitals.json             # Hospitals feature translations
│   ├── navigation.json            # Navigation menu translations
│   ├── notifications.json         # Notifications translations
│   ├── requests.json              # Requests feature translations
│   ├── settings.json              # Settings translations
│   ├── users.json                 # Users management translations
│   └── validation.json            # Form validation error translations
└── en/                            # English translations (same structure as ar/)
```

### 10. **services/**
External service integrations and API clients.
```
services/
└── signalrService.ts              # SignalR real-time communication service (WebSocket)
```

### 11. **shared/**
Shared utilities, hooks, and reusable UI components.
```
shared/
├── common/                        # Common utilities and constants
├── hooks/                         # Reusable custom hooks (useMediaQuery, useFetch, etc.)
└── ui/                            # Reusable UI components (buttons, modals, cards, etc.)
```

### 12. **styles/**
Global styles and theme configuration.
```
styles/
├── index.css                      # Global styles and Tailwind imports
└── themes.css                     # Dark/light mode theme variables
```

### 13. **Root Files**
```
main.tsx                           # React application entry point
App.tsx                            # Main App component wrapper
i18next.ts                         # i18next configuration loader
```

---

## Key Architecture Patterns

### Feature-Based Structure
Each feature (ambulances, requests, hospitals, etc.) is self-contained with:
- **components/**: UI components specific to that feature
- **pages/**: Full page components
- **hooks/**: Custom hooks for feature logic
- **types/**: TypeScript interfaces
- **utils/**: Helper functions and mappers
- **schemas/**: Form validation (Zod/Yup)
- **store/**: Feature-specific state management (Redux)

### Shared Utilities
- **shared/hooks/**: Reusable hooks across features (e.g., `useMediaQuery`, `useAuth`)
- **shared/ui/**: Generic UI components (buttons, modals, inputs)
- **shared/common/**: Constants and utility functions

### i18n Organization
- Single source of truth for translations in `locales/`
- Namespaced by feature for scalability
- Language provider at app root

### Configuration Centralization
- API config in `config/api.config.ts`
- Routes defined in `app/routes/Router.tsx`
- Auth context in `app/provider/AuthContext.tsx`

---

## Technology Stack Reference

| Layer | Technology |
|-------|-----------|
| **UI Framework** | React 19.2.0 |
| **Language** | TypeScript |
| **Routing** | React Router 7.12.0 |
| **Styling** | Tailwind CSS 4.1.18 (dark mode enabled) |
| **State Management** | Redux Toolkit + React Context |
| **Forms** | Formik + Yup/Zod |
| **Animations** | Framer Motion |
| **HTTP Client** | Axios |
| **Icons** | FontAwesome + Lucide React |
| **Notifications** | Sonner 2.0.7 |
| **i18n** | react-i18next 16.5.4 |
| **Build Tool** | Vite 7.2.4 |
| **Real-time** | SignalR |

---

## File Naming Conventions

- **React Components**: PascalCase (e.g., `AdminNavBar.tsx`, `RequestList.tsx`)
- **Custom Hooks**: camelCase with `use` prefix (e.g., `useAuth.ts`, `useRequests.ts`)
- **Utility Functions**: camelCase (e.g., `formatDate.ts`, `mapRequest.ts`)
- **Types/Interfaces**: PascalCase (e.g., `User.ts`, `RequestType.ts`)
- **Constants**: UPPER_SNAKE_CASE (defined in files or `constants.ts`)
- **Translations**: snake_case keys in JSON (e.g., `sign_in_button`, `error_message`)

---

## Navigation Flow

```
src/
├── app/routes/Router.tsx          → Define all routes
├── app/provider/AuthContext.tsx   → Manage authentication
├── app/layouts/AdminLayout.tsx    → Main layout wrapper
├── components/AdminNavBar.tsx     → Top navigation
├── components/SideBar.tsx         → Sidebar navigation
└── features/[feature]/pages/      → Feature pages
```

Mobile-responsive routing:
- **Admin Requests**: Mobile clicks navigate to `/admin/requests/:id` (full details page)
- **Desktop**: Shows grid + details panel side-by-side
- **Mobile**: Shows full request list or full details page

---

## Feature Quick Reference

| Feature | Purpose | Key Files |
|---------|---------|-----------|
| **auth** | Login, signup, password reset | SignInForm, ResetPassword, AuthContext |
| **requests** | Ambulance request management | AllRequests, RequestList, RequestDetails |
| **hospitalsManagement** | Admin hospital CRUD | AllHospitals, HospitalCard |
| **ambulancesManagement** | Admin ambulance fleet | AllAmbulances, AmbulanceCard |
| **dashboard** | Admin KPI overview | DashboardPage, AlertsPanel |
| **hospitalDashboard** | Hospital-specific view | HospitalDashboardPage |
| **hospitalProfile** | Hospital details | HospitalProfilePage |
| **notifications** | Notification center | NotificationsList, NotificationPanel |
| **settings** | User preferences | SettingsPage, SettingsForm |
| **users** | User management | UsersList, UserForm |
| **analytics** | Reporting & metrics | AnalyticsDashboard |

---

## Loading States

Skeleton loaders for smooth loading experiences:
- **RequestListSkeleton**: Admin request board loading
- **HospitalRequestsSkeleton**: Hospital requests table loading
- **HospitalsListSkeleton**: Hospital management grid loading
- **AmbulanceFleetSkeleton**: Ambulance fleet grid loading

All skeletons use animated pulse and bone effects matching component dimensions.
