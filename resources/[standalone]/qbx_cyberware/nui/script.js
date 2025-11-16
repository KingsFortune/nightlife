// Kiroshi Optics - Clean Toggle System
let kiroshiActive = false;
let isScanning = false;
let scanProgress = 0;
let scanInterval = null;

// DOM elements
const overlay = document.getElementById('kiroshi-overlay');
const targetInfo = document.getElementById('target-info');
const vehicleInfo = document.getElementById('vehicle-info');
const targetOutline = document.getElementById('target-outline');
const crosshair = document.querySelector('.crosshair');
const scanProgressBar = document.getElementById('scan-progress');
const scanProgressFill = document.querySelector('.scan-progress-fill');

// Ped info box elements
const targetName = document.querySelector('.target-name');
const targetDistance = document.querySelector('.target-distance');
const targetJob = document.querySelector('.target-job');
const healthFill = document.querySelector('.health-fill');
const healthText = document.querySelector('.health-text');

// Vehicle info box elements
const vehicleModel = document.querySelector('.vehicle-model');
const vehicleDistance = document.querySelector('.vehicle-distance');
const vehicleMake = document.querySelector('.vehicle-make');
const vehicleClass = document.querySelector('.vehicle-class');

// Sound cache
const sounds = {
    doublejump: new Audio('../sounds/doublejump.ogg')
};

// Listen for messages from Lua
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.action) {
        case 'toggle':
            toggleKiroshi(data.active);
            break;
            
        case 'updateTarget':
            updateTarget(data.target);
            break;
            
        case 'updateVehicle':
            updateVehicle(data.target);
            break;
            
        case 'clearTarget':
            clearTarget();
            break;
            
        case 'playSound':
            playSound(data.sound, data.volume);
            break;
    }
});

// Toggle Kiroshi overlay on/off
function toggleKiroshi(active) {
    kiroshiActive = active;
    
    if (active) {
        overlay.classList.add('active');
        crosshair.classList.add('scanning');
    } else {
        overlay.classList.remove('active');
        crosshair.classList.remove('scanning');
        clearTarget();
    }
}

// Update target information
function updateTarget(target) {
    if (!kiroshiActive) return;
    
    // Start scanning animation if not already scanning
    if (!isScanning) {
        startScan();
    }
    
    // Hide vehicle info, show target info
    vehicleInfo.classList.add('hidden');
    targetInfo.classList.remove('hidden');
    targetOutline.classList.remove('hidden');
    
    // Set type class (player or npc)
    if (target.isPlayer) {
        targetInfo.classList.remove('npc');
        targetOutline.classList.remove('npc');
    } else {
        targetInfo.classList.add('npc');
        targetOutline.classList.add('npc');
    }
    
    // Update text content
    targetName.textContent = target.name || 'UNKNOWN';
    targetDistance.textContent = target.distance + 'm';
    targetJob.textContent = target.job || 'CIVILIAN';
    
    // Update health bar
    const health = target.health || 100;
    healthFill.style.width = health + '%';
    healthText.textContent = health + '%';
    
    // Position outline box around target
    targetOutline.style.left = target.boxX + 'px';
    targetOutline.style.top = target.boxY + 'px';
    targetOutline.style.width = target.boxWidth + 'px';
    targetOutline.style.height = target.boxHeight + 'px';
}

// Update vehicle information
function updateVehicle(target) {
    if (!kiroshiActive) return;
    
    // Start scanning animation if not already scanning
    if (!isScanning) {
        startScan();
    }
    
    // Hide target info, show vehicle info
    targetInfo.classList.add('hidden');
    vehicleInfo.classList.remove('hidden');
    targetOutline.classList.remove('hidden');
    
    // Vehicles always use cyan
    targetOutline.classList.add('npc');
    
    // Update vehicle text content
    vehicleModel.textContent = target.model || 'UNKNOWN';
    vehicleDistance.textContent = target.distance + 'm';
    vehicleMake.textContent = target.make || 'UNKNOWN';
    vehicleClass.textContent = target.class || 'UNKNOWN';
    
    // Position outline box around vehicle
    targetOutline.style.left = target.boxX + 'px';
    targetOutline.style.top = target.boxY + 'px';
    targetOutline.style.width = target.boxWidth + 'px';
    targetOutline.style.height = target.boxHeight + 'px';
}

// Clear target display
function clearTarget() {
    targetInfo.classList.add('hidden');
    vehicleInfo.classList.add('hidden');
    targetOutline.classList.add('hidden');
    stopScan();
}

// Start scanning progress bar
function startScan() {
    if (isScanning) return;
    
    isScanning = true;
    scanProgress = 0;
    scanProgressBar.classList.remove('hidden');
    scanProgressFill.style.width = '0%';
    
    // 1.5 second scan duration
    const scanDuration = 1500;
    const updateInterval = 16; // ~60fps
    const increment = (100 / scanDuration) * updateInterval;
    
    scanInterval = setInterval(() => {
        scanProgress += increment;
        scanProgressFill.style.width = Math.min(scanProgress, 100) + '%';
        
        if (scanProgress >= 100) {
            stopScan();
        }
    }, updateInterval);
}

// Stop scanning progress bar
function stopScan() {
    if (scanInterval) {
        clearInterval(scanInterval);
        scanInterval = null;
    }
    isScanning = false;
    scanProgressBar.classList.add('hidden');
    scanProgress = 0;
}

// Play sound effect
function playSound(soundName, volume = 1.0) {
    if (sounds[soundName]) {
        const sound = sounds[soundName];
        sound.volume = volume;
        sound.currentTime = 0; // Reset to start
        sound.play().catch(err => console.log('Sound play error:', err));
    }
}
