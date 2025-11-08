# Karhebti iOS - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Add Files to Xcode
Since the Swift files were created outside Xcode's project structure, you need to add them to your Xcode project:

1. **Open Xcode**
   ```bash
   cd /Users/aziz/Desktop/karhebti/karhebti-ios
   open karhebti-ios.xcodeproj
   ```

2. **Add the new folders to your project**:
   - In Xcode, right-click on the `karhebti-ios` group (the yellow folder icon)
   - Select **"Add Files to karhebti-ios..."**
   - Navigate to `/Users/aziz/Desktop/karhebti/karhebti-ios/`
   - Select these folders (hold Cmd to select multiple):
     - `Models`
     - `Network`
     - `ViewModels`
     - `Views`
     - `Utilities`
   - Make sure these options are checked:
     - ✅ "Copy items if needed"
     - ✅ "Create groups"
     - ✅ Add to targets: karhebti-ios
   - Click **"Add"**

### Step 2: Remove Old CoreData Files (Optional)
Since we're not using CoreData, you can remove:
- `Persistence.swift`
- `karhebti_ios.xcdatamodeld` folder

Right-click on each → **Delete** → **Move to Trash**

### Step 3: Configure Backend URL
If testing on a **physical device** (not simulator):

Open `Network/APIClient.swift` and change line 44:
```swift
// Change from:
private let baseURL = "http://localhost:3000"

// To (replace X.X.X.X with your Mac's IP):
private let baseURL = "http://X.X.X.X:3000"
```

To find your Mac's IP:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### Step 4: Build & Run
1. Select your target device (iPhone 15 Pro or your device)
2. Press **Cmd + R** to build and run
3. Wait for the build to complete

### Step 5: Test the App

#### Create Account
1. On login screen, tap **"S'inscrire"** (Sign Up)
2. Fill in:
   - Nom: Test
   - Prénom: User
   - Email: test@example.com
   - Téléphone: 0612345678
   - Mot de passe: password123
   - Confirm password: password123
3. Tap **"S'inscrire"**

#### Add Your First Vehicle
1. After login, go to **"Véhicules"** tab
2. Tap **+** button (top right)
3. Fill in:
   - Marque: Toyota
   - Modèle: Camry
   - Immatriculation: ABC-123
   - Année: 2020
   - Type de carburant: Essence
4. Tap **"Ajouter le véhicule"**

#### Add Maintenance Record
1. Tap on your vehicle in the list
2. In the **Entretiens** section, tap **"+ Ajouter"**
3. Select type: Vidange
4. Enter cost: 50
5. Tap **"Enregistrer l'entretien"**

## 🐛 Troubleshooting

### Build Errors

#### "Cannot find type 'AuthViewModel'"
**Cause**: Files not added to Xcode project
**Fix**: Follow Step 1 again

#### "Use of unresolved identifier"
**Cause**: Missing import statements
**Fix**: Make sure all files are in the correct folders and added to the project target

#### "Ambiguous use of 'ContentView'"
**Cause**: Multiple ContentView definitions
**Fix**: The new ContentView in `karhebti-ios/ContentView.swift` should be the only one used

### Runtime Errors

#### "Failed to connect to localhost"
**Cause**: Backend not running or wrong URL
**Fix**: 
1. Make sure your backend is running: `npm start` or `node server.js`
2. Check the URL in `APIClient.swift`
3. For physical devices, use your Mac's IP address

#### "401 Unauthorized"
**Cause**: Token expired or not sent correctly
**Fix**: Log out and log in again

#### "Decoding error"
**Cause**: API response format doesn't match models
**Fix**: Check that your backend returns dates in ISO 8601 format

## 📝 Test Credentials

If your backend has test data:
```
Email: test@example.com
Password: password123
```

## 🎯 What's Implemented

✅ Complete authentication system (login, signup, forgot password)
✅ Vehicle management (CRUD operations)
✅ Maintenance tracking
✅ Garage directory
✅ Document management structure
✅ Beautiful, production-ready UI
✅ Error handling and loading states
✅ Pull-to-refresh
✅ Search functionality
✅ Status indicators

## 📱 App Structure

```
Login/Signup → Home Dashboard → 4 Tabs:
├─ Accueil (Dashboard with stats)
├─ Véhicules (Vehicle list & details)
├─ Garages (Garage directory)
└─ Profil (User settings & logout)
```

## 🔗 Useful Commands

### Check if backend is running:
```bash
curl http://localhost:3000/cars
```

### Get your Mac's IP address:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### Clean Xcode build:
```
Cmd + Shift + K (Clean Build Folder)
Cmd + B (Build)
```

## 📚 Next Steps

Once the app is running:
1. Explore the dashboard
2. Add multiple vehicles
3. Record maintenance for each vehicle
4. Browse and add garages
5. Test the profile and logout

## 💡 Tips

- Use **pull-to-refresh** on list views to reload data
- **Status badges** indicate vehicle health (BON, ATTENTION, URGENT)
- All forms have **validation** - required fields must be filled
- **Remember Me** checkbox saves your email for next login
- Use the **search bar** in garages to find specific services

## 🆘 Need Help?

Check the main README.md for:
- Complete API documentation
- Architecture details
- Full feature list
- Advanced troubleshooting

---

**Happy coding! 🚗💨**
