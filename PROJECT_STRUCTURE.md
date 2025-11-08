# Karhebti iOS Project Structure

## Complete File Tree

```
karhebti-ios/
│
├── README.md                           # Comprehensive documentation
├── QUICKSTART.md                       # Quick start guide
│
├── karhebti-ios/                      # Original Xcode project folder
│   ├── karhebti_iosApp.swift         # ✅ Updated - App entry point
│   ├── ContentView.swift              # ✅ Updated - Main content router
│   ├── Persistence.swift              # ⚠️  Can be deleted (not used)
│   ├── Assets.xcassets/               # App icons and images
│   └── karhebti_ios.xcdatamodeld/    # ⚠️  Can be deleted (not used)
│
├── Models/                            # 📦 Data Models
│   ├── AuthModels.swift               # Auth requests & responses
│   ├── VehicleModels.swift            # Car models & enums
│   ├── MaintenanceModels.swift        # Maintenance models & enums
│   ├── GarageModels.swift             # Garage models & enums
│   └── DocumentModels.swift           # Document models & enums
│
├── Network/                           # 🌐 API Layer
│   ├── APIClient.swift                # HTTP client with async/await
│   └── TokenManager.swift             # Keychain & token management
│
├── ViewModels/                        # 🧠 Business Logic
│   ├── AuthViewModel.swift            # Authentication logic
│   ├── VehicleViewModel.swift         # Vehicle CRUD operations
│   ├── MaintenanceViewModel.swift     # Maintenance operations
│   ├── GarageViewModel.swift          # Garage operations
│   └── DocumentViewModel.swift        # Document operations
│
├── Views/                             # 🎨 UI Components
│   ├── Authentication/
│   │   ├── LoginView.swift            # Login screen
│   │   ├── SignUpView.swift           # Registration screen
│   │   └── ForgotPasswordView.swift   # Password recovery
│   │
│   ├── Home/
│   │   └── HomeView.swift             # Tab navigation + Dashboard
│   │
│   ├── Vehicles/
│   │   ├── VehiclesListView.swift     # Vehicle list with search
│   │   ├── VehicleDetailView.swift    # Vehicle details & actions
│   │   ├── AddVehicleView.swift       # Add new vehicle form
│   │   └── EditVehicleView.swift      # Edit vehicle form
│   │
│   ├── Garages/
│   │   ├── GaragesListView.swift      # Garage directory
│   │   ├── GarageDetailView.swift     # Garage info & contact
│   │   └── AddGarageView.swift        # Add garage form
│   │
│   ├── Maintenance/
│   │   └── AddMaintenanceView.swift   # Add maintenance record
│   │
│   └── Common/
│       └── CommonViews.swift          # Reusable components
│                                       # (Loading, Empty, Error states)
│
├── Utilities/                         # 🛠️ Helpers & Extensions
│   └── Extensions.swift               # Color, Date, View extensions
│
└── karhebti-ios.xcodeproj/           # Xcode project files
    └── project.pbxproj                # Project configuration
```

## File Count Summary

| Category | Files | Lines of Code (approx) |
|----------|-------|------------------------|
| Models | 5 | 400 |
| Network | 2 | 250 |
| ViewModels | 5 | 600 |
| Views | 12 | 2,400 |
| Utilities | 1 | 150 |
| **Total** | **25** | **~3,800** |

## Component Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                     karhebti_iosApp.swift                    │
│                  @StateObject AuthViewModel                  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      ContentView.swift                       │
│              Routes to Login or Home based on auth           │
└────────┬──────────────────────────────────┬─────────────────┘
         │                                   │
    ┌────▼────┐                        ┌────▼──────┐
    │  Login  │                        │   Home    │
    │  Views  │                        │ (TabView) │
    └─────────┘                        └────┬──────┘
                                            │
                    ┌───────────────────────┼──────────────────────┐
                    │                       │                      │
              ┌─────▼─────┐         ┌──────▼──────┐      ┌───────▼────────┐
              │ Dashboard │         │  Véhicules  │      │    Garages     │
              │   View    │         │   + CRUD    │      │  + Directory   │
              └───────────┘         └──────┬──────┘      └────────────────┘
                                           │
                                    ┌──────▼──────┐
                                    │ Maintenance │
                                    │   Records   │
                                    └─────────────┘
