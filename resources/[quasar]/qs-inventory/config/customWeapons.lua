--[[────────────────────────────────────────────────────────────────────────────
  Custom Weapons Configuration                                                 [EDIT]
  [INFO] Define additional weapons not present in GTA V’s base arsenal. Each
         entry maps to a unique weapon hash name and specifies its attachments
         and durability rate. Be sure to register the weapon properly in your
         `items.lua` and `weapons.lua`.

  Requirements:
  • Each key must match the internal weapon hash (e.g., 'WEAPON_AK47').         [REQ]
  • Every attachment must include both a valid component and corresponding item. [REQ]
  • Durability defines wear rate (higher = faster degradation).                 [INFO]
  • For reference examples:                                                     [TIP]
    https://github.com/NoobySloth/Custom-Weapons/tree/main

  Fields per weapon:
  • attachments – Defines all available attachments (e.g., clips, scopes).      [EDIT]
  • durability  – Numeric value controlling durability consumption speed.       [EDIT]
────────────────────────────────────────────────────────────────────────────]]

Config.CustomWeapons = {
    -- Example structure ------------------------------------------------------ [TIP]
    -- ['WEAPON_AK47'] = {
    --     attachments = {
    --         defaultclip  = { component = 'COMPONENT_AK47_CLIP_01', item = 'rifle_defaultclip' },
    --         extendedclip = { component = 'COMPONENT_AK47_CLIP_02', item = 'rifle_extendedclip' },
    --         suppressor   = { component = 'COMPONENT_AT_AR_SUPP',    item = 'rifle_suppressor' },
    --         scope        = { component = 'COMPONENT_AT_SCOPE_MEDIUM', item = 'rifle_largescope' },
    --     },
    --     durability = 0.15, -- [EDIT] Durability rate for this weapon
    -- },
}
