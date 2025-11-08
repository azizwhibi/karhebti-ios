# ✅ Karhebti iOS - Setup Checklist

Use this checklist to get your app up and running in Xcode.

---

## Phase 1: Xcode Project Setup

### Step 1: Open Project
- [ ] Navigate to `/Users/aziz/Desktop/karhebti/karhebti-ios/`
- [ ] Double-click `karhebti-ios.xcodeproj` or run:
      ```bash
      open karhebti-ios.xcodeproj
      ```

### Step 2: Add New Files to Xcode
The Swift files were created outside Xcode, so you need to add them:

- [ ] In Xcode Project Navigator, **right-click** on `karhebti-ios` (yellow folder)
- [ ] Select **"Add Files to karhebti-ios..."**
- [ ] Navigate to: `/Users/aziz/Desktop/karhebti/karhebti-ios/`
- [ ] **Select all these folders** (hold Cmd):
      - [ ] `Models`
      - [ ] `Network`
      - [ ] `ViewModels`  
      - [ ] `Views`
      - [ ] `Utilities`
- [ ] Check these options:
      - [x] ✅ "Copy items if needed"
      - [x] ✅ "Create groups"
      - [x] ✅ "Add to targets: karhebti-ios"
- [ ] Click **"Add"**

### Step 3: Verify File Structure
Your Project Navigator should now look like:
```
karhebti-ios
├── karhebti-ios/
│   ├── karhebti_iosApp.swift
│   └── ContentView.swift
├── Models/
│   ├── AuthModels.swift
│   ├── VehicleModels.swift
│   ├── MaintenanceModels.swift
│   ├── GarageModels.swift
│   └── DocumentModels.swift
├── Network/
│   ├── APIClient.swift
│   └── TokenManager.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── VehicleViewModel.swift
│   ├── MaintenanceViewModel.swift
│   ├── GarageViewModel.swift
│   └── DocumentViewModel.swift
├── Views/
│   ├── Authentication/
│   ├── Home/
│   ├── Vehicles/
│   ├── Garages/
│   ├── Maintenance/
│   └── Common/
└── Utilities/
    └── Extensions.swift
```

### Step 4: Clean Up (Optional)
Remove unused CoreData files:
- [ ] Right-click `Persistence.swift` → **Delete** → **Move to Trash**
- [ ] Right-click `karhebti_ios.xcdatamodeld` → **Delete** → **Move to Trash**

---

## Phase 2: Configuration

### Step 5: Configure Backend URL

#### For Simulator (Mac localhost):
- [ ] Open `Network/APIClient.swift`
- [ ] Verify line 44 is:
      ```swift
      private let baseURL = "http://localhost:3000"
      ```

#### For Physical Device:
- [ ] Find your Mac's IP address:
      ```bash
      ifconfig | grep "inet " | grep -v 127.0.0.1
      ```
      Example output: `inet 192.168.1.5`
- [ ] Open `Network/APIClient.swift`
- [ ] Change line 44 to:
      ```swift
      private let baseURL = "http://192.168.1.5:3000"
      ```
      (Replace with your actual IP)

### Step 6: Verify Backend is Running
- [ ] Ensure your backend server is running
- [ ] Test with:
      ```bash
      curl http://localhost:3000/cars
      ```
- [ ] Should return JSON (even if empty array)

---

## Phase 3: Build & Run

### Step 7: Select Target
- [ ] In Xcode toolbar, click the device selector
- [ ] Choose: **iPhone 15 Pro** (or your preferred simulator)
- [ ] OR connect your physical iPhone and select it

### Step 8: Build Project
- [ ] Press **Cmd + B** to build
- [ ] Wait for "Build Succeeded" message
- [ ] Check for any build errors (see Troubleshooting below)

### Step 9: Run App
- [ ] Press **Cmd + R** to run
- [ ] App should launch on simulator/device
- [ ] You should see the **Login Screen**

---

## Phase 4: Test the App

### Step 10: Test Authentication
- [ ] **Sign Up** with new account:
      - Nom: Test
      - Prénom: User  
      - Email: test@example.com
      - Téléphone: 0612345678
      - Password: password123
- [ ] Should automatically log in
- [ ] Should see Home Dashboard

### Step 11: Test Vehicle Management
- [ ] Go to **Véhicules** tab
- [ ] Tap **+** button
- [ ] Add a vehicle:
      - Marque: Toyota
      - Modèle: Camry
      - Immatriculation: ABC-123
      - Année: 2020
      - Carburant: Essence
- [ ] Tap vehicle to view details
- [ ] Try editing the vehicle
- [ ] Test delete (cancel it)

### Step 12: Test Maintenance
- [ ] From vehicle detail page
- [ ] Tap **+ Ajouter** in Entretiens section
- [ ] Add maintenance:
      - Type: Vidange
      - Cost: 50
- [ ] Should appear in maintenance list

