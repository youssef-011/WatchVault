# WatchVault Checkpoint — 2026-10-21

## 1. Snapshot

WatchVault is a Flutter/Dart movie and TV tracker for the Mobile App Programming course. It browses TMDB catalog sections, searches titles, shows title details, and provides an in-memory personal library with status and ratings. The maintainer reports that the last run had a clean `flutter analyze`, 59 passing tests, and the app running in Chrome with live TMDB data; these results were not independently rerun for this checkpoint.

Run commands, as documented in [README.md](../README.md):

```sh
flutter pub get
flutter run -d chrome --dart-define-from-file=config/tmdb.json
flutter run --dart-define-from-file=config/tmdb.json
flutter test
flutter analyze
```

`config/tmdb.json` is a local, gitignored configuration file; `.gitignore` ignores that path. Use the placeholder format shown in `config/tmdb.example.json`, and keep real TMDB tokens out of commits and documentation. The README also credits TMDB with its required non-endorsement statement.

Workflow: the maintainer decides, Claude writes prompts, Codex writes files only and cannot run Flutter or Git, and the maintainer runs analyze/test/run and commits or pushes.

## 2. Journey

- **Week 4 — named navigation and title entry.** `core/router/app_routes.dart` handles named routes and argument validation; `features/details/presentation/details_screen.dart` presents a title; `features/library/presentation/add_title_screen.dart` validates and returns a manual-title result. The built-in Navigator keeps routing package-free.
- **Week 5 — app-owned library state.** `features/library/application/library_controller.dart` is a `ChangeNotifier`, provided by `library_scope.dart` (`InheritedNotifier`); no state package is used. `library_entry.dart` validates ratings as null or half-step values from 0.5 through 5.0, and changing away from Watched clears the rating.
- **Repository layer — replaceable storage boundary.** `features/library/domain/library_repository.dart` defines the contract; `features/library/data/in_memory_library_repository.dart` supplies process-local data. `core/models/load_status.dart` and `core/widgets/load_state_view.dart` represent loading/error/content. `LibraryController` applies mutations optimistically, then restores prior in-memory lists and sets a generic user-facing error if a repository write fails.
- **Week 6 — interface polish.** `core/theme/app_spacing.dart` centralizes spacing/radius tokens; `core/widgets/media_card.dart` and `features/details/presentation/details_screen.dart` share Hero tags; `core/widgets/load_state_view.dart`, Search, and Details use built-in implicit transitions. `features/library/presentation/library_screen.dart` offers a long-press status/remove sheet. `core/widgets/media_card_sizing.dart` derives card dimensions from text scale and width.
- **Catalog phase — TMDB boundary and composite identity.** `core/models/media_key.dart` distinguishes overlapping movie/TV IDs using type plus ID; shared media types/items live in `core/models/`. `features/catalog/domain/` defines catalog contracts/details, while `features/catalog/data/` contains the `http`-based client, typed `CatalogException`, TMDB mapping, image URL helper, and fake repository.
- **Catalog wiring.** `features/catalog/application/catalog_scope.dart` exposes the catalog. `features/home/application/home_controller.dart` loads five independent sections with retry; `features/home/presentation/home_screen.dart` refreshes them together. `features/search/application/search_results_controller.dart` debounces queries and ignores stale responses. `features/details/application/details_controller.dart` loads metadata after the screen opens and skips manual negative-ID titles. Profile and README include TMDB attribution (`features/profile/presentation/profile_screen.dart`, `README.md`).

## 3. Architecture now

- `lib/core/config/`, `core/models/`, `core/router/`, `core/theme/`, `core/widgets/`: configuration, shared identity/status types, navigation, styling, and reusable UI.
- `lib/features/catalog/domain/`: `CatalogRepository` and `MediaDetails` contracts.
- `lib/features/catalog/data/`: `TmdbClient`, `TmdbCatalogRepository`, `CatalogException`, `tmdb_image_url.dart`, and `FakeCatalogRepository`.
- `lib/features/catalog/application/catalog_scope.dart`: catalog dependency access for the UI.
- `lib/features/library/domain/`: library entries, status labels, add-title result, and repository interface.
- `lib/features/library/data/`: in-memory repository and mock fixtures; `library/application/`: `LibraryController` and `LibraryScope`.
- `lib/features/{home,search,details,profile,shell}/`: feature controllers and screens, plus main tab shell; `lib/app.dart` owns controllers and scopes.
- `test/`: repository, model, controller, routing, layout, and widget coverage; `docs/`: project reports and this checkpoint.

