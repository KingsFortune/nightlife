local config = require 'config.shared'
local activeVisuals = {}

-- Simple particle/glow effect simulation
-- Note: For proper glowing effects, you'd need custom models/textures
-- This provides a basic visual feedback system

-- Apply visual effects for an implant
RegisterNetEvent('qbx_cyberware:client:applyVisuals', function(implantId)
    local implant = config.Implants[implantId]
    if not implant or not implant.visual or not implant.visual.enabled then return end
    
    -- Store that this implant has visuals active
    activeVisuals[implantId] = true
    
    -- Visual feedback based on implant type
    local color = implant.visual.color
    local notifyColor = string.format('rgb(%d, %d, %d)', color.r, color.g, color.b)
    
    -- Notify player with colored message
    exports.qbx_core:Notify(
        string.format('💠 %s: Active', implant.label),
        'success',
        3000
    )
    
    print(string.format('^2[Cyberware]^7 Visual effect applied for: %s (Color: R%d G%d B%d)', 
        implant.label, color.r, color.g, color.b))
end)

-- Remove visual effects for an implant
RegisterNetEvent('qbx_cyberware:client:removeVisuals', function(implantId)
    local implant = config.Implants[implantId]
    if not implant then return end
    
    activeVisuals[implantId] = nil
    
    exports.qbx_core:Notify(
        string.format('💠 %s: Deactivated', implant.label),
        'inform',
        3000
    )
    
    print(string.format('^3[Cyberware]^7 Visual effect removed for: %s', implant.label))
end)

-- Visual indicator thread (optional ambient effects)
CreateThread(function()
    while true do
        Wait(1000)
        
        if next(activeVisuals) then
            -- Could add ambient effects here like:
            -- - Screen edge glow
            -- - HUD markers
            -- - Particle effects
            -- For now, just maintaining state
        else
            Wait(5000)
        end
    end
end)

-- Export to check if implant has active visuals
exports('HasActiveVisual', function(implantId)
    return activeVisuals[implantId] == true
end)

print('^2[qbx_cyberware]^7 Visual effects system loaded')
