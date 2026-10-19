# WatchVault Project Status

This report reflects the source files currently present in the project. It does not imply that analysis, tests, or a build were run.

## Implemented

- Home screen with media sections: `lib/features/home/presentation/home_screen.dart`.
- Search screen with title filtering: `lib/features/search/presentation/search_screen.dart`.
- Library tabs and media grid: `lib/features/library/presentation/library_screen.dart`.
- Profile screen with mock counts and rating: `lib/features/profile/presentation/profile_screen.dart`.
- Media details and read-only library activity: `lib/features/details/presentation/details_screen.dart`.
- Add Title form and result: `lib/features/library/presentation/add_title_screen.dart`, `lib/features/library/domain/add_title_result.dart`.
- Four-tab app shell and app entry: `lib/features/shell/presentation/main_shell.dart`, `lib/app.dart`, `lib/main.dart`.
- Named routes, argument validation, and not-found UI: `lib/core/router/app_routes.dart`.
- Shared empty state, media card, sizing, poster placeholder, and section header: `lib/core/widgets/empty_state.dart`, `media_card.dart`, `media_card_sizing.dart`, `poster_placeholder.dart`, `section_header.dart`.
- Theme and text styles: `lib/core/theme/app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`.
- Domain models and enums: `lib/features/library/domain/media_item.dart`, `library_entry.dart`, `add_title_result.dart`, `media_type.dart`, `watch_status.dart`, `watch_status_label.dart`.
- Static media and library examples: `lib/features/home/data/mock_media.dart`, `lib/features/library/data/mock_library.dart`.

## Concepts used

### Dart fundamentals

- Classes, constructors, fields, and methods: `MediaItem`, `LibraryEntry`, `AddTitleResult` in `lib/features/library/domain/`.
- Null safety and fallback values: optional model fields and `??` in `lib/features/details/presentation/details_screen.dart` and `lib/features/library/presentation/add_title_screen.dart`.
- Lists, maps, loops, and conditions: static media lists in `lib/features/home/data/mock_media.dart`; entry counting loop in `lib/features/profile/presentation/profile_screen.dart`; status filtering in `lib/features/library/presentation/library_screen.dart`.
- `final`, `const`, enums, and string interpolation: throughout `lib/`, including `MediaType` and `WatchStatus` in `lib/features/library/domain/`.
- Arrow functions and switch expressions: callbacks across presentation files and status/type labels in `lib/features/library/domain/watch_status_label.dart` and screen widgets.
- Equality and serialization methods: `copyWith`, `toMap`, `fromMap`, `==`, and `hashCode` in `media_item.dart` and `library_entry.dart`.

### Widgets

- Stateless and stateful widgets; `setState`: `lib/features/shell/presentation/main_shell.dart`, `lib/features/search/presentation/search_screen.dart`, `lib/features/library/presentation/add_title_screen.dart`.
- Text, `TextStyle`, padding, sizing, rows, columns, and alignment: presentation screens and `lib/core/widgets/`.
- Buttons and callbacks: `AddTitleScreen`, `ProfileScreen`, `LibraryScreen`, and `MainShell`.
- Card, icon, `CircleAvatar`, `Expanded`, `Flexible`, and responsive constraints: `lib/features/profile/presentation/profile_screen.dart`, `lib/features/details/presentation/details_screen.dart`, `lib/core/widgets/media_card_sizing.dart`.
- Material 3 navigation, tabs, grids, scroll views, text fields, form validation, segmented controls, dropdowns, and sliders: respective files under `lib/features/`.
- Image widgets and image assets are not used; posters are themed placeholders in `lib/core/widgets/poster_placeholder.dart`.

### Navigation

- Named details and Add Title routes with typed argument/result handling: `lib/core/router/app_routes.dart`, `lib/features/library/presentation/library_screen.dart`.
- Bottom-tab selection with `NavigationBar` and `IndexedStack`: `lib/features/shell/presentation/main_shell.dart`.

### Architecture and testing

- Feature-first organization: `lib/features/{home,search,library,profile,details,shell}/` with shared code in `lib/core/`.
- Widget and model tests: `test/widget_test.dart`, `test/home_screen_test.dart`, `test/library_screen_test.dart`, `test/details_screen_test.dart`, `test/search_screen_test.dart`, `test/profile_screen_test.dart`, `test/responsive_layout_test.dart`, `test/library_entry_test.dart`, `test/add_title_screen_test.dart`, `test/app_routes_test.dart`.

## Not implemented from the course scope (Weeks 1–4)

- Dedicated lesson or exercise screens for practicing Dart fundamentals; the concepts are used in app source instead.
- Authentication, persistent storage, backend integration, and live media loading.
- Image assets or network images; media posters remain placeholders.
- Automated verification results for the current changes; commands were not run in this environment.

## Known limitations

- Home and library content comes from static mock lists and is not persisted.
- Add Title returns an in-memory result and shows a “not saved yet” message; the title is not added to the displayed library.
- Search filters the bundled mock media titles only.
- Profile identity and statistics are illustrative and are not tied to a signed-in user.
- Route fallbacks show a generic not-found screen; no deep-link handling is configured.
