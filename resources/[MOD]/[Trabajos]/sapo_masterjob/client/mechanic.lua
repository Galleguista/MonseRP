local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function SelectRandomTowableM()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.ZonesM) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJobM()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowableM()
	local zone = Config.ZonesM[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StartNPCJobM(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.ZonesM.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable  = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		--TriggerServerEvent('sapo_masterjob_mechanic:onNPCJobCompleted')
	end
end

function OpenMechanicActionsMenuM()
	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then

			local elements = Config.VehiclesMechanic

			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
				title    = _U('service_vehicle'),
				align    = 'right',
				elements = elements
			}, function(data, menu)
				if Config.MaxInService == -1 then
					ESX.Game.SpawnVehicle(data.current.value, Config.ZonesM.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
						local playerPed = PlayerPedId()
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					end)
				else
					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if canTakeService then
							ESX.Game.SpawnVehicle(data.current.value, Config.ZonesM.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
								local playerPed = PlayerPedId()
								TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
							end)
						else
							ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
						end
					end, 'mechanic')
				end

				menu.close()
			end, function(data, menu)
				menu.close()
				OpenMechanicActionsMenuM()
			end)

		elseif data.current.value == 'cloakroom' then
			ESX.TriggerServerCallback(
				"esx_skin:getPlayerSkin",
				function(skin, jobSkin)
					OpenEUPClothesMenuM(masterJob, skin.sex)
			end)
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenuM()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenuM()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionMsgCoords = vector3(Config.ZonesM.MechanicActions.Pos.x, Config.ZonesM.MechanicActions.Pos.y, Config.ZonesM.MechanicActions.Pos.z + 1)
		CurrentActionData = {}
	end)
end

