# Karhebti iOS App - Complete Implementation

## Overview
Karhebti is a comprehensive vehicle and maintenance management application built with SwiftUI for iOS 15.0+. This app allows users to manage their vehicles, track maintenance records, find garages, and store vehicle documents.

## ✨ Features

### Core Features
- ✅ **Authentication System**
  - User registration with validation
  - Login with "Remember Me" functionality
  - Forgot password flow
  - Secure token management with Keychain

- ✅ **Vehicle Management**
  - Add, edit, delete vehicles
  - View vehicle details with status indicators
  - Track mileage and fuel type
  - Maintenance scheduling

- ✅ **Maintenance Tracking**
  - Record maintenance history per vehicle
  - Multiple maintenance types (oil change, revision, tires, etc.)
  - Cost tracking
  - Link to garages

- ✅ **Garage Directory**
  - Browse and search garages
  - View garage details and services
  - Rating system
  - Call and navigation integration

- ✅ **Document Storage**
  - Manage vehicle documents
  - Track expiry dates
  - Multiple document types (insurance, registration, etc.)

## 🏗 Architecture

### MVVM Pattern
The app follows the MVVM (Model-View-ViewModel) architecture:

```
Models/          - Data structures and enums
├── AuthModels.swift
├── VehicleModels.swift
├── MaintenanceModels.swift
├── GarageModels.swift
└── DocumentModels.swift

Network/         - API client and token management
├── APIClient.swift
└── TokenManager.swift

ViewModels/      - Business logic and state management
├── AuthViewModel.swift
├── VehicleViewModel.swift
├── MaintenanceViewModel.swift
├── GarageViewModel.swift
└── DocumentViewModel.swift

Views/           - UI components
├── Authentication/
│   ├── LoginView.swift
│   ├── SignUpView.swift
│   └── ForgotPasswordView.swift
├── Home/
│   └── HomeView.swift
├── Vehicles/
│   ├── VehiclesListView.swift
│   ├── VehicleDetailView.swift
│   ├── AddVehicleView.swift
│   └── EditVehicleView.swift
├── Garages/
│   ├── GaragesListView.swift
│   ├── GarageDetailView.swift
│   └── AddGarageView.swift
├── Maintenance/
│   └── AddMaintenanceView.swift
└── Common/
    └── CommonViews.swift

Utilities/       - Extensions and helpers
└── Extensions.swift
```

## 🔧 Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- macOS 13.0 or later
- iOS 15.0+ deployment target
- Backend API running on `http://localhost:3000`

### Backend Setup
1. Start your Node.js backend server on port 3000
2. Ensure all API endpoints are accessible

### iOS App Setup

#### 1. Open the Project
```bash
cd /Users/aziz/Desktop/karhebti/karhebti-ios
open karhebti-ios.xcodeproj
```

#### 2. Configure API Base URL
The API client is configured for localhost testing. For physical device testing:

Open `Network/APIClient.swift` and update:
```swift
// For Simulator (Mac)
private let baseURL = "http://localhost:3000"

// For Physical Device on same network
private let baseURL = "http://192.168.1.X:3000"  // Replace X with your Mac's IP
```

#### 3. Add Files to Xcode Project

Since the files were created outside Xcode's project structure, you need to add them:

1. **Open Xcode** and select your project
2. **Right-click on the project root** in the navigator
3. **Select "Add Files to karhebti-ios"**
4. **Navigate to and select these folders**:
   - `Models/`
   - `Network/`
   - `ViewModels/`
   - `Views/`
   - `Utilities/`
5. **Check**: ✅ "Copy items if needed"
6. **Check**: ✅ "Create groups"
7. **Add to targets**: ✅ karhebti-ios
8. Click **Add**

#### 4. Build and Run
1. Select your target device or simulator
2. Press `Cmd + B` to build
3. Press `Cmd + R` to run

## 📱 App Navigation

### Tab Bar Navigation
1. **Accueil (Home)** - Dashboard with statistics and recent vehicles
2. **Véhicules** - List and manage all vehicles
3. **Garages** - Browse and search garages
4. **Profil** - User profile and settings

## 🔐 Authentication Flow

### Login
- Email and password authentication
- Remember me checkbox saves email
- Token stored securely in Keychain
- User data in UserDefaults

### Sign Up
- Complete registration form
- Password validation (min 6 characters)
- Password confirmation
- Automatic login after signup

### Forgot Password
- Email-based password reset
- Success confirmation message

## 🚗 Using the App

### Adding a Vehicle
1. Go to **Véhicules** tab
2. Tap **+** button
3. Fill in required fields:
   - Marque (Brand)
   - Modèle (Model)
   - Année (Year)
   - Immatriculation (License plate)
   - Type de carburant (Fuel type)
