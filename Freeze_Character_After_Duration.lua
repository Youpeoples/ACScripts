-- CONFIGURATION
local PARALYZE_SPELL_ID = 9454       
local DELAY_SECONDS = 10              -- Configurable delay in seconds
local MESSAGE = "Time is up for you"  -- System message to send before paralyze

-- INTERNAL STORAGE
local playerTimers = {}

-- On player login
local function OnLogin(event, player)
    local guid = player:GetGUID()
    if playerTimers[guid] then return end -- Already scheduled

    playerTimers[guid] = true

    -- Schedule the delayed action using the player's GUID
    CreateLuaEvent(function()
        local p = GetPlayerByGUID(guid)
        if p and p:IsInWorld() then
            p:SendBroadcastMessage(MESSAGE)
            p:CastSpell(p, PARALYZE_SPELL_ID, true)
        end
        playerTimers[guid] = nil -- Cleanup whether valid or not
    end, DELAY_SECONDS * 1000, 1)
end

-- On player logout
local function OnLogout(event, player)
    local guid = player:GetGUID()
    playerTimers[guid] = nil
end

-- Register Events
RegisterPlayerEvent(3, OnLogin)   -- PLAYER_EVENT_ON_LOGIN
RegisterPlayerEvent(4, OnLogout)  -- PLAYER_EVENT_ON_LOGOUT
