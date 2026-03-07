# Types of Apps You Can Build for iOS

## 1. Standard iOS Apps (UIKit / SwiftUI)

Traditional apps that run on iPhone and iPad. These are the most common type and cover a wide range of use cases:

- **Productivity apps** — task managers, note-taking, calendars
- **Social media apps** — messaging, photo sharing, feeds
- **E-commerce apps** — shopping, payments, product catalogs
- **Entertainment apps** — streaming, music players, podcasts
- **Health & fitness apps** — workout trackers, step counters, diet logs
- **Education apps** — courses, flashcards, language learning
- **Finance apps** — banking, budgeting, stock trading
- **Travel apps** — maps, booking, itinerary planners
- **News & media apps** — article readers, RSS feeds, magazines
- **Utility apps** — calculators, weather, QR scanners

**Frameworks:** SwiftUI, UIKit
**Languages:** Swift, Objective-C

---

## 2. Games

iOS is one of the largest mobile gaming platforms. You can build:

- **Casual 2D games** — puzzles, card games, platformers
- **3D games** — racing, adventure, simulation
- **AR games** — augmented reality experiences using the camera
- **Multiplayer games** — real-time or turn-based online games

**Frameworks:** SpriteKit (2D), SceneKit (3D), Metal (high-performance graphics), GameplayKit, Unity, Unreal Engine

---

## 3. Widgets (WidgetKit)

Small, glanceable views that live on the Home Screen or Lock Screen. They display timely, relevant information without opening the full app.

- **Static widgets** — show fixed data (e.g., a quote of the day)
- **Dynamic widgets** — update periodically (e.g., weather, stocks)
- **Interactive widgets** — support taps and toggles (iOS 17+)
- **Live Activities** — real-time updates on the Lock Screen and Dynamic Island

**Framework:** WidgetKit, ActivityKit

---

## 4. watchOS Apps (Apple Watch)

Apps designed for Apple Watch, either standalone or as companions to an iPhone app:

- **Workout & fitness trackers**
- **Notification-driven apps**
- **Complications** — small data displays on watch faces
- **Health monitoring apps** — heart rate, blood oxygen, sleep

**Framework:** SwiftUI (preferred), WatchKit

---

## 5. tvOS Apps (Apple TV)

Apps and games for the big screen:

- **Streaming video apps**
- **TV games** — controller or remote-based
- **Digital signage / presentation apps**
- **Fitness apps** — guided workouts on a TV

**Framework:** SwiftUI, UIKit (TVUIKit)

---

## 6. visionOS Apps (Apple Vision Pro)

Spatial computing apps for Apple's mixed-reality headset:

- **Immersive 3D experiences**
- **Spatial productivity apps** — windows placed in your room
- **AR/VR collaboration tools**
- **3D object viewers**

**Framework:** SwiftUI, RealityKit, ARKit

---

## 7. App Clips

Lightweight, fast-loading portions of your app (under 15 MB) that users can access without installing the full app:

- **Order-ahead at a restaurant**
- **Rent a scooter or bike**
- **Pay for parking**
- **Try a feature before downloading**

Triggered via NFC tags, QR codes, App Clip Codes, Safari links, or Messages.

**Framework:** SwiftUI, UIKit (same as standard apps, with size constraints)

---

## 8. iMessage Apps & Sticker Packs

Apps that live inside the Messages app:

- **Sticker packs** — static or animated stickers (no code required for simple packs)
- **Interactive iMessage apps** — collaborative games, polls, shared content

**Framework:** Messages framework

---

## 9. Safari Web Extensions

Browser extensions for Safari on iOS and macOS:

- **Content blockers** — ad blockers, tracker blockers
- **Page-modifying extensions** — dark mode, reader tools, translation
- **Toolbar extensions** — password managers, bookmarking tools

**Languages:** JavaScript, HTML, CSS (bundled in a native app container)

---

## 10. Keyboard Extensions

Custom keyboards that replace the system keyboard:

- **Alternative input methods** — swipe typing, voice input
- **Themed keyboards** — custom styles and layouts
- **Language-specific keyboards**

**Framework:** UIKit (UIInputViewController)

---

## 11. SharePoint / Action Extensions

Extensions that appear in the system Share Sheet or Action menu:

- **Share extensions** — post to social media, save to your app
- **Action extensions** — translate text, markup photos, convert files

**Framework:** UIKit, SwiftUI

---

## 12. Document Provider / File Provider Extensions

Integrate with the Files app:

- **Cloud storage providers** — expose your cloud files in the Files app
- **Custom document formats** — open and save proprietary file types

**Framework:** FileProvider

---

## 13. Siri Shortcuts & App Intents

Voice-driven and automation-ready integrations:

- **Custom Siri voice commands** — "Hey Siri, log my water intake"
- **Shortcuts app actions** — expose app functionality as automation building blocks
- **Spotlight integration** — make app content searchable

**Framework:** App Intents, SiriKit

---

## 14. Network & VPN Extensions

System-level networking tools:

- **VPN apps** — personal VPN clients
- **Content filters** — parental controls, corporate security
- **DNS proxies** — custom DNS resolution
- **Hotspot helpers** — auto-join Wi-Fi networks

**Framework:** NetworkExtension

---

## 15. Audio & Camera Extensions

Plug into system media pipelines:

- **Audio Unit (AUv3) extensions** — synthesizers, effects, instruments for GarageBand and other DAWs
- **Camera Capture extensions** — custom camera modes available system-wide (iOS 18+)

**Framework:** AudioToolbox, AVFoundation

---

## Summary Table

| App Type | Platform | Key Framework |
|---|---|---|
| Standard App | iPhone / iPad | SwiftUI, UIKit |
| Game | iPhone / iPad | SpriteKit, Metal, Unity |
| Widget | iPhone / iPad | WidgetKit |
| Watch App | Apple Watch | SwiftUI, WatchKit |
| TV App | Apple TV | SwiftUI, TVUIKit |
| Vision App | Apple Vision Pro | SwiftUI, RealityKit |
| App Clip | iPhone / iPad | SwiftUI (< 15 MB) |
| iMessage App | Messages | Messages framework |
| Safari Extension | Safari | JS / HTML / CSS |
| Keyboard Extension | System-wide | UIKit |
| Share Extension | Share Sheet | UIKit, SwiftUI |
| File Provider | Files app | FileProvider |
| Siri / Shortcuts | System-wide | App Intents |
| Network Extension | System-wide | NetworkExtension |
| Audio Extension | System-wide | AudioToolbox |

---

All of these app types are distributed through the **App Store** (or TestFlight for beta testing) and are built using **Xcode** on macOS.