function OpenMechanicHarvestMenuM()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
			title    = _U('harvest'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'gaz_bottle' then
				TriggerServerEvent('sapo_masterjob_mechanic:startHarvest')
			elseif data.current.value == 'fix_tool' then
				TriggerServerEvent('sapo_masterjob_mechanic:startHarvest2')
			elseif data.current.value == 'caro_tool' then
				TriggerServerEvent('sapo_masterjob_mechanic:startHarvest3')
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_harvest_menu'
			CurrentActionMsg  = _U('press_to_open')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMechanicCraftMenuM()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
			title    = _U('craft'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'blow_pipe' then
				TriggerServerEvent('sapo_masterjob_mechanic:startCraft')
			elseif data.current.value == 'fix_kit' then
				TriggerServerEvent('sapo_masterjob_mechanic:startCraft2')
			elseif data.current.value == 'caro_kit' then
				TriggerServerEvent('sapo_masterjob_mechanic:startCraft3')
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionMsg  = _U('press_to_open')
			CurrentActionMsgCoords  = vector3(Config.ZonesM.Craft.Pos.x, Config.ZonesM.Craft.Pos.y, Config.ZonesM.Craft.Pos.z + 1)
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMobileMechanicActionsMenuM()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'right',
		elements = {
			{label = _U('billing'),       value = 'billing'},
			{label = _U('hijack'),        value = 'hijack_vehicle'},
			{label = _U('repair'),        value = 'fix_vehicle'},
			{label = _U('clean'),         value = 'clean_vehicle'},
			{label = _U('imp_veh'),       value = 'del_vehicle'},
			-- {label = _U('flat_bed'),      value = 'dep_vehicle'},
			-- {label = _U('deposit_object'), value = 'object_spawner'}
	}}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'hijack_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_unlocked'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'fix_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_repaired'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'del_vehicle' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenuM()
	ESX.TriggerServerCallback('sapo_masterjob_mechanic:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count ~= 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
		    end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('mechanic_stock'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sapo_masterjob_mechanic:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenuM()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenuM()
	ESX.TriggerServerCallback('sapo_masterjob_mechanic:getPlayerInventory', function(inventory)
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

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sapo_masterjob_mechanic:putStockItems', itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenuM()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('sapo_masterjob_mechanic:onHijack')
AddEventHandler('sapo_masterjob_mechanic:onHijack', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('sapo_masterjob_mechanic:onCarokit')
AddEventHandler('sapo_masterjob_mechanic:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('sapo_masterjob_mechanic:onFixkit')
AddEventHandler('sapo_masterjob_mechanic:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('sapo_masterjob_mechanic:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionMsgCoords = vector3(Config.ZonesM.MechanicActions.Pos.x, Config.ZonesM.MechanicActions.Pos.y, Config.ZonesM.MechanicActions.Pos.z + 1)
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionMsgCoords  = vector3(Config.ZonesM.Craft.Pos.x, Config.ZonesM.Craft.Pos.y, Config.ZonesM.Craft.Pos.z + 1)
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionMsgCoords = vector3(Config.ZonesM.VehicleDeleter.Pos.x, Config.ZonesM.VehicleDeleter.Pos.y, Config.ZonesM.VehicleDeleter.Pos.z + 1)
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('sapo_masterjob_mechanic:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('sapo_masterjob_mechanic:stopCraft')
		TriggerServerEvent('sapo_masterjob_mechanic:stopCraft2')
		TriggerServerEvent('sapo_masterjob_mechanic:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('sapo_masterjob_mechanic:stopHarvest')
		TriggerServerEvent('sapo_masterjob_mechanic:stopHarvest2')
		TriggerServerEvent('sapo_masterjob_mechanic:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('sapo_masterjob_mechanic:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('sapo_masterjob_mechanic:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('mechanic'),
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
	while true do
		s = 1000

		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.ZonesM[NPCTargetTowableZone]

			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then
				s = 5
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.ZonesM[NPCTargetTowableZone]

			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance then
				s = 5
				ESX.ShowNotification(_U('please_tow'))
				NPCHasBeenNextToTowable = true
			end
		end
		Citizen.Wait(s)
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.ZonesM.MechanicActions.Pos.x, Config.ZonesM.MechanicActions.Pos.y, Config.ZonesM.MechanicActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()

	while true do
		
		s = 1000

		if ESX then

			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				local coords, letSleep = GetEntityCoords(PlayerPedId()), true

				for k,v in pairs(Config.ZonesM) do
					if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
						s = 1
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
						letSleep = false
					end
				end

				if letSleep then
					s = 1000
				end
			else
				s = 500
			end

		else

			Citizen.Wait(1000)

		end

		Citizen.Wait(s)
	
	end

end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local s = 1000

		if ESX then

			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				local s = 5
				local coords = GetEntityCoords(PlayerPedId())
				local isInMarker = false
				local currentZone = nil

				for k,v in pairs(Config.ZonesM) do
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
						isInMarker  = true
						currentZone = k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('sapo_masterjob_mechanic:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('sapo_masterjob_mechanic:hasExitedMarker', LastZone)
				end
			else
				local s = 1000
			end

		else

			Citizen.Wait(s)

		end
		
		Citizen.Wait(s)
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
  
		local s = 1000
		Citizen.Wait(s)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity = nil

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			local s = 5
			if LastEntity ~= closestEntity then
				TriggerEvent('sapo_masterjob_mechanic:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			local s = 1000
			if LastEntity then
				TriggerEvent('sapo_masterjob_mechanic:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
		Citizen.Wait(s)
	end
end)


-- Key Controls
Citizen.CreateThread(function()
	while true do
		s = 1000

		if CurrentAction then
			s = 0
			ESX.ShowFloatingHelpNotification(CurrentActionMsg, CurrentActionMsgCoords)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

				if CurrentAction == 'mechanic_actions_menu' then
					OpenMechanicActionsMenuM()
				elseif CurrentAction == 'mechanic_harvest_menu' then
					OpenMechanicHarvestMenuM()
				elseif CurrentAction == 'mechanic_craft_menu' then
					OpenMechanicCraftMenuM()
				elseif CurrentAction == 'delete_vehicle' then

					if
						GetEntityModel(vehicle) == GetHashKey('flatbed')   or
						GetEntityModel(vehicle) == GetHashKey('towtruck2') or
						GetEntityModel(vehicle) == GetHashKey('slamvan3')
					then
						TriggerServerEvent('esx_service:disableService', 'mechanic')
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end
		Citizen.Wait(s)
	end
end)

RegisterCommand('mechanicMenu',function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		if not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			OpenMobileMechanicActionsMenuM()
		end
	end
end)

RegisterKeyMapping('mechanicMenu',"Abrir menu de mecanicos","keyboard","F6")

RegisterCommand('StartNPCJobM',function()
	if NPCOnJob then
		if GetGameTimer() - NPCLastCancel > 5 * 60000 then
			StartNPCJobM(true)
			NPCLastCancel = GetGameTimer()
		else
			ESX.ShowNotification(_U('wait_five'))
		end
	else
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('flatbed')) then
			StartNPCJobM()
		else
			ESX.ShowNotification(_U('must_in_flatbed'))
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------


function EUPCategoryAllowedM(masterJob, category)
	local category = Config.EUPOutFitsCategoriesM[category]
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
function OpenEUPClothesMenuM(masterJob, sex)
	print(masterJob, sex)
	local elements = {}
	local categoryOutfits = {}
	masterJob = 'mechanic'

	for name, outfit in pairs(Config.EUPOutFitsM) do
		if not categoryOutfits[outfit.category] then
			categoryOutfits[outfit.category] = {}
		end
		if (sex == 0 and outfit.ped == "mp_m_freemode_01") or (sex == 1 and outfit.ped == "mp_f_freemode_01") then
			categoryOutfits[outfit.category][name] = outfit
		end
	end
	for _, categoryName in pairs(sortedKeysM(categoryOutfits)) do
		if (EUPCategoryAllowedM(masterJob, categoryName)) then
			table.insert(elements, {label = categoryName, value = categoryName})
		end
	end
	ESX.UI.Menu.Open(
		"default",
		GetCurrentResourceName(),
		"eupcategories",
		{
			title = "Ropa EUP",
			align    = 'right',
			elements = elements
		},
		function(data, menu)
			local elements2 = {}
			local selectedCategory = data.current.value
			for _, name in pairs(sortedKeysM(categoryOutfits[selectedCategory])) do
				table.insert(elements2, {label = name, value = name})
			end
			ESX.UI.Menu.Open(
				"default",
				GetCurrentResourceName(),
				"eupclothes",
				{
					title = "Ropa EUP - " .. selectedCategory,
					align    = 'right',
					elements = elements2
				},
				function(dataOutfit, menuOutfit)
					local selectedEUPOutfit = dataOutfit.current.value
					setEUPOutfitM(categoryOutfits[selectedCategory][selectedEUPOutfit])
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

function setEUPOutfitM(outfit)
	local ped = PlayerPedId()
	local skinEup = TranslateEupToSkinChangerM(outfit)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, skinEup)
	end)
end
function GetEUPComponentVariationForIdM(outfit, id, variation)
	for _, comp in ipairs(outfit.components) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function GetEUPPropIndexForIdM(outfit, id, variation)
	for _, comp in ipairs(outfit.props) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function TranslateEupToSkinChangerM(outfit)
	
	local skin = {
		['mask_1'] = GetEUPComponentVariationForIdM(outfit, 1, 2) - 1,  
		['mask_2'] = GetEUPComponentVariationForIdM(outfit, 1, 3) - 1,  

		['arms'] = GetEUPComponentVariationForIdM(outfit, 3, 2) - 1,
		['arms_2'] = GetEUPComponentVariationForIdM(outfit, 3, 3) - 1,

		['pants_1'] = GetEUPComponentVariationForIdM(outfit, 4, 2) - 1, 
		['pants_2'] = GetEUPComponentVariationForIdM(outfit, 4, 3) - 1,

		['bags_1'] = GetEUPComponentVariationForIdM(outfit, 5, 2) - 1, 
		['bags_2'] = GetEUPComponentVariationForIdM(outfit, 5, 3) - 1,

		['shoes_1'] = GetEUPComponentVariationForIdM(outfit, 6, 2) - 1, 
		['shoes_2'] = GetEUPComponentVariationForIdM(outfit, 6, 3) - 1,

		['chain_1'] =  GetEUPComponentVariationForIdM(outfit, 7, 2) - 1,
		['chain_2'] = GetEUPComponentVariationForIdM(outfit, 7, 3) - 1,

		['tshirt_1'] = GetEUPComponentVariationForIdM(outfit, 8, 2) - 1,  
		['tshirt_2'] = GetEUPComponentVariationForIdM(outfit, 8, 3) - 1,  

		['bproof_1'] = GetEUPComponentVariationForIdM(outfit, 9, 2) - 1,  
		['bproof_2'] = GetEUPComponentVariationForIdM(outfit, 9, 3) - 1,  

		['decals_1'] = GetEUPComponentVariationForIdM(outfit, 10, 2) - 1, 
		['decals_2'] = GetEUPComponentVariationForIdM(outfit, 10, 3) - 1,

		['torso_1'] = GetEUPComponentVariationForIdM(outfit, 11, 2) - 1,  
		['torso_2'] = GetEUPComponentVariationForIdM(outfit, 11, 3) - 1,
		
		['helmet_1'] =  GetEUPPropIndexForIdM(outfit, 0, 2) - 1,  
		['helmet_2'] = GetEUPPropIndexForIdM(outfit, 0, 3) - 1, 
		['glasses_1'] =  GetEUPPropIndexForIdM(outfit, 1, 2) - 1,  
		['glasses_2'] = GetEUPPropIndexForIdM(outfit, 1, 3) - 1, 
		['ears_1'] =  GetEUPPropIndexForIdM(outfit, 2, 2) - 1,   
		['ears_2'] =  GetEUPPropIndexForIdM(outfit, 2, 3) - 1,  
	}
	return skin
end

function OpenCustomClothesMenuM(masterJob)
	local elements = {}
	if (PlayerHaveMenuPermission(masterJob, "ConfigureClothes")) then
		table.insert(elements, {label = "Guardar ropa actual como nueva ropa custom", value = "newclothes_menuoption"})
		table.insert(elements, {label = "Eliminar ropa custom", value = "deleteclothes_menuoption"})
	end

	ESX.UI.Menu.CloseAll()
	if (#elements > 0) then
		ESX.UI.Menu.Open(
			"default",
			GetCurrentResourceName(),
			"customclothes",
			{
				title = "Ropa custom",
				align    = 'right',
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
											ESX.ShowNotification(_U('skin_saved'))
											menu2.close()
											OpenCustomClothesMenuM(masterJob)
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


function sortedKeysM(query, sortFunction)
    local keys, len = {}, 0
    for k, _ in pairs(query) do
        len = len + 1
        keys[len] = k
    end
    table.sort(keys, sortFunction)
    return keys
end