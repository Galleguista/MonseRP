ESX = nil
local PlayerData = {}
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local esxloaded, currentstop = false, 0
local HasAlreadyEnteredArea, clockedin, vehiclespawned, albetogetbags, truckdeposit = false, false, false, false, false
local work_truck, NewDrop, LastDrop, binpos, truckpos, garbagebag, truckplate, mainblip, AreaType, AreaInfo, currentZone, currentstop, AreaMarker
local Blips, CollectionJobs, depositlist = {}, {}, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
		
	mainblip = AddBlipForCoord(Config.ZonesG[2].pos)

	SetBlipSprite (mainblip, 318)
	SetBlipDisplay(mainblip, 4)
	SetBlipScale  (mainblip, 0.8)
	SetBlipColour (mainblip, 5)
	SetBlipAsShortRange(mainblip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_job'))
	EndTextCommandSetBlipName(mainblip)
		
	esxloaded = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	TriggerServerEvent('sapo_masterjob_garbagecrew:setconfig')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	TriggerEvent('sapo_masterjob_garbagecrew:checkjob')
end)

RegisterNetEvent('sapo_masterjob_garbagecrew:movetruckcount')
AddEventHandler('sapo_masterjob_garbagecrew:movetruckcount', function(count)
	Config.TruckPlateNumb = count
end)

RegisterNetEvent('sapo_masterjob_garbagecrew:updatejobs')
AddEventHandler('sapo_masterjob_garbagecrew:updatejobs', function(newjobtable)
	CollectionJobs = newjobtable
end)


RegisterNetEvent('sapo_masterjob_garbagecrew:selectnextjob')
AddEventHandler('sapo_masterjob_garbagecrew:selectnextjob', function()
	if currentstop < Config.MaxStops then
		SetVehicleDoorShut(work_truck, 5, false)
		SetBlipRoute(Blips['delivery'], false)
		FindDeliveryLocG()
		albetogetbags = false
	else
		NewDrop = nil
		oncollection = false
		SetVehicleDoorShut(work_truck, 5, false)
		RemoveBlip(Blips['delivery'])
		SetBlipRoute(Blips['endmission'], true)
		albetogetbags = false
		ESX.ShowNotification(_U('return_depot'))
	end
end)

RegisterNetEvent('sapo_masterjob_garbagecrew:enteredarea')
AddEventHandler('sapo_masterjob_garbagecrew:enteredarea', function(zone)
	CurrentAction = zone.name

	-- if CurrentAction == 'timeclock'  and IsGarbageJobG() then
	-- 	MenuCloakRoomG()
	-- end

	if zone == 'timeclock' and IsGarbageJobG() then
		CurrentAction     = 'menucloak'
	end

	if CurrentAction == 'vehiclelist' then
		if clockedin and not vehiclespawned then
			CurrentAction     = 'vehiclelistopen'
			-- MenuVehicleSpawnerG()
		end
	end

	-- if CurrentAction == 'endmission' and vehiclespawned then
	-- 	CurrentActionMsg = _U('cancel_mission')
	-- end

	if CurrentAction == 'collection' and not albetogetbags then
		if IsPedInAnyVehicle(PlayerPedId()) and GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) == worktruckplate then
			CurrentActionMsg = _U('collection')
		else
			CurrentActionMsg = _U('need_work_truck')
		end
	end

	if CurrentAction == 'bagcollection' then
		if zone.bagsremaining > 0 then
			CurrentActionMsg = _U('collect_bags', tostring(zone.bagsremaining))
		else
			CurrentActionMsg = nil
		end
	end

	if CurrentAction == 'deposit' then
		CurrentActionMsg = _U('toss_bag')
	end

end)

RegisterNetEvent('sapo_masterjob_garbagecrew:leftarea')
AddEventHandler('sapo_masterjob_garbagecrew:leftarea', function()
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
	CurrentActionMsg = ''
end)

