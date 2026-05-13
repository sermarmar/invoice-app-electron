# invoice-app-electron

App de escritorio para gestión de facturas. Todo local, sin nube. Genera PDFs en el dispositivo.

## Stack actual

- **Electron** — proceso principal (`main.js`, `preload.js`)
- **Backend embebido** — Express.js + better-sqlite3, arranca como proceso hijo
- **Frontend** — HTML/CSS/JS vanilla en `frontend/`
- **PDF** — pdf-lib en el backend
- **Empaquetado** — electron-builder

Funciona en macOS. Tiene problemas en Windows (ver agente `windows-compat`).

## Migración a Flutter

El plan es migrar esta app a **Flutter para Windows** usando:
- **Material 3** (`useMaterial3: true`)
- **Arquitectura hexagonal** (`domain` / `data` / `presentation` por feature)
- **Drift** como ORM SQLite (reemplaza better-sqlite3)
- **flutter_bloc** + **get_it**

Para tareas de migración usa el agente `@flutter-migrate`.

## Agentes disponibles

| Agente | Cuándo usarlo |
|---|---|
| `windows-compat` | Algo no funciona en Windows, build, rutas, better-sqlite3 |
| `flutter-migrate` | Crear features Flutter, estructura hexagonal, migración |
| `backend` | Endpoints Express, SQLite, generación de PDFs |
| `electron-main` | main.js, preload.js, IPC, empaquetado electron-builder |
| `github-actions` | CI/CD, builds automáticos, releases |

## Reglas generales

- No hacer refactors grandes en el JS — la app va a migrar a Flutter
- Al tocar rutas de archivos, verificar que funcionan en Windows (`C:\...`) y macOS (`/Users/...`)
- La DB se guarda en `app.getPath('userData')`, nunca junto al binario
- No añadir tests salvo que se pidan explícitamente