```

## Data Flow Architecture

```
┌─────────┐     ┌────────────┐     ┌───────────┐     ┌─────────┐
│  View   │────▶│ ViewModel  │────▶│ APIClient │────▶│ Backend │
└─────────┘     └────────────┘     └───────────┘     └─────────┘
     ▲               │                    │                 │
     │               │                    │                 │
     │               ▼                    ▼                 │
     │          ┌─────────┐         ┌──────────┐          │
     └──────────│ @Published        │  Token   │◀─────────┘
                │  State  │         │ Manager  │
                └─────────┘         └──────────┘
                                         │
                                         ▼
                                    ┌──────────┐
                                    │ Keychain │
                                    └──────────┘
```

## Key Features by File

### Core App Files
- **karhebti_iosApp.swift**: App lifecycle, AuthViewModel injection
- **ContentView.swift**: Authentication routing

### Authentication System
- **LoginView.swift**: Email/password login, Remember Me
- **SignUpView.swift**: User registration, password validation
- **ForgotPasswordView.swift**: Password reset flow
- **AuthViewModel.swift**: Login/signup/logout logic, token handling

### Vehicle Management
- **VehiclesListView.swift**: List all vehicles, pull-to-refresh, add button
- **VehicleDetailView.swift**: Full vehicle info, maintenance history, documents
- **AddVehicleView.swift**: Create new vehicle with validation
- **EditVehicleView.swift**: Update vehicle information
- **VehicleViewModel.swift**: CRUD operations for vehicles

### Maintenance System
- **AddMaintenanceView.swift**: Record maintenance with type, date, cost
- **MaintenanceViewModel.swift**: Maintenance CRUD operations

### Garage Directory
- **GaragesListView.swift**: Browse garages, search functionality
- **GarageDetailView.swift**: Garage info, call, directions
- **AddGarageView.swift**: Add new garage with services
- **GarageViewModel.swift**: Garage CRUD operations

### Common Components
- **CommonViews.swift**: LoadingView, EmptyStateView, ErrorView
- **Extensions.swift**: Color palette, date formatting, view modifiers

### Network Layer
- **APIClient.swift**: RESTful API client, error handling, JSON coding
- **TokenManager.swift**: Keychain storage, UserDefaults for user data

## Import Dependencies

Each file uses only what it needs:

```swift
// Views
import SwiftUI

// ViewModels
import SwiftUI
import Combine

// Network
import Foundation
import Security (TokenManager only)
```

## Color System

Defined in `Extensions.swift`:

```swift
Primary Colors:
- deepPurple: #6658DD
- lightPurple: #EBEAFE
- softWhite: #FAFAFA

Accent Colors:
- accentGreen: #00C896
- accentBlue: #2196F3
- accentOrange: #FF9800
- accentYellow: #FFC107
- alertRed: #DC3545

Grey Scale:
- lightGrey, mediumGrey, darkGrey
- textPrimary, textSecondary
```

## State Management

```swift
@StateObject     → ViewModel instances (owners)
@EnvironmentObject → Shared ViewModels across hierarchy
@Published       → Observable properties in ViewModels
@State          → Local view state
@Binding        → Two-way data binding
```

## Navigation Pattern

```swift
NavigationStack               → Root navigation
TabView                      → Bottom tab bar
NavigationLink              → Push navigation
.sheet()                    → Modal presentation
.alert()                    → Alerts and confirmations
```

## Best Practices Used

✅ MVVM architecture separation
✅ Async/await for networking
✅ Proper error handling
✅ Loading and empty states
✅ Pull-to-refresh on lists
✅ Form validation
✅ Secure token storage
✅ Reusable components
✅ Consistent design system
✅ SwiftUI best practices

---

**This structure provides a maintainable, scalable foundation for the Karhebti iOS app.**
