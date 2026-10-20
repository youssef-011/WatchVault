# Project status

## Implemented

- App entry and app-owned controller lifecycle: `lib/main.dart`, `lib/app.dart` (`WatchVaultApp`).
- Material 3 light/dark themes and spacing tokens: `lib/core/theme/app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`.
- Shared empty/loading states, media cards, poster rendering/placeholders, sizing, and section headers: `lib/core/widgets/` (`EmptyState`, `LoadStateView`, `MediaCard`, `PosterImage`, `PosterPlaceholder`, `mediaCardHeight`, `SectionHeader`).
- Named details and add-title routes, route argument validation, and not-found screen: `lib/core/router/app_routes.dart`, `details_route_arguments.dart`.
- Home curated rows backed by mock catalog entries: `lib/features/home/data/mock_media.dart`, `lib/features/home/presentation/home_screen.dart`.
- Search over the controller catalog, with empty, no-results, and results states: `lib/features/search/presentation/search_screen.dart`.
- Library tabs, responsive grids, add-title form, refresh, status/removal quick actions, and user feedback: `lib/features/library/presentation/library_screen.dart`, `add_title_screen.dart`.
- Title detail view with poster Hero, overview, library status/rating controls, add/remove actions, and animated control changes: `lib/features/details/presentation/details_screen.dart`.
- Profile statistics from controller state and placeholder profile actions: `lib/features/profile/presentation/profile_screen.dart`.
- Four-tab shell using `NavigationBar` and `IndexedStack`: `lib/features/shell/presentation/main_shell.dart`.
- Domain models, enums, label extension, add-title result, and repository contract: `lib/features/library/domain/` (`MediaItem`, `LibraryEntry`, `MediaType`, `WatchStatus`, `WatchStatusLabel`, `AddTitleResult`, `LibraryRepository`).
- Mock library and in-memory repository: `lib/features/library/data/mock_library.dart`, `in_memory_library_repository.dart`.
- `LibraryController` manages catalog/entries, load states, derived counts/ratings, negative IDs for manual titles, optimistic updates and rollback: `lib/features/library/application/library_controller.dart`.
- Controller state is exposed through `LibraryScope`; load/error/content transitions use an `AnimatedSwitcher`: `lib/features/library/application/library_scope.dart`, `lib/core/widgets/load_state_view.dart`.
- Tests: 13 test files containing 33 test cases, including model serialization, routes, widgets, responsive layout, repository/controller behavior, and a cross-screen state flow. Test sources are under `test/`; `test/helpers/` contains support code.

## Concepts used

### Dart

- Classes, constructors, named/optional parameters, and null safety: `lib/features/library/domain/media_item.dart` (`MediaItem`); `library_entry.dart` (`LibraryEntry`).
- `final` and `const`: `lib/features/home/data/mock_media.dart` (constant mock catalog); domain model fields and constructors.
- Lists, maps, iteration, and conditions: `lib/features/library/application/library_controller.dart` (catalog/entry operations and derived values); `lib/features/home/data/mock_media.dart` (curated lists).
- Arrow functions and string interpolation: `lib/features/library/presentation/library_screen.dart` (callbacks and feedback); `lib/features/search/presentation/search_screen.dart` (query states).
- Enums and extension methods: `lib/features/library/domain/media_type.dart`, `watch_status.dart`, `watch_status_label.dart`.
- Serialization, `copyWith`, equality, and `hashCode`: `lib/features/library/domain/media_item.dart`, `library_entry.dart`.
- Abstract interface, futures, async/await, and exception handling: `lib/features/library/domain/library_repository.dart`, `lib/features/library/data/in_memory_library_repository.dart`, `lib/features/library/application/library_controller.dart`.

### Flutter

- Stateless/stateful widgets and local `setState`: `lib/core/widgets/empty_state.dart`, `lib/features/search/presentation/search_screen.dart`, `lib/features/library/presentation/add_title_screen.dart`.
- `ChangeNotifier`, `ListenableBuilder`, and `InheritedNotifier`: `lib/features/library/application/library_controller.dart`, `lib/core/widgets/load_state_view.dart`, `lib/features/library/application/library_scope.dart`.
- Named navigation and route arguments: `lib/core/router/app_routes.dart`, `lib/core/router/details_route_arguments.dart`.
- `Scaffold`, app bars, text/styles, rows/columns, flexible layout, padding, cards, icons, and buttons: `lib/features/profile/presentation/profile_screen.dart`, `lib/features/details/presentation/details_screen.dart`.
- Text fields, form validation, segmented controls, and sliders: `lib/features/library/presentation/add_title_screen.dart`, `lib/features/details/presentation/details_screen.dart`.
- Lists, grids, tabs, navigation bar, and indexed stack: `lib/features/home/presentation/home_screen.dart`, `lib/features/library/presentation/library_screen.dart`, `lib/features/shell/presentation/main_shell.dart`.
- SnackBars and modal bottom sheet actions: `lib/features/library/presentation/library_screen.dart`.
- Responsive layout and sizing: `lib/features/library/presentation/library_screen.dart`, `lib/features/search/presentation/search_screen.dart`, `lib/core/widgets/media_card_sizing.dart`.
- Network image fallback and placeholder: `lib/core/widgets/poster_image.dart`, `poster_placeholder.dart`.
- `ThemeData`, `ColorScheme`, Material 3, and implicit animations: `lib/core/theme/app_theme.dart`, `lib/core/widgets/load_state_view.dart`, `lib/features/details/presentation/details_screen.dart`.

## Not implemented

- Firebase Authentication, user accounts, and Firestore persistence.
- Live TMDB catalog/search integration; current catalog/search data is local mock data.
- Persistent storage, localization, and production profile editing/settings.

## Known limitations

- The in-memory repository is reset when the app process ends: `lib/features/library/data/in_memory_library_repository.dart`.
- Home and initial library content come from mock lists: `lib/features/home/data/mock_media.dart`, `lib/features/library/data/mock_library.dart`.
- PosterImage can load a supplied TMDB poster path, but mock items use null poster paths; live catalog retrieval is not implemented: `lib/core/widgets/poster_image.dart`, `lib/features/home/data/mock_media.dart`.
- Profile identity/actions are presentation placeholders; the settings, sign-in, edit-profile, and about actions do not implement account functionality: `lib/features/profile/presentation/profile_screen.dart`.
- Automated verification was not run for this documentation update; run `flutter analyze` and `flutter test` locally.
