-- Extend duration to 60 minutes (in milliseconds)
local EXTENDED_DURATION = 60
local MATHED_DURATION = EXTENDED_DURATION * 60 * 1000
-- All Blessing Spell IDs
local ALL_BLESSING_IDS = {
    -- Blessing of Might
    [19740] = true, [19834] = true, [19835] = true, [19836] = true,
    [19837] = true, [19838] = true, [25291] = true, [27140] = true,
    [48931] = true, [48932] = true,
    -- Greater Blessing of Might
    [25782] = true, [25916] = true, [27141] = true, [48933] = true, [48934] = true,
    -- Blessing of Wisdom
    [19742] = true, [19850] = true, [19852] = true, [19853] = true,
    [19854] = true, [25290] = true, [27142] = true, [48935] = true, [48936] = true,
    -- Greater Blessing of Wisdom
    [25894] = true, [25918] = true, [27143] = true, [48937] = true, [48938] = true,
    -- Blessing of Kings
    [20217] = true,
    -- Greater Blessing of Kings
    [25898] = true,
    -- Blessing of Sanctuary
    [20911] = true,
    -- Greater Blessing of Sanctuary
    [25899] = true,
}

-- Track which buffs have been extended per player
local extendedBuffs = {}

local function CheckAndRefreshBlessings(eventId, delay, repeats, player)
    local playerGUID = player:GetGUIDLow()
    extendedBuffs[playerGUID] = extendedBuffs[playerGUID] or {}

    for spellId, _ in pairs(ALL_BLESSING_IDS) do
        local aura = player:GetAura(spellId)

        -- If blessing is present and not yet extended
        if aura and not extendedBuffs[playerGUID][spellId] then
            local caster = aura:GetCaster()
            if caster then
                player:RemoveAura(spellId)
                local newAura = player:AddAura(spellId, caster)
                if newAura then
                    newAura:SetDuration(MATHED_DURATION)
                    extendedBuffs[playerGUID][spellId] = true
                end
            end

        -- If blessing is gone but was marked extended — clear it
        elseif not aura and extendedBuffs[playerGUID][spellId] then
            extendedBuffs[playerGUID][spellId] = nil
        end
    end
end

-- Checking every 2 seconds for the apperance of a new buff
RegisterPlayerEvent(3, function(event, player)
    player:RegisterEvent(CheckAndRefreshBlessings, 2000, 0)
end)

-- Clean up on logout
RegisterPlayerEvent(4, function(event, player)
    player:RemoveEvents()
    extendedBuffs[player:GetGUIDLow()] = nil
end)
