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
  HandSignal.swift           ← Hand signal data
  SafetyItem.swift           ← Safety checklist data
  DiveTable.swift            ← No-deco limit table data
  DiveSite.swift             ← Dive site directory data
Storage/
  DiveStore.swift            ← Persistence (saves dives as JSON)
Views/
  DiveListView.swift         ← Main dive log list
  DiveDetailView.swift       ← Individual dive details
  AddDiveView.swift          ← Form to log a new dive
  StatsView.swift            ← Stats dashboard
  ReferenceView.swift        ← Reference guide hub
  HandSignalsView.swift      ← Underwater hand signals
  SafetyChecklistView.swift  ← Interactive safety checklists
  DiveTableView.swift        ← No-deco limits lookup
  PlanView.swift             ← Dive planning hub
  DepthPlannerView.swift     ← No-deco & repetitive dive planner
  GasCalculatorView.swift    ← Air consumption calculator
  GearChecklistView.swift    ← Gear packing checklist
  ExploreView.swift          ← Explore hub (sites + sharing)
  DiveSiteDirectoryView.swift ← Dive site directory
  DiveSiteDetailView.swift   ← Individual dive site details
  ShareDiveView.swift        ← Share/export dive logs
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

## Features (Phase 2 - Reference Guide)

- **Hand Signals** — 20 underwater signals across 4 categories (Essential, Direction, Status, Marine Life) with expandable cards showing how to signal and when to use each one
- **Dive Tables** — Interactive no-deco limit lookup with depth slider, color-coded limits, and full reference table
- **Safety Checklists** — Interactive checklists with progress tracking:
  - Pre-dive buddy check (BWRAF)
  - Gear packing checklist
  - Emergency procedures

## Features (Phase 3 - Dive Planning)

- **Dive Planner** — Plan first and second (repetitive) dives with depth/time sliders, surface interval calculator, and adjusted no-deco limits for the second dive
- **Gas Calculator** — Calculate available bottom time based on tank size (AL63–HP120), start pressure, SAC rate, and depth. Includes Rule of Thirds visualization, turn pressure, and no-deco vs. gas limit comparison
- **Gear Checklist** — 27 items across 5 categories (Essentials, Exposure, Accessories, Safety, Personal) with progress tracking. Add custom items and reset between trips. Saved locally.

## Features (Phase 4 - Explore & Share)

- **Dive Site Directory** — 12 world-class dive sites across 5 regions (Caribbean, Southeast Asia, Pacific, Red Sea, Americas) with detailed info: depth, difficulty, water temp, visibility, best months, and highlights
- **Site Detail Pages** — Full descriptions, quick-fact cards, and highlight lists for each dive site
- **Share Dive Logs** — Beautiful share card preview with dive stats, export via share sheet or copy to clipboard
- **Explore Hub** — Browse sites by region, share recent dives, and discover new destinations
