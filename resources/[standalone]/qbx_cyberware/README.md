# Qbx Cyberware - Experimental Implants System

A lore-friendly cyberware/implant system for Qbox Framework servers. Features experimental medical implants that enhance player capabilities.

## Features

### Phase 1 Implants

**Combat: Subdermal Armor**
- Passive 15% damage reduction
- Blue glow effect
- $100,000

**Mobility: Reinforced Tendons**
- Allows double jumping
- Enhanced jump height
- Green glow effect
- $100,000

**Sensory: Kiroshi Optics**
- Scan nearby players (U key)
- Shows name, job, health
- 5 second cooldown
- Gold glow effect
- $100,000

**Nervous System: Adrenaline Booster**
- Activate for 30s boost (Y key)
- +30% movement speed
- +20% damage
- 10 minute cooldown
- Red glow effect
- $100,000

## Installation

1. **Database**: Run `sql/cyberware.sql` on your database
2. **Items**: Items already added to `qs-inventory/shared/items.lua`
3. **Images**: Add placeholder images to `qs-inventory/html/images/`:
   - `implant_subdermal.png`
   - `implant_tendons.png`
   - `implant_kiroshi.png`
   - `implant_adrenaline.png`
4. **Start**: Add `ensure qbx_cyberware` to your `server.cfg`
5. **Shop**: Configure ripperdoc shop in qs-advancedshops (see below)

## Ripperdoc Shop Setup

Add to qs-advancedshops config:

```lua
{
    name = 'Experimental Implants Lab',
    coords = vector3(3612.43, 3632.86, 43.78),
    ped = {
        model = 's_m_m_scientist_01',
        coords = vector4(3612.43, 3632.86, 43.78, 81.03),
    },
    blip = {
        enabled = true,
        sprite = 403,
        color = 3,
        label = 'Experimental Implants',
    },
    items = {
        {item = 'implant_subdermal', price = 100000},
        {item = 'implant_tendons', price = 100000},
        {item = 'implant_kiroshi', price = 100000},
        {item = 'implant_adrenaline', price = 100000},
    },
}
```

## Usage

**Installing Implants:**
1. Purchase implant at Ripperdoc shop
2. Use the implant item from inventory
3. Wait for installation (15 seconds)
4. Implant is now active

**Removing Implants:**
- Use `/removeimplant [implant_id]` command (admin only)
- Returns item to inventory

**Using Active Implants:**
- **Kiroshi Optics**: Press U to scan nearest player
- **Adrenaline Boost**: Press Y to activate 30s boost

**Passive Implants:**
- Subdermal Armor: Always reduces damage
- Reinforced Tendons: Always allows double jump

## Configuration

Edit `config/shared.lua`:

```lua
Config.MaxImplants = 4 -- Max implants per player
Config.RemovalReturnsItem = true -- Get item back when removing
Config.Keybinds.kiroshi_scan = 'U' -- Scan key
Config.Keybinds.adrenaline_boost = 'Y' -- Boost key
```

## Compatibility

- **Framework**: Qbox (qbx_core)
- **Inventory**: qs-inventory
- **Required**: ox_lib, oxmysql

## Future Phases

Phase 2 will add:
- Mantis Blades (melee weapon)
- Gorilla Arms (melee damage boost)
- Kerenzikov (slow-mo dash)
- Neural Link (hacking enhancement)
- Humanity/Cyberpsychosis system
- Power/Battery system
- Full cyberpunk UI

## Credits

Created for Nightlife RP
Built on Qbox Framework
