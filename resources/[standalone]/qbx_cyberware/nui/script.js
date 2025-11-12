// Random name generator for NPCs
const firstNames = [
    'John', 'Jane', 'Michael', 'Sarah', 'Robert', 'Lisa', 'David', 'Emily',
    'James', 'Emma', 'William', 'Olivia', 'Richard', 'Sophia', 'Joseph', 'Ava',
    'Thomas', 'Isabella', 'Charles', 'Mia', 'Daniel', 'Charlotte', 'Matthew', 'Amelia',
    'Anthony', 'Harper', 'Mark', 'Evelyn', 'Donald', 'Abigail', 'Steven', 'Elizabeth'
];

const lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas',
    'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris',
    'Clark', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen', 'King', 'Wright'
];

const occupations = [
    'Mechanic', 'Taxi Driver', 'Security Guard', 'Store Clerk', 'Bartender',
    'Chef', 'Delivery Driver', 'Construction Worker', 'Office Worker', 'Accountant',
    'Lawyer', 'Doctor', 'Nurse', 'Teacher', 'Engineer', 'Programmer',
    'Artist', 'Musician', 'Journalist', 'Photographer', 'Fitness Trainer',
    'Real Estate Agent', 'Sales Rep', 'Waiter', 'Janitor', 'Unemployed'
];

const gangs = [
    'None', 'None', 'None', 'None', 'None', // Higher chance of no gang
    'Ballas', 'Vagos', 'Families', 'Marabunta', 'Triads',
    'Lost MC', 'Street Thugs'
];

// Generate random NPC data
function generateNPCData(entityId) {
    return {
        name: `${firstNames[Math.floor(Math.random() * firstNames.length)]} ${lastNames[Math.floor(Math.random() * lastNames.length)]}`,
        occupation: occupations[Math.floor(Math.random() * occupations.length)],
        gang: gangs[Math.floor(Math.random() * gangs.length)],
        threat: Math.random() > 0.7 ? 'HIGH' : (Math.random() > 0.4 ? 'MEDIUM' : 'LOW'),
        criminal: Math.random() > 0.8
    };
}

// Store generated data to keep it consistent
const entityDataCache = {};

// Main overlay state
let overlayActive = false;
let entities = [];

// Show/hide overlay
window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.action === 'show') {
        overlayActive = true;
        document.getElementById('kiroshi-overlay').classList.remove('hidden');
    } 
    else if (data.action === 'hide') {
        overlayActive = false;
        document.getElementById('kiroshi-overlay').classList.add('hidden');
        clearMarkers();
    }
    else if (data.action === 'updateEntities') {
        entities = data.entities || [];
        updateMarkers();
    }
});

// Clear all markers
function clearMarkers() {
    const container = document.getElementById('entity-markers');
    container.innerHTML = '';
    entityDataCache = {};
}

// Update entity markers on screen
function updateMarkers() {
    const container = document.getElementById('entity-markers');
    container.innerHTML = '';
    
    entities.forEach(entity => {
        // Get or generate entity data
        if (!entityDataCache[entity.id]) {
            if (entity.isPlayer) {
                entityDataCache[entity.id] = {
                    name: entity.name || 'Unknown Player',
                    job: entity.job || 'Civilian',
                    gang: entity.gang || 'None',
                    threat: 'LOW'
                };
            } else {
                entityDataCache[entity.id] = generateNPCData(entity.id);
            }
        }
        
        const entityData = entityDataCache[entity.id];
        
        // Create marker element
        const marker = document.createElement('div');
        marker.className = 'entity-marker';
        marker.style.left = `${entity.x}px`;
        marker.style.top = `${entity.y}px`;
        
        // Create outline
        const outline = document.createElement('div');
        outline.className = `entity-outline ${entity.isPlayer ? 'player' : 'npc'}`;
        marker.appendChild(outline);
        
        // Create info panel
        const info = document.createElement('div');
        info.className = `entity-info ${entity.isPlayer ? 'player' : 'npc'}`;
        
        // Distance indicator
        const distance = document.createElement('div');
        distance.className = 'distance-indicator';
        distance.textContent = `${entity.distance.toFixed(1)}m`;
        info.appendChild(distance);
        
        // Header
        const header = document.createElement('div');
        header.className = `info-header ${entity.isPlayer ? 'player' : 'npc'}`;
        header.textContent = entity.isPlayer ? 'PLAYER' : 'CIVILIAN';
        info.appendChild(header);
        
        // Name
        const nameRow = document.createElement('div');
        nameRow.className = 'info-row';
        nameRow.innerHTML = `
            <span class="info-label">Name:</span>
            <span class="info-value">${entityData.name}</span>
        `;
        info.appendChild(nameRow);
        
        // Job/Occupation
        const jobRow = document.createElement('div');
        jobRow.className = 'info-row';
        jobRow.innerHTML = `
            <span class="info-label">${entity.isPlayer ? 'Job' : 'Occupation'}:</span>
            <span class="info-value">${entity.isPlayer ? entityData.job : entityData.occupation}</span>
        `;
        info.appendChild(jobRow);
        
        // Gang (if applicable)
        if (entityData.gang && entityData.gang !== 'None') {
            const gangRow = document.createElement('div');
            gangRow.className = 'info-row';
            gangRow.innerHTML = `
                <span class="info-label">Gang:</span>
                <span class="info-value" style="color: #ff4444;">${entityData.gang}</span>
            `;
            info.appendChild(gangRow);
        }
        
        // Threat level (for NPCs)
        if (!entity.isPlayer) {
            const threatRow = document.createElement('div');
            threatRow.className = 'info-row';
            const threatColor = entityData.threat === 'HIGH' ? '#ff4444' : (entityData.threat === 'MEDIUM' ? '#ffaa00' : '#44ff44');
            threatRow.innerHTML = `
                <span class="info-label">Threat:</span>
                <span class="info-value" style="color: ${threatColor};">${entityData.threat}</span>
            `;
            info.appendChild(threatRow);
        }
        
        // Health
        const healthRow = document.createElement('div');
        healthRow.className = 'info-row';
        healthRow.innerHTML = `
            <span class="info-label">Health:</span>
            <span class="info-value">${entity.health}%</span>
        `;
        info.appendChild(healthRow);
        
        // Health bar
        const healthBar = document.createElement('div');
        healthBar.className = 'health-bar';
        const healthFill = document.createElement('div');
        healthFill.className = 'health-bar-fill';
        healthFill.style.width = `${entity.health}%`;
        healthBar.appendChild(healthFill);
        info.appendChild(healthBar);
        
        marker.appendChild(info);
        container.appendChild(marker);
    });
}

// Animation frame loop for smooth updates
let lastUpdate = 0;
function animationLoop(timestamp) {
    if (overlayActive && timestamp - lastUpdate > 100) {
        // Trigger update from Lua side
        fetch(`https://${GetParentResourceName()}/requestUpdate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
        lastUpdate = timestamp;
    }
    
    requestAnimationFrame(animationLoop);
}

requestAnimationFrame(animationLoop);