**Data flow:** Home/Search/Details screens read `CatalogScope` and call feature controllers or the catalog repository. `TmdbCatalogRepository` maps API JSON through `TmdbClient`, which applies auth, language, timeout, and typed failures. Library/Profile/Details library controls read `LibraryScope`; `LibraryController` coordinates optimistic mutations through `LibraryRepository` to the in-memory implementation. `WatchVaultApp` owns and disposes the library controller.

**Key decisions:** `MediaKey(type, id)` avoids movie/TV ID collisions; interfaces keep catalog and library storage replaceable; typed catalog failures map to short user messages; loading and retry are represented without blocking Details; mock repositories allow tests without real network access.

## 4. Real versus mock

- Home catalog sections and Search use `CatalogRepository`, whose app default is the TMDB implementation (`lib/app.dart`, `lib/features/home/`, `lib/features/search/`, `lib/features/catalog/data/tmdb_catalog_repository.dart`). Search additionally filters the library catalog to negative-ID items, matches their titles against the normalized query, and merges them with catalog results by `MediaKey` (`lib/features/search/presentation/search_screen.dart`, `lib/features/search/application/search_results_controller.dart`).
- Details loads TMDB metadata for nonnegative IDs (`features/details/application/details_controller.dart`). Library activity shown there is local in-memory state.
- Library contents, Profile counts/average, and Add Title are in-memory only (`lib/features/library/data/in_memory_library_repository.dart`, `features/library/application/library_controller.dart`). Initial fixtures are `lib/features/home/data/mock_media.dart` and `lib/features/library/data/mock_library.dart`; the in-memory repository copies these lists.
- `lib/features/catalog/data/fake_catalog_repository.dart` is a test/development fake, not the app's default live catalog.

## 5. Known issues and TODO

- Each non-empty Library grid uses bottom padding `kFloatingActionButtonMargin + AppSpacing.fabHeight` (56 logical pixels) after its horizontal padding `mediaCardGridPadding` and top padding `AppSpacing.lg` (`lib/features/library/presentation/library_screen.dart`, `lib/core/theme/app_spacing.dart`). Whether this clears the FAB in practice is unverified; visual verification is pending.
- Details `SliverAppBar` has no `title:` property; the title is displayed in the body. Its poster `Stack` overlays a top-to-bottom `LinearGradient` from `Colors.black.withValues(alpha: 0.48)` to transparent (`lib/features/details/presentation/details_screen.dart`). The code therefore does not show a duplicated AppBar title; visual verification is pending.
- TMDB results map any nonzero `vote_average` to `MediaItem.voteAverage`; the app does not check vote count or release status before showing a rating (`lib/features/catalog/data/tmdb_catalog_repository.dart`, `lib/core/widgets/media_card.dart`).
- Nullable values cannot be cleared through current `copyWith` methods because null means “keep the old value” (`lib/core/models/media_item.dart`, `lib/features/library/domain/library_entry.dart`).
- The library controller catches repository failures and uses generic messages; no raw exception string is shown in the inspected controller (`lib/features/library/application/library_controller.dart`).
- `docs/PROJECT_STATUS.md` predates the current library state/repository and catalog wiring and should be refreshed.
- Current tests are not rerun here. The 59 passing count and Chrome live-data run are maintainer-reported only.

## 6. Next steps, in order

1. **Phase 2b:** start Library empty; represent a library item as a `MediaItem` snapshot plus `LibraryEntry`; add any TMDB title to the library; move library mocks to `test/helpers`.
2. Add Firebase Auth login, registration, logout, and session handling.
3. Store library documents at `users/{uid}/library/{mediaKey}` in Firestore, including the media snapshot; move the repository to a stream and add security rules.
4. Add Profile editing for username, bio, and avatar.
5. Add social follow/unfollow, follower/following lists, and friends’ libraries; do not use Cloud Functions.

## 7. Resume checklist

- Maintainer verification: `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter run -d chrome --dart-define-from-file=config/tmdb.json` (or the README's device run command).
- Read and follow `AGENTS.md`, including backend boundaries, typed user-facing errors, fake-based tests, and the rule against real network in tests.
- Ask before adding any package; never commit secrets. The current `http` dependency is already part of the project.
