# Project instructions — alat_magang

## Project identity

- Internship ("alat magang") report tool for Polmed students.
- **Web-only.** Do not add mobile/desktop platform code, native channels, or platform-specific plugins.
- Flutter + Dart, Firebase Hosting for deployment, Riverpod + Freezed for state, `flutter_riverpod` / `riverpod_generator` / `freezed` / `flutter_lints`.

## Architecture rules

> Originally sourced from the former `RULES.md`; that file is now only a pointer to this one.

Feature-first architecture. Follow these whenever writing code:

- **Never put business logic in UI files.** No calculations, API calls, or services inside widgets.
- New feature goes in `lib/features/<nama_fitur>/`.
- Split into `presentation/` (UI), `provider/` (state), and `data/` (API/repository).
- **If a file exceeds 150 lines, split it** into sub-widgets or separate files.
- Single Responsibility Principle.

### Riverpod providers

Write providers inline in the same file, directly above the class/function they serve, using `@riverpod` annotations from `riverpod_generator`. Do not create a separate providers file.

> Example request: "Saya menggunakan riverpod_generator. Tolong buatkan provider untuk fitur [Nama Fitur] menggunakan anotasi @riverpod. Jangan tulis provider di luar file, tapi tulis langsung di atas class/fungsi logic-nya."

## Official Flutter agent rules

### Proactive hot reload (`lib/**/*.dart`)

Whenever you edit a `.dart` file under `lib/`:

1. **Skip** when the change is only comments, docstrings, or whitespace.
2. **Skip** for files outside `lib/` (`test/**`, `integration_test/**`, `benchmark/**`, `test_driver/**`, `example/**`).
3. **Discover & connect** to a running app using the `dtd` MCP tool (`listConnectedApps` / `listDtdUris`).
4. **Hot reload** (`hot_reload`) after UI changes, including widget `build` methods and simple method edits.
5. **Hot restart** (`hot_restart`) when fundamental logic, state initialization (`initState`), global/static state, or `main()` changed.

## Tooling available to agents

- **Dart & Flutter MCP server** (`dart mcp-server`) — analyzer diagnostics, symbol resolution, runtime introspection, pub.dev search, `pubspec.yaml` management, test running, `dart format`.
- **Google Developer Knowledge MCP server** (`https://developerknowledge.googleapis.com/mcp`) — grounded search over official docs.flutter.dev, dart.dev, Firebase, and other Google developer docs. Tools: `search_documents`, `get_documents`, `answer_query`.
  - **Prefer this over guessing Flutter APIs.** Before using an unfamiliar widget, parameter, or flag, look it up here instead of relying on training data.
  - Two-step retrieval: call `search_documents` first (cheap snippets), then `get_documents` only when the snippet lacks needed code context. `answer_query` is quota-limited to 50/day — reserve it for broad conceptual questions.
- **Agent skills** in `.agents/skills/` — official `flutter/agent-plugins`, `dart-lang/skills`, and `google/skills` sets. Load with the `skill` tool when relevant.

`opencode.json` references the Developer Knowledge key as `{env:DEVELOPERKNOWLEDGE_API_KEY}`. The value lives in `~/.config/opencode/dk-api-key.env` (mode 0600), sourced from `~/.bashrc`. **Never** commit the key or place it literally in `opencode.json`. Restart OpenCode from a shell if the server reports it needs sign-in.

## Commands

```bash
# Static analysis (run before finishing any change)
dart analyze

# Formatting
dart format .

# Build runner (regenerates .g.dart for riverpod/freezed)
dart run build_runner watch

# Deploy to Firebase Hosting (auto-increments build number first)
dart scripts/increment_build.dart && flutter build web --release && firebase deploy --only hosting
# or: python deploy.py
# or: pwsh ./deploy.ps1
```

## Conventions

- App version and build number live in `lib/app_version.dart` (`kAppVersion`, `kBuildNumber`, `kAppYear`). Do not hand-edit `kBuildNumber`; use `scripts/increment_build.dart`.
- Keep `README.md` feature notes and `PROJECT_TODO.md` updated when finishing a listed item.
