# Invoice App

![Build](https://github.com/sermarmar/invoice-app-electron/actions/workflows/build.yml/badge.svg)
![Release](https://github.com/sermarmar/invoice-app-electron/actions/workflows/release.yml/badge.svg)

Aplicación de escritorio para gestión de facturas. Todo local, sin nube. Genera PDFs en el dispositivo.

## Descargar

| Plataforma | Descarga |
|------------|----------|
| Windows | [invoice-app-windows-1.4.0.zip](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/invoice-app-windows-1.4.0.zip) |
| macOS | [invoice-app-macos-1.4.0.zip](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/invoice-app-macos-1.4.0.zip) |

> Los links apuntan siempre a la última versión publicada. Actualiza el número de versión en esta tabla al hacer una nueva release. Si aún no hay ninguna release, ve a [Releases](https://github.com/sermarmar/invoice-app-electron/releases) para ver las disponibles.

## Características

- Gestión de clientes y facturas (CRUD completo)
- Generación de PDFs localmente
- Base de datos SQLite integrada (sin servidor externo)
- Interfaz Material Design 3
- Multiplataforma: Windows y macOS

## Requisitos

No necesitas instalar nada adicional. Descarga el ZIP de tu plataforma, descomprímelo y ejecuta la aplicación.

### Windows

1. Descarga `invoice-app-windows-x.x.x.zip`
2. Descomprime la carpeta
3. Ejecuta `invoice_app.exe`

### macOS

1. Descarga `invoice-app-macos-x.x.x.zip`
2. Descomprime — obtendrás `invoice_app.app`
3. Arrastra la app a `/Applications` o ejecútala directamente

> En macOS puede aparecer un aviso de seguridad la primera vez porque la app no está firmada. Para abrirla: clic derecho → Abrir → Abrir igualmente.

## Desarrollo

### Requisitos previos

- [Flutter](https://flutter.dev/docs/get-started/install) >= 3.22.0
- SDK de Dart >= 3.4.0

### Ejecutar en modo desarrollo

```bash
flutter pub get
flutter run -d windows   # o -d macos
```

### Compilar

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release
```

## Stack

- **Flutter** — UI y lógica de presentación
- **flutter_bloc** — gestión de estado
- **Drift** — ORM para SQLite
- **get_it** — inyección de dependencias
- **pdf + printing** — generación de PDFs
- **fpdart** — tipos funcionales (Either, Unit)

## Estructura del proyecto

```
lib/
├── main.dart
├── injection_container.dart
└── features/
    ├── invoices/
    │   ├── domain/        # entidades, repositorios, casos de uso
    │   ├── data/          # implementaciones, modelos, DB
    │   └── presentation/  # BLoC, páginas, widgets
    ├── clients/
    └── users/
```

## Licencia

MIT