4. Tap **Ajouter le véhicule**

### Adding Maintenance
1. Open a vehicle detail page
2. In **Entretiens** section, tap **+ Ajouter**
3. Select maintenance type
4. Enter date and cost
5. Optionally link to a garage
6. Tap **Enregistrer l'entretien**

### Finding Garages
1. Go to **Garages** tab
2. Browse the list or use search
3. Tap on a garage to view details
4. Use **Appeler** to call or **Itinéraire** for directions

## 🎨 Design System

### Colors
- **Primary**: Deep Purple (#6658DD)
- **Accent**: Green (#00C896), Blue (#2196F3), Orange (#FF9800)
- **Status**: Green (Good), Yellow (Attention), Red (Urgent)
- **Background**: Soft White (#FAFAFA)

### Typography
- **Headlines**: System Bold
- **Body**: System Regular
- **Captions**: System Caption

### Components
- **Cards**: White background, rounded corners (12-16pt), subtle shadows
- **Buttons**: Primary (filled) and Secondary (outlined)
- **Status Badges**: Colored with opacity backgrounds

## 🔌 API Integration

### Endpoints Used
```
Authentication:
POST /auth/signup
POST /auth/login
POST /auth/forgot-password

Vehicles:
GET    /cars
GET    /cars/:id
POST   /cars
PATCH  /cars/:id
DELETE /cars/:id

Maintenance:
GET    /maintenances
POST   /maintenances
PATCH  /maintenances/:id
DELETE /maintenances/:id

Garages:
GET    /garages
GET    /garages/:id
POST   /garages
PATCH  /garages/:id
DELETE /garages/:id

Documents:
GET    /documents
POST   /documents
PATCH  /documents/:id
DELETE /documents/:id
```

## 🐛 Common Issues & Solutions

### Issue: "Cannot connect to localhost"
**Solution**: If testing on a physical device, update the base URL in `APIClient.swift` to your Mac's local IP address.

### Issue: "Decoding error"
**Solution**: Ensure your backend returns dates in ISO 8601 format with milliseconds: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`

### Issue: "Unauthorized (401)"
**Solution**: 
1. Check if token is saved correctly
2. Verify token is being sent in Authorization header
3. Log out and log in again

### Issue: Files not found in Xcode
**Solution**: Make sure you've added all the created folders to the Xcode project (see Setup Instructions step 3)

## 📝 Testing Checklist

- [ ] Login with valid credentials
- [ ] Login with invalid credentials shows error
- [ ] Remember Me saves email
- [ ] Logout clears data
- [ ] Sign up with all fields
- [ ] Forgot password sends email
- [ ] Add new vehicle
- [ ] Edit vehicle details
- [ ] Delete vehicle (with confirmation)
- [ ] View vehicle details
- [ ] Add maintenance record
- [ ] View maintenance history
- [ ] Browse garages
- [ ] Search garages
- [ ] Call garage from detail page
- [ ] Pull to refresh updates data
- [ ] Empty states display correctly
- [ ] Loading indicators work

## 🚀 Next Steps

### To Implement
1. **Document Upload**: Integrate file picker and upload
2. **AI Features**: Maintenance recommendations endpoint
3. **Push Notifications**: Maintenance reminders
4. **Localization**: Add English language support
5. **Dark Mode**: System-based theme switching
6. **Offline Mode**: Core Data for local caching
7. **Maps Integration**: Display garage locations on map
8. **Photos**: Vehicle image upload and display

### Recommended Improvements
1. Add haptic feedback for actions
2. Implement biometric authentication
3. Add widget for quick vehicle status
4. Export maintenance history as PDF
5. Add vehicle value tracking
6. Implement fuel consumption calculator

## 📄 License
This project is part of the Karhebti vehicle management system.

## 👨‍💻 Development Notes

### Code Style
- Follow Swift naming conventions
- Use SwiftUI best practices
- Keep ViewModels @MainActor
- Use async/await for network calls
- Implement proper error handling

### State Management
- `@StateObject` for ViewModel instances
- `@EnvironmentObject` for shared state
- `@Published` for observable properties
- Combine for reactive updates

### Security
- Tokens stored in Keychain
- No sensitive data in UserDefaults
- HTTPS recommended for production
- Input validation on all forms

## 🤝 Contributing
When adding new features:
1. Follow existing architecture patterns
2. Add proper error handling
3. Include loading and empty states
4. Test on both simulator and device
5. Update this README

---

**Built with ❤️ using SwiftUI**
