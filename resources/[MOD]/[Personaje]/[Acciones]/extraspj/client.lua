local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX = nil


local ragdoll_chance = 0.75

local PlayerData = {}
local roboestado = false






------------------------------------------------Cruzar Brazos--------------------------------
Citizen.CreateThread(function()
    local waitTime = 500
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(waitTime)
    end
    local handsup = false
    while true do
        Citizen.Wait(5)
        if IsControlJustPressed(1, 74) then --Start holding z
            if not handsup then
                waitTime = 5
                TaskPlayAnim(PlayerPedId(), dict, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(PlayerPedId())
            end
                        else
                waitTime = 500
        end

    end

end)
    
---------------------------------------------Levantar manos-----------------------------------
local canHandsUp = true

AddEventHandler('handsup:toggle', function(param)
    canHandsUp = param
end)

Citizen.CreateThread(function()
     local waitTime = 500
    local handsup = false

    while true do
         Citizen.Wait(waitTime)

        if canHandsUp then
            waitTime = 5
            if IsControlJustReleased(0, Keys['X']) and not IsPedInAnyVehicle(PlayerPedId())then
                local playerPed = PlayerPedId()

                RequestAnimDict('random@mugging3')
                while not HasAnimDictLoaded('random@mugging3') do
                    Citizen.Wait(waitTime)
                end

                if handsup  then
                    handsup = false
                    waitTime = 5
                    ClearPedSecondaryTask(playerPed)
                    TriggerServerEvent('esx_thief:update', handsup)
                else
                    handsup = true
                    waitTime = 500
                    TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                    TriggerServerEvent('esx_thief:update', handsup)
                end
            end
        end
    end
end)

------------------------------------------------------------Apuntar dedo-------------------------------
-- local mp_pointing = false
-- local keyPressed = false

-- local function startPointing()
--     local ped = PlayerPedId()
--     RequestAnimDict("anim@mp_point")
--     while not HasAnimDictLoaded("anim@mp_point") do
--         Wait(500)
--     end
--     SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
--     SetPedConfigFlag(ped, 36, 1)
--     Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
--     RemoveAnimDict("anim@mp_point")
-- end

-- local function stopPointing()
--     local ped = PlayerPedId()
--     Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
--     if not IsPedInjured(ped) then
--         ClearPedSecondaryTask(ped)
--     end
--     if not IsPedInAnyVehicle(ped, 1) then
--         SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
--     end
--     SetPedConfigFlag(ped, 36, 0)
--     ClearPedSecondaryTask(PlayerPedId())
-- end

-- local once = true
-- local oldval = false
-- local oldvalped = false

-- Citizen.CreateThread(function()
--     local waitTime = 500
--     while true do
--         Citizen.Wait(waitTime)

--         if once then
--             waitTime = 5
--             once = false
            
--         end


--         if not keyPressed then
--             if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
--                 Wait(250)
--                 if not IsControlPressed(0, 29) then
--                     keyPressed = true
--                     startPointing()
--                     mp_pointing = true
--                 else
--                     keyPressed = true
--                     while IsControlPressed(0, 29) do
--                         Wait(50)
--                     end
--                 end
--             elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
--                 keyPressed = true
--                 mp_pointing = false
--                 stopPointing()
--             end
 
--         end

--         if keyPressed then
--             if not IsControlPressed(0, 29) then
--                 keyPressed = false
--             end
--         end
--         if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
--             stopPointing()
--         end
--         if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
--             if not IsPedOnFoot(PlayerPedId()) then
--                 stopPointing()
--             else
--                 local ped = PlayerPedId()
--                 local camPitch = GetGameplayCamRelativePitch()
--                 if camPitch < -70.0 then
--                     camPitch = -70.0
--                 elseif camPitch > 42.0 then
--                     camPitch = 42.0
--                 end
--                 camPitch = (camPitch + 70.0) / 112.0

--                 local camHeading = GetGameplayCamRelativeHeading()
--                 local cosCamHeading = Cos(camHeading)
--                 local sinCamHeading = Sin(camHeading)
--                 if camHeading < -180.0 then
--                     camHeading = -180.0
--                 elseif camHeading > 180.0 then
--                     camHeading = 180.0
--                 end
--                 camHeading = (camHeading + 180.0) / 360.0

--                 local blocked = 0
--                 local nn = 0

--                 local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
--                 local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
--                 nn,blocked,coords,coords = GetRaycastResult(ray)

--                 Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
--                 Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
--                 Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
--                 Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

--             end

--         end

--     end

-- end)

--------------------------------------------No zoom en inactividad---------------------------------------------
Citizen.CreateThread(function() 
    while true do
      N_0xf4f2c0d4ee209e20() 
      Wait(1000)
    end 
end)


--------------------------------------- Quitar casco Moto ---------------------------------
Citizen.CreateThread( function()
    local waitTime = 500
  while true do
   Wait(waitTime) 
   local playerVeh = GetVehiclePedIsUsing(playerPed)
   if gPlayerVeh ~= 0 then

    SetPedConfigFlag(PlayerPedId(), 35, false)
else 
    waitTime = 500
  end
end
end)

--------------------------------------- CARGAR PERSONA -------------------------------------

local carryingBackInProgress = false

RegisterCommand("cargar",function(source, args)
	--print("carrying")
	if not carryingBackInProgress then
		carryingBackInProgress = true
		local player = PlayerPedId()	
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= nil then
			--print("triggering cmg2_animations:sync")
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			--print("[CMG Anim] No player nearby")
			TriggerEvent("carry:notify", "CHAR_PEGASUS_DELIVERY", 1, "Notification", false, 'Aucun joueur à proximité')
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end,false)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	--print("triggered cmg2_animations:syncTarget")
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	--print("triggered cmg2_animations:syncMe")
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	--print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

RegisterNetEvent("carry:notify")
AddEventHandler("carry:notify", function(icon, type, sender, title, text)
    Citizen.CreateThread(function()
		Wait(1)
		SetNotificationTextEntry("STRING");
		AddTextComponentString(text);
		SetNotificationMessage(icon, icon, true, type, sender, title, text);
		DrawNotification(false, true);
    end)
end)



--------- coger rehen ---------------------------------


local hostageAllowedWeapons = {               
	"WEAPON_switchblade",                               ---- CONFIGURAR ARMAS ----
	"weapon_knife",
    "weapon_machete",                               ---- CONFIGURAR ARMAS ----
	"weapon_pistol",
    "weapon_combatpistol",                               ---- CONFIGURAR ARMAS ----
	"weapon_pistol50",
    "weapon_snspistol",                               ---- CONFIGURAR ARMAS ----
	"weapon_heavypistol",
    "weapon_vintagepistol",                               ---- CONFIGURAR ARMAS ----
	"weapon_machinepistol",
    "weapon_microsmg",                               ---- CONFIGURAR ARMAS ----
	"weapon_pumpshotgun",
    "weapon_compactrifle",                               ---- CONFIGURAR ARMAS ----
	"weapon_sawnoffshotgun",
	--etc add guns you want
}

local holdingHostageInProgress = false
local takeHostageAnimNamePlaying = ""
local takeHostageAnimDictPlaying = ""
local takeHostageControlFlagPlaying = 0

RegisterCommand("cogerrehen",function()
	takeHostage()
end)

RegisterCommand("th",function()
	takeHostage()
end)

function takeHostage()
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
	for i=1, #hostageAllowedWeapons do
		if HasPedGotWeapon(PlayerPedId(), GetHashKey(hostageAllowedWeapons[i]), false) then
			if GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(hostageAllowedWeapons[i]), false) then
				canTakeHostage = true 
				foundWeapon = GetHashKey(hostageAllowedWeapons[i])
				break
			end 					
		end
	end

	if not canTakeHostage then 
		drawNativeNotification("You need a pistol with ammo to take a hostage at gunpoint!")
	end

	if not holdingHostageInProgress and canTakeHostage then		
		local player = PlayerPedId()	
		--lib = 'misssagrab_inoffice'
		--anim1 = 'hostage_loop'
		--lib2 = 'misssagrab_inoffice'
		--anim2 = 'hostage_loop_mrk'
		lib = 'anim@gangops@hostage@'
		anim1 = 'perp_idle'
		lib2 = 'anim@gangops@hostage@'
		anim2 = 'victim_idle'
		distans = 0.11 --Higher = closer to camera
		distans2 = -0.24 --higher = left
		height = 0.0
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 49
		animFlagTarget = 50
		attachFlag = true 
		local closestPlayer = GetClosestPlayer(2)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			SetCurrentPedWeapon(PlayerPedId(), foundWeapon, true)
			holdingHostageInProgress = true
			holdingHostage = true 
			TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
		else
			drawNativeNotification("No one nearby to take as hostage!")
		end 
	end
	canTakeHostage = false 
