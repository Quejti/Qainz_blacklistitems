ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CheckPlayerInventory(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        print("[BLACKLIST] Player ID not found:", playerId)
        return
    end

    for _, itemName in ipairs(Config.BlacklistItems) do
        local itemCount = xPlayer.getInventoryItem(itemName).count

        if itemCount > 0 then
            xPlayer.removeInventoryItem(itemName, itemCount)
            print(("[BLACKLIST] Removed %d x %s from the player %s"):format(itemCount, itemName, xPlayer.getName()))
            
            TriggerClientEvent('chat:addMessage', playerId, {
                args = {"SYSTEM", "Illegal items have been removed from your inventory!"},
                color = {255, 0, 0}
            })
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            CheckPlayerInventory(playerId)
        end
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = source
    Citizen.Wait(5000)
    CheckPlayerInventory(playerId)
end)