### Step 13: Test Garages
- [ ] Go to **Garages** tab
- [ ] Tap **+** to add garage
- [ ] Fill in garage details
- [ ] Test search functionality
- [ ] Tap garage to view details

### Step 14: Test Profile
- [ ] Go to **Profil** tab
- [ ] Verify your user info displays
- [ ] Test logout (then login again)

---

## Troubleshooting Guide

### Build Errors

#### ❌ "Cannot find type 'AuthViewModel'"
**Cause**: Files not added to Xcode project
**Fix**:
- [ ] Verify you completed Step 2
- [ ] Check files are in Project Navigator
- [ ] Verify "Target Membership" is checked for each file

#### ❌ "Use of unresolved identifier"
**Cause**: Missing imports or files not in target
**Fix**:
- [ ] Select each file in Project Navigator
- [ ] Check File Inspector (right panel)
- [ ] Under "Target Membership", ensure `karhebti-ios` is ✅ checked

#### ❌ "Multiple commands produce..."
**Cause**: Duplicate file references
**Fix**:
- [ ] Clean build folder: **Cmd + Shift + K**
- [ ] Delete derived data: Xcode → Preferences → Locations → Derived Data → Delete
- [ ] Rebuild

### Runtime Errors

#### ❌ "Failed to connect to localhost:3000"
**Fix**:
- [ ] Verify backend is running:
      ```bash
      curl http://localhost:3000/cars
      ```
- [ ] For physical device: Did you update the IP in APIClient.swift?
- [ ] Check firewall isn't blocking port 3000

#### ❌ "Decoding error" in console
**Fix**:
- [ ] Check backend returns dates in ISO 8601 format
- [ ] Example: `"2024-11-06T14:30:00.000Z"`
- [ ] Check API response matches model structure

#### ❌ "401 Unauthorized"
**Fix**:
- [ ] Log out and log in again
- [ ] Check token is being saved to Keychain
- [ ] Verify backend accepts Bearer token format

#### ❌ App crashes on launch
**Fix**:
- [ ] Check console for error messages
- [ ] Verify all files are added to project
- [ ] Clean and rebuild: **Cmd + Shift + K**, then **Cmd + B**

---

## Verification Checklist

After completing all steps, verify:

- [ ] ✅ App builds without errors
- [ ] ✅ App runs on simulator/device
- [ ] ✅ Login screen appears
- [ ] ✅ Can create account
- [ ] ✅ Can login
- [ ] ✅ Dashboard shows after login
- [ ] ✅ Can navigate between tabs
- [ ] ✅ Can add vehicle
- [ ] ✅ Can view vehicle details
- [ ] ✅ Can add maintenance
- [ ] ✅ Can browse garages
- [ ] ✅ Can logout
- [ ] ✅ Remember Me saves email
- [ ] ✅ Pull-to-refresh works
- [ ] ✅ Search works in garages
- [ ] ✅ No console errors during normal use

---

## Additional Tests (Optional)

### Error Handling
- [ ] Test login with wrong password
- [ ] Test signup with existing email
- [ ] Test adding vehicle with empty fields
- [ ] Turn off backend and see error messages

### UI/UX
- [ ] Test on different screen sizes
- [ ] Test rotation (iPad)
- [ ] Test dark mode (if implemented)
- [ ] Check all animations are smooth
- [ ] Verify all icons display correctly

### Data Persistence
- [ ] Add data, close app, reopen
- [ ] Verify data persists
- [ ] Test logout clears data
- [ ] Test Remember Me persists

---

## Success Criteria

✅ **You're done when:**
1. App builds and runs without errors
2. You can complete the full user flow:
   - Sign up → Login → Add Vehicle → Add Maintenance → Logout
3. All tabs are accessible and functional
4. Data syncs with backend correctly
5. No console errors during normal use

---

## Next Steps After Success

Once everything works:
- [ ] Read `README.md` for detailed documentation
- [ ] Check `PROJECT_STRUCTURE.md` for architecture details
- [ ] Review `IMPLEMENTATION_SUMMARY.md` for feature overview
- [ ] Start customizing for your needs!

---

## Need Help?

If stuck, check:
1. **QUICKSTART.md** - Quick setup guide
2. **README.md** - Comprehensive documentation
3. **Console** in Xcode - for error messages
4. **Network logs** - Check APIClient prints

---

## Useful Xcode Shortcuts

- `Cmd + B` - Build
- `Cmd + R` - Build and Run
- `Cmd + .` - Stop
- `Cmd + Shift + K` - Clean Build Folder
- `Cmd + 0` - Toggle Navigator
- `Cmd + Option + 0` - Toggle Inspector
- `Cmd + /` - Comment/Uncomment
- `Cmd + Click` - Jump to definition

---

**Good luck! 🚀 You've got this!**

Mark each item as you complete it. Once all checkboxes are ✅, your app is ready!
