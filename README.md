# 🚀 Invoice App - Electron

![Build Status](https://github.com/sermarmar/invoice-app-electron/actions/workflows/build.yml/badge.svg)

Aplicación de escritorio multiplataforma construida con Electron, Express, SQLite y PDF generation.

## ⬇️ Descargar

| Plataforma | Descarga |
|------------|----------|
| 🪟 Windows | [invoice-app-windows.exe](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/invoice-app-windows.exe) |
| 🍎 macOS | [invoice-app-mac.dmg](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/invoice-app-mac.dmg) |
| 🐧 Linux | [invoice-app-linux.AppImage](https://github.com/sermarmar/invoice-app-electron/releases/latest/download/invoice-app-linux.AppImage) |

> Los links apuntan siempre a la última versión publicada. Si aún no hay ninguna release, ve a [Releases](https://github.com/sermarmar/invoice-app-electron/releases) para ver las disponibles.

## 📋 Tabla de Contenidos

- [Descargar](#️-descargar)
- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Desarrollo](#desarrollo)
- [Compilación](#compilación)
- [Uso](#uso)
- [Tecnologías](#tecnologías)
- [Troubleshooting](#troubleshooting)

## ✨ Características

- ✅ Interfaz gráfica moderna con HTML/CSS/JavaScript
- ✅ Backend REST API con Express.js
- ✅ Base de datos SQLite integrada
- ✅ Generación de PDFs (facturas y documentos)
- ✅ Gestión de usuarios (CRUD completo)
- ✅ Inicialización automática en primera ejecución
- ✅ Multiplataforma (Windows, macOS, Linux)
- ✅ Instaladores nativos para cada sistema operativo

## 📦 Requisitos Previos

- **Node.js** >= 16.x ([Descargar](https://nodejs.org/))
- **npm** >= 8.x (incluido con Node.js)
- **Git** (opcional, para clonar el repositorio)

### Requisitos adicionales por sistema operativo:

#### Windows:
- Windows 10 o superior
- No requiere configuración adicional

#### macOS:
- macOS 10.13 o superior
- Para compilar para Windows desde Mac: **Wine** ([instrucciones](#compilar-para-windows-desde-mac))

#### Linux:
- Ubuntu 18.04+ / Debian 10+ / Fedora 35+
- Librerías requeridas:
  ```bash
  sudo apt-get install libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libdrm2 libgbm1 libxcb-dri3-0
  ```

## 🔧 Instalación

### 1. Clonar el repositorio (o descargar el código)

```bash
git clone https://github.com/tu-usuario/invoice-app-electron.git
cd invoice-app-electron
```

### 2. Instalar dependencias

El proyecto tiene dos `package.json` (raíz y backend):

```bash
# Instalar dependencias de Electron (raíz)
npm install

# Las dependencias del backend se instalan automáticamente
# Pero si necesitas instalarlas manualmente:
cd backend
npm install
cd ..
```

### 3. Verificar la instalación

```bash
# Verificar que todo está instalado
npm list --depth=0
```

## 📁 Estructura del Proyecto

```
invoice-app-electron/
├── main.js                    # Proceso principal de Electron
├── preload.js                 # Script de seguridad (contexto aislado)
├── package.json               # Dependencias de Electron
├── README.md                  # Este archivo
│
├── backend/                   # Backend Express
│   ├── package.json           # Dependencias del backend
│   ├── server.js              # Servidor Express + API REST
│   ├── database/
│   │   └── app.db             # Base de datos SQLLite
│   │   └── init.sql           # Inicializión de script SQL
│   └── src/
│       ├── init.js            # Script de inicialización
│       ├── adapters           # Adapters Express
│       │   └── cotrollers     # Controllers Express
│       │   └── routers        # Routers Express
│       └── config             # Configuration of server Express
│           └── db.js          # Controllers Express
├── frontend/                  # Frontend (interfaz de usuario)
│   ├── index.html             # Página principal
│   ├── css/
│   │   └── styles.css         # Estilos
│   └── js/
│       └── script.js          # Lógica del frontend
│
└── build/                     # Recursos para compilación
    ├── icon.ico               # Icono para Windows
    ├── icon.icns              # Icono para macOS
    └── icon.png               # Icono para Linux

```

## 🛠️ Desarrollo

### Ejecutar la aplicación completa (Electron + Backend)

Este comando inicia todo: el backend Express y la ventana de Electron.

```bash
npm start
```

La aplicación se abrirá automáticamente en una ventana de Electron.

### Ejecutar solo el backend (desarrollo/testing)

Si solo quieres probar la API sin Electron:

```bash
cd backend
npm start
```

El servidor estará disponible en: `http://localhost:3000`

#### Endpoints disponibles:

- `GET /api/health` - Verificar que el servidor funciona
- `GET /api/users` - Obtener todos los usuarios
- `POST /api/users` - Crear un usuario
- `DELETE /api/users/:id` - Eliminar un usuario
- `POST /api/generate-pdf` - Generar PDF simple
- `POST /api/generate-invoice-pdf` - Generar factura PDF

### Ejecutar solo el frontend (desarrollo)

El frontend puede ejecutarse con cualquier servidor HTTP local:

```bash
# Opción 1: Con http-server
npx http-server frontend -p 8080

# Opción 2: Con Python
cd frontend
python3 -m http.server 8080

# Opción 3: Con VS Code Live Server
# Instala la extensión "Live Server" y haz clic derecho en index.html
```

**Nota:** Al ejecutar el frontend solo, necesitas que el backend esté corriendo en `http://localhost:3000`

### Modo desarrollo con recarga automática

```bash
# Backend con nodemon (recarga automática)
cd backend
npm run dev

# Electron con recarga (requiere electron-reload)
npm install --save-dev electron-reload
# Agregar en main.js:
# require('electron-reload')(__dirname);
npm start
```

## 📦 Compilación

### Compilar para tu sistema operativo actual

```bash
npm run build
```

Esto detecta automáticamente tu sistema operativo y compila para él.

### Compilar para sistemas específicos

#### Windows

```bash
npm run build:win
```

**Salida:** `dist/Invoice App Setup.exe`

#### macOS

```bash
npm run build:mac
```

**Salida:** `dist/Invoice App.dmg`

#### Linux

```bash
npm run build:linux
```

**Salida:** `dist/Invoice App.AppImage`

#### Compilar para todas las plataformas

```bash
npm run build:all
```

**⚠️ Importante:** Esto solo funciona correctamente si tienes configuradas las herramientas de cross-compilation.

### Compilar para Windows desde Mac

Para compilar instaladores de Windows desde macOS, necesitas Wine:

```bash
# Instalar Homebrew (si no lo tienes)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar Wine
brew install --cask wine-stable

# Verificar instalación
wine --version

# Ahora puedes compilar para Windows
npm run build:win
```

### Compilar para Mac desde Windows/Linux

Desafortunadamente, compilar para macOS desde otros sistemas requiere hardware Apple o usar servicios en la nube como:
- **GitHub Actions** (recomendado)
- **CircleCI**
- **Travis CI**

## 🎮 Uso

### Primera ejecución

La primera vez que ejecutes la aplicación:

1. Se ejecutará automáticamente `backend/src/init.js`
2. Se creará la base de datos SQLite
3. Se insertarán datos de ejemplo (usuario administrador)
4. Se creará un archivo `.initialized` para no repetir este proceso

### Funcionalidades principales

#### Gestión de Usuarios
- ➕ Crear usuarios con nombre y email
- 📋 Listar todos los usuarios
- 🗑️ Eliminar usuarios

#### Generación de PDFs
- 📄 Exportar lista de usuarios a PDF
- 🧾 Generar facturas en PDF
- 📥 Descarga automática al navegador

### Resetear la aplicación

Si quieres que la app ejecute de nuevo el script de inicialización:

**Opción 1: Desde código (si lo implementaste)**
```javascript
await window.electronAPI.resetApp();
```

**Opción 2: Manual**
```bash
# macOS
rm ~/Library/Application\ Support/invoice-app-electron/.initialized

# Windows (PowerShell)
Remove-Item "$env:APPDATA\invoice-app-electron\.initialized"

# Linux
rm ~/.config/invoice-app-electron/.initialized
```

Luego reinicia la aplicación.

## 🔨 Tecnologías

### Frontend
- HTML5
- CSS3
- JavaScript (Vanilla)

### Backend
- Node.js
- Express.js
- SQLite3
- pdf-lib (generación de PDFs)

### Desktop
- Electron
- electron-builder (compilación)

## 🐛 Troubleshooting

### Error: "setupIpcHandlers is not defined"

**Solución:** Asegúrate de que `main.js` tiene el import correcto:
```javascript
const { app, BrowserWindow, ipcMain } = require('electron');
```

### Error: "ENOENT: no such file or directory, rename electron.exe"

**Causa:** Estás compilando para Windows desde Mac sin Wine.

**Solución:**
```bash
brew install --cask wine-stable
npm run build:win
```

### Error: "Cannot find module 'pdfkit'"

**Solución:**
```bash
cd backend
npm install
cd ..
```

### Error: "Port 3000 already in use"

**Causa:** El puerto 3000 ya está siendo usado por otra aplicación.

**Solución:**
```bash
# Encontrar el proceso usando el puerto
# macOS/Linux:
lsof -ti:3000 | xargs kill -9

# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

O cambia el puerto en `backend/server.js`:
```javascript
const PORT = 3001; // Cambiar a otro puerto
```

### La base de datos no se crea

**Ubicación de la base de datos según el sistema:**

- **macOS:** `~/Library/Application Support/invoice-app-electron/database.db`
- **Windows:** `C:\Users\Usuario\AppData\Roaming\invoice-app-electron\database.db`
- **Linux:** `~/.config/invoice-app-electron/database.db`

**Verificar:**
```bash
# macOS/Linux
ls -la ~/Library/Application\ Support/invoice-app-electron/

# Windows (PowerShell)
dir $env:APPDATA\invoice-app-electron\
```

### El instalador no se genera

**Verificar:**
1. Que tienes los iconos en `build/`
2. Que el `package.json` tiene la configuración `build`
3. Que electron-builder está instalado:
   ```bash
   npm list electron-builder
   ```

### Problemas con SQLite en producción

Si SQLite falla después de compilar, reconstruye los binarios nativos:

```bash
cd backend
npm rebuild sqlite3 --build-from-source
cd ..
npm run build
```

## 📄 Scripts disponibles

```json
{
  "start": "Ejecutar la aplicación en modo desarrollo",
  "build": "Compilar para el sistema actual",
  "build:win": "Compilar para Windows",
  "build:mac": "Compilar para macOS",
  "build:linux": "Compilar para Linux",
  "build:all": "Compilar para todas las plataformas"
}
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👨‍💻 Autor

Tu Nombre - [@tu_usuario](https://twitter.com/tu_usuario)

Proyecto: [https://github.com/tu-usuario/invoice-app-electron](https://github.com/tu-usuario/invoice-app-electron)

## 🙏 Agradecimientos

- [Electron](https://www.electronjs.org/)
- [Express](https://expressjs.com/)
- [SQLite](https://www.sqlite.org/)
- [pdf-lib](https://pdf-lib.js.org/)
- [electron-builder](https://www.electron.build/)

---

**¿Necesitas ayuda?** Abre un [issue](https://github.com/tu-usuario/invoice-app-electron/issues) en GitHub.