Citizen.CreateThread( function()
	while true do 
		sleep = 1500
		ply = PlayerPedId()
		plyloc = GetEntityCoords(ply)

		for i, v in pairs(Config.ZonesG) do
			if GetDistanceBetweenCoords(plyloc, v.pos, true)  < 20.0 and esxloaded then
				sleep = 0
				if v.name == 'timeclock' and IsGarbageJobG() then
					DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.size,  v.size, 0.3, 255,0, 0, 100, false, true, 2, false, false, false, false)
				elseif v.name == 'endmission' and vehiclespawned then
					DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  v.size,  v.size, 0.3, 255,0, 0, 100, false, true, 2, false, false, false, false)
				elseif v.name == 'vehiclelist' and clockedin and not vehiclespawned then
					DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  v.size,  v.size, 0.3, 255,0, 0, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		

		for i, v in pairs(Config.ZonesG) do
			if GetDistanceBetweenCoords(plyloc, v.pos, true)  < 5.0 and esxloaded then
				sleep = 0
				if v.name == 'timeclock' and IsGarbageJobG() then _U('')
					ESX.ShowFloatingHelpNotification(_U('open_cloackroom'), vector3(v.pos.x, v.pos.y, v.pos.z + 2))
				elseif v.name == 'endmission' and vehiclespawned then
					ESX.ShowFloatingHelpNotification(_U('store_vehicle'), vector3(v.pos.x, v.pos.y, v.pos.z + 2))
				elseif v.name == 'vehiclelist' and clockedin and not vehiclespawned then
					ESX.ShowFloatingHelpNotification(_U('abrir_garaje'), vector3(v.pos.x, v.pos.y, v.pos.z + 2))
				end
			end
		end

		for i, v in pairs(CollectionJobs)  do
			if GetDistanceBetweenCoords(plyloc, v.pos, true)  < 10.0 and truckpos == nil then
				sleep = 0
				DrawMarker(1, v.pos.x,  v.pos.y,  v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  3.0,  3.0, 1.0, 255,0, 0, 100, false, true, 2, false, false, false, false)
				break
			end
		end

		if truckpos ~= nil then
			if GetDistanceBetweenCoords(plyloc, truckpos, true) < 10.0  then
				sleep = 0
				DrawMarker(1, truckpos.x,  truckpos.y,  truckpos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  1.0, 1.0, 0.3, 255,0, 0, 100, false, true, 2, false, false, false, false)
			end
		end

		if oncollection then
			if GetDistanceBetweenCoords(plyloc, NewDrop.pos, true) < 20.0 and not albetogetbags then
				sleep = 0
				DrawMarker(1, NewDrop.pos.x,  NewDrop.pos.y,  NewDrop.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  NewDrop.size,  NewDrop.size, 1.0, 255,0, 0, 100, false, true, 2, false, false, false, false)
			end
		end

		Citizen.Wait(sleep)
	end
end)

AddEventHandler('sapo_masterjob_garbagecrew:checkjob', function()
	if PlayerData.job.name ~= Config.JobName then
		if mainblip ~= nil then
			RemoveBlip(mainblip)
			mainblip = nil
		end
	elseif mainblip == nil then
		mainblip = AddBlipForCoord(Config.ZonesG[2].pos)

		SetBlipSprite (mainblip, 318)
		SetBlipDisplay(mainblip, 4)
		SetBlipScale  (mainblip, 1.2)
		SetBlipColour (mainblip, 5)
		SetBlipAsShortRange(mainblip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_job'))
		EndTextCommandSetBlipName(mainblip)
	end
end)

Citizen.CreateThread( function()
	while true do
		local s = 200
		Citizen.Wait(s)
		if PlayerData.job and PlayerData.job.name == 'garbage' then
			while CurrentAction ~= nil and CurrentActionMsg ~= nil do
				Citizen.Wait(5)
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, 38) then
					local s = 100

					if CurrentAction == 'endmission' then
						if IsPedInAnyVehicle(PlayerPedId()) then
							local getvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
							TaskLeaveVehicle(PlayerPedId(), getvehicle, 0)
						end
						while IsPedInAnyVehicle(PlayerPedId()) do
							Citizen.Wait(0)
						end
						Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( work_truck ) )
						if Blips['delivery'] ~= nil then
							RemoveBlip(Blips['delivery'])
							Blips['delivery'] = nil
						end
						
						if Blips['endmission'] ~= nil then
							RemoveBlip(Blips['endmission'])
							Blips['endmission'] = nil
						end
						SetBlipRoute(Blips['delivery'], false)
						SetBlipRoute(Blips['endmission'], false)
						vehiclespawned = false
						albetogetbags = false
						CurrentAction =nil
						CurrentActionMsg = nil
					end

					if CurrentAction == 'collection' then
						if CurrentActionMsg == _U('collection') then
							SelectBinAndCrewG(GetEntityCoords(PlayerPedId()))
							CurrentAction = nil
							CurrentActionMsg  = nil
							IsInArea = false
						end
					end

					if CurrentAction == 'bagcollection' then
						CurrentAction = nil
						CurrentActionMsg = nil
						CollectBagFromBinG(currentZone)
						IsInArea = false
					end

					if CurrentAction == 'timeclock' then
						local s = 5
						MenuCloakRoomG()
					end

					if CurrentAction == 'vehiclelistopen' then
						local s = 5
						MenuVehicleSpawnerG()
					end


					if CurrentAction == 'deposit' then
						CurrentAction = nil
						CurrentActionMsg = nil
						PlaceBagInTruckG(currentZone)
						IsInArea = false
					end
				else
					local s = 5
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
	Citizen.Wait(s)
