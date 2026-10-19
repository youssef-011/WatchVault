# WatchVault project rules

## Stack
- Flutter with Dart 3; use Material widgets and the system font.
- Ask before adding any package.

## Structure
- Organize `lib/` feature-first: shared code belongs in `core/`; each feature owns its domain and presentation code; app navigation belongs in `features/shell/`.
- Keep each file focused and place it under the feature or shared folder that owns it.

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
- State management, Firebase, networking, mock data, assets, localization, and packages beyond the existing `flutter_lints` development dependency.

## UI rules
- Avoid unnecessary nested `Container` and `Padding`; use only what is needed.
- Avoid large hardcoded sizes; prefer `Expanded`, `Flexible`, `MediaQuery`, or theme spacing.
- Layouts must work on small phone, large phone, and tablet widths.
- Use `const` wherever possible.
