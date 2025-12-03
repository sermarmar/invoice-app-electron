const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');
const { spawn } = require('child_process');

let mainWindow;
let serverProcess;

function startExpressServer() {
  return new Promise((resolve, reject) => {
    // Iniciar el servidor Express como proceso hijo
    const serverPath = path.join(__dirname, 'backend', 'server.js');
    
    serverProcess = spawn('node', [serverPath], {
      cwd: path.join(__dirname, 'backend'),
      stdio: 'inherit'
    });

    serverProcess.on('error', (err) => {
      console.error('Error al iniciar el servidor:', err);
      reject(err);
    });

    // Esperar a que el servidor esté listo
    setTimeout(() => {
      console.log('Servidor Express iniciado');
      resolve();
    }, 2000);
  });
}

// Ejecutar script de inicialización
function runInitScript() {
  return new Promise((resolve, reject) => {
    console.log('🔧 Ejecutando script de inicialización...');
    
    const initPath = path.join(__dirname, 'backend', 'src', 'init.js');
    const initProcess = spawn('node', [initPath], {
      cwd: path.join(__dirname, 'backend'),
      stdio: 'inherit'
    });

    initProcess.on('close', (code) => {
      if (code === 0) {
        console.log('✅ Inicialización completada exitosamente');
        resolve();
      } else {
        console.error('❌ Error en la inicialización, código:', code);
        reject(new Error(`Init script failed with code ${code}`));
      }
    });

    initProcess.on('error', (err) => {
      console.error('❌ Error al ejecutar init.js:', err);
      reject(err);
    });
  });
}

// Verificar si es la primera vez que se ejecuta la app
function isFirstRun() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  const dbFile = path.join(__dirname, 'backend', 'database', 'app.db');

  // Primera ejecución si no existe el flag o si falta la base de datos
  const flagMissing = !fs.existsSync(flagFile);
  const dbMissing = !fs.existsSync(dbFile);

  if (flagMissing) {
    console.log('🔍 Flag de inicialización no encontrado');
  }
  if (dbMissing) {
    console.log('🔍 Base de datos backend/database/app.db no encontrada');
  }

  return flagMissing || dbMissing;
}

// Marcar que la app ya fue inicializada
function markAsInitialized() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  
  // Crear el archivo de bandera
  fs.writeFileSync(flagFile, new Date().toISOString());
  console.log('✅ App marcada como inicializada');
}

// Resetear la app (eliminar flag de inicialización)
function resetApp() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  
  if (fs.existsSync(flagFile)) {
    fs.unlinkSync(flagFile);
    console.log('🔄 App reseteada - se ejecutará init.js en el próximo arranque');
  }
}

// Configurar manejadores IPC
function setupIpcHandlers() {
  // Resetear la aplicación
  ipcMain.handle('reset-app', async () => {
    resetApp();
    app.relaunch();
    app.exit(0);
  });
  
  // Verificar si está inicializada
  ipcMain.handle('is-initialized', () => {
    return !isFirstRun();
  });
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  // Cargar la aplicación (puedes usar localhost si Express sirve el frontend)
  mainWindow.loadFile('frontend/index.html');
  
  // O si Express sirve el frontend:
  // mainWindow.loadURL('http://localhost:3000');
  
  mainWindow.webContents.openDevTools();
}

app.whenReady().then(async () => {
  try {
    // Configurar manejadores IPC
    setupIpcHandlers();
    
    // Verificar si es la primera ejecución
    if (isFirstRun()) {
      console.log('🎉 Primera ejecución detectada');
      
      // Ejecutar script de inicialización
      await runInitScript();
      
      // Marcar como inicializada
      markAsInitialized();
    } else {
      console.log('✅ App ya inicializada previamente');
    }
    
    // Iniciar el servidor Express
    await startExpressServer();
    
    // Crear la ventana
    createWindow();

    app.on('activate', function () {
      if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
  } catch (error) {
    console.error('Error al iniciar la aplicación:', error);
    app.quit();
  }
});

app.on('window-all-closed', function () {
  // Cerrar el servidor Express
  if (serverProcess) {
    serverProcess.kill();
  }
  
  // En Mac, las apps suelen quedarse abiertas aunque cierres las ventanas
  // En Windows/Linux, cerrar la ventana cierra la app
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  if (serverProcess) {
    serverProcess.kill();
  }
});