end 

RegisterNetEvent('cmg3_animations:syncTarget')
AddEventHandler('cmg3_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if holdingHostageInProgress then 
		holdingHostageInProgress = false 
	else 
		holdingHostageInProgress = true
	end
	beingHeldHostage = true 
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then 
		AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	else 
	end
	
	if controlFlag == nil then controlFlag = 0 end
	
	if animation2 == "victim_fail" then 
		SetEntityHealth(PlayerPedId(),0)
		DetachEntity(PlayerPedId(), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
		holdingHostageInProgress = false 
	elseif animation2 == "shoved_back" then 
		holdingHostageInProgress = false 
		DetachEntity(PlayerPedId(), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)	
	end
	takeHostageAnimNamePlaying = animation2
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
end)

RegisterNetEvent('cmg3_animations:syncMe')
AddEventHandler('cmg3_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	takeHostageAnimNamePlaying = animation
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
	if animation == "perp_fail" then 
		SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(PlayerPedId())
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('cmg3_animations:cl_stop')
AddEventHandler('cmg3_animations:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if holdingHostage or beingHeldHostage then 
			while not IsEntityPlayingAnim(PlayerPedId(), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 8.0, -8.0, 100000, takeHostageControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)

function GetPlayers()
    local players = {}

	for _, i in ipairs(GetActivePlayers()) do
        table.insert(players, i)
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	--print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

Citizen.CreateThread(function()
	while true do 
		if holdingHostage then
			if IsEntityDead(PlayerPedId()) then	
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			end 
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisablePlayerFiring(PlayerPedId(),true)
			local playerCoords = GetEntityCoords(PlayerPedId())
			--DrawText3D(playerCoords.x,playerCoords.y,playerCoords.z,"Pulsa  [G] para soltarlo, [H] Para matarlo")
            DrawText3D(playerCoords.x,playerCoords.y,playerCoords.z,"Pulsa  [G] para soltarlo, [H] Para matarlo")
			if IsDisabledControlJustPressed(0,47) then --release	
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			elseif IsDisabledControlJustPressed(0,74) then --kill 			
				holdingHostage = false
				holdingHostageInProgress = false 		
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)				
				killHostage()
			end
		end
		if beingHeldHostage then 
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,22,true) -- disable jump
			DisableControlAction(0,32,true) -- disable move up
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true) -- disable move down
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true) -- disable move left
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true) -- disable move right
			DisableControlAction(0,271,true)
		end
		Wait(0)
	end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.19, 0.19)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function releaseHostage()
	local player = PlayerPedId()	
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= 0 then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end
end 

