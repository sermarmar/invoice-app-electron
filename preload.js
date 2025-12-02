const { contextBridge, ipcRenderer } = require('electron');

// Exponer información útil al frontend
contextBridge.exposeInMainWorld('electronAPI', {
  // Información del entorno
  platform: process.platform,
  version: process.versions.electron,
  
  // Si necesitas comunicación con el proceso principal
  onServerReady: (callback) => ipcRenderer.on('server-ready', callback),
  onServerError: (callback) => ipcRenderer.on('server-error', callback),
  
  // Utilidades opcionales
  openExternal: (url) => ipcRenderer.send('open-external', url),
  
  // Para cerrar la aplicación desde el frontend
  closeApp: () => ipcRenderer.send('close-app'),
  
  // Gestión de inicialización
  resetApp: () => ipcRenderer.invoke('reset-app'),
  isInitialized: () => ipcRenderer.invoke('is-initialized')
});

// Puedes también exponer la URL del API si quieres centralizarla
contextBridge.exposeInMainWorld('config', {
  API_URL: 'http://localhost:3000/api'
});

console.log('✅ Preload script cargado correctamente');