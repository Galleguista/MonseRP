local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local PlayerData              = {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy, deadPlayers, deadPlayerBlips, isOnDuty = false, {}, {}, false
isInShopMenu = false

function OpenAmbulanceActionsMenuA()
	local elements = {{label = _U('cloakroom'), value = 'cloakroom'}}
	table.insert(elements,  {label = _U('vestimentas'), value = 'vestimentas_usuario'})
	table.insert(elements, {label = _U('deposit_object'),  value = 'put_stock'})
    table.insert(elements, {label = _U('remove_object'), value = 'get_stock'})
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = 'Vestuario',
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenuA()
		elseif data.current.value == 'put_stock' then
            OpenPutStocksMenuA()
        elseif data.current.value == 'get_stock' then
            OpenGetStocksMenuA()
		elseif data.current.value == 'vestimentas_usuario' then
			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}
				for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
				end
	
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = 'Tus vestimentas',
					align    = 'right',
					elements = elements,
				}, function(data, menu)
	
					TriggerEvent('skinchanger:getSkin', function(skin)
	
					ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)
	
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)
	
						TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
						end)
						
						ESX.ShowNotification(_U'puesta_vestimenta')
						HasLoadCloth = true
					end, data.current.value)
					end)
				end, function(data, menu)
					menu.close()
					
				end)
			end)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenuA()
	ESX.TriggerServerCallback('sapo_masterjob_ambulance:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			if data.current.type == 'item_weapon' then
				TriggerServerEvent('sapo_masterjob_ambulance:putStockItems', data.current.type, data.current.value, data.current.ammo)
				menu.close()
				
				ESX.SetTimeout(300, function()
					OpenPutStocksMenuA()
				end)
			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = _U('quantity')
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else

						TriggerServerEvent('sapo_masterjob_ambulance:putStockItems', data.current.type, data.current.value, count)
						menu2.close()
						menu.close()
						

						Citizen.Wait(500)
						OpenPutStocksMenuA()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBossActionsMenuA()
	local elements = {
	--	{label = _U('cloakroom'), value = 'cloakroom'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenuA()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenuA()
	ESX.TriggerServerCallback('sapo_masterjob_ambulance:showStockItems', function(inventory)
		local elements = {}
		local menutitle = _U('ambulance_armario')

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = menutitle,
			align    = 'right',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()

				TriggerServerEvent('sapo_masterjob_ambulance:getStockItem', data.current.type, data.current.value, data.current.ammo)
				ESX.SetTimeout(300, function()
					OpenGetStocksMenuA()
				end)
			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = _U('quantity')
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('sapo_masterjob_ambulance:getStockItem', data.current.type, data.current.value, count)

						Citizen.Wait(500)
						OpenGetStocksMenuA()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, 'society_ambulance')
end

function OpenMobileAmbulanceActionsMenuA()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = {
			{label = 'menu de trabajo', value = 'citizen_interaction'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'right',
				elements = {
					{label = _U('revive_ambulance'), value = 'revive'},
					{label = _U('venda_peque'), value = 'small'},
					{label = _U('venda_grande'), value = 'big'},
					{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
					{label = _U('billing'), value = 'billing'}
			}}, function(data, menu)
				if isBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
				if data.current.value == 'search' then
					TriggerServerEvent('sapo_masterjob_ambulance:svsearch')
				elseif closestPlayer == -1 or closestDistance > 1.0 then
					ESX.ShowNotification(_U('no_players'))
				else
					if data.current.value == 'revive' then
						revivePlayerA(closestPlayer)
					elseif data.current.value == 'small' then
						ESX.TriggerServerCallback('sapo_masterjob_ambulance:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('sapo_masterjob_ambulance:removeItem', 'bandage')
									TriggerServerEvent('sapo_masterjob_ambulance:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									isBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('sapo_masterjob_ambulance:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('sapo_masterjob_ambulance:removeItem', 'medikit')
									TriggerServerEvent('sapo_masterjob_ambulance:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									isBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')
						
				    elseif data.current.value == 'billing' then

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
							title = _U('ems_menu')
						}, function(data, menu)
							local amount = tonumber(data.value)

							if amount == nil or amount < 0 then
								ESX.ShowNotification(_U('amount_invalid'))
							else
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								if closestPlayer == -1 or closestDistance > 3.0 then
									ESX.ShowNotification(_U('no_players'))
								else
									menu.close()
									TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', _U('ambulance'), amount)
								end
							end
						end, function(data, menu)
							menu.close()
						end)

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('sapo_masterjob_ambulance:putInVehicle', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function revivePlayerA(closestPlayer)
	isBusy = true

	ESX.TriggerServerCallback('sapo_masterjob_ambulance:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)

			if IsPedDeadOrDying(closestPlayerPed, 1) then
				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				ESX.ShowNotification(_U('revive_inprogress'))

				for i=1, 15 do
					Citizen.Wait(900)

					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end

				TriggerServerEvent('sapo_masterjob_ambulance:removeItem', 'medikit')
				TriggerServerEvent('sapo_masterjob_ambulance:revive', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification(_U('player_not_unconscious'))
			end
		else
			ESX.ShowNotification(_U('not_enough_medikit'))
		end
		isBusy = false
	end, 'medikit')
end

function FastTravelA(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

			for hospitalNum,hospital in pairs(Config.Hospitals) do
				-- Acciones de ambulancia
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
						end
					end
				end

				-- Farmacia
				for k,v in ipairs(hospital.Pharmacies) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
						end
					end
				end

				-- Vehículos
				for k,v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
						end
					end
				end

				-- Acciones de jefe
				for k,v in ipairs(hospital.BossActions) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)
	
					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false
					end
	
					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'BossActions', k
					end
				end

				-- Guardar coches
				for k,v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Delete)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Delete, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Guardar', k
						end
					end
				end

				-- Helicopteros
				for k,v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
						end
					end
				end

				-- Trasportes
				for k,v in ipairs(hospital.FastTravels) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)
	
					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false
					end
	
	
					if distance < v.Marker.x then
						FastTravelA(v.To.coords, v.To.heading)
					end
				end
	

				for k,v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Delete)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Delete1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.5, 7.5, 0.2, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Guardar1', k
						end
					end
				end
			end
			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('sapo_masterjob_ambulance:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('sapo_masterjob_ambulance:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('sapo_masterjob_ambulance:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler('sapo_masterjob_ambulance:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'AmbulanceActions' then
		CurrentAction = part
		CurrentActionData = {}
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionMsgCoords = vector3(301.59, -599.27, 42.32 + 1.3)
	elseif part == 'Pharmacy' then
		CurrentAction = part
		CurrentActionData = {}
		CurrentActionMsg = _U('abrir_farmacia')
		CurrentActionMsgCoords = vector3(309.57, -568.59, 42.30 + 1.3)
	elseif part == 'BossActions' then
		CurrentAction = part
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
		CurrentActionMsgCoords = vector3(334.92, -593.3, 43.32 + 0.2)
	elseif part == 'Vehicles' then
		CurrentAction = part
		CurrentActionData = {hospital = hospital, partNum = partNum}
		CurrentActionMsg = _U('abrir_garaje')
		CurrentActionMsgCoords = vector3(294.89, -601.05, 42.4 + 1.3)
	elseif part == 'Helicopters' then
		CurrentAction = part
		CurrentActionData = {hospital = hospital, partNum = partNum}
		CurrentActionMsg = _U('abrir_helipuerto')
		CurrentActionMsgCoords = vector3(338.52, -587.63, 73.17 + 1.3)
	elseif part == 'Guardar' then
		CurrentAction = part
		CurrentActionData = {hospital = hospital, partNum = partNum}
		CurrentActionMsg = _U('store_vehicle')
		CurrentActionMsgCoords = vector3(295.97, -607.05, 42.30 + 2)
	elseif part == 'Guardar1' then
		CurrentAction = part
		CurrentActionData = {hospital = hospital, partNum = partNum}
		CurrentActionMsg = _U('helicopter_delete')
		CurrentActionMsgCoords = vector3(351.19, -588.39, 73.06 + 2)
	end
end)

AddEventHandler('sapo_masterjob_ambulance:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowFloatingHelpNotification(CurrentActionMsg, CurrentActionMsgCoords)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenuA()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenuA()
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenuA()
				elseif CurrentAction == 'Helicopters' then
					OpenVHelicopterSpawnerMenuA()
				elseif CurrentAction == 'BossActions' then
					OpenBossActionsMenuA()
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravelA(CurrentActionData.to, CurrentActionData.heading)
				elseif CurrentAction == 'Guardar' then 
					DeleteJobVehicle()
				elseif CurrentAction == 'Guardar1' then 
					DeleteJobVehicle()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterKeyMapping("EAmbulanceMenu","Menu de EMS","keyboard","F6")

RegisterCommand("EAmbulanceMenu",function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		OpenMobileAmbulanceActionsMenuA()
	end
end)


RegisterNetEvent('sapo_masterjob_ambulance:putInVehicle')
AddEventHandler('sapo_masterjob_ambulance:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenuA()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('work_wear'), value = 'ambulance_wear'},
	}}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				isOnDuty = false

				for playerId,v in pairs(deadPlayerBlips) do
					RemoveBlip(v)
					deadPlayerBlips[playerId] = nil
				end
			end)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback(
				"esx_skin:getPlayerSkin",
				function(skin, jobSkin)
					OpenEUPClothesMenuA(masterJob, skin.sex)
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPharmacyMenuA()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'right',
		elements = {
			{label = _U('pharmacy_take', _U('medikit')), item = 'medikit', type = 'slider', value = 1, min = 1, max = 100},
			{label = _U('pharmacy_take', _U('bandage')), item = 'bandage', type = 'slider', value = 1, min = 1, max = 100},
       
	}}, function(data, menu)
		TriggerServerEvent('sapo_masterjob_ambulance:giveItem', data.current.item, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('sapo_masterjob_ambulance:heal')
AddEventHandler('sapo_masterjob_ambulance:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if isOnDuty and job ~= 'ambulance' then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		isOnDuty = false
	end
end)

RegisterNetEvent('sapo_masterjob_ambulance:setDeadPlayers')
AddEventHandler('sapo_masterjob_ambulance:setDeadPlayers', function(_deadPlayers)
	deadPlayers = _deadPlayers

	if isOnDuty then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		for playerId,status in pairs(deadPlayers) do
			if status == 'distress' then
				local player = GetPlayerFromServerId(playerId)
				local playerPed = GetPlayerPed(player)
				local blip = AddBlipForEntity(playerPed)

				SetBlipSprite(blip, 303)
				SetBlipColour(blip, 1)
				SetBlipFlashes(blip, true)
				SetBlipCategory(blip, 7)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('blip_dead'))
				EndTextCommandSetBlipName(blip)

				deadPlayerBlips[playerId] = blip
			end
		end
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OpenVehicleSpawnerMenuA()
    ESX.UI.Menu.CloseAll()

    local elements = {}

    local spanwCar = Config.SpawnPointsVehicles.coords
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
    {
        title = 'Garage',
        align = 'right',
        elements = Config.AuthorizedVehiclesA
    }, function(data, menu)
        if not ESX.Game.IsSpawnPointClear(
            Config.SpawnPointsVehicles.coords, Config.SpawnPointsVehicles.radius) then
            ESX.ShowNotification(_U('spawnpoint_blocked'))
            return
        end

        menu.close()
        ESX.Game.SpawnVehicle(data.current.model, Config.SpawnPointsVehicles.coords, Config.SpawnPointsVehicles.heading, function(vehicle)
            SetVehicleNumberPlateText(vehicle, "LSFD"..GetPlayerServerId(PlayerId()))   
            local playerPed = PlayerPedId()
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        end)

    end, function(data, menu)
        CurrentAction = 'vehicle_spawner'
        CurrentActionMsg = 'Garage'
        CurrentActionData = {}

        menu.close()
    end)
end


function OpenVHelicopterSpawnerMenuA()
    ESX.UI.Menu.CloseAll()

    local elements = {}
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
    {
        title = 'Garaje',
        align = 'right',
        elements = Config.AuthorizedHelicoptersA
    }, function(data, menu)
        if not ESX.Game.IsSpawnPointClear(
            Config.SpawnPointsHelicopters.coords, Config.SpawnPointsHelicopters.radius) then
            ESX.ShowNotification(_U('spawnpoint_blocked'))
            return
        end

        menu.close()
        ESX.Game.SpawnVehicle(data.current.model, Config.SpawnPointsHelicopters.coords, Config.SpawnPointsHelicopters.heading, function(vehicle)
            SetVehicleNumberPlateText(vehicle, "LSFD"..GetPlayerServerId(PlayerId()))   
            local playerPed = PlayerPedId()
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        end)

    end, function(data, menu)
        CurrentAction = 'vehicle_spawner'
        CurrentActionMsg = 'Garage'
        CurrentActionData = {}

        menu.close()
    end)
end



----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

function EUPCategoryAllowedA(masterJob, category)
	local category = Config.EUPOutFitsCategoriesA[category]
	if (category ~= nil) then
		for _, k in pairs(category.jobs) do
			if (k == masterJob) then
				return true
			end
		end
		return false
	end
	return true
end
function OpenEUPClothesMenuA(masterJob, sex)
	print(masterJob, sex)
	local elements = {}
	local categoryOutfits = {}
	masterJob = 'ambulance'
	for name, outfit in pairs(Config.EUPOutFitsA) do
		if not categoryOutfits[outfit.category] then
			categoryOutfits[outfit.category] = {}
		end
		if (sex == 0 and outfit.ped == "mp_m_freemode_01") or (sex == 1 and outfit.ped == "mp_f_freemode_01") then
			categoryOutfits[outfit.category][name] = outfit
		end
	end
	for _, categoryName in pairs(sortedKeysA(categoryOutfits)) do
		if (EUPCategoryAllowedA(masterJob, categoryName)) then
			table.insert(elements, {label = categoryName, value = categoryName})
		end
	end
	ESX.UI.Menu.Open(
		"default",
		GetCurrentResourceName(),
		"eupcategories",
		{
			title = "Ropa EUP",
			align = "right",
			elements = elements
		},
		function(data, menu)
			local elements2 = {}
			local selectedCategory = data.current.value
			for _, name in pairs(sortedKeysA(categoryOutfits[selectedCategory])) do
				table.insert(elements2, {label = name, value = name})
			end
			ESX.UI.Menu.Open(
				"default",
				GetCurrentResourceName(),
				"eupclothes",
				{
					title = "Ropa EUP - " .. selectedCategory,
					align = "right",
					elements = elements2
				},
				function(dataOutfit, menuOutfit)
					local selectedEUPOutfit = dataOutfit.current.value
					setEUPOutfitA(categoryOutfits[selectedCategory][selectedEUPOutfit])
					if (categoryOutfits[selectedCategory][selectedEUPOutfit].armor ~= nil) then
						SetPedArmour(PlayerPedId(), categoryOutfits[selectedCategory][selectedEUPOutfit].armor)
					else
						SetPedArmour(PlayerPedId(), 0)
					end
				end,
				function(dataOutfit, menuOutfit)
					menuOutfit.close()
				end
			)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function setEUPOutfitA(outfit)
	local ped = PlayerPedId()
	local skinEup = TranslateEupToSkinChangerA(outfit)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, skinEup)
	end)
	--[[setUniform(masterJob, grade, playerPed, skin)

	RequestModel(outfit.ped)

	while not HasModelLoaded(outfit.ped) do
		Wait(0)
	end

	if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
		SetPlayerModel(PlayerId(), outfit.ped)
	end

	ped = PlayerPedId()

	for _, comp in ipairs(outfit.components) do
		SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
	end

	for _, comp in ipairs(outfit.props) do
		if comp[2] == 0 then
			ClearPedProp(ped, comp[1])
		else
			SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
		end
	end
]]--
end
function GetEUPComponentVariationForIdA(outfit, id, variation)
	for _, comp in ipairs(outfit.components) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function GetEUPPropIndexForIdA(outfit, id, variation)
	for _, comp in ipairs(outfit.props) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function TranslateEupToSkinChangerA(outfit)
	
	local skin = {
		['mask_1'] = GetEUPComponentVariationForIdA(outfit, 1, 2) - 1,  
		['mask_2'] = GetEUPComponentVariationForIdA(outfit, 1, 3) - 1,  

		['arms'] = GetEUPComponentVariationForIdA(outfit, 3, 2) - 1,
		['arms_2'] = GetEUPComponentVariationForIdA(outfit, 3, 3) - 1,

		['pants_1'] = GetEUPComponentVariationForIdA(outfit, 4, 2) - 1, 
		['pants_2'] = GetEUPComponentVariationForIdA(outfit, 4, 3) - 1,

		['bags_1'] = GetEUPComponentVariationForIdA(outfit, 5, 2) - 1, 
		['bags_2'] = GetEUPComponentVariationForIdA(outfit, 5, 3) - 1,

		['shoes_1'] = GetEUPComponentVariationForIdA(outfit, 6, 2) - 1, 
		['shoes_2'] = GetEUPComponentVariationForIdA(outfit, 6, 3) - 1,

		['chain_1'] =  GetEUPComponentVariationForIdA(outfit, 7, 2) - 1,
		['chain_2'] = GetEUPComponentVariationForIdA(outfit, 7, 3) - 1,

		['tshirt_1'] = GetEUPComponentVariationForIdA(outfit, 8, 2) - 1,  
		['tshirt_2'] = GetEUPComponentVariationForIdA(outfit, 8, 3) - 1,  

		['bproof_1'] = GetEUPComponentVariationForIdA(outfit, 9, 2) - 1,  
		['bproof_2'] = GetEUPComponentVariationForIdA(outfit, 9, 3) - 1,  

		['decals_1'] = GetEUPComponentVariationForIdA(outfit, 10, 2) - 1, 
		['decals_2'] = GetEUPComponentVariationForIdA(outfit, 10, 3) - 1,

		['torso_1'] = GetEUPComponentVariationForIdA(outfit, 11, 2) - 1,  
		['torso_2'] = GetEUPComponentVariationForIdA(outfit, 11, 3) - 1,
		
		['helmet_1'] =  GetEUPPropIndexForIdA(outfit, 0, 2) - 1,  
		['helmet_2'] = GetEUPPropIndexForIdA(outfit, 0, 3) - 1, 
		['glasses_1'] =  GetEUPPropIndexForIdA(outfit, 1, 2) - 1,  
		['glasses_2'] = GetEUPPropIndexForIdA(outfit, 1, 3) - 1, 
		['ears_1'] =  GetEUPPropIndexForIdA(outfit, 2, 2) - 1,   
		['ears_2'] =  GetEUPPropIndexForIdA(outfit, 2, 3) - 1,  
	}
	return skin
end
function OpenCustomClothesMenuA(masterJob)
	local elements = {}
	
	table.insert(elements, {label = "Guardar ropa actual como nueva ropa custom", value = "newclothes_menuoption"})
	table.insert(elements, {label = "Eliminar ropa custom", value = "deleteclothes_menuoption"})
	

	ESX.UI.Menu.CloseAll()
	if (#elements > 0) then
		ESX.UI.Menu.Open(
			"default",
			GetCurrentResourceName(),
			"customclothes",
			{
				title = "Ropa custom",
				align = "right",
				elements = elements
			},
			function(data, menu)
				if data.current.value == "newclothes_menuoption" then
					ESX.UI.Menu.Open(
						"dialog",
						GetCurrentResourceName(),
						"newclothes_menuoption_name",
						{
							title = "Nombre de la ropa"
						},
						function(data2, menu2)
							ESX.TriggerServerCallback(
								"esx_skin:getPlayerSkin",
								function(skin)
									ESX.TriggerServerCallback(
										"esx_mole_masterjob:addSocietyClothes",
										function()
											ESX.ShowNotification(_U("skin_saved"))
											menu2.close()
											OpenCustomClothesMenuA(masterJob)
										end,
										masterJob,
										data2.value,
										skin
									)
								end
							)
						end
					)
				elseif data.current.value == "deleteclothes_menuoption" then
					OpenRemoveCustomClothesMenu(masterJob)
				end
			end,
			function(data, menu)
				menu.close()
			end
		)
	end
end


function sortedKeysA(query, sortFunction)
    local keys, len = {}, 0
    for k, _ in pairs(query) do
        len = len + 1
        keys[len] = k
    end
    table.sort(keys, sortFunction)
    return keys
end