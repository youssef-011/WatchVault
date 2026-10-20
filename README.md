# WatchVault 🎬

**Your personal space to discover, track, and organize movies and TV shows.**

WatchVault is a Flutter-based movie and TV tracking application developed as part of the Mobile App Programming course. It provides a clean, responsive interface for exploring titles, searching the catalog, managing a personal watchlist, tracking viewing progress, and rating completed titles.

The project focuses on maintainable Flutter architecture, reusable UI components, and a clear separation between presentation, application logic, and data access.

---

## ✨ Features

- **Discover Titles** — Explore curated Trending, Popular Series, and Top Rated sections.
- **Search** — Find titles in the available catalog and navigate to their details.
- **Title Details** — Inspect individual titles and manage library actions.
- **Personal Library** — Add and remove titles and organize them by viewing status.
- **Viewing Progress** — Track titles as *Want to Watch*, *Watching*, or *Watched*.
- **Ratings** — Rate watched titles and view your library's average rating.
- **Profile & Statistics** — View library counts and personal tracking statistics.
- **Responsive UI** — Adapt the interface to different screen sizes.
- **Navigation & Transitions** — Use named routes, poster transitions, and a structured tab-based navigation system.
- **Loading & Error Handling** — Handle loading and error states with retry and refresh actions.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI development |
| Dart 3 | Application logic and models |
| Material 3 | Modern interface and theming |
| ChangeNotifier | Application state notifications |
| InheritedNotifier | Sharing application state across the widget tree |
| Repository Pattern | Separation of data access from application logic |
| TMDB API integration layer | Foundation for movie and TV catalog data |

**State management:** Native Flutter mechanisms, without an additional state-management package.

## 🏗️ Architecture

WatchVault follows a feature-oriented project structure, with dedicated modules for its main application features and shared components.

```text
lib/
├── core/
│   ├── theme/
│   ├── widgets/
│   └── routing/
├── features/
│   ├── home/
│   ├── search/
│   ├── library/
│   │   ├── domain/
│   │   ├── application/
│   │   ├── data/
│   │   └── presentation/
│   ├── details/
│   ├── profile/
│   └── shell/
├── app.dart
└── main.dart

test/
```

*The directory names above illustrate the main organization; the exact files and subdirectories depend on the current implementation.*

### Design Principles

- **Separation of Concerns** — Keep UI responsibilities distinct from application logic and data access.
- **Reusable Components** — Share common UI elements and styling across features.
- **Centralized State Access** — Use `ChangeNotifier` and `InheritedNotifier` to expose and update application state.
- **Repository Abstraction** — Keep the library's data operations behind a repository interface.
- **Testability** — Support focused tests for models, repositories, controllers, and widgets.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK compatible with the project's Flutter version
- [Visual Studio Code](https://code.visualstudio.com/) or Android Studio
- A browser for web execution or an Android emulator/device

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/youssef-011/WatchVault.git
cd WatchVault
```

Replace the repository URL if your GitHub repository uses a different name or location.

**2. Install dependencies**

```bash
flutter pub get
```

**3. Configure local TMDB settings**

If your local setup requires TMDB configuration, create the configuration file expected by the project. For example:

```text
config/
└── tmdb.json
```

Supply the required values locally according to the project's configuration format. Do not commit API keys or other secrets.

**4. Run the application**

For web:

```bash
flutter run -d chrome --dart-define-from-file=config/tmdb.json
```

For a connected device or emulator:

```bash
flutter run --dart-define-from-file=config/tmdb.json
```

If the current UI does not require TMDB configuration, run the app without the `--dart-define-from-file` argument.

## 🧪 Testing & Code Quality

Run the automated tests:

```bash
flutter test
```

Analyze the project for potential issues:

```bash
flutter analyze
```

These checks help validate application behavior and identify common Dart and Flutter issues.

## 📌 Current Status

WatchVault is under active development.

| Component | Current status |
|---|---|
| Main UI and navigation | Implemented |
| Catalog browsing and search UI | Implemented with the current catalog data |
| Personal library management | Implemented with in-memory storage |
| Viewing statuses and ratings | Implemented in the current library flow |
| TMDB data layer | Available; screen integration remains in progress |
| Persistent storage | Not yet implemented |
| Firebase Authentication | Planned |
| Cloud persistence with Firestore | Planned |

**Current limitation:** Library changes are held in memory and are lost when the application process ends. The TMDB data layer exists, but the screens have not yet been fully connected to live catalog data.

## 🗺️ Roadmap

- [ ] Integrate the TMDB catalog with the browsing and search screens.
- [ ] Complete loading, empty, and error-state handling for live data.
- [ ] Implement persistent library storage.
- [ ] Add Firebase Authentication.
- [ ] Integrate Cloud Firestore for user-specific library data.
- [ ] Expand automated tests and edge-case coverage.
- [ ] Refine the UI and accessibility across screen sizes.

## 🎓 Project Context

Developed for the **Mobile App Programming** course using Flutter and Dart.

The project serves as a practical exercise in mobile application development, state management, feature-based organization, repository abstraction, and automated testing.

## 👨‍💻 Author

**Youssef Zenhom**

- GitHub: [@youssef-011](https://github.com/youssef-011)

---

*WatchVault — Discover what to watch. Keep track of what you love.*
