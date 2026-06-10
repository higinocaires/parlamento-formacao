# Parlamento Formação — Project Context

> **For AI agents:** Read this file for project context only. The user will provide the specific task in each session. Use English for code, comments, and commit messages. UI labels should be in Portuguese.

## Overview

**Parlamento PT** is a Flutter course project (`parlamento-formacao`) that builds a cross-platform app (Web is required) to explore **Portuguese Parliament open data**.

| Item | Value |
|------|-------|
| Repository | https://github.com/higinocaires/parlamento-formacao |
| Package name | `parlamento_pt` |
| Org | `pt.parlamento` |
| Primary platform | Web (`flutter run -d chrome`) |
| API | [Parlamento.pt open data](https://www.parlamento.pt/Cidadania/paginas/dadosabertos.aspx) (JSON or XML) |
| State management | **Riverpod only** (no BLoC, no Hooks) |
| UI language | Portuguese (user-facing labels) |

## App concept

A simple app where users can:

1. Browse a **list of deputies** (deputados) from Parliament open data
2. **Search/filter** by name or party (ephemeral state)
3. Open a **detail screen** for a selected deputy
4. Switch between **light and dark themes**

Keep scope small and course-focused. Prefer clarity over features.

## Architecture (Feature First)

```
lib/
  core/
    theme/          # AppTheme light/dark
    router/         # Navigation (go_router)
    constants/      # API URLs
  features/
    deputies/
      data/         # Repository, API client, JSON parsing
      domain/       # Deputy model
      presentation/
        providers/  # Riverpod providers
        screens/    # List + detail
        widgets/    # PartyBadge, DeputyCard, etc.
    settings/       # Theme toggle (optional)
  main.dart         # Bootstrap only (ProviderScope + MaterialApp)
```

**Do not** put all code in a single file.

## Course requirements (Must / Should / Nice / Not)

### Module 1 — Architecture, components, AI setup

| Level | Requirement |
|-------|-------------|
| **Must** | Independent widgets with single-child and multi-child patterns |
| **Should** | At least one `ListView` |
| **Nice** | Atomic Design (atoms → molecules → organisms) |
| **Not** | All code in one file |

### Module 2 — UI, themes, tests

| Level | Requirement |
|-------|-------------|
| **Must** | App-wide theme |
| **Should** | Two themes (Light & Dark) |
| **Nice** | Cucumber / Maestro tests, ≥20% coverage (`flutter test --coverage`) |

### Module 3 — Libraries, APIs, external context

| Level | Requirement |
|-------|-------------|
| **Must** | Connect to remote data |
| **Should** | Navigation between at least 2 screens |
| **Nice** | Project MCP server |
| **Not** | Cache / database / cookies are **not** required |

### Module 4 — Advanced state & optimization

| Level | Requirement |
|-------|-------------|
| **Must** | Ephemeral state in at least one screen/widget |
| **Must** | API data persisted **in memory** while the app runs |
| **Should** | Riverpod **or** BLoC → we use **Riverpod** |
| **Nice** | SOLID, Feature First architecture |
| **Not** | No other state managers; no Hooks |

### Module 5 — Firebase & deploy

| Level | Requirement |
|-------|-------------|
| **Must** | Runnable Web app via `flutter run` |
| **Should** | Deploy to Firebase Hosting |
| **Nice** | Public hosting, runnable on all platforms |

## Tech stack

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `http` | API calls |
| `go_router` | Navigation |

## Coding rules

1. **Minimal scope** — small, focused changes only
2. **Match existing conventions** — read surrounding code before editing
3. **Feature First** — keep code inside the correct feature folder
4. **Riverpod only** — wrap app in `ProviderScope`
5. **Ephemeral vs persisted state**
   - Ephemeral: search query, form input, selected tab
   - Persisted in memory: deputies list loaded from API (survives navigation, not app restart)
6. **Verify before finishing:** `flutter analyze` and `flutter run -d chrome`

## Current status

### Done

- Git repository connected to GitHub
- Flutter project scaffold (`flutter create`)
- Platforms enabled: web, android, ios, windows
- Project documentation: `docs/CONTEXTO.md`, `README.md`
- **Task 1.1** — Feature First folder structure under `lib/`
- **Task 1.2** — `PartyBadge` atom widget with tests and examples
- **Task 1.3** — `DeputyCard` molecule widget with tests and integrated ListView
- **Task 1.4** — Deputies list scrolling smoothly with mock data file (`mock_deputies.dart`)
- **Task 1.5** — Bootstrap-only `lib/main.dart`; `MaterialApp` setup in `lib/core/app.dart`
- Dependencies: `flutter_riverpod`, `http`, `go_router`
- `DeputiesListScreen` wired as home screen via `App`
- Widget smoke test (`test/widget_test.dart`)
- **Task 2.1** — App-wide Light and Dark themes (`app_theme.dart`) with Parliament-inspired palette
- **Task 2.2** — Theme mode toggle via Riverpod (`theme_mode_provider.dart`); AppBar `Switch` in `DeputiesListScreen` (light ↔ dark, in-memory only)

### Not started yet

- Deputies list content (API data) and detail screen
- `go_router` navigation setup
- Parlamento.pt API integration
- Riverpod providers (cache + search)
- Firebase Hosting deploy
- Extended test coverage (Nice — ≥20% coverage planned for after the app is functional)

### Current codebase

```
lib/
  main.dart                              # Bootstrap only (ProviderScope + App)
  core/
    app.dart                             # MaterialApp setup
    theme/
      app_theme.dart
      theme_mode_provider.dart
    router/
    constants/
  features/
    deputies/
      data/
        mock_deputies.dart
      domain/
      presentation/
        providers/
        screens/
          deputies_list_screen.dart
        widgets/
          party_badge.dart
          deputy_card.dart
```

Base dependencies installed. `http` and `go_router` are not wired in code yet.
