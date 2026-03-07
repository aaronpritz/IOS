# ReefBuddy - Scuba Diving App

A SwiftUI scuba diving companion app designed to be built and tested in **Swift Playgrounds on iPad**.

## How to Use in Swift Playgrounds

1. Open **Swift Playgrounds** on your iPad
2. Tap **"App"** at the bottom to create a new app project
3. Delete the default `ContentView.swift` file
4. Create the following files and paste the code from this repo:

### File Structure

```
ReefBuddyApp.swift          ← Main app entry point
Models/
  Dive.swift                 ← Dive data model
  UnitSettings.swift         ← Imperial/Metric unit conversions
Storage/
  DiveStore.swift            ← Persistence (saves dives as JSON)
Views/
  DiveListView.swift         ← Main dive log list
  DiveDetailView.swift       ← Individual dive details
  AddDiveView.swift          ← Form to log a new dive
  StatsView.swift            ← Stats dashboard
  SettingsView.swift         ← Settings (unit toggle)
```

### Step-by-Step Setup

1. **Create the app** in Swift Playgrounds
2. **Rename** the default file to `ReefBuddyApp.swift` and paste its contents
3. **Create** `Dive.swift` and paste the model code
4. **Create** `DiveStore.swift` and paste the storage code
5. **Create** each view file (`DiveListView.swift`, `DiveDetailView.swift`, `AddDiveView.swift`, `StatsView.swift`, `SettingsView.swift`)
6. **Run** the app — you should see the dive list with sample data!

> **Tip:** In Swift Playgrounds, you can create new files by tapping the file icon in the sidebar.
> Files don't need to be in folders — Swift Playgrounds will find them regardless of organization.

## Features (Phase 1 - Dive Log)

- **US Imperial by default** (feet, °F) with option to switch to Metric (meters, °C)
- Log dives with depth, time, location, buddy, conditions, and notes
- View dive history in a scrollable list
- Tap any dive to see full details
- Star rating system (1-5)
- Stats dashboard (total dives, deepest dive, total time, avg depth)
- Swipe to delete dives
- Offline-first — all data saved locally on device
- Sample dives included to see the app in action immediately

## Coming Soon

- **Phase 2:** Reference guide (hand signals, safety checklists, dive tables)
- **Phase 3:** Dive planning (no-deco calculator, gas planning)
- **Phase 4:** Social features (dive site directory, photo gallery, sharing)
