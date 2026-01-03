const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

exports.default = async function(context) {
  const { appOutDir, electronPlatformName } = context;
  
  console.log('🔧 Running afterPack hook...');
  console.log('App output directory:', appOutDir);
  console.log('Platform:', electronPlatformName);
  
  // Determinar la ruta al backend según la plataforma
  let backendPath;
  if (electronPlatformName === 'darwin') {
    backendPath = path.join(appOutDir, 'Invoice App.app', 'Contents', 'Resources', 'backend');
  } else if (electronPlatformName === 'win32') {
    // En Windows, los resources están en la carpeta win-unpacked
    backendPath = path.join(appOutDir, 'resources', 'backend');
  } else if (electronPlatformName === 'linux') {
    backendPath = path.join(appOutDir, 'resources', 'backend');
  }
  
  console.log('Backend path:', backendPath);
  
  if (!fs.existsSync(backendPath)) {
    console.error('❌ Backend path does not exist:', backendPath);
    return;
  }
  
  if (electronPlatformName === 'win32') {
    console.log('📦 Rebuilding better-sqlite3 for Windows...');
    
    try {
      // Rebuild better-sqlite3 for the target platform
      execSync('npx electron-rebuild -f -w better-sqlite3', {
        cwd: backendPath,
        stdio: 'inherit'
      });
      
      console.log('✅ better-sqlite3 rebuilt successfully for Windows');
    } catch (error) {
      console.error('❌ Error rebuilding better-sqlite3:', error);
      throw error;
    }
  }
};
