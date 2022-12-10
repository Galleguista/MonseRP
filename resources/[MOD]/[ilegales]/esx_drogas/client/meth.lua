local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	local s = 1000
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MethProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa [E] para procesar la mentanfetamina", vector3(coords.x, coords.y, coords.z + 1))
			end

			s = 30
			if IsControlJustReleased(0, 35) and not isProcessing then
				if isAllowedDrug('meth') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('sapo_drogas:EnoughCops', function(cb)
								if cb then
									ProcessMeth()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.Meth)
						else
							ProcessMeth()
						end
					else
						ESX.ShowNotification(_U('need_on_foot'))
					end
				else
					ESX.ShowNotification("No tienes la suficiente habilidad para realizar esta acción")
				end
			end
		else
			Citizen.Wait(s)
		end
	end
end)

function ProcessMeth()
	isProcessing = true

	ESX.ShowNotification(_U('meth_processingstarted'))
	TriggerServerEvent('sapo_drogas:processMeth')
	local timeLeft = Config.Delays.MethProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MethProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('meth_processingtoofar'))
			TriggerServerEvent('sapo_drogas:cancelProcessing')
			break
		end
	end

	isProcessing = false
end