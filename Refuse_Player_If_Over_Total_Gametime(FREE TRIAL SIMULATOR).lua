-- CONFIGURATION
local MAX_ACCOUNT_PLAYTIME_SECONDS = 600  -- 10 minutes
local LOGOUT_DELAY_MS = 1000              -- 1 second delay for safe logout

local kickedAccounts = {}

-- Helper: Get total account playtime for this account
local function GetTotalAccountPlayTime(accountId)
    local total = 0
    local result = CharDBQuery("SELECT totaltime FROM characters WHERE account = " .. accountId)
    if result then
        repeat
            total = total + result:GetUInt32(0)
        until not result:NextRow()
    end
    return total
end

-- On player login
local function OnLogin(event, player)
    local accountId = player:GetAccountId()
    if kickedAccounts[accountId] then return end

    local totalTime = GetTotalAccountPlayTime(accountId)
    if totalTime >= MAX_ACCOUNT_PLAYTIME_SECONDS then
        -- Defer logout safely
        local guid = player:GetGUID()
        kickedAccounts[accountId] = true

        CreateLuaEvent(function()
            local p = GetPlayerByGUID(guid)
            if p and p:IsInWorld() then
                p:SendBroadcastMessage("You have reached your account's playtime limit. Logging out...")
                p:LogoutPlayer()  -- Send to character screen safely
            end
        end, LOGOUT_DELAY_MS, 1)
    end
end

local function OnLogout(event, player)
    local accountId = player:GetAccountId()
    kickedAccounts[accountId] = nil
end

-- Register Events
RegisterPlayerEvent(3, OnLogin)   -- PLAYER_EVENT_ON_LOGIN
RegisterPlayerEvent(4, OnLogout)  -- PLAYER_EVENT_ON_LOGOUT
