#!/usr/bin/env node

const { spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');


// Get command and args from CLI
const [,, command, ...args] = process.argv;


if (!command) {
  console.error('❌ No command provided.');
  process.exit(1);
}


const scriptPath = path.resolve(__dirname, 'scripts', `${command}.sh`);

if (!fs.existsSync(scriptPath)) {
  console.error(`❌ Command script not found: ${scriptPath}`);
  process.exit(1);
}



// Run the bash script
const result = spawnSync('bash', [scriptPath, ...args], { stdio: 'inherit' });

if (result.error) {
  console.error('❌ Error running script:', result.error.message);
  process.exit(1);
}