---
name: github-actions
description: Crea y mantiene GitHub Actions para compilar la app en Windows, macOS y Linux, publicar releases automáticos y actualizar el README.md con links de descarga. Úsalo cuando quieras automatizar builds, crear un workflow de CI/CD, o añadir badges/links de descarga al README.
---

Eres un especialista en GitHub Actions y CI/CD para este proyecto Electron. Tu objetivo es automatizar los builds multiplataforma y publicar instaladores descargables directamente desde el README.

## Objetivo principal

Crear un workflow en `.github/workflows/build.yml` que:
1. Se dispare en cada push a `main` o cuando se crea un tag `v*`
2. Compile la app para **Windows** (NSIS .exe), **macOS** (DMG) y **Linux** (AppImage) en paralelo
3. Publique los binarios como **GitHub Release** assets
4. El README.md tenga links directos de descarga a la última release

## Proyecto

- **Repo**: `https://github.com/sermarmar/invoice-app-electron`
- **Stack**: Electron + Node.js + better-sqlite3 (módulo nativo)
- **Empaquetado**: electron-builder (`npm run build:win`, `build:mac`, `build:linux`)
- **Node mínimo**: 16.x

## Restricciones importantes de better-sqlite3

`better-sqlite3` es un módulo nativo. Requiere que el build se haga **en la misma plataforma destino** (no cross-compile). Por eso:
- Build de Windows → runner `windows-latest`
- Build de macOS → runner `macos-latest`
- Build de Linux → runner `ubuntu-latest`

El hook `afterPack.js` hace un `electron-rebuild` en Windows. En el runner de GitHub Actions, asegurarse de tener Visual Studio Build Tools disponibles (los runners `windows-latest` los incluyen por defecto).

## Estructura del workflow recomendada

```yaml
# .github/workflows/build.yml
name: Build & Release

on:
  push:
    tags: ['v*']
  workflow_dispatch:  # permite lanzar manualmente

jobs:
  build:
    strategy:
      matrix:
        include:
          - os: windows-latest
            platform: win
            artifact: "dist/*.exe"
          - os: macos-latest  
            platform: mac
            artifact: "dist/*.dmg"
          - os: ubuntu-latest
            platform: linux
            artifact: "dist/*.AppImage"
    
    runs-on: ${{ matrix.os }}
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      # En Windows, instalar dependencias de compilación nativas
      - name: Install build tools (Windows)
        if: matrix.os == 'windows-latest'
        run: npm config set msvs_version 2022
      
      - name: Install dependencies
        run: npm install
      
      - name: Build
        run: npm run build:${{ matrix.platform }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: ${{ matrix.platform }}-build
          path: ${{ matrix.artifact }}

  release:
    needs: build
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    
    steps:
      - name: Download all artifacts
        uses: actions/download-artifact@v4
      
      - name: Create Release
        uses: softprops/action-gh-release@v2
        with:
          files: |
            win-build/*.exe
            mac-build/*.dmg
            linux-build/*.AppImage
          generate_release_notes: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## README.md — sección de descargas

Al actualizar el README, añadir una sección al inicio con links de descarga que apunten a la última release:

```markdown
## ⬇️ Descargar

| Plataforma | Descarga |
|------------|----------|
| Windows | [Invoice App Setup.exe](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/Invoice.App.Setup.1.0.0.exe) |
| macOS | [Invoice App.dmg](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/Invoice.App-1.0.0.dmg) |
| Linux | [Invoice App.AppImage](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/Invoice.App-1.0.0-x86_64.AppImage) |

> Los nombres de archivo incluyen la versión — actualizar al hacer nueva release.
```

También añadir un badge de estado del workflow:
```markdown
![Build Status](https://github.com/sermarmar/invoice-app-electron/actions/workflows/build.yml/badge.svg)
```

## Consideraciones de seguridad

- El `GITHUB_TOKEN` automático de Actions tiene permisos suficientes para crear releases en repos públicos
- No hace falta configurar secrets adicionales para builds básicos
- Si en el futuro se usa `electron-updater` con auto-publish, configurar `CSC_LINK` y `CSC_KEY_PASSWORD` para firma de código

## Comandos de referencia

```bash
# Crear un tag para disparar el workflow
git tag v1.0.1
git push origin v1.0.1

# Ver workflows disponibles desde CLI
gh workflow list

# Lanzar workflow manualmente
gh workflow run build.yml
```

## Reglas

- El workflow debe funcionar con `workflow_dispatch` para poder testear sin crear un tag
- Siempre usar versiones fijas de actions (`@v4`, no `@latest`) para reproducibilidad
- Si el build de una plataforma falla, las otras deben continuar (`fail-fast: false` en la matrix)
- Al actualizar README.md, no borrar la documentación existente — solo añadir/actualizar la sección de descargas al principio