end)

-- thread so the script knows you have entered a markers area - 
Citizen.CreateThread( function()
	while true do 
		sleep = 1000
		ply = PlayerPedId()
		plyloc = GetEntityCoords(ply)
		IsInArea = false
		currentZone = nil
		
		for i,v in pairs(Config.ZonesG) do
			if GetDistanceBetweenCoords(plyloc, v.pos, false)  <  v.size then
				IsInArea = true
				currentZone = v
			end
		end

		if oncollection and not albetogetbags then
			if GetDistanceBetweenCoords(plyloc, NewDrop.pos, true)  <  NewDrop.size then
				IsInArea = true
				currentZone = NewDrop
			end
		end

		if truckpos ~= nil then
			if GetDistanceBetweenCoords(plyloc, truckpos, false)  <  2.0 then
				IsInArea = true
				currentZone = {type = 'Deposit', name = 'deposit', pos = truckpos,}
			end
		end

		for i,v in pairs(CollectionJobs) do
			if GetDistanceBetweenCoords(plyloc, v.pos, false)  <  2.0 and truckpos == nil then
				IsInArea = true
				currentZone = v
			end
		end

		if IsInArea and not HasAlreadyEnteredArea then
			HasAlreadyEnteredArea = true
			sleep = 0
			TriggerEvent('sapo_masterjob_garbagecrew:enteredarea', currentZone)
		end

		if not IsInArea and HasAlreadyEnteredArea then
			HasAlreadyEnteredArea = false
			sleep = 1000
			TriggerEvent('sapo_masterjob_garbagecrew:leftarea', currentZone)
		end

		Citizen.Wait(sleep)
	end
end)

function CollectBagFromBinG(currentZone)
	binpos = currentZone.pos
	truckplate = currentZone.trucknumber

	if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
		RequestAnimDict("anim@heists@narcotics@trash") 
		while not HasAnimDictLoaded("anim@heists@narcotics@trash") do 
			Citizen.Wait(0)
		end
	end

	local worktruck = NetworkGetEntityFromNetworkId(currentZone.truckid)

	if DoesEntityExist(worktruck) and GetDistanceBetweenCoords(GetEntityCoords(worktruck), GetEntityCoords(PlayerPedId()), true) < 25.0 then
		truckpos = GetOffsetFromEntityInWorldCoords(worktruck, 0.0, -5.25, 0.0)
		if not Config.Debug then
			TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
		end
		TriggerServerEvent('sapo_masterjob_garbagecrew:bagremoval', currentZone.pos, currentZone.trucknumber) 
		trashcollection = false
		if not Config.Debug then
			Citizen.Wait(4000)
		end
		ClearPedTasks(PlayerPedId())
		local randombag = math.random(0,2)

		if randombag == 0 then
			garbagebag = CreateObject(GetHashKey("prop_cs_street_binbag_01"), 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand    
		elseif randombag == 1 then
			garbagebag = CreateObject(GetHashKey("bkr_prop_fakeid_binbag_01"), 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), .65, 0, -.1, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand    
		elseif randombag == 2 then
			garbagebag = CreateObject(GetHashKey("hei_prop_heist_binbag"), 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true) -- object is attached to right hand    
		end  

		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
		CurrentAction = nil
		CurrentActionMsg = nil
		HasAlreadyEnteredArea = false
	else
		ESX.ShowNotification(_U('not_near_truck'))
		TriggerServerEvent('sapo_masterjob_garbagecrew:unknownlocation', currentZone.pos)
	end
end

function PlaceBagInTruckG(thiszone)
	if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
		RequestAnimDict("anim@heists@narcotics@trash") 
		while not HasAnimDictLoaded("anim@heists@narcotics@trash") do 
			Citizen.Wait(0)
		end
	end
	ClearPedTasksImmediately(PlayerPedId())
	TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
	Citizen.Wait(800)
	local garbagebagdelete = DeleteEntity(garbagebag)
	Citizen.Wait(100)
	ClearPedTasksImmediately(PlayerPedId())
	CurrentAction = nil
	CurrentActionMsg = nil
	depositlist = nil
	truckpos = nil
	TriggerServerEvent('sapo_masterjob_garbagecrew:bagdumped', binpos, truckplate)
	HasAlreadyEnteredArea = false
end

function SelectBinAndCrewG(location)
	local bin = nil
	
	for i, v in pairs(Config.DumpstersAvaialbe) do
		bin = GetClosestObjectOfType(location, 20.0, v, false, false, false )
		if bin ~= 0 then
			if CollectionJobs[GetEntityCoords(bin)] == nil then
				break
			else
				bin = 0
			end
		end
	end
	if bin ~= 0 then
		truckplate = GetVehicleNumberPlateText(work_truck)
		truckid = NetworkGetNetworkIdFromEntity(work_truck)
		TriggerServerEvent('sapo_masterjob_garbagecrew:setworkers', GetEntityCoords(bin), truckplate, truckid )
		truckpos = nil
		albetogetbags = true
		SetBlipRoute(Blips['delivery'], false)
		currentstop = currentstop + 1
		SetVehicleDoorOpen(work_truck, 5, false, false)
	else
		ESX.ShowNotification( _U('no_trash_aviable'))
		SetBlipRoute(Blips['endmission'], true)
		FindDeliveryLocG()
	end
end

function FindDeliveryLocG()
	if LastDrop ~= nil then
		lastregion = GetNameOfZone(LastDrop.pos)
	end
	local newdropregion = nil
	while newdropregion == nil or newdropregion == lastregion do
		randomloc = math.random(1, #Config.Collections)
		newdropregion = GetNameOfZone(Config.Collections[randomloc].pos)
	end
	NewDrop = Config.Collections[randomloc]
	LastDrop = NewDrop
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['endmission'] ~= nil then
		RemoveBlip(Blips['endmission'])
		Blips['endmission'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(NewDrop.pos)
	SetBlipSprite (Blips['delivery'], 318)
	SetBlipAsShortRange(Blips['delivery'], true)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	Blips['endmission'] = AddBlipForCoord(Config.ZonesG[1].pos)
	SetBlipSprite (Blips['endmission'], 318)
	SetBlipColour(Blips['endmission'], 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_goal'))
	EndTextCommandSetBlipName(Blips['endmission'])

	oncollection = true
	ESX.ShowNotification(_U('drive_to_collection'))
end

function IsGarbageJobG()
	if ESX ~= nil then
		local isjob = false
		if PlayerData.job.name == Config.JobName then
			isjob = true
		end
		return isjob
	end
end

function MenuCloakRoomG()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
			title    = _U('cloakroom'),
			align = 'right',
			elements = {
				{label = _U('work_wear'), value = 'work_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}}, function(data, menu)
			if data.current.value == 'citizen_wear' then
				clockedin = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			elseif data.current.value == 'work_wear' then
				clockedin = true
				ESX.TriggerServerCallback(
				"esx_skin:getPlayerSkin",
				function(skin, jobSkin)
					OpenEUPClothesMenuG(masterJob, skin.sex)
			end)
			end
	end, function(data, menu)
		menu.close()
	end)
end

function MenuVehicleSpawnerG()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehiclespawner', {
			title    = _U('vehiclespawner'),
			align = 'right',
			elements = elements
		}, function(data, menu)
			ESX.Game.SpawnVehicle(data.current.value, Config.VehicleSpawnG.pos, 270.0, function(vehicle)
				local trucknumber = Config.TruckPlateNumb + 1
				if trucknumber <=9 then
					SetVehicleNumberPlateText(vehicle, 'GCREW00'..trucknumber)
					worktruckplate =   'GCREW00'..trucknumber 
				elseif trucknumber <=99 then
					SetVehicleNumberPlateText(vehicle, 'GCREW0'..trucknumber)
					worktruckplate =   'GCREW0'..trucknumber 
				else
					SetVehicleNumberPlateText(vehicle, 'GCREW'..trucknumber)
					worktruckplate =   'GCREW'..trucknumber 
				end
				TriggerServerEvent('sapo_masterjob_garbagecrew:movetruckcount')   
				SetEntityAsMissionEntity(vehicle,true, true)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)  
				vehiclespawned = true 
				albetogetbags = false
				work_truck = vehicle

				currentstop = 0
				FindDeliveryLocG()
			end)

			menu.close()
		end, function(data, menu)
			menu.close()
		end)
end



----------------

function EUPCategoryAllowedG(masterJob, category)
	local category = Config.EUPOutFitsCategoriesG[category]
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

function OpenEUPClothesMenuG(masterJob, sex)
	print(masterJob, sex)
	local elements = {}
	local categoryOutfits = {}
	masterJob = 'garbage'

	for name, outfit in pairs(Config.EUPOutFitsG) do
		if not categoryOutfits[outfit.category] then
			categoryOutfits[outfit.category] = {}
		end
		if (sex == 0 and outfit.ped == "mp_m_freemode_01") or (sex == 1 and outfit.ped == "mp_f_freemode_01") then
			categoryOutfits[outfit.category][name] = outfit
		end
	end
	for _, categoryName in pairs(sortedKeysG(categoryOutfits)) do
		if (EUPCategoryAllowedG(masterJob, categoryName)) then
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
			for _, name in pairs(sortedKeysG(categoryOutfits[selectedCategory])) do
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
					setEUPOutfitG(categoryOutfits[selectedCategory][selectedEUPOutfit])
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

function setEUPOutfitG(outfit)
	local ped = PlayerPedId()
	local skinEup = TranslateEupToSkinChangerG(outfit)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, skinEup)
	end)
