# parlamento-formacao

Flutter course project — Web app to explore **Portuguese Parliament** open data (deputies list, search, detail screen, iniciativas).

**Live app:** https://parlamento-formacao.web.app

## Docs

- **[Project context](docs/CONTEXTO.md)** — app overview, architecture, course requirements, current status

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

## Stack

- Flutter (Web + mobile/desktop)
- Riverpod · http · go_router
- Firebase Hosting + Cloud Functions (Web CORS proxy)
- API: [votoaberto](https://api.votoaberto.org/api/v1) (Parlamento.pt open data)
