# parlamento-formacao

Flutter course project — Web app to explore **Portuguese Parliament** open data (deputies list, search, detail screen, iniciativas).

**Live app:** https://parlamento-formacao.web.app

## Docs

- **[Project context](docs/CONTEXTO.md)** — app overview, architecture, course requirements, current status
- **[Module guide (PT)](docs/GUIA-MODULOS.md)** — Must/Should/Nice per module, demo Q&A
- **[MCP server](mcp_server/README.md)** — simple `mcp_dart` server (Module 3 Nice)

## Quick start (local)

```bash
flutter pub get
flutter run -d windows   # recommended for local dev (no CORS)
```

Web on `localhost` cannot call the votoaberto API directly (browser CORS). Use the live URL above for Web demos, or Windows/Android locally.

## Deploy (Firebase Hosting + CORS proxy)

```bash
flutter build web
firebase deploy --only hosting,functions
```

Project: `parlamento-formacao` (Blaze plan). The Cloud Function `votoabertoProxy` proxies `/api/**` to [votoaberto](https://api.votoaberto.org/api/v1) so the Web app can load data without CORS errors.

## Tests

```bash
flutter test
flutter test --coverage   # writes coverage/lcov.info (lib/ ~94% line coverage)
```

39 tests passing. See [docs/CONTEXTO.md](docs/CONTEXTO.md) for full project status.

## MCP server (Module 3 Nice)

Separate Dart process for AI tools ([`mcp_dart`](https://pub.dev/packages/mcp_dart)). See [mcp_server/README.md](mcp_server/README.md).

```powershell
cd mcp_server
dart run bin/demo_list.dart    # quick API demo
.\test_inspect.cmd             # full MCP tool test (Windows)
```

Works in **Cursor** via `.cursor/mcp.json` (tools: `list_deputies`, `get_deputy`).

## Stack

- Flutter (Web + mobile/desktop)
- Riverpod · http · go_router
- Firebase Hosting + Cloud Functions (Web CORS proxy)
- API: [votoaberto](https://api.votoaberto.org/api/v1) (Parlamento.pt open data)
