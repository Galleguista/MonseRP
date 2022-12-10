-- change all these functions to the one your framework uses, default is esx :)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

addMoney = function(src, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addMoney(amount)
end

getCops = function()
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    return cops
end