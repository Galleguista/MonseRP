ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local currSpeed = 0.0
local blackoutVariable = false
local sBuffer  	  = {}
local vBuffer  	  = {}  
local vehicleCruiser
local compass = true
local logActivate = true
local seatbeltEjectSpeed = 45.0 
local seatbeltEjectAccel = 100.0
local seatbeltIsOn = false

Citizen.CreateThread(function()
    while true do
    local msec = 1500
    local ped = PlayerPedId()
    local isInCoche = IsPedInAnyVehicle(ped)


        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehicleSpeedSource = GetEntitySpeed(vehicle)
            local vehicleSpeed = math.ceil(vehicleSpeedSource * 3.6)
            local vehiclemodel = GetEntityModel(vehicle)
            local position = GetEntityCoords(ped)
            local vehicleClass = GetVehicleClass(vehicle)

            if vehicleClass ~= 8 and vehicleClass ~= 16 and vehicleClass ~= 15 and vehicleClass ~= 13 then
                local prevSpeed = currSpeed
                currSpeed = vehicleSpeedSource
                SetPedConfigFlag(PlayerPedId(), 32, true)
                if not seatbeltIsOn then
                    local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                        SetEntityCoords(ped, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(ped, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                    else
                        -- Update previous velocity for ejecting player
                        prevVelocity = GetEntityVelocity(vehicle)
                    end
                else
                    DisableControlAction(0, 75)
                end
            end

        msec = 5

            local coche = GetVehiclePedIsIn(ped, false)
            local fLevel = GetVehicleFuelLevel(coche)
            local marcha = GetVehicleCurrentGear(coche)
            local rpm1 = GetVehicleCurrentRpm(coche)
            local rpm = math.ceil(rpm1 * 90, 1)
            local vehSpeed = GetEntitySpeed(coche)
            local speed = math.ceil(vehSpeed * 3.6)
            local vida = (GetVehicleEngineHealth(coche) / 10)

            SendNUIMessage({
                isInCoche = isInCoche;
                speed = speed;
                fuel = fLevel;
                marcha = marcha;
                seatbelt = seatbeltIsOn;
                rpm = rpm;
            });
        else
            Citizen.Wait(5)
            SendNUIMessage({
                isInCoche = false;
            });
        end
    Citizen.Wait(msec)
    end
end)

RegisterKeyMapping("PonerCinto", "Ponte el cinturon", "keyboard", "B")

RegisterCommand("PonerCinto", function(source)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicleClass = GetVehicleClass(vehicle)
    local vehiclemodel = GetEntityModel(vehicle)
    if vehicleClass ~= 8 and vehicleClass ~= 16 and vehicleClass ~= 15 and vehicleClass ~= 13 and GetDisplayNameFromVehicleModel(vehiclemodel) ~= "moto1" then
        if IsPedInAnyVehicle(playerPed, false) and GetIsVehicleEngineRunning(vehicle) then
            seatbeltIsOn = not seatbeltIsOn
            if seatbeltIsOn == true then
                ESX.ShowNotification("Te has puesto el cinturón")
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.2, "cinturonPuesto", 0.5)
            elseif seatbeltIsOn == false then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.2, "cinturonQuitado", 0.5)
                ESX.ShowNotification("Te has quitado el cinturón")
            end
        end
    else
        return
    end
end)