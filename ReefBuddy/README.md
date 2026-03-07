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
  Certification.swift        ← Certification model
  DiveWeather.swift          ← Weather & marine condition models
  MarineSpecies.swift        ← 52 species database + sighting model
  GearItem.swift             ← Gear equipment model with service tracking
  Achievement.swift          ← 30 achievement definitions with unlock logic
  DiveBuddy.swift            ← Buddy contact model
Storage/
  DiveStore.swift            ← Persistence (saves dives as JSON)
  FavoriteSitesStore.swift   ← Favorites & custom dive sites
  GearStore.swift            ← Gear equipment persistence
  BuddyStore.swift           ← Buddy contacts persistence
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
  NitroxCalculatorView.swift ← Nitrox MOD/EAD calculator
  WeightCalculatorView.swift ← Dive weight estimator
  ExploreView.swift          ← Explore hub (sites + sharing)
  AddCustomSiteView.swift    ← Add user dive sites
  DiveMapView.swift          ← Interactive MapKit dive map
  OnlineSiteSearchView.swift ← Online API site search
  DiveSiteDirectoryView.swift ← Dive site directory
  DiveSiteDetailView.swift   ← Individual dive site details
  ShareDiveView.swift        ← Share/export dive logs
  CertificationView.swift   ← Certification tracker
  DataManagementView.swift   ← Export/import dive data
  SettingsView.swift         ← Settings & profile
  DivePhotoPicker.swift      ← Photo picker (camera + library)
  DiveWeatherView.swift      ← Weather conditions display + site picker
  SpeciesPickerView.swift    ← Marine species catalog + sighting editor
  GearListView.swift         ← Gear list, detail, and service alerts
  AddGearView.swift          ← Add/edit gear form
  iPadSidebarView.swift      ← iPad sidebar navigation layout
  AchievementsView.swift     ← Achievement badge grid + progress
  BuddyListView.swift        ← Buddy list, detail, and add/edit views
  BuddyPickerField.swift     ← Buddy selector for dive form
Services/
  DiveSiteAPIService.swift   ← World Scuba Diving Sites API client
  PhotoStorage.swift         ← Dive photo file storage
  WeatherService.swift       ← Open-Meteo weather + marine API client
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

- **Dive Site Directory** — 87 world-class dive sites across 7 regions (Caribbean, Southeast Asia, Pacific, Red Sea, Americas, Mediterranean, Indian Ocean) with GPS coordinates, depth, difficulty, water temp, visibility, best months, and highlights
- **Site Detail Pages** — Full descriptions, quick-fact cards, and highlight lists for each dive site
- **Share Dive Logs** — Beautiful share card preview with dive stats, export via share sheet or copy to clipboard
- **Explore Hub** — Browse sites by region, share recent dives, and discover new destinations

## Features (Phase 5 - Enhanced Experience)

- **Edit Dives** — Tap the pencil icon on any dive detail to edit all fields
- **Sort & Filter** — Sort dive list by date, depth, or rating; filter by star rating or depth range
- **Search** — Search dives by site, location, or buddy name
- **Dive Numbering** — Auto-numbered dives in chronological order (#1 = first dive)
- **Dive Profile Chart** — Visual depth profile showing descent, bottom time, safety stop, and ascent
- **Current & Entry** — Log current strength (None/Mild/Moderate/Strong) and entry type (Shore/Boat/Pier)
- **Nitrox Calculator** — Calculate MOD, EAD, and ppO2 for enriched air mixes (EAN21–EAN40) with safety warnings
- **Weight Calculator** — Estimate dive weight based on body weight, suit type, water/tank type, and experience
- **Monthly Activity Chart** — Bar chart showing dive frequency over the last 6 months
- **Depth Distribution** — Horizontal bar chart showing how many dives in each depth range
- **Certification Tracker** — Log certs (OW, AOW, Rescue, Nitrox, etc.) with agency, date, and cert number
- **Favorite Sites** — Heart button to bookmark dive sites from the directory
- **Custom Dive Sites** — Add your own dive sites with full details to the directory
- **Data Export/Import** — JSON backup/restore via share sheet or clipboard for data portability

## Features (Phase 6 - Online & Maps)

- **Interactive Dive Map** — MapKit-powered world map with all 87+ dive sites pinned with colored markers by region. Filter by region, tap pins for site details
- **GPS Coordinates** — Every dive site includes real-world latitude/longitude for map display
- **Expanded Directory** — 87 curated sites (up from 12) across 7 regions including Mediterranean and Indian Ocean
- **Online Site Search** — Connect to the World Scuba Diving Sites API (15,000+ sites) to search by country and add results to your local directory
- **API Integration** — Optional RapidAPI key in Settings enables online search; app works fully offline without it
- **Region Filters** — Filter the map and directory by Caribbean, Southeast Asia, Pacific, Red Sea, Americas, Mediterranean, or Indian Ocean

## Features (Phase 7 - Dive Log Photos)

- **Photo Attachments** — Attach up to 10 photos per dive from camera or photo library
- **Camera Integration** — Take photos directly from the dive log using the device camera
- **Photo Library Picker** — Select multiple photos at once using the iOS PhotosPicker
- **Photo Gallery** — Scrollable horizontal photo gallery on each dive's detail page
- **Photo Management** — Remove individual photos from a dive; photos auto-delete when dives are deleted
- **Local Storage** — Photos saved as compressed JPEGs in the app's documents directory

## Features (Phase 8 - Weather & Conditions)

- **Dive Weather Tab** — Dedicated weather tab with real-time conditions for any dive site
- **Open-Meteo Integration** — Free weather API (no key required) for current weather data worldwide
- **Marine Conditions** — Wave height, wave period, wave direction, and ocean water temperature
- **Dive Condition Rating** — Automatic Excellent/Good/Fair/Poor rating based on wind, waves, and weather
- **Weather Details** — Air temp, humidity, wind speed/direction, UV index, cloud cover, pressure
- **Smart Dive Tips** — Context-aware recommendations based on current conditions (suit thickness, entry type, UV protection)
- **Site Picker** — Searchable dive site selector pulls from the full 87-site directory
- **Unit Aware** — All temperatures and measurements respect Imperial/Metric setting
- **Site Detail Integration** — "Check Weather" link on every dive site detail page

## Features (Phase 9 - Species Log)

- **Marine Species Database** — 52 curated species across 8 categories (fish, sharks, mammals, turtles, invertebrates, coral, cephalopods, crustaceans)
- **Species Sightings** — Log what you saw on each dive with count (1, 2-5, 6-20, 20+, School) and optional notes
- **Searchable Picker** — Full species catalog organized by category with search
- **Species Detail** — Tap any species for common name, scientific name, and description
- **Sighting Chips** — Compact species tags in the dive form with inline editing
- **Detail View** — Marine life section on dive detail showing all sightings with counts
- **Edit Support** — Add/remove/modify sightings when editing existing dives

## Features (Phase 10 - Gear Tracker)

- **Equipment Catalog** — Track all dive gear across 12 categories (regulator, BCD, wetsuit, drysuit, mask, fins, computer, tank, light, camera, weights, accessories)
- **Service Tracking** — Set service intervals and last service dates with automatic overdue/due-soon alerts
- **Service Alerts** — Color-coded warnings (red = overdue, orange = due within 30 days, green = good)
- **Gear Details** — Brand, model, serial number, purchase date, dive count, and notes per item
- **Gear Tab** — Dedicated tab with equipment organized by category
- **Retire Equipment** — Mark gear as retired to keep history without cluttering the active list
- **Add/Edit Forms** — Full gear management with toggleable service schedule and purchase tracking

## Features (Phase 11 - Social Sharing)

- **Styled Dive Cards** — Beautiful gradient cards with dive stats, conditions, species, and rating
- **4 Card Styles** — Ocean, Sunset, Deep, and Coral color themes
- **Share as Image** — High-resolution (3x) rendered card image for Instagram, iMessage, etc.
- **Save to Photos** — One-tap save card image to camera roll
- **Share as Text** — Plain text dive summary for messaging apps
- **Copy to Clipboard** — Quick copy of text dive log
- **Rich Card Content** — Shows depth, time, temp, visibility, conditions, species sightings, buddy, notes, and rating

## Features (Phase 12 - iPad Layout)

- **Adaptive Navigation** — Automatically switches between tab bar (iPhone) and sidebar (iPad)
- **Sidebar Navigation** — Collapsible sidebar on iPad with sections: Diving, Discover, Equipment, App
- **NavigationSplitView** — Native iPad split view with sidebar + detail pane
- **Full Reuse** — All existing views work in both layouts without modification
- **Size Class Detection** — Uses `horizontalSizeClass` environment to detect iPad vs iPhone

## Features (Phase 13 - Achievements & Badges)

- **30 Achievements** — Unlockable badges across 6 categories
- **Categories** — Milestones, Depth, Exploration, Dedication, Wildlife, Social
- **Progress Ring** — Visual progress indicator showing unlock percentage
- **Badge Grid** — 3-column grid with locked/unlocked visual states
- **Badge Details** — Tap any badge for name, description, and unlock status
- **Live Tracking** — Achievements evaluate in real-time against dive log data
- **Stats Integration** — Achievement progress card on the Stats dashboard

## Features (Phase 14 - Dive Buddy Manager)

- **Buddy Contacts** — Save dive buddies with name, certification level, phone, email, and notes
- **Favorites** — Star your frequent dive partners for quick access
- **Buddy Picker** — Select from saved buddies when logging a dive (or type a new name)
- **Shared History** — View all dives you've done together with a buddy, plus deepest dive stat
- **Buddy Detail** — Avatar with initials, contact info, dive stats, and shared dive list
- **iPad Sidebar** — Buddies section in iPad sidebar under Equipment
- **Settings Access** — Dive Buddies link in Settings > Profile & Data on iPhone
