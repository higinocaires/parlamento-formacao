# Parlamento Formação — Project Context

> **For AI agents:** Read this file for project context only. The user will provide the specific task in each session. Use English for code, comments, and commit messages. UI labels should be in Portuguese.

## Overview

**Parlamento PT** is a Flutter course project (`parlamento-formacao`) that builds a cross-platform app (Web is required) to explore **Portuguese Parliament open data**.

| Item | Value |
|------|-------|
| Repository | https://github.com/higinocaires/parlamento-formacao |
| Package name | `parlamento_pt` |
| Org | `pt.parlamento` |
| Primary platform | Web (deployed: `parlamento-formacao.web.app`) |
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
6. **Verify before finishing:** `flutter analyze`, `flutter test`, and Web on Firebase Hosting (or `flutter run -d windows` locally)

## Current status

### Done

- Git repository connected to GitHub
- Flutter project scaffold (`flutter create`)
- Platforms enabled: web, android, ios, windows
- Project documentation: `docs/CONTEXTO.md`, `README.md`
- **Task 1.1** — Feature First folder structure under `lib/`
- **Task 1.2** — `PartyBadge` atom widget with tests
- **Task 1.3** — `DeputyCard` molecule widget with tests and integrated ListView
- **Task 1.4** — Deputies list scrolling with mock data (`mock_deputies.dart`)
- **Task 1.5** — Bootstrap-only `lib/main.dart`; `MaterialApp` setup in `lib/core/app.dart`
- **Task 2.1** — App-wide Light and Dark themes (`app_theme.dart`) with Parliament-inspired palette
- **Task 2.2** — Theme mode toggle via Riverpod (`theme_mode_provider.dart`); AppBar `Switch` (light ↔ dark, in-memory only)
- **Task 3.1** — votoaberto API constants (`api_constants.dart`)
- **Task 3.2** — `Deputy` domain model + `DeputiesPage` JSON parsing
- **Task 3.3** — `DeputiesRepository` with paginated HTTP fetch
- **Task 3.4** — Deputies list loaded from votoaberto API (replaces mock in UI)
- **Task 3.5** — `DeputyDetailScreen`, `go_router` navigation, iniciativas list
- **Task 4.2** — `deputiesProvider` Riverpod cache (in-memory, no refetch on back)
- **Task 4.3** — Ephemeral search + party filter (`deputies_filter_provider.dart`, `DeputiesFilterBar`)
- **Module 5** — Firebase Hosting deploy (project `parlamento-formacao`, `build/web`)
- **Web CORS proxy** — Cloud Function `votoabertoProxy` (`functions/index.js`); Hosting rewrite `/api/**` → proxy; Web uses `ApiConstants.webProxyBaseUrl` (`/api/v1`), native uses upstream URL directly
- Dependencies: `flutter_riverpod`, `http`, `go_router`, `diacritic`
- `PartyColors` utility for party badge colours
- **Tests (Module 2 Nice)** — 39 tests passing; `lib/` line coverage **~94%** (`flutter test --coverage`; course target ≥20%)
- **Iniciativas pagination** — `fetchIniciativasPage` in repository; detail screen loads 50 at a time with **Carregar mais** button
- **MCP server (Module 3 Nice)** — `mcp_server/` with [`mcp_dart`](https://pub.dev/packages/mcp_dart); tools `list_deputies`, `get_deputy`; Cursor config in `.cursor/mcp.json`; terminal demos: `bin/demo_list.dart`, `test_inspect.cmd`

### Not started yet

- Cucumber / Maestro (Module 2 Nice)

### Current codebase

```
lib/
  main.dart                              # Bootstrap only (ProviderScope + App)
  core/
    app.dart                             # MaterialApp.router
    theme/
      app_theme.dart
      theme_mode_provider.dart
    router/
      app_router.dart                    # / and /deputado/:depCadId
    constants/
      api_constants.dart
  features/
    deputies/
      data/
        deputies_repository.dart
        mock_deputies.dart               # kept for reference/tests
      domain/
        deputy.dart
        deputies_page.dart
        iniciativa.dart
        iniciativas_page.dart
      presentation/
        providers/
          deputies_provider.dart
          deputies_filter_provider.dart
        screens/
          deputies_list_screen.dart
          deputy_detail_screen.dart
        utils/
          party_colors.dart
        widgets/
          party_badge.dart
          deputy_card.dart
          deputies_filter_bar.dart
          iniciativa_card.dart
firebase.json                            # Hosting + Functions config
.firebaserc                              # Project: parlamento-formacao
functions/
  index.js                               # votoabertoProxy (public CORS proxy for Web)
.cursor/
  mcp.json                               # Cursor MCP config (Windows cmd wrapper)
mcp_server/
  bin/parlamento_mcp.dart                # MCP server (stdio)
  bin/demo_list.dart                     # Terminal API demo (no MCP protocol)
  test_inspect.cmd                       # Windows: test list_deputies via mcp_dart inspect
```

**Live URL:** https://parlamento-formacao.web.app

API: [votoaberto](https://api.votoaberto.org/api/v1). Web calls `/api/v1` via Hosting proxy; Android/iOS/Windows call upstream directly. No `firebase_core` in the app — proxy + Hosting only. Android `INTERNET` permission configured.

Deploy: `flutter build web` then `firebase deploy --only hosting,functions`
