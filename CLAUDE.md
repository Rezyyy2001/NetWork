# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NetWork is a SwiftUI iOS social networking app for tennis players. It uses Firebase (Auth, Firestore, Analytics) as its backend and Google Places API for location/court search.

## Build & Run

This is a pure Xcode project — no SPM, CocoaPods, or Makefile.

- **Build/Run:** Open `NetWork.xcodeproj` in Xcode, select a simulator, and press ⌘R.
- **API Keys:** `Secrets.xcconfig` is injected at build time via `Info.plist`. The `Secrets` enum reads from the bundle at runtime.
- **Firebase:** `GoogleService-Info.plist` must be present for Firebase to initialize.
- **No test target exists** in the project; there is no `xcodebuild test` command to run.

## Architecture

**MVVM with a Service Layer.** The pattern is consistent across all features:

```
View  →  ViewModel (@MainActor, ObservableObject)  →  Service  →  Firebase / URLSession
```

- **ViewModels** are `final class`, always marked `@MainActor`, expose `@Published` state.
- **Services** handle all Firebase/network I/O; they are `Sendable` structs or singletons.
- **No coordinator pattern** — navigation is SwiftUI-native (`NavigationStack`, `navigationDestination`, `sheet`).
- **Auth routing** lives in `App/AuthState.swift` (ObservableObject). `ContentView` switches between login and home based on it; a UUID reset forces SwiftUI to re-init the home tree on sign-out.

## Directory Layout

```
NetWork/
├── App/                  # Entry point, AppDelegate (Firebase init), AuthState
├── Core/
│   ├── Extensions/       # Date.age, etc.
│   ├── Models/           # Shared data types (UserProfile, Message, UserStub, FriendshipStatus)
│   └── Protocols/        # UserProfileDataProvider (@MainActor protocol)
├── Features/
│   ├── Authentication/   # Login, Signup, AuthenticationManager (singleton)
│   ├── Chat/             # Real-time Firestore messaging, ListenerRegistration cleanup in deinit
│   ├── Friends/          # Friend requests & list; FriendService handles all Firestore queries
│   ├── Profile/          # CurrentUser vs OtherUser split into separate services & view models
│   ├── Search/           # User search (Firestore) + GooglePlacesService (URLSession)
│   ├── Post/             # Create posts with location autocomplete
│   ├── Settings/         # Profile editing, sign-out
│   └── Local/            # Stub feature (minimal)
└── Reusables/            # Shared UI: CustomTabView, InputView, StubView, PlaceSuggestionView
```

## Key Conventions

- **Strict concurrency:** All Firebase imports use `@preconcurrency import FirebaseFirestore` (and Auth) to suppress Sendable warnings without hiding real issues.
- **Firestore listeners** must be stored as `ListenerRegistration` and removed in `deinit`.
- **`@DocumentID`** is used on Firestore-mapped model IDs (e.g., `Message`).
- **`UserStub`** is a lightweight reference type used when a full `UserProfile` isn't needed (e.g., friend lists, search results).
- **Singletons:** `AuthenticationManager.shared` and `CurrentUserService.shared` — do not create additional instances.
- **Google Places** calls are made directly via `URLSession` in `GooglePlacesService`; the key comes from `Secrets.googlePlacesAPIKey`.
