# WatchVault 🎬

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20App-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Mobile App" />
  <img src="https://img.shields.io/badge/Dart-3-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart 3" />
  <img src="https://img.shields.io/badge/Material-3-6750A4?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material 3" />
</p>

<p align="center">
  <strong>Discover what to watch. Keep track of what you love.</strong>
</p>

<p align="center">
  A movie and TV show tracking application built with Flutter and Dart.
  Explore titles, manage your personal watchlist, track viewing progress, and rate the shows and movies you have watched.
</p>

---

## 📖 Overview

**WatchVault** is a movie and TV tracking application developed as part of the Mobile App Programming course.

The application provides a centralized space for discovering titles and organizing a personal viewing library through a clean, responsive interface. The project emphasizes maintainable code, feature-based organization, reusable components, and separation of concerns.

The current implementation includes a working UI and in-memory library management. Live catalog integration and persistent user data are part of the ongoing development roadmap.

## ✨ Features

- **Discover Movies & TV Shows** — Browse curated Trending, Popular Series, and Top Rated sections.
- **Search Catalog** — Search available titles and access their details.
- **Title Details** — Explore title information and manage library actions.
- **Personal Watchlist** — Add titles to your personal library and remove them when needed.
- **Viewing Progress** — Organize titles into three statuses:
  - Want to Watch
  - Watching
  - Watched
- **Personal Ratings** — Rate titles you have watched.
- **Library Statistics** — View library counts and average ratings.
- **Responsive Interface** — Adapt layouts to different screen sizes.
- **Structured Navigation** — Use named routes, tab-based navigation, and poster transitions.
- **Error Handling** — Provide loading and error states with retry and refresh actions.

## 🖼️ Screenshots

<p align="center">
  <em>Screenshots coming soon.</em>
</p>

<!--
Add your actual screenshots to a screenshots/ directory and replace
the placeholders below with the correct image paths.

<p align="center">
  <img src="screenshots/home.png" width="250" alt="Home Screen" />
  <img src="screenshots/search.png" width="250" alt="Search Screen" />
  <img src="screenshots/library.png" width="250" alt="Library Screen" />
</p>
-->

## 🛠️ Tech Stack

### Core Technologies

<p align="left">
  <a href="https://flutter.dev/" target="_blank">
    <img src="https://skillicons.dev/icons?i=flutter" width="48" height="48" alt="Flutter" />
  </a>
  <a href="https://dart.dev/" target="_blank">
    <img src="https://skillicons.dev/icons?i=dart" width="48" height="48" alt="Dart" />
  </a>
  <a href="https://code.visualstudio.com/" target="_blank">
    <img src="https://skillicons.dev/icons?i=vscode" width="48" height="48" alt="Visual Studio Code" />
  </a>
  <a href="https://git-scm.com/" target="_blank">
    <img src="https://skillicons.dev/icons?i=git" width="48" height="48" alt="Git" />
  </a>
  <a href="https://github.com/" target="_blank">
    <img src="https://skillicons.dev/icons?i=github" width="48" height="48" alt="GitHub" />
  </a>
</p>

### Framework & UI

- **Flutter** — Cross-platform application development.
- **Dart 3** — Application logic and type-safe programming.
- **Material 3** — Modern UI components and application theming.

### State Management

- **ChangeNotifier** — Notify listeners when application state changes.
- **InheritedNotifier** — Expose shared state throughout the widget tree.
- **Native Flutter State Management** — No additional state-management package required.

### Architecture & Design

- **Feature-Based Structure** — Organize the application around individual features.
- **Repository Pattern** — Separate data access from application logic.
- **Separation of Concerns** — Keep presentation, application logic, and data responsibilities distinct.
- **Reusable Components** — Share common UI elements and styling.

### API & Data

<p align="left">
  <a href="https://developer.themoviedb.org/" target="_blank">
    <img src="https://img.shields.io/badge/TMDB-API-01B4E4?style=for-the-badge&logo=themoviedatabase&logoColor=white" alt="The Movie Database API" />
  </a>
</p>

The project includes a TMDB client and catalog data layer. Full integration with the application screens is still in progress.

> **Current data limitation:** The catalog and personal library currently use mock and in-memory data. Library changes are not persisted after the application process ends.

## 🏗️ Project Structure

```text
lib/
├── core/
│   ├── theme/
│   ├── widgets/
│   └── routing/
│
├── features/
│   ├── home/           # Curated catalog sections
│   ├── search/         # Catalog search
│   ├── library/        # Personal library management
│   │   ├── domain/
│   │   ├── application/
│   │   ├── data/
│   │   └── presentation/
│   ├── details/        # Title details and library actions
│   ├── profile/        # User statistics and profile UI
│   └── shell/          # Main tab navigation
│
├── app.dart
└── main.dart

test/
```

*This tree illustrates the intended organization of the main modules; consult the actual repository for the exact file and directory names.*

## 🚀 Getting Started

Follow these steps to run WatchVault locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK compatible with your installed Flutter version
- [Visual Studio Code](https://code.visualstudio.com/) or Android Studio
- Chrome for web execution, or an Android emulator or connected device

### 1. Clone the Repository

```bash
git clone https://github.com/youssef-011/WatchVault.git
cd WatchVault
```

Replace the repository URL if your GitHub repository uses a different name.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment

If your local setup requires TMDB configuration, create the configuration file expected by the project:

```text
config/
└── tmdb.json
```

Provide the required configuration values locally, following the format expected by the application.

**Security note:** Never commit API keys, credentials, or other secrets to version control.

### 4. Run the Application

**Web — Chrome**

```bash
flutter run -d chrome --dart-define-from-file=config/tmdb.json
```

**Android — Emulator or Connected Device**

```bash
flutter run --dart-define-from-file=config/tmdb.json
```

If the application can run without the TMDB configuration file, omit the `--dart-define-from-file` argument.

## 🧪 Testing & Code Quality

WatchVault includes tests for application components such as models, repositories, controllers, and widgets.

Run the test suite:

```bash
flutter test
```

Analyze the project:

```bash
flutter analyze
```

These commands help verify expected behavior and identify potential code issues.

## 📌 Development Status

| Component | Status |
|---|---|
| Main UI and navigation | Implemented |
| Catalog browsing interface | Implemented with current catalog data |
| Search interface | Implemented |
| Library management | Implemented with in-memory storage |
| Viewing statuses and ratings | Implemented in the current library flow |
| TMDB client and catalog data layer | Available; screen integration in progress |
| Persistent library storage | Planned |
| Firebase Authentication | Planned |
| Cloud Firestore integration | Planned |

## 🗺️ Roadmap

- [ ] Connect the Home screen to live TMDB catalog data.
- [ ] Integrate live catalog search.
- [ ] Complete loading, empty, and error states for API requests.
- [ ] Persist library changes between application sessions.
- [ ] Implement Firebase Authentication.
- [ ] Integrate Cloud Firestore for user-specific library data.
- [ ] Expand unit and widget test coverage.
- [ ] Improve accessibility and responsive layouts.
- [ ] Refine the overall user experience.

## 🔐 Security

- Keep API credentials and local configuration out of public repositories.
- Use local configuration for development secrets.
- Review API key restrictions and deployment requirements before publishing the application.

## 🎓 Project Context

**Course:** Mobile App Programming  
**Framework:** Flutter  
**Language:** Dart

This project is an opportunity to apply mobile development concepts, state management, repository abstraction, modular architecture, and automated testing in a practical application.

## 👨‍💻 Author

**Youssef Zenhom**

<p align="left">
  <a href="https://github.com/youssef-011">
    <img src="https://img.shields.io/badge/GitHub-youssef--011-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Profile" />
  </a>
</p>

---

<p align="center">
  <strong>WatchVault</strong>
  <br />
  Your next favorite story starts here.
</p>
