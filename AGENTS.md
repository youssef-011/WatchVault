# WatchVault project rules

## Stack
- Flutter with Dart 3; use Material widgets and the system font.
- Ask before adding any package other than the approved `http` package.

## Structure
- Organize `lib/` feature-first: shared code belongs in `core/`; each feature owns its domain, application, data, and presentation code; route names and `onGenerateRoute` belong in `core/router/`.
- Keep each file focused and place it under the feature or shared folder that owns it.
- Catalog and library features never import each other; shared models live in `core/models`; screens (home, search, details, profile) compose both.

## Code rules
- Write null-safe Dart. Prefer small files and `const` constructors/values where possible.
- Do not leave unused code, imports, or dependencies.

## Verification
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`

## Git rules
- Use conventional commit messages and make one logical change per commit.
- Never commit secrets. Never force-push or use `git reset --hard`.

## Out of scope
- Third-party state-management packages, Firebase, persistence, authentication, assets, localization, and packages beyond the approved `http` package and existing `cupertino_icons` / `flutter_lints` dependencies.

## Backend rules
- Use one interface per data source and do not leave unused functions.
- Surface typed errors; do not show raw `toString()` output to users.
- Do not commit secrets or add Cloud Functions.
- Test every new layer with fakes; tests must not use the real network.

## UI rules
- All navigation goes through AppRoutes (named routes).
- App state uses `ChangeNotifier` provided by `LibraryScope`; do not add a state-management package.
- Avoid unnecessary nested `Container` and `Padding`; use only what is needed.
- Avoid large hardcoded sizes; prefer `Expanded`, `Flexible`, `MediaQuery`, or theme spacing.
- Layouts must work on small phone, large phone, and tablet widths.
- Use `const` wherever possible.
