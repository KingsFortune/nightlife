// Kiroshi Optics - Clean Toggle System
let kiroshiActive = false;

// DOM elements
const overlay = document.getElementById('kiroshi-overlay');
const targetInfo = document.getElementById('target-info');
const vehicleInfo = document.getElementById('vehicle-info');
const targetOutline = document.getElementById('target-outline');
const crosshair = document.querySelector('.crosshair');

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
    doublejump: new Audio('sounds/doublejump.ogg')
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
    
    // Position outline box around target (smooth following)
    requestAnimationFrame(() => {
        targetOutline.style.left = target.boxX + 'px';
        targetOutline.style.top = target.boxY + 'px';
        targetOutline.style.width = target.boxWidth + 'px';
        targetOutline.style.height = target.boxHeight + 'px';
        
        // Position info box to the right of target with screen edge detection
        const screenWidth = window.innerWidth;
        const infoWidth = 220; // Approximate width of info box
        let infoX = target.boxX + target.boxWidth + 15;
        
        // If too close to right edge, place on left side
        if (infoX + infoWidth > screenWidth) {
            infoX = target.boxX - infoWidth - 15;
        }
        
        targetInfo.style.left = infoX + 'px';
        targetInfo.style.top = target.boxY + 'px';
    });
}

// Update vehicle information
function updateVehicle(target) {
    if (!kiroshiActive) return;
    
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
    
    // Position outline box around vehicle (smooth following)
    requestAnimationFrame(() => {
        targetOutline.style.left = target.boxX + 'px';
        targetOutline.style.top = target.boxY + 'px';
        targetOutline.style.width = target.boxWidth + 'px';
        targetOutline.style.height = target.boxHeight + 'px';
        
        // Position info box to the right of vehicle with screen edge detection
        const screenWidth = window.innerWidth;
        const infoWidth = 220;
        let infoX = target.boxX + target.boxWidth + 15;
        
        // If too close to right edge, place on left side
        if (infoX + infoWidth > screenWidth) {
            infoX = target.boxX - infoWidth - 15;
        }
        
        vehicleInfo.style.left = infoX + 'px';
        vehicleInfo.style.top = target.boxY + 'px';
    });
}

// Clear target display
function clearTarget() {
    targetInfo.classList.add('hidden');
    vehicleInfo.classList.add('hidden');
    targetOutline.classList.add('hidden');
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
