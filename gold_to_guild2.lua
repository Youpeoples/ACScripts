
local percentage = 0.1  -- 1.0 = 100%

local function DepositLootedGoldToGuild(event, player, amount)
    -- Check if the player is in a guild
    local guild = player:GetGuild()
    if not guild then
        return
    end

    -- Retrieve the amount of gold looted
    local lootedGold = amount

    -- Calculate 10% of the looted gold
    local depositAmount = math.floor(lootedGold * percentage)

    -- Ensure the player has enough gold
    if player:GetCoinage() >= depositAmount then
        -- Deposit the gold into the guild bank
        guild:ModifyBankMoney(depositAmount)
        -- Remove the same amount from the player's inventory
        player:ModifyMoney(-depositAmount)
        -- Optionally, notify the player
        player:SendBroadcastMessage("Deposited and removed " .. depositAmount / 10000 .. " gold. The Guild Thanks you.")
    else
        -- Notify the player if they don't have enough gold
        player:SendBroadcastMessage("Insufficient funds to deposit into the guild bank.")
    end
end

-- Register the event
RegisterPlayerEvent(37, DepositLootedGoldToGuild)