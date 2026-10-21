# WatchVault project status

## Implemented

- App startup, repository injection, and controller lifecycle: `lib/main.dart`, `lib/app.dart` (`WatchVaultApp`).
- Material 3 dark-default and light themes, colors, text styles, and spacing tokens: `lib/core/theme/`.
- Named routes for Details and Add Title, with argument validation and a not-found page: `lib/core/router/app_routes.dart`, `details_route_arguments.dart`.
- Four-tab shell using `NavigationBar` and `IndexedStack`: `lib/features/shell/presentation/main_shell.dart`.
- Live Home catalog sections (Trending, Popular Movies, Popular Series, Top Rated Movies, Top Rated Series), independent loading/error/retry, and refresh: `lib/features/home/application/home_controller.dart`, `lib/features/home/presentation/home_screen.dart`.
- Debounced TMDB Search with a two-character minimum, stale-response protection, retry, and catalog-only results: `lib/features/search/application/search_results_controller.dart`, `lib/features/search/presentation/search_screen.dart`.
- Details screen with poster, basic media data, loaded genres/runtime/seasons, retryable metadata errors, and library controls: `lib/features/details/`.
- Empty personal library that can store media snapshots, status, and optional ratings: `lib/features/library/domain/library_item.dart`, `lib/features/library/application/library_controller.dart`.
- Manual title form, negative IDs assigned by the controller, and library tabs, responsive grids, refresh, and long-press actions: `lib/features/library/presentation/`, `lib/features/library/application/library_controller.dart`.
- Profile counts and average rating derived from library items. Profile/account actions remain placeholders: `lib/features/profile/presentation/profile_screen.dart`.
- Shared media cards, poster image fallback, loading/empty states, and responsive card sizing: `lib/core/widgets/`.

## Architecture and data flow

- `core/models/` contains shared `MediaItem`, `MediaKey`, `MediaType`, and `LoadStatus` types.
- `features/catalog/domain/catalog_repository.dart` defines catalog reads; `features/catalog/data/tmdb_catalog_repository.dart` maps TMDB JSON.
- `features/catalog/data/tmdb_client.dart` sends authenticated requests and converts failures to `CatalogException`; `catalog_exception_message.dart` provides short user messages.
- `features/catalog/application/catalog_scope.dart` exposes the injected catalog repository.
- `features/library/domain/library_repository.dart` defines snapshot load/save/remove operations; `in_memory_library_repository.dart` starts empty and is process-local.
- `LibraryController` owns library snapshots and optimistic mutations; `LibraryScope` exposes it as an `InheritedNotifier`.
- Home, Search, and Details use their own `ChangeNotifier` controllers. Screens use `ListenableBuilder` to reflect controller changes.
- `WatchVaultApp` defaults to `TmdbCatalogRepository` and `InMemoryLibraryRepository`; tests inject fakes (`lib/app.dart`, `test/helpers/`).

## Concepts used

### Dart

- Classes, constructors, named/optional parameters, null safety: `MediaItem` and `LibraryEntry` (`lib/core/models/media_item.dart`, `lib/features/library/domain/library_entry.dart`).
- Lists, maps, loops, conditions, `final`, and `const`: library aggregation and updates (`lib/features/library/application/library_controller.dart`).
- Arrow functions and interpolation: callbacks and screen labels (`lib/features/library/presentation/library_screen.dart`).
- Enums and extensions: `MediaType`, `WatchStatus`, and status labels (`lib/core/models/media_type.dart`, `lib/features/library/domain/watch_status.dart`, `watch_status_label.dart`).
- Map conversion, `copyWith`, equality, and `hashCode`: shared and library models (`lib/core/models/media_item.dart`, `lib/core/models/media_key.dart`, `lib/features/library/domain/library_entry.dart`, `library_item.dart`).
- Interface, futures, async/await, and try/catch: repositories and controllers (`lib/features/catalog/domain/catalog_repository.dart`, `lib/features/library/domain/library_repository.dart`, `lib/features/library/application/library_controller.dart`).

### Flutter

- `StatelessWidget`, `StatefulWidget`, and `setState`: shared states, forms, and search input (`lib/core/widgets/empty_state.dart`, `lib/features/library/presentation/add_title_screen.dart`, `lib/features/search/presentation/search_screen.dart`).
- `ChangeNotifier`, `ListenableBuilder`, and `InheritedNotifier`: controller updates and library scope (`lib/features/library/application/library_controller.dart`, `library_scope.dart`).
- Named navigation and arguments: `AppRoutes` (`lib/core/router/app_routes.dart`).
- Forms, text fields, segmented buttons, sliders, cards, grids, tabs, snackbars, and bottom sheets: feature presentation folders (`lib/features/library/presentation/`, `lib/features/details/presentation/details_screen.dart`).
- Responsive sizing, network images, semantics, and built-in animations: shared widgets (`lib/core/widgets/`).
- ThemeData, ColorScheme, and Material 3: `lib/core/theme/app_theme.dart`.

## Tests

There are 21 Dart test files under `test/`, plus fakes and fixtures under `test/helpers/`. Coverage includes:

- Model conversion and composite keys: `library_entry_test.dart`, `library_item_test.dart`, `media_key_test.dart`.
- Library repository/controller behaviors and rollback: `in_memory_library_repository_test.dart`, `library_controller_test.dart`.
- TMDB mapping, typed failures, image URL generation, and fake catalog behavior: `tmdb_catalog_repository_test.dart`, `tmdb_client_test.dart`, `tmdb_image_url_test.dart`, `fake_catalog_repository_test.dart`.
- Home/Search controller and widget states: `home_controller_test.dart`, `home_screen_test.dart`, `search_results_controller_test.dart`, `search_screen_test.dart`.
- Forms, routes, Details, Library, Profile, responsive layout, and app tabs: `add_title_screen_test.dart`, `app_routes_test.dart`, `details_screen_test.dart`, `library_screen_test.dart`, `library_state_flow_test.dart`, `profile_screen_test.dart`, `responsive_layout_test.dart`, `widget_test.dart`.

Tests use fakes and HTTP mock clients; no real network is needed by the test suite. This report does not claim that tests or analysis were run.

## Not implemented

- Firebase Authentication, user sessions, Firestore persistence, and cross-device sync.
- Offline cache, pagination, social features, custom lists, reviews, and episode tracking.
- Cast/crew, trailers, recommendations, provider availability, and genre browsing.
- Arabic localization, onboarding, profile editing, and functional settings.

## Known limitations

- Library data exists only in memory and resets after the app process ends: `lib/features/library/data/in_memory_library_repository.dart`.
- TMDB data and poster images need network access and a valid local token: `lib/features/catalog/data/tmdb_client.dart`, `lib/core/widgets/poster_image.dart`.
- Manual titles are local snapshots; Details skips the TMDB details request for negative IDs: `lib/features/library/application/library_controller.dart`, `lib/features/details/application/details_controller.dart`.
- Settings, Sign in, and Edit profile show placeholder feedback rather than account features: `lib/features/profile/presentation/profile_screen.dart`.
- `MediaItem.copyWith` and `LibraryEntry.copyWith` treat null as “keep the current value,” so they cannot clear nullable fields: `lib/core/models/media_item.dart`, `lib/features/library/domain/library_entry.dart`.