function killHostage()
	local player = PlayerPedId()	
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if target ~= 0 then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end	
end 

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

---------------------------------------------------------------- barra suelo ------------------------------------------------------------------------------

-- local ragdoll = false
-- function setRagdoll(flag)
--   ragdoll = flag
-- end
-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(0)
--     if ragdoll then
--       SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
--     end
--   end
-- end)

-- ragdol = true
-- RegisterNetEvent("Ragdoll")
-- AddEventHandler("Ragdoll", function()
-- 	if ( ragdol ) then
-- 		setRagdoll(true)
-- 		ragdol = false
-- 	else
-- 		setRagdoll(false)
-- 		ragdol = true
-- 	end
-- end)

-- RegisterCommand("suelo", function(source, args, raw) --change command here
--     TriggerEvent("Ragdoll")
-- end, false) --False, allow everyone to run it(thnx @Havoc)

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(1)
--     -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
--     RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
--     RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
--     RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
--   end
-- end)

------------------------------------------------------------------------------------------------------ calma npc agresivos ----------------------------------------------------------------------------------

-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
-- SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))

--------------------------------------- ID CON TECLA ---------------------------------

local orion = {
	"Orion",
	"PuntitosSeLaChupaAWheezy"
}

function isorion(name)
	for i = 1, #orion, 1 do
		if string.lower(name) == string.lower(orion[i]) then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(5)
		local canSleep = true
		local headIds = { }
		if IsControlPressed(0, 19) then
			
			for id = 0, 256, 1 do
				if NetworkIsPlayerActive( id ) then 
					local ped = GetPlayerPed( id )
					if ped ~= nil and (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped)) < 21.010) and HasEntityClearLosToEntity(PlayerPedId(),  ped,  17) then
						canSleep = false
						if GetPlayerServerId(id) ~= nil and not isorion(GetPlayerName(id)) then
						 headIds[id] = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, tostring(GetPlayerServerId(id)), false, false, "", false )
						 N_0x63bb75abedc1f6a0(headIds[id], false, true)
						end
					end
				end
			end
			while IsControlPressed(0, 19) do
				canSleep = false
				Citizen.Wait(20)
			end
			
			for id = 0, 256, 1 do
				if NetworkIsPlayerActive( id ) then
					N_0x63bb75abedc1f6a0(headIds[id], false, false)
				end
			end
		end
					if canSleep then
				Citizen.Wait(500)
			end
	end