end

function GetEUPComponentVariationForIdG(outfit, id, variation)
	for _, comp in ipairs(outfit.components) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end

function GetEUPPropIndexForIdG(outfit, id, variation)
	for _, comp in ipairs(outfit.props) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end

function TranslateEupToSkinChangerG(outfit)
	
	local skin = {
		['mask_1'] = GetEUPComponentVariationForIdG(outfit, 1, 2) - 1,  
		['mask_2'] = GetEUPComponentVariationForIdG(outfit, 1, 3) - 1,  

		['arms'] = GetEUPComponentVariationForIdG(outfit, 3, 2) - 1,
		['arms_2'] = GetEUPComponentVariationForIdG(outfit, 3, 3) - 1,

		['pants_1'] = GetEUPComponentVariationForIdG(outfit, 4, 2) - 1, 
		['pants_2'] = GetEUPComponentVariationForIdG(outfit, 4, 3) - 1,

		['bags_1'] = GetEUPComponentVariationForIdG(outfit, 5, 2) - 1, 
		['bags_2'] = GetEUPComponentVariationForIdG(outfit, 5, 3) - 1,

		['shoes_1'] = GetEUPComponentVariationForIdG(outfit, 6, 2) - 1, 
		['shoes_2'] = GetEUPComponentVariationForIdG(outfit, 6, 3) - 1,

		['chain_1'] =  GetEUPComponentVariationForIdG(outfit, 7, 2) - 1,
		['chain_2'] = GetEUPComponentVariationForIdG(outfit, 7, 3) - 1,

		['tshirt_1'] = GetEUPComponentVariationForIdG(outfit, 8, 2) - 1,  
		['tshirt_2'] = GetEUPComponentVariationForIdG(outfit, 8, 3) - 1,  

		['bproof_1'] = GetEUPComponentVariationForIdG(outfit, 9, 2) - 1,  
		['bproof_2'] = GetEUPComponentVariationForIdG(outfit, 9, 3) - 1,  

		['decals_1'] = GetEUPComponentVariationForIdG(outfit, 10, 2) - 1, 
		['decals_2'] = GetEUPComponentVariationForIdG(outfit, 10, 3) - 1,

		['torso_1'] = GetEUPComponentVariationForIdG(outfit, 11, 2) - 1,  
		['torso_2'] = GetEUPComponentVariationForIdG(outfit, 11, 3) - 1,
		
		['helmet_1'] =  GetEUPPropIndexForIdG(outfit, 0, 2) - 1,  
		['helmet_2'] = GetEUPPropIndexForIdG(outfit, 0, 3) - 1, 
		['glasses_1'] =  GetEUPPropIndexForIdG(outfit, 1, 2) - 1,  
		['glasses_2'] = GetEUPPropIndexForIdG(outfit, 1, 3) - 1, 
		['ears_1'] =  GetEUPPropIndexForIdG(outfit, 2, 2) - 1,   
		['ears_2'] =  GetEUPPropIndexForIdG(outfit, 2, 3) - 1,  
	}
	return skin
end

function OpenCustomClothesMenuG(masterJob)
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
											OpenCustomClothesMenuG(masterJob)
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

function sortedKeysG(query, sortFunction)
    local keys, len = {}, 0
    for k, _ in pairs(query) do
        len = len + 1
        keys[len] = k
    end
    table.sort(keys, sortFunction)
    return keys
end