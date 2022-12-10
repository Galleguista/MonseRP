local status = nil
Citizen.CreateThread(function()
    local s = 500
    while true do
        Citizen.Wait(s)

            o2 = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10

        TriggerEvent('esx_status:getStatus', 'hunger', function(status) comida = status.val / 10000 end)
       
        TriggerEvent('esx_status:getStatus', 'thirst', function(status) bebida = status.val / 10000 end)

        SendNUIMessage({
            health = GetEntityHealth(PlayerPedId()) - 100,
            armor = GetPedArmour(PlayerPedId()),
            stamina = 99 - GetPlayerSprintStaminaRemaining(PlayerId()),
            bebida = bebida;
            comida = comida;
        })


        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            Wait(s)
            DisplayRadar(true)
        else
            Wait(s)
            DisplayRadar(false)
            
        end
    end
end)




