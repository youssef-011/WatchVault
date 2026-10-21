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
  A movie and TV show tracking application built with Flutter and Dart for the Mobile App Programming course. Discover titles from TMDB, inspect their details, and organize a personal watchlist with viewing statuses and ratings.
</p>

---

## 📖 Overview

**WatchVault** is a movie and TV tracking application developed as part of the Mobile App Programming course. It uses a feature-first structure, reusable Material 3 widgets, and repository boundaries to keep the catalog and personal library separate.

## ✨ Features

- **Discover Movies & TV Shows** — Home loads five live TMDB sections: Trending, Popular Movies, Popular Series, Top Rated Movies, and Top Rated Series.
- **Search Catalog** — Search TMDB titles with a debounced query and open matching details.
- **Title Details** — Load TMDB metadata, including genres, movie runtime, and series seasons.
- **Personal Watchlist** — The library starts empty. Add any catalog title or enter a manual title.
- **Viewing Progress** — Organize titles as Want to Watch, Watching, or Watched.
- **Personal Ratings** — Give watched titles ratings in half-star steps.
- **Library Statistics** — View status counts and the average of rated watched titles.
- **Responsive Interface** — Adapt catalog cards and library grids to screen size and text scale.
- **Navigation and feedback** — Use named routes, poster Hero transitions, retry states, and library quick actions.

Library contents are held in memory and are not persisted after the app process ends. Firebase Authentication and Firestore are planned.

## 🖼️ Screenshots

<p align="center">
  <em>Screenshots coming soon.</em>
</p>

<!--
Add screenshots to a screenshots/ directory and update these paths when available.
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
- **Dart 3** — Application logic and null-safe types.
- **Material 3** — UI components with dark and light themes.

### State Management

- **ChangeNotifier** — Notify screens when controller state changes.
- **InheritedNotifier** — Expose library state through `LibraryScope`.
- **No state-management package** — The app uses Flutter's built-in state tools.

### Architecture & Design

- **Feature-first structure** — Group code by shared core and app feature.
- **Repository layer** — Separate catalog and library data access from UI.
- **Reusable components** — Share cards, posters, load states, and spacing tokens.

### API & Data

<p align="left">
  <a href="https://developer.themoviedb.org/" target="_blank">
    <img src="https://img.shields.io/badge/TMDB-API-01B4E4?style=for-the-badge&logo=themoviedatabase&logoColor=white" alt="The Movie Database API" />
  </a>
</p>

The catalog uses TMDB through the `http` package. The personal library uses an in-memory repository and is not saved across app restarts.

## 🏗️ Project Structure

```text
lib/
├── core/
│   ├── config/
│   ├── models/
│   ├── router/
│   ├── theme/
│   └── widgets/
├── features/
│   ├── catalog/
│   │   ├── application/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   │   ├── application/
│   │   └── presentation/
│   ├── search/
│   │   ├── application/
│   │   └── presentation/
│   ├── library/
│   │   ├── application/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── details/
│   │   ├── application/
│   │   └── presentation/
│   ├── profile/
│   │   └── presentation/
│   └── shell/
│       └── presentation/
├── app.dart
└── main.dart

test/
└── helpers/
```

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Chrome for web, or an Android emulator/device

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure TMDB

Live catalog data requires `config/tmdb.json` with a `TMDB_READ_TOKEN` value. This local file is gitignored and must not be committed. Use `config/tmdb.example.json` as the template, then provide your own TMDB read token in the local config file.

### 3. Run the Application

**Web — Chrome**

```bash
flutter run -d chrome --dart-define-from-file=config/tmdb.json
```

**Android — Emulator or Connected Device**

```bash
flutter run --dart-define-from-file=config/tmdb.json
```

Without a valid token, catalog requests return an authorization error and the UI shows its error state.

## 🧪 Testing & Code Quality

Run the test suite:

```bash
flutter test
```

Analyze the project:

```bash
flutter analyze
```

## 📌 Development Status

| Component | Status |
|---|---|
| Home TMDB sections | Implemented: five live catalog sections |
| Search and title details | Implemented with TMDB catalog data |
| Library statuses, ratings, and snapshots | Implemented with in-memory storage |
| Responsive UI and loading/error states | Implemented |
| Firebase Authentication | Planned |
| Firestore persistence | Planned |

## 🗺️ Roadmap

- [ ] Add Firebase Authentication and user sessions.
- [ ] Persist each user's library in Firestore.
- [ ] Continue improving accessibility and responsive layouts.
- [ ] Add screenshots and refine the overall experience.

## 🔐 Security

- Keep `config/tmdb.json` and all credentials out of version control.
- Use local configuration for development secrets.
- Review token restrictions and deployment requirements before release.

## 🎓 Project Context

**Course:** Mobile App Programming  
**Framework:** Flutter  
**Language:** Dart

## Credits

This product uses the TMDB API but is not endorsed or certified by TMDB.

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