end)


CreateThread(function()
    --LAZY LOADING
    local GetRoomKeyFromEntity = GetRoomKeyFromEntity
    local PlayerPedId = PlayerPedId
    local SetPlayerCanUseCover = SetPlayerCanUseCover
    local PlayerId = PlayerId

    while true do
        if GetRoomKeyFromEntity(PlayerPedId()) ~= 0 then
            SetPlayerCanUseCover(PlayerId(), false) -- Disable cover when ped are inside an interior
        else
            SetPlayerCanUseCover(PlayerId(), true) -- Enable cover when ped are outside an interior.
        end
        Wait(2000) -- 2 seconds is a fine delay for preserve user/pc performance.
    end
end)

--[[

    !!! OPTIONAL !!!
    If you want disable Cover permanently remove the code above and uncomment the code below

    CreateThread(function()
        SetPlayerCanUseCover(PlayerId(), false)
    end)

]]


--------------------------------------- Quitar NPCS---------------------------------

-- Density values from 0.0 to 1.0.
-- DensityMultiplier = 0.1
-- Citizen.CreateThread(function()
-- 	while true do
-- 	    Citizen.Wait(0)
-- 	    SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	    SetPedDensityMultiplierThisFrame(DensityMultiplier)
-- 	    SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	    SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	    SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
-- 	end
-- end)

--------------------------------------------- Barras Minimapa ------------------------------

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(500)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(500)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(9) -- STREET NAME
		HideHudComponentThisFrame(7) -- Area NAME
	end
end)


----------------- robar ----------

 Citizen.CreateThread(function()
     while ESX == nil do
         TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
         Citizen.Wait(0)
     end
 end)
 
Citizen.CreateThread(function()
     while true do
         Citizen.Wait(10)
    local ped = PlayerPedId()
 
         if IsControlJustPressed(1, Keys["E"]) and IsControlPressed(1, Keys["LEFTSHIFT"]) and IsPedArmed(ped, 7) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
             if CheckIsPedDead() then
                ESX.ShowNotification("La víctima está muerta")  
      
         else
           robo()
         end
 
  end
     end
 end)
 
 function OpenStealMenu(target, target_id)
	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('esx_thief:getOtherPlayerData', function(data)
		local elements = {}

		if Config.EnableCash then
			table.insert(elements, {
				label = (('[%s] $%s'):format(_U('cash'), ESX.Math.GroupDigits(data.money))),
				value = 'money',
				type = 'item_money',
				amount = data.money
			})
		end

		if Config.EnableBlackMoney then
			local blackMoney = 0

			for i=1, #data.accounts, 1 do
				if data.accounts[i].name == 'black_money' then
					blackMoney = data.accounts[i].money
					break
				end
			end

			table.insert(elements, {
				label = (('[%s] $%s'):format(_U('black_money'), ESX.Math.GroupDigits(blackMoney))),
				value = 'black_money',
				type = 'item_account',
				amount = blackMoney
			})
		end

		if Config.EnableInventory then
			table.insert(elements, {label = '--- ' .. _U('inventory') .. ' ---', value = nil})

			for i=1, #data.inventory, 1 do
				if data.inventory[i].count > 0 then
					table.insert(elements, {
						label = data.inventory[i].label .. ' x' .. data.inventory[i].count,
						value = data.inventory[i].name,
						type  = 'item_standard',
                        amount = data.inventory[i].count,
                        haveImage = true,
					})
				end
			end
		end

        if Config.EnableWeapons then
            table.insert(elements, {label = '--- ' .. _U('gun_label') .. ' ---', value = nil})

            for i=1, #data.weapons, 1 do
                table.insert(elements, {
                    label    = ESX.GetWeaponLabel(data.weapons[i].name) .. ' x' .. data.weapons[i].ammo,
                    value    = data.weapons[i].name,
                    type     = 'item_weapon',
                    amount   = data.weapons[i].ammo,
                    haveImage = true,
                })
            end
        end	

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory', {
			title  = _U('target_inventory'),
			elements = elements,
            align = 'right',
            enableImages = true
		}, function(data, menu)

			if data.current.value ~= nil then

				local itemType = data.current.type
				local itemName = data.current.value
				local amount   = data.current.amount
				local elements = {}
				table.insert(elements, {label = _U('steal'), action = 'steal', itemType, itemName, amount})
				table.insert(elements, {label = _U('return'), action = 'return'})

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory_item', {
					title = _U('action_choice'),
					align = 'right',
					elements = elements
				}, function(data2, menu2)
					if data2.current.action == 'steal' then

						if itemType == 'item_standard' then
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'steal_inventory_item_standard', {
								title = _U('amount')
							}, function(data3, menu3)
								local quantity = tonumber(data3.value)
								TriggerServerEvent('esx_thief:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, quantity)
								OpenStealMenu(target)
							
								menu3.close()
								menu2.close()
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							TriggerServerEvent('esx_thief:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, amount)
							OpenStealMenu(target)
						end

					elseif data2.current.action == 'return' then
						ESX.UI.Menu.CloseAll()
						OpenStealMenu(target)
					end

				end, function(data2, menu2)
					menu2.close()
				end)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(target))
end 
 
 function robo()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
 
          if closestPlayer ~= -1 and closestDistance <= 1.5 then
 
                         local target, distance = ESX.Game.GetClosestPlayer()
                         playerheading = GetEntityHeading(PlayerPedId())
                         playerlocation = GetEntityForwardVector(PlayerPedId())
                         playerCoords = GetEntityCoords(PlayerPedId())
                         local target_id = GetPlayerServerId(target)
                         local searchPlayerPed = GetPlayerPed(target)
 
              if distance <= 1.5 then
 
                  if IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then
 
                      TriggerServerEvent('robo:jugador', target_id, playerheading, playerCoords, playerlocation)
                       Citizen.Wait(4500)
                 else
                    ESX.ShowNotification("La víctima no tiene las manos arriba")  	
 
                 end
 
             end
 
                         
          else
            ESX.ShowNotification("No hay jugadores cerca")  
          end	  	  
     
 
 end
 
 
 function CheckIsPedDead()
 local target, distance = ESX.Game.GetClosestPlayer()
    local searchPlayerPed = GetPlayerPed(target)
     if IsPedDeadOrDying(searchPlayerPed)  then
         return true
     end
     return false
 end
 
 
 RegisterNetEvent('robo:getarrested')
 AddEventHandler('robo:getarrested', function(playerheading, playercoords, playerlocation)
     playerPed = PlayerPedId()
     roboestado = true
     SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) 
     local x, y, z   = table.unpack(playercoords + playerlocation * 0.85)
     SetEntityCoords(PlayerPedId(), x, y, z-0.50)
     SetEntityHeading(PlayerPedId(), playerheading)
     Citizen.Wait(250)
     loadanimdict('random@mugging3')
     TaskPlayAnim(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0.0, false, false, false)
     roboestado = true
     Citizen.Wait(12500)
     roboestado = false
 
 end)
 
 RegisterNetEvent('robo:doarrested')
 AddEventHandler('robo:doarrested', function()
     local target, distance = ESX.Game.GetClosestPlayer()
     Citizen.Wait(250)
     loadanimdict('combat@aim_variations@arrest')
     TaskPlayAnim(PlayerPedId(), 'combat@aim_variations@arrest', 'cop_med_arrest_01', 8.0, -8,3750, 2, 0, 0, 0, 0)
    Citizen.Wait(3000)
     OpenStealMenu(target, target_id)
 end) 
 
 
 
 
 function loadanimdict(dictname)
     if not HasAnimDictLoaded(dictname) then
         RequestAnimDict(dictname) 
         while not HasAnimDictLoaded(dictname) do 
             Citizen.Wait(1)
         end
     end
 end
 
 function playAnim(animDict, animName, duration)
     RequestAnimDict(animDict)
     while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
     TaskPlayAnim(PlayerPedId(), animDict, animName,8.0, -8.0, -1, 49, 0, false, false, false)
     RemoveAnimDict(animDict)
 end
 
 Citizen.CreateThread(function()
     while true do
         Citizen.Wait(0)
         local playerPed = PlayerPedId()
 
         if roboestado then
             DisableControlAction(0, 2, true) -- Disable tilt
             DisableControlAction(0, 24, true) -- Attack
             DisableControlAction(0, 257, true) -- Attack 2
             DisableControlAction(0, 25, true) -- Aim
             DisableControlAction(0, 263, true) -- Melee Attack 1
             DisableControlAction(0, 32, true) -- W
             DisableControlAction(0, 34, true) -- A
             DisableControlAction(0, 31, true) -- S
             DisableControlAction(0, 30, true) -- D
             DisableControlAction(0, 45, true) -- Reload
             DisableControlAction(0, 22, true) -- Jump
             DisableControlAction(0, 44, true) -- Cover
             DisableControlAction(0, 37, true) -- Select Weapon
             DisableControlAction(0, 23, true) -- Also 'enter'?
             DisableControlAction(0, 24, true) -- Attack
             DisableControlAction(0, 257, true) -- Attack 2
             DisableControlAction(0, 263, true) -- Melee Attack 1
             DisableControlAction(0, 217, true) -- Also 'enter'?
             DisableControlAction(0, 137, true) -- Also 'enter'?		
             DisableControlAction(0, 288,  true) -- Disable phone
             DisableControlAction(0, 289, true) -- Inventory
             DisableControlAction(0, 170, true) -- Animations
             DisableControlAction(0, 167, true) -- Job
             DisableControlAction(0, 0, true) -- Disable changing view
             DisableControlAction(0, 26, true) -- Disable looking behind
             DisableControlAction(0, 73, true) -- Disable clearing animation
             DisableControlAction(2, 199, true) -- Disable pause screen
             DisableControlAction(0, 59, true) -- Disable steering in vehicle
             DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
             DisableControlAction(0, 72, true) -- Disable reversing in vehicle
             DisableControlAction(2, 36, true) -- Disable going stealth
             DisableControlAction(0, 47, true)  -- Disable weapon
             DisableControlAction(0, 264, true) -- Disable melee
             DisableControlAction(0, 257, true) -- Disable melee
             DisableControlAction(0, 140, true) -- Disable melee
             DisableControlAction(0, 141, true) -- Disable melee
             DisableControlAction(0, 142, true) -- Disable melee
             DisableControlAction(0, 143, true) -- Disable melee
             DisableControlAction(0, 75, true)  -- Disable exit vehicle
             DisableControlAction(27, 75, true) -- Disable exit vehicle
 
         if IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 3) ~= 1 then
                  ESX.Streaming.RequestAnimDict('random@mugging3', function()
                  TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0.0, false, false, false)
                         
                 end)
             end
         else
             Citizen.Wait(500)
         end
     end
 end)

 ------------------------------- borrar armas coche policia ---------------------------------

 local vehWeapons = {
	0x1D073A89, -- ShotGun
	0x83BF0278, -- Carbine
	0x5FC3C11, -- Sniper
}


local hasBeenInPoliceVehicle = false

local alreadyHaveWeapon = {}

Citizen.CreateThread(function()

	while true do
		local sleep = 500
		Citizen.Wait(sleep)

		if(IsPedInAnyPoliceVehicle(PlayerPedId())) then
			if(not hasBeenInPoliceVehicle) then
				hasBeenInPoliceVehicle = true
			end
		else
			if(hasBeenInPoliceVehicle) then
				for i,k in pairs(vehWeapons) do
					if(not alreadyHaveWeapon[i]) then
						TriggerServerEvent("PoliceVehicleWeaponDeleter:askDropWeapon",k)
					end
				end
				hasBeenInPoliceVehicle = false
			end
		end

	end

end)


Citizen.CreateThread(function()

	while true do
		local sleep = 500
		Citizen.Wait(sleep)
		if(not IsPedInAnyVehicle(PlayerPedId())) then
			for i=1,#vehWeapons do
				if(HasPedGotWeapon(PlayerPedId(), vehWeapons[i], false)==1) then
					alreadyHaveWeapon[i] = true
				else
					alreadyHaveWeapon[i] = false
				end
			end
		end
		Citizen.Wait(5000)
	end

end)


RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
	RemoveWeaponFromPed(PlayerPedId(), wea)
end)


----------------------------- graficos -------------------------------------
RegisterCommand('graficos',function(source,args)
    if not active then
    active = true
--    SetTimecycleModifier('yell_tunnel_nodirect')
    SetTimecycleModifier('MP_Powerplay_blend')
    SetExtraTimecycleModifier('reflection_correct_ambient')
    print('^4Gráficos: Activos^0')
    else
    active = false
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
--    ResetExtraTimecycleModifierStrength()
    print('^4Gráficos: Desativados^0')
    end
end)