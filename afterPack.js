const { rebuild } = require('@electron/rebuild');
const path = require('path');
const fs = require('fs');

exports.default = async function(context) {
  const { appOutDir, electronPlatformName } = context;

  console.log('🔧 Running afterPack hook...');
  console.log('Platform:', electronPlatformName);

  let backendPath;
  if (electronPlatformName === 'darwin') {
    backendPath = path.join(appOutDir, 'Invoice App.app', 'Contents', 'Resources', 'backend');
  } else {
    backendPath = path.join(appOutDir, 'resources', 'backend');
  }

  console.log('Backend path:', backendPath);

  if (!fs.existsSync(backendPath)) {
    console.error('❌ Backend path not found:', backendPath);
    return;
  }

  const electronVersion = require('./node_modules/electron/package.json').version;
  console.log('📦 Rebuilding better-sqlite3 for Electron', electronVersion, 'on', electronPlatformName, '...');

  await rebuild({
    buildPath: backendPath,
    electronVersion,
    force: true,
    onlyModules: ['better-sqlite3'],
  });

  console.log('✅ better-sqlite3 rebuilt successfully');
};
