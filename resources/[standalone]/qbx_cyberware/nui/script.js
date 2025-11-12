// Kiroshi Optics NUI - Toggle Mode with Hover Targeting
let kiroshiActive = false;
let currentTarget = null;

// Get DOM elements
const overlay = document.getElementById('kiroshi-overlay');
const targetContainer = document.getElementById('target-container');
const targetOutline = targetContainer.querySelector('.target-outline');
const detailBox = targetContainer.querySelector('.detail-box');
const distanceIndicator = targetContainer.querySelector('.distance-indicator');

// Message handler
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.action) {
        case 'toggleActive':
            toggleKiroshi(data.active);
            break;
        case 'updateTarget':
            updateTarget(data.target);
            break;
        case 'clearTarget':
            clearTarget();
            break;
        case 'clearCache':
            console.log('[KIROSHI NUI] Cache cleared');
            break;
        case 'playSound':
            playSound(data.sound, data.volume);
            break;
    }
});

// Toggle Kiroshi overlay
function toggleKiroshi(active) {
    kiroshiActive = active;
    
    if (active) {
        overlay.classList.add('active');
        console.log('[KIROSHI NUI] Activated');
    } else {
        overlay.classList.remove('active');
        clearTarget();
        console.log('[KIROSHI NUI] Deactivated');
    }
}

// Update target info and position
function updateTarget(target) {
    if (!kiroshiActive) return;
    
    currentTarget = target;
    const isPlayer = target.isPlayer;
    const typeClass = isPlayer ? 'player' : 'npc';
    
    // Show target container
    targetContainer.classList.add('visible');
    
    // Update outline box position (center on target)
    targetOutline.style.left = target.x + 'px';
    targetOutline.style.top = target.y + 'px';
    targetOutline.className = `target-outline ${typeClass}`;
    
    // Update distance indicator
    distanceIndicator.textContent = `${target.distance}m`;
    distanceIndicator.className = `distance-indicator ${typeClass}`;
    distanceIndicator.style.left = target.x + 'px';
    distanceIndicator.style.top = (target.y - 100) + 'px'; // Above outline
    distanceIndicator.style.transform = 'translateX(-50%)';
    
    // Update detail box position (to the right of outline)
    const detailOffsetX = 70; // Distance from outline center
    detailBox.style.left = (target.x + detailOffsetX) + 'px';
    detailBox.style.top = target.y + 'px';
    detailBox.className = `detail-box ${typeClass}`;
    
    // Update detail box content
    const header = detailBox.querySelector('.detail-header');
    header.textContent = isPlayer ? '◆ PLAYER SCAN ◆' : '◆ NPC SCAN ◆';
    header.className = `detail-header ${typeClass}`;
    
    // Update name
    detailBox.querySelector('.name-value').textContent = target.name || 'Unknown';
    
    // Update job/occupation
    const jobRow = detailBox.querySelector('.job-row');
    if (isPlayer) {
        jobRow.style.display = 'flex';
        detailBox.querySelector('.job-value').textContent = target.job || 'Civilian';
    } else {
        jobRow.style.display = 'none';
    }
    
    // Update gang
    const gangRow = detailBox.querySelector('.gang-row');
    if (isPlayer && target.gang && target.gang !== 'None') {
        gangRow.style.display = 'flex';
        detailBox.querySelector('.gang-value').textContent = target.gang;
        detailBox.querySelector('.gang-value').className = 'detail-value player-accent';
    } else {
        gangRow.style.display = 'none';
    }
    
    // Update health bar
    const healthFill = detailBox.querySelector('.health-bar-fill');
    healthFill.style.width = target.health + '%';
    healthFill.style.backgroundPosition = (100 - target.health) + '% 0';
}

// Clear target display
function clearTarget() {
    currentTarget = null;
    targetContainer.classList.remove('visible');
}

// Play sound effect
function playSound(sound, volume = 0.5) {
    const audio = new Audio(`../sounds/${sound}.ogg`);
    audio.volume = volume;
    audio.play().catch(err => console.error('[KIROSHI SOUND] Failed to play:', err));
}

