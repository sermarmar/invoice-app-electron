const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');
const { spawn } = require('child_process');

let mainWindow;
let serverProcess;

// Configurar logging
const logFile = path.join(app.getPath('userData'), 'app.log');
const log = (message) => {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${message}\n`;
  console.log(message);
  try {
    fs.appendFileSync(logFile, logMessage);
  } catch (err) {
    console.error('Error writing to log:', err);
  }
};

log('=== APP STARTING ===');
log('App path: ' + app.getAppPath());
log('User data path: ' + app.getPath('userData'));
log('Is packaged: ' + app.isPackaged);
log('Platform: ' + process.platform);
log('__dirname: ' + __dirname);

// Obtener la ruta correcta del backend según si está empaquetado o no
function getBackendPath() {
  if (app.isPackaged) {
    // En producción, el backend está en extraResources
    const resourcesPath = path.join(process.resourcesPath, 'backend');
    log('Backend path (packaged): ' + resourcesPath);
    return resourcesPath;
  } else {
    // En desarrollo
    const devPath = path.join(__dirname, 'backend');
    log('Backend path (dev): ' + devPath);
    return devPath;
  }
}

function startExpressServer() {
  return new Promise((resolve, reject) => {
    const backendPath = getBackendPath();
    const serverPath = path.join(backendPath, 'server.js');
    
    log('Starting Express server...');
    log('Server path: ' + serverPath);
    
    // Verificar que el archivo existe
    if (!fs.existsSync(serverPath)) {
      const error = 'ERROR: server.js not found at ' + serverPath;
      log(error);
      reject(new Error(error));
      return;
    }
    
    // Usar process.execPath para ejecutar Node.js dentro de Electron
    serverProcess = spawn(process.execPath, [serverPath], {
      cwd: backendPath,
      stdio: 'inherit',
      env: { 
        ...process.env, 
        ELECTRON_RUN_AS_NODE: '1',
        NODE_ENV: 'production',
        USER_DATA_PATH: app.getPath('userData')
      }
    });

    serverProcess.on('error', (err) => {
      log('ERROR starting server: ' + err.message);
      console.error('Error al iniciar el servidor:', err);
      reject(err);
    });

    serverProcess.on('exit', (code, signal) => {
      log('Server process exited with code: ' + code + ', signal: ' + signal);
    });

    waitForServer()
      .then(() => {
        log('Server is ready');
        resolve();
      })
      .catch(reject);
  });
}

function waitForServer(maxAttempts = 40, intervalMs = 500) {
  return new Promise((resolve, reject) => {
    const http = require('http');
    let attempts = 0;

    const check = () => {
      attempts++;
      const req = http.get('http://localhost:3001/api/health', (res) => {
        if (res.statusCode === 200) {
          log('Server ready after ' + attempts + ' attempt(s)');
          resolve();
        } else {
          scheduleRetry();
        }
      });
      req.on('error', scheduleRetry);
      req.setTimeout(400, () => { req.destroy(); scheduleRetry(); });
    };

    const scheduleRetry = () => {
      if (attempts >= maxAttempts) {
        reject(new Error('Server did not start within ' + (maxAttempts * intervalMs / 1000) + 's'));
        return;
      }
      setTimeout(check, intervalMs);
    };

    setTimeout(check, intervalMs);
  });
}

// Ejecutar script de inicialización
function runInitScript() {
  return new Promise((resolve, reject) => {
    log('Running init script...');
    console.log('🔧 Ejecutando script de inicialización...');
    
    const backendPath = getBackendPath();
    const initPath = path.join(backendPath, 'src', 'init.js');
    
    log('Init script path: ' + initPath);
    
    // Verificar que el archivo existe
    if (!fs.existsSync(initPath)) {
      const error = 'ERROR: init.js not found at ' + initPath;
      log(error);
      reject(new Error(error));
      return;
    }
    
    const initProcess = spawn(process.execPath, [initPath], {
      cwd: backendPath,
      stdio: 'inherit',
      env: { 
        ...process.env, 
        ELECTRON_RUN_AS_NODE: '1',
        USER_DATA_PATH: app.getPath('userData')
      }
    });

    initProcess.on('close', (code) => {
      if (code === 0) {
        log('Init completed successfully');
        console.log('✅ Inicialización completada exitosamente');
        resolve();
      } else {
        log('Init failed with code: ' + code);
        console.error('❌ Error en la inicialización, código:', code);
        reject(new Error(`Init script failed with code ${code}`));
      }
    });

    initProcess.on('error', (err) => {
      log('ERROR running init: ' + err.message);
      console.error('❌ Error al ejecutar init.js:', err);
      reject(err);
    });
  });
}

// Verificar si es la primera vez que se ejecuta la app
function isFirstRun() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  const backendPath = getBackendPath();
  const dbFile = path.join(app.getPath('userData'), 'app.db');

  log('Checking first run...');
  log('Flag file: ' + flagFile);
  log('DB file: ' + dbFile);

  // Primera ejecución si no existe el flag o si falta la base de datos
  const flagMissing = !fs.existsSync(flagFile);
  const dbMissing = !fs.existsSync(dbFile);

  if (flagMissing) {
    log('Flag missing - first run detected');
    console.log('🔍 Flag de inicialización no encontrado');
  }
  if (dbMissing) {
    log('Database missing - first run detected');
    console.log('🔍 Base de datos backend/database/app.db no encontrada');
  }

  return flagMissing || dbMissing;
}

// Marcar que la app ya fue inicializada
function markAsInitialized() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  
  log('Marking app as initialized');
  
  // Crear el archivo de bandera
  fs.writeFileSync(flagFile, new Date().toISOString());
  log('App marked as initialized: ' + flagFile);
  console.log('✅ App marcada como inicializada');
}

// Resetear la app (eliminar flag de inicialización)
function resetApp() {
  const userDataPath = app.getPath('userData');
  const flagFile = path.join(userDataPath, '.initialized');
  
  log('Resetting app...');
  
  if (fs.existsSync(flagFile)) {
    fs.unlinkSync(flagFile);
    log('App reset - init will run on next start');
    console.log('🔄 App reseteada - se ejecutará init.js en el próximo arranque');
  }
}

// Configurar manejadores IPC
function setupIpcHandlers() {
  log('Setting up IPC handlers');
  
  // Resetear la aplicación
  ipcMain.handle('reset-app', async () => {
    log('Reset app requested');
    resetApp();
    app.relaunch();
    app.exit(0);
  });
  
  // Verificar si está inicializada
  ipcMain.handle('is-initialized', () => {
    const initialized = !isFirstRun();
    log('Is initialized check: ' + initialized);
    return initialized;
  });
}

function createWindow() {
  log('Creating window...');
  
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  // Cargar la aplicación
  const indexPath = path.join(__dirname, 'frontend', 'index.html');
  log('Loading frontend from: ' + indexPath);
  
  mainWindow.loadFile(indexPath);
  
  // Abrir DevTools solo en desarrollo
  if (!app.isPackaged) {
    mainWindow.webContents.openDevTools();
  }
  
  log('Window created successfully');
}

app.whenReady().then(async () => {
  try {
    log('App ready event fired');
    
    // Configurar manejadores IPC
    setupIpcHandlers();
    
    // Verificar si es la primera ejecución
    if (isFirstRun()) {
      log('First run detected - running initialization');
      console.log('🎉 Primera ejecución detectada');
      
      // Ejecutar script de inicialización
      await runInitScript();
      
      // Marcar como inicializada
      markAsInitialized();
    } else {
      log('App already initialized');
      console.log('✅ App ya inicializada previamente');
    }
    
    // Iniciar el servidor Express
    log('Starting Express server...');
    await startExpressServer();
    
    // Crear la ventana
    log('Creating main window...');
    createWindow();

    app.on('activate', function () {
      log('App activated');
      if (BrowserWindow.getAllWindows().length === 0) {
        createWindow();
      }
    });
    
    log('=== APP STARTED SUCCESSFULLY ===');
  } catch (error) {
    log('FATAL ERROR during startup: ' + error.message);
    log('Stack trace: ' + error.stack);
    console.error('Error al iniciar la aplicación:', error);
    
    // Mostrar diálogo de error
    const { dialog } = require('electron');
    dialog.showErrorBox(
      'Error al iniciar',
      'La aplicación no pudo iniciarse correctamente.\n\n' +
      'Error: ' + error.message + '\n\n' +
      'Revisa el log en:\n' + logFile
    );
    
    app.quit();
  }
});

app.on('window-all-closed', function () {
  log('All windows closed');
  
  // Cerrar el servidor Express
  if (serverProcess) {
    log('Killing server process');
    serverProcess.kill();
  }
  
  // En Mac, las apps suelen quedarse abiertas aunque cierres las ventanas
  // En Windows/Linux, cerrar la ventana cierra la app
  if (process.platform !== 'darwin') {
    log('Quitting app (non-macOS)');
    app.quit();
  }
});

app.on('before-quit', () => {
  log('App quitting...');
  if (serverProcess) {
    log('Killing server process before quit');
    serverProcess.kill();
  }
});

// Capturar errores no manejados
process.on('uncaughtException', (error) => {
  log('UNCAUGHT EXCEPTION: ' + error.message);
  log('Stack: ' + error.stack);
  console.error('Uncaught exception:', error);
});

process.on('unhandledRejection', (reason, promise) => {
  log('UNHANDLED REJECTION at: ' + promise + ', reason: ' + reason);
  console.error('Unhandled rejection:', reason);
});