# WatchVault

WatchVault is a movie and TV tracker built with Flutter and Dart for the Mobile App Programming course. It provides a UI for browsing, searching, and organizing titles, with its current catalog and library held in memory.

## Features

- Browse curated Trending, Popular Series, and Top Rated sections.
- Search the catalog and inspect title details.
- Add titles, track Want to Watch / Watching / Watched status, rate watched titles, and remove titles.
- View library counts and average rating on the profile screen.
- Use responsive layouts, named routes, poster transitions, loading/error states, and retry/refresh actions.

## Technology

Flutter and Dart 3, Material 3, `ChangeNotifier` with `InheritedNotifier` for app state (no state-management package), and a repository layer backed by an in-memory implementation.

## Project structure

```text
lib/
  core/             shared theme, widgets, and routing
  features/
    home/           curated catalog sections
    search/         catalog search
    library/        domain, application, data, and presentation
    details/        title details and library actions
    profile/        library statistics and profile UI
    shell/          main tab navigation
  app.dart
  main.dart
test/               widget and model/repository/controller tests
```

## Run locally

```sh
flutter pub get
flutter run
flutter test
flutter analyze
```

## Status and roadmap

The app currently uses mock catalog/library data and an in-memory repository; changes are not persisted after the app process ends. Planned work is Firebase Authentication and Firestore persistence, followed by TMDB catalog/search integration. No secrets are committed; provide any future API keys through local configuration.
