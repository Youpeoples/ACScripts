-- Configurable speed multiplier (1.0 = 100%, 2.0 = 200%, etc.)
local SPEED_MULTIPLIER = 2.5 
local CHECK_INTERVAL = 2000 
-- Movement types
local MOVE_WALK = 0
local MOVE_RUN = 1
-- Track players with speed boost applied
local boostedPlayers = {}

local function UpdateSpeed(eventId, delay, repeats, player)
    if not player or not player:IsInWorld() then return end

    local guid = player:GetGUIDLow()
    local isMounted = player:IsMounted()

    if isMounted and not boostedPlayers[guid] then
        player:SetSpeed(MOVE_RUN, SPEED_MULTIPLIER, true)
        boostedPlayers[guid] = true
        player:SendBroadcastMessage("|cff00ff00[Mount Boost]|r Extra mount speed applied!")
    elseif not isMounted and boostedPlayers[guid] then
        player:SetSpeed(MOVE_RUN, 1.0, true)
        boostedPlayers[guid] = nil
        player:SendBroadcastMessage("|cffff0000[Mount Boost]|r Extra mount speed removed.")
    end
end

local function OnLogin(event, player)
    player:RegisterEvent(UpdateSpeed, CHECK_INTERVAL, 0)
end

local function OnLogout(event, player)
    player:RemoveEvents()
    boostedPlayers[player:GetGUIDLow()] = nil
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
