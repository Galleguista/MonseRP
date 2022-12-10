ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
local CurrentDelivery 		  = false 
local DeliveryPoint			  = nil
local Blips 		  		  = {}
local district 		  		  = {}
local progress 		  		  = 1
local package 		  	  	  = 0
local lettre 		  		  = 0
local isInService 			  = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local vehicleMaxHealth 	      = nil
--------------------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function IsJobTruckerGo() 
	if PlayerData ~= nil then
		local isJobTrucker = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'mailjob' then
			isJobTrucker = true
		end
		return isJobTrucker
	end
end

function Draw3DTextGo(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = 0.5
   
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(1, 1, 0, 0, 255)
        SetTextEdge(0, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(2)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									CLOAKROOM	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function setUniformGo(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.UniformsGo.male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.UniformsGo.male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.UniformsGo.female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.UniformsGo.female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function cloakroomGo()
	if isInService then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local model = nil

			if skin.sex == 0 then
				model = GetHashKey("mp_m_freemode_01")
			else
				model = GetHashKey("mp_f_freemode_01")
			end

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(1)
			end

			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)

			TriggerEvent('skinchanger:loadSkin', skin)
			TriggerEvent('esx:restoreLoadout')
    	end)
		isInService = false
	else
	    setUniformGo(PlayerPedId())
	    isInService = true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									VEHICLE	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function VehiculeSpawnerGo()
	local elements = {}
	local len = 0
	for i=1, #Config.Vehicle, 1 do len = len + 1 end

	local plate = Config.JobVehiclePlate


	if len > 1 then

		for i=1, #Config.Vehicle, 1 do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Vehicle[i])), value = Config.Vehicle[i]})
		end


		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehiclespawner',
			{
				title    = _U('vehiclespawner'),
				elements = elements
			},
			function(data, menu)

				TriggerServerEvent('sapo_masterjob_gopostal:caution', 'take', Config.Caution)

				ESX.Game.SpawnVehicle(data.current.value, Config.ZonesGo.VehicleSpawnPoint.Pos, Config.ZonesGo.VehicleSpawnPoint.Heading, function(vehicle)
					vehicleMaxHealth = GetVehicleEngineHealth(vehicle)
					SetVehicleNumberPlateText(vehicle, plate)             	
					TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)   
				end)

				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
	else
		TriggerServerEvent('sapo_masterjob_gopostal:caution', 'take', Config.Caution)

		ESX.Game.SpawnVehicle(Config.Vehicle[1], Config.ZonesGo.VehicleSpawnPoint.Pos, Config.ZonesGo.VehicleSpawnPoint.Heading, function(vehicle)
			vehicleMaxHealth = GetVehicleEngineHealth(vehicle)
			SetVehicleNumberPlateText(vehicle, plate)             			
			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)   
		end)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									Distribution	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function MenuDistributionGo()
	local elements = {
		-- Courrier
		{label      = _U('letter'),
		item       = 'letter',

		-- menu properties
		value      = 1,
		type       = 'slider',
		min        = 1,
		max        = 100},

		--Package
		{label      = _U('package'),
		item       = 'package',

		-- menu properties
		value      = 1,
		type       = 'slider',
		min        = 1,
		max        = 100}
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'distribution', {
		title    = _U('distribution'),
		align    = 'right',
		elements = elements
	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'distribution_choice', {
			title    = 'x'.. data.current.value .. ' ' .. data.current.label,
			align    = 'right',
			elements = {
				{label = _U('pick'),  value = 'pick'},
				{label = _U('deposit'), value = 'deposit'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'pick' then
				TriggerServerEvent('sapo_masterjob_gopostal:Item', data.current.item, data.current.value, data.current.label, 'pick')
			elseif data2.current.value == 'deposit' then
				TriggerServerEvent('sapo_masterjob_gopostal:Item', data.current.item, data.current.value, data.current.label, 'deposit')
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)

		
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'distribution'
		CurrentActionMsg  = _U('open_distribution')
		CurrentActionData = {}
	end)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									ZONE
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

AddEventHandler('sapo_masterjob_gopostal:hasEnteredMarker', function(zone)

	local playerPed = PlayerPedId()

	if zone == 'CloakRoom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionMsgCoords = vector3(Config.ZonesGo.CloakRoom.Pos.x, Config.ZonesGo.CloakRoom.Pos.y, Config.ZonesGo.CloakRoom.Pos.z + 1)
		CurrentActionData = {}
	end

	if zone == 'VehicleSpawner' and isInService then
		CurrentAction     = 'vehiclespawner'
		CurrentActionMsg  = _U('sort_vehicle')
		CurrentActionMsgCoords = vector3(Config.ZonesGo.VehicleSpawner.Pos.x, Config.ZonesGo.VehicleSpawner.Pos.y, Config.ZonesGo.VehicleSpawner.Pos.z + 1)
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleter' and isInService then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
			
		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})
			
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

			CurrentAction     = 'vehicledeleter'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionMsgCoords = vector3(Config.ZonesGo.VehicleDeleter.Pos.x, Config.ZonesGo.VehicleDeleter.Pos.y, Config.ZonesGo.VehicleDeleter.Pos.z + 1)
			CurrentActionData = {vehicle = vehicle}
					
		end

	end

	if zone == 'Distribution' and isInService then
		CurrentAction     = 'distribution'
		CurrentActionMsg  = _U('open_distribution')
		CurrentActionMsgCoords = vector3(Config.ZonesGo.Distribution.Pos.x, Config.ZonesGo.Distribution.Pos.y, Config.ZonesGo.Distribution.Pos.z + 1)
		CurrentActionData = {}
	end

end)

AddEventHandler('sapo_masterjob_gopostal:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									KEY CONTROLS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
		local sleep = 500

        Citizen.Wait(0)

        if CurrentAction ~= nil then
			local sleep = 5

        	SetTextComponentFormat('STRING')
        	AddTextComponentString(CurrentActionMsg)
			ESX.ShowFloatingHelpNotification(CurrentActionMsg, CurrentActionMsgCoords)
       		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, 38) and IsJobTruckerGo() then -- Touche E
            	
            	if CurrentAction == 'cloakroom' then
            		cloakroomGo()
                end

                if CurrentAction == 'vehiclespawner' then
                	VehiculeSpawnerGo()
                end

                if CurrentAction == 'distribution' then
                	MenuDistributionGo()
                end

                if CurrentAction == 'vehicledeleter' then

                	local vehicleHealth = GetVehicleEngineHealth(CurrentActionData.vehicle)
                	local giveBack = ESX.Math.Round(vehicleHealth / vehicleMaxHealth, 2)

                	TriggerServerEvent('sapo_masterjob_gopostal:caution', "give_back", giveBack)
                	ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                end


                CurrentAction = nil
            end
		else
			Citizen.Wait(sleep)
        end
    end
end)

RegisterKeyMapping("Livraison","Livraison","keyboard","F6")

RegisterCommand("Livraison",function()
	if IsJobTruckerGo() and isInService then
		LivraisonGo()
	end
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									MARKERS & BLIP
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- DISPLAY MISSION MARKERS AND MARKERS


Citizen.CreateThread( function()
	while true do 
		sleep = 1500
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.ZonesGo) do
			if k == 'CloakRoom' and (IsJobTruckerGo() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				sleep = 0
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			elseif isInService and (IsJobTruckerGo() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				sleep = 0
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		Citizen.Wait(sleep)
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		Wait(5)
		
		if IsJobTruckerGo() then
			local sleep = 10

			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.ZonesGo) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('sapo_masterjob_gopostal:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('sapo_masterjob_gopostal:hasExitedMarker', lastZone)
			end
		else
			local sleep = 1000
		end
		Citizen.Wait(sleep)
	end
end)

-- CREATE BLIPS
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.ZonesGo.CloakRoom.Pos.x, Config.ZonesGo.CloakRoom.Pos.y, Config.ZonesGo.CloakRoom.Pos.z)
  
	SetBlipSprite (blip, 357)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_jobG'))
	EndTextCommandSetBlipName(blip)
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									LIVRAISON
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function LivraisonGo()

	District = SelectDistrictGo()

	if CurrentDelivery then
		LivraisonStopGo(district, true)
		CurrentDelivery = false
		
	else
		CurrentDelivery = true
		ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('notif_district', district.label), 'CHAR_BRYONY', 1 )
		ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('create_itinary'), 'CHAR_ANDREAS', 1 )
		LivraisonStartGo(district)
	end
end

function SelectDistrictGo() 

	for k,v in pairs (Config.Livraisons) do
		local DistrictLong = 0
		for i=1, #Config.Livraisons[k].Pos, 1 do 
			DistrictLong = DistrictLong + 1 
		end

		table.insert(district, {label = _U(k), value = k, long = DistrictLong} )
	end
	district = district[ math.random( #district ) ]
	return district;
end

function LivraisonStartGo(district)
	if CurrentDelivery then
		DeliveryPoint = district.value 
		local zone = Config.Livraisons[district.value]

		Blips['DeliveryPoint'] = AddBlipForCoord(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z)
		SetBlipRoute(Blips['DeliveryPoint'], true)
		LetterAndPackageGo()
		ESX.ShowNotification(_U('join_next'))
	end
end

function LivraisonStopGo(district, cancel)
	if Blips['DeliveryPoint'] ~= nil then
	    RemoveBlip(Blips['DeliveryPoint'])
	    Blips['DeliveryPoint'] = nil
	end

	if cancel then
		ESX.ShowNotification(_U('cancel_delivery'))
		CurrentDelivery = false
	else
		if progress < district.long then
			progress = progress + 1
			LivraisonStartGo(district)
		else
			CurrentDelivery = false
			progress = 1
			ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('finish_delivery'), 'CHAR_BRYONY', 1 )
		end
	end
end


function LetterAndPackageGo()

	local zone = Config.Livraisons[district.value]

	if zone.Pos[progress].letter then
		lettre = GetRandomIntInRange(Config.MinLetter, Config.MaxLetter)
	else
		lettre = 0
	end

	if zone.Pos[progress].package then
		package = GetRandomIntInRange(Config.MinPackage, Config.MaxPackage)
	else
		package = 0
	end
	
end


Citizen.CreateThread(function()
	WaitTime = 500
	while true do
		Citizen.Wait(WaitTime)
		if DeliveryPoint ~= nil then
			if CurrentDelivery then
				local coords = GetEntityCoords(PlayerPedId())
				local zone = Config.Livraisons[district.value]

				if GetDistanceBetweenCoords(coords, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, true) < 50.0 then
					WaitTime = 5
					-- DrawMarker(zone.Type, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, zone.Size.x, zone.Size.y, zone.Size.z, zone.Color.r, zone.Color.g, zone.Color.b, 100, false, true, 2, false, false, false, false)
					-- Draw3DTextGo(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z + 1.5 , _U('letter') .. lettre .. '\n' .. _U('package') .. package)
					ESX.ShowFloatingHelpNotification(_U('letter') .. lettre .. '\n' .. _U('package') .. package, vector3(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z + 1.5))
					if GetDistanceBetweenCoords(coords, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, true) < 3.0 then
						WaitTime = 5
						HelpPromtGo(_U('pickup'))
						if IsControlJustReleased(0, 38) and IsJobTruckerGo() and isInService then
							if not IsPedInAnyVehicle(PlayerPedId(), false) then
									ESX.TriggerServerCallback('sapo_masterjob_gopostal:haveItem', function(haveItem)
										if haveItem then
											TriggerServerEvent('sapo_masterjob_gopostal:end', lettre, package)
											LivraisonStopGo(district, false)
										end

									end, lettre, package)

									
							else
								ESX.ShowNotification(_U('must_be_walking'))
							end

						end
					end
				else
					WaitTime = 500
				end
			else 
				WaitTime = 500
			end
		else 
			WaitTime = 500
		end
	end
end)

function HelpPromtGo(text)
	Citizen.CreateThread(function()
    	SetTextComponentFormat('STRING')
        AddTextComponentString(text)
       	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  	end)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									CMD COORD
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNetEvent("SaveCommand")
AddEventHandler("SaveCommand", function(message)
		x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	    local PlayerName = GetPlayerName()
	    TriggerServerEvent("SaveCoords", PlayerName , x , y , z, message)			
end)
