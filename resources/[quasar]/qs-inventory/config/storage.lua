--──────────────────────────────────────────────────────────────────────────────
-- Container / Storage Items                                                  [CORE]
-- [INFO] Define items that behave as containers (mini-inventories).
-- [EDIT] Each entry sets capacity, slot count, and default contents.
-- [TIP]  Weight must be lower than parent item weight to prevent nesting.
--──────────────────────────────────────────────────────────────────────────────

Config.Storage = {
    [1] = {
        name   = "cigarettebox",  -- [EDIT] Container item name.
        label  = "Cigarette Box", -- [EDIT] Display label in inventory.
        weight = 50,              -- [EDIT] Max weight this container can hold.
        slots  = 1,               -- [EDIT] Slot count inside container.
        items  = {
            [1] = {
                name        = "cigarette",
                label       = "Cigarette",
                description = "A single cigarette",
                useable     = true,
                type        = "item",
                amount      = 20,
                weight      = 1,
                unique      = false,
                slot        = 1,
                info        = {},
            },
            -- Add more items here.
        }
    },
    -- Add more storage containers here.
}
