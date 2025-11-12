// Random name generator for NPCs
const firstNames = ['John', 'Jane', 'Michael', 'Sarah', 'Robert', 'Lisa', 'David', 'Emily', 'James', 'Emma', 'William', 'Olivia', 'Richard', 'Sophia', 'Joseph', 'Ava', 'Thomas', 'Isabella', 'Charles', 'Mia', 'Daniel', 'Charlotte', 'Matthew', 'Amelia', 'Anthony', 'Harper', 'Mark', 'Evelyn', 'Donald', 'Abigail', 'Steven', 'Elizabeth'];
const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris', 'Clark', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen', 'King', 'Wright'];
const occupations = ['Mechanic', 'Taxi Driver', 'Security Guard', 'Store Clerk', 'Bartender', 'Chef', 'Delivery Driver', 'Construction Worker', 'Office Worker', 'Accountant', 'Lawyer', 'Doctor', 'Nurse', 'Teacher', 'Engineer', 'Programmer', 'Artist', 'Musician', 'Journalist', 'Photographer', 'Fitness Trainer', 'Real Estate Agent', 'Sales Rep', 'Waiter', 'Janitor', 'Unemployed'];
const gangs = ['None', 'None', 'None', 'None', 'None', 'Ballas', 'Vagos', 'Families', 'Marabunta', 'Triads', 'Lost MC', 'Street Thugs'];

function generateNPCData(entityId) {
    return {
        name: `${firstNames[Math.floor(Math.random() * firstNames.length)]} ${lastNames[Math.floor(Math.random() * lastNames.length)]}`,
        occupation: occupations[Math.floor(Math.random() * occupations.length)],
        gang: gangs[Math.floor(Math.random() * gangs.length)],
        threat: Math.random() > 0.7 ? 'HIGH' : (Math.random() > 0.4 ? 'MEDIUM' : 'LOW')
    };
}

let entityDataCache = {};
let overlayActive = false;
let entities = [];

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'show') {
        overlayActive = true;
        document.getElementById('kiroshi-overlay').classList.add('active');
        console.log('[KIROSHI NUI] Overlay activated');
    } else if (data.action === 'hide') {
        overlayActive = false;
        document.getElementById('kiroshi-overlay').classList.remove('active');
        document.getElementById('entity-markers').innerHTML = '';
        // DON'T clear entityDataCache - keep persistent data between scans
        console.log('[KIROSHI NUI] Overlay deactivated (data persists)');
    } else if (data.action === 'clearCache') {
        // Only clear cache when explicitly requested
        entityDataCache = {};
        console.log('[KIROSHI NUI] Cache cleared');
    } else if (data.action === 'updateEntities') {
        entities = data.entities || [];
        updateMarkers();
    }
});

function updateMarkers() {
    const container = document.getElementById('entity-markers');
    container.innerHTML = '';
    
    entities.forEach(entity => {
        if (!entityDataCache[entity.id]) {
            entityDataCache[entity.id] = entity.isPlayer ? {
                name: entity.name || 'Unknown',
                job: entity.job || 'Civilian',
                gang: entity.gang || 'None',
                threat: 'LOW'
            } : generateNPCData(entity.id);
        }
        
        const entityData = entityDataCache[entity.id];
        const entityType = entity.isPlayer ? 'player' : 'npc';
        
        // Create wrapper - positioned at exact pixel coordinates
        const wrapper = document.createElement('div');
        wrapper.className = 'entity-wrapper';
        wrapper.style.position = 'absolute';
        wrapper.style.left = entity.x + 'px';
        wrapper.style.top = entity.y + 'px';
        wrapper.style.transform = 'translate(-50%, -100%)'; // Center horizontally, position above
        
        // Create info panel only (no CSS outline, using game rendering)
        const info = document.createElement('div');
        info.className = `entity-info ${entityType}`;
        info.innerHTML = `
            <div class="distance-indicator">${entity.distance.toFixed(1)}m</div>
            <div class="info-header ${entityType}">${entity.isPlayer ? '◆ PLAYER ◆' : '◆ CIVILIAN ◆'}</div>
            <div class="info-row"><span class="info-label">ID:</span><span class="info-value">${entityData.name}</span></div>
            <div class="info-row"><span class="info-label">${entity.isPlayer ? 'JOB' : 'OCC'}:</span><span class="info-value">${entity.isPlayer ? entityData.job : entityData.occupation}</span></div>
            ${entityData.gang !== 'None' ? `<div class="info-row"><span class="info-label">GANG:</span><span class="info-value" style="color:#ff4444">${entityData.gang}</span></div>` : ''}
            ${!entity.isPlayer ? `<div class="info-row"><span class="info-label">THREAT:</span><span class="info-value" style="color:${entityData.threat === 'HIGH' ? '#ff4444' : (entityData.threat === 'MEDIUM' ? '#ffaa00' : '#44ff44')}">${entityData.threat}</span></div>` : ''}
            <div class="info-row"><span class="info-label">HP:</span><span class="info-value">${entity.health}%</span></div>
            <div class="health-bar"><div class="health-bar-fill" style="width:${entity.health}%;background-position:${100-entity.health}% 0"></div></div>
        `;
        
        wrapper.appendChild(info);
        container.appendChild(wrapper);
    });
}

RegisterNUICallback('requestUpdate', (data, cb) => cb('ok'));
