// Kiroshi Optics - Clean Toggle System
let kiroshiActive = false;

// DOM elements
const overlay = document.getElementById('kiroshi-overlay');
const targetInfo = document.getElementById('target-info');
const targetOutline = document.getElementById('target-outline');

// Info box elements
const targetName = document.querySelector('.target-name');
const targetDistance = document.querySelector('.target-distance');
const targetJob = document.querySelector('.target-job');
const healthFill = document.querySelector('.health-fill');
const healthText = document.querySelector('.health-text');

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
            
        case 'clearTarget':
            clearTarget();
            break;
    }
});

// Toggle Kiroshi overlay on/off
function toggleKiroshi(active) {
    kiroshiActive = active;
    
    if (active) {
        overlay.classList.add('active');
    } else {
        overlay.classList.remove('active');
        clearTarget();
    }
}

// Update target information
function updateTarget(target) {
    if (!kiroshiActive) return;
    
    // Show elements
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
    
    // Position info box to the right of target
    targetInfo.style.left = (target.boxX + target.boxWidth + 15) + 'px';
    targetInfo.style.top = target.boxY + 'px';
}

// Clear target display
function clearTarget() {
    targetInfo.classList.add('hidden');
    targetOutline.classList.add('hidden');
}

