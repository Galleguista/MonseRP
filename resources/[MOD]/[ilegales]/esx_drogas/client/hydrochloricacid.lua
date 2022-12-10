local spawnedHydrochloricAcidBarrels = 0
local HydrochloricAcidBarrels = {}

Citizen.CreateThread(function()
	local s = 1000
	while true do
		Citizen.Wait(15)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.HydrochloricAcidFarm.coords, true) < 50 then
			SpawnHydrochloricAcidBarrels()
			Citizen.Wait(s)
		else
			Citizen.Wait(s)
		end
	end
end)

Citizen.CreateThread(function()
	local s = 1000
	while true do
		Citizen.Wait(15)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #HydrochloricAcidBarrels, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(HydrochloricAcidBarrels[i]), false) < 1 then
				nearbyObject, nearbyID = HydrochloricAcidBarrels[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowFloatingHelpNotification("Pulsa [E] para recoger ácido clorhídrico del bote", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if isAllowedDrug('hydrochloricacid') then
					if Config.RequireCopsOnline then
						ESX.TriggerServerCallback('sapo_drogas:EnoughCops', function(cb)
							if cb then
								PickUpHydrochloricAcid(playerPed, coords, nearbyObject, nearbyID)
							else
								ESX.ShowNotification(_U('cops_notenough'))
							end
						end, Config.Cops.Meth)
					else
						PickUpHydrochloricAcid(playerPed, coords, nearbyObject, nearbyID)
					end
				else
					ESX.ShowNotification("No tienes la suficiente habilidad para realizar esta acción")
				end
			end

		else
			Citizen.Wait(500)
		end

	end

end)

function PickUpHydrochloricAcid(playerPed, coords, nearbyObject, nearbyID)
	isPickingUp = true

	ESX.TriggerServerCallback('sapo_drogas:canPickUp', function(canPickUp)

		if canPickUp then
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			Citizen.Wait(2000)
			ClearPedTasks(playerPed)
			Citizen.Wait(1500)

			ESX.Game.DeleteObject(nearbyObject)

			table.remove(HydrochloricAcidBarrels, nearbyID)

			TriggerServerEvent('sapo_drogas:pickedUpHydrochloricAcid')
			Citizen.Wait(5000)
			spawnedHydrochloricAcidBarrels = spawnedHydrochloricAcidBarrels - 1
		else
			ESX.ShowNotification(_U('HydrochloricAcid_inventoryfull'))
		end

		isPickingUp = false

	end, 'hydrochloric_acid')
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(HydrochloricAcidBarrels) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnHydrochloricAcidBarrels()
	while spawnedHydrochloricAcidBarrels < 5 do
		Citizen.Wait(0)
		local weedCoords = GenerateHydrochloricAcidCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_01a', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(HydrochloricAcidBarrels, obj)
			spawnedHydrochloricAcidBarrels = spawnedHydrochloricAcidBarrels + 1
		end)
	end
end

function ValidateHydrochloricAcidCoord(plantCoord)
	if spawnedHydrochloricAcidBarrels > 0 then
		local validate = true

		for k, v in pairs(HydrochloricAcidBarrels) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.HydrochloricAcidFarm.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateHydrochloricAcidCoords()
	while true do
		Citizen.Wait(1)

		local weed2CoordX, weed2CoordY

		math.randomseed(GetGameTimer())
		local modX2 = math.random(-7, 7)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY2 = math.random(-7, 7)

		weed2CoordX = Config.CircleZones.HydrochloricAcidFarm.coords.x + modX2
		weed2CoordY = Config.CircleZones.HydrochloricAcidFarm.coords.y + modY2

		local coordZ2 = GetCoordZHydrochloricAcid(weed2CoordX, weed2CoordY)
		local coord2 = vector3(weed2CoordX, weed2CoordY, coordZ2)

		if ValidateHydrochloricAcidCoord(coord2) then
			return coord2
		end
	end
end

function GetCoordZHydrochloricAcid(x, y)
	local groundCheckHeights = { 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0 }

	for i, height in ipairs(groundCheckHeights) do
		local found2Ground, z = GetGroundZFor_3dCoord(x, y, height)

		if found2Ground then
			return z
		end
	end

	return 24.5
end