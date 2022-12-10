local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local GUI                        = {}
GUI.Time                         = 0
GUI.PoliceCadIsShowed            = false
local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
      PlayerData = ESX.GetPlayerData()
  end
  ESX.UI.Menu.RegisterType('cadsystem', OpenCadSystem, CloseCadSystem)
end)

function OpenCadSystem()
  local playerPed = PlayerPedId()
  GUI.PoliceCadIsShowed = true
  SendNUIMessage({
      showCadSystem = true,
    })
  ESX.SetTimeout(250, function()
    SetNuiFocus(true, true)
  end)
end

function CloseCadSystem()
  local playerPed = PlayerPedId()
  SendNUIMessage({
    showCadSystem = false
  })
  SetNuiFocus(false)
  GUI.PoliceCadIsShowed = false
  ClearPedTasks(playerPed)

end

RegisterNUICallback('escape', function()
  ESX.UI.Menu.Close('cadsystem', GetCurrentResourceName(), 'main')
  tablet = false
end)

RegisterNUICallback('search-plate', function(data)
  TriggerServerEvent('esx_police_cad:search-plate', data.plate)
end)

RegisterNUICallback('add-cr', function(data)
  officer = ESX.GetPlayerData(-1);
  TriggerServerEvent('esx_police_cad:add-cr', data, officer.identifier)
end)

RegisterNUICallback('add-note', function(data)
  officer = ESX.GetPlayerData(-1);
  TriggerServerEvent('esx_police_cad:add-note', data, officer.identifier)
end)

RegisterNUICallback('add-licencia', function(data)
  officer = ESX.GetPlayerData(-1);
  TriggerServerEvent('esx_police_cad:add-licencia', data, officer.identifier)
end)

RegisterNUICallback('add-photo', function(data)
  officer = ESX.GetPlayerData(-1);
  print(data.title)
  TriggerServerEvent('esx_police_cad:add-photo', data, officer.identifier)
end)

RegisterNUICallback('remove-licencia', function(data)
  officer = ESX.GetPlayerData(-1);
  TriggerServerEvent('esx_police_cad:remove-licencia', data, officer.identifier)
end)

RegisterNUICallback('add-bolo', function(data)
  TriggerServerEvent('esx_police_cad:add-bolo', data)
end)

RegisterNUICallback('get-cr', function(playerid)
  TriggerServerEvent('esx_police_cad:get-cr', playerid.playerid)
end)

RegisterNUICallback('get-bolos', function()
  TriggerServerEvent('esx_police_cad:get-bolos')
end)

RegisterNUICallback('get-note', function(playerid)
  TriggerServerEvent('esx_police_cad:get-note', playerid.playerid)
end)

RegisterNUICallback('get-photo', function(playerid)
  TriggerServerEvent('esx_police_cad:get-photo', playerid.playerid)
end)

RegisterNUICallback('delete_note', function(noteId)
  TriggerServerEvent('esx_police_cad:delete_note', noteId)
end)

RegisterNUICallback('delete_cr', function(crId)
  TriggerServerEvent('esx_police_cad:delete_cr', crId)
end)

RegisterNUICallback('delete-bolo', function(boloId)
  TriggerServerEvent('esx_police_cad:delete-bolo', boloId)
end)

RegisterNUICallback('get-license', function(playerid)
  TriggerServerEvent('esx_police_cad:get-license', playerid.playerid)
end)

RegisterNUICallback('search-players', function(data)
  TriggerServerEvent('esx_police_cad:search-players', data.search)
end)
--Coords = {
  --[1] = {x = 442.0, y = -978.89, z = 30.69},
  --[2] = {x = 447.24, y = -973.43, z = 30.69},
  --[3] = {x = 459.8, y = -988.96, z = 24.91},
--}

function ToggleTablet(toggle)
    if toggle and not tablet then
        tablet = true

        Citizen.CreateThread(function()
            RequestAnimDict(tabletDict)

            while not HasAnimDictLoaded(tabletDict) do
                Citizen.Wait(150)
            end

            RequestModel(tabletProp)

            while not HasModelLoaded(tabletProp) do
                Citizen.Wait(150)
            end

            local playerPed = PlayerPedId()
            local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
            local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

            SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
            SetModelAsNoLongerNeeded(tabletProp)

            while tablet do
                Citizen.Wait(100)
                playerPed = PlayerPedId()

                if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end
            end

            ClearPedSecondaryTask(playerPed)

            Citizen.Wait(450)

            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
        end)
    elseif not toggle and tablet then
        tablet = false 
    end
end

RegisterCommand("tabletlspd", function()
  if GUI.PhoneIsShowed then -- codes here: https://pastebin.com/guYd0ht4
    DisableControlAction(0, 1,    true) -- LookLeftRight
    DisableControlAction(0, 2,    true) -- LookUpDown
    DisableControlAction(0, 25,   true) -- Input Aim
    DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

    DisableControlAction(0, 24,   true) -- Input Attack
    DisableControlAction(0, 140,  true) -- Melee Attack Alternate
    DisableControlAction(0, 141,  true) -- Melee Attack Alternate
    DisableControlAction(0, 142,  true) -- Melee Attack Alternate
    DisableControlAction(0, 257,  true) -- Input Attack 2
    DisableControlAction(0, 263,  true) -- Input Melee Attack
    DisableControlAction(0, 264,  true) -- Input Melee Attack 2

    DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
    DisableControlAction(0, 14,   true) -- Weapon Wheel Next
    DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
    DisableControlAction(0, 16,   true) -- Select Next Weapon
    DisableControlAction(0, 17,   true) -- Select Prev Weapon
    if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({
            type = "click"
        })
    end
  else
    PlayerData = ESX.GetPlayerData()
      --if IsPedInAnyPoliceVehicle(PlayerPedId()) then
        if PlayerData.job.name == 'police' then
          if not ESX.UI.Menu.IsOpen('cadsystem', GetCurrentResourceName(), 'main') then
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('cadsystem', GetCurrentResourceName(), 'main')
            ToggleTablet(not tablet)
          end
        end
      --end
  end
end, false)

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(0)
--     local playerPed = PlayerPedId()
--     local coords = GetEntityCoords(playerPed)
--     for i=1, #Coords, 1 do
--       distance = GetDistanceBetweenCoords(coords,vector3(Coords[i].x, Coords[i].y, Coords[i].z), true)
--       if distance < 1 then
--     DrawText3Ds(Coords[i].x, Coords[i].y, Coords[i].z, "Abrir la tablet [E]")
--     if IsControlJustReleased(0, 38) then
--       PlayerData = ESX.GetPlayerData()
--       if PlayerData.job.name == 'police' then
--             if not ESX.UI.Menu.IsOpen('cadsystem', GetCurrentResourceName(), 'main') then
--               ESX.UI.Menu.CloseAll()
--               ESX.UI.Menu.Open('cadsystem', GetCurrentResourceName(), 'main')
--             end
--           end
--         end
--       end
--     end
--   end
-- end)

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
RegisterNetEvent('esx_police_cad:showdataplate')
AddEventHandler('esx_police_cad:showdataplate', function(plate,model,firstname,lastname)
        SendNUIMessage({
          plate = plate,
          model = model,
          firstname = firstname,
          lastname = lastname
        })
end)

RegisterNetEvent('esx_police_cad:showdateplateNotFound')
AddEventHandler('esx_police_cad:showdateplateNotFound', function()
        SendNUIMessage({
          plate = 'Matricula no encontrada',
          model = 'Modelo desconocido',
          firstname = '',
          lastname = ''
        })
end)

RegisterNUICallback('esx_police_cad:search-players', function(data)
  TriggerServerEvent('esx_police_cad:search-players', data.search)
end)

RegisterNetEvent('esx_police_cad:returnsearch')
AddEventHandler('esx_police_cad:returnsearch', function(results)
        SendNUIMessage({
          civilianresults = results
        })
end)

RegisterNetEvent('esx_police_cad:show-cr')
AddEventHandler('esx_police_cad:show-cr', function(results)
        SendNUIMessage({
          crresults = results
        })
end)

RegisterNetEvent('esx_police_cad:show-notes')
AddEventHandler('esx_police_cad:show-notes', function(results)
        SendNUIMessage({
          noteResults = results
        })
end)
RegisterNetEvent('esx_police_cad:show-photo')
AddEventHandler('esx_police_cad:show-photo', function(results)
        SendNUIMessage({
          photoFinish = results
        })
end)

RegisterNetEvent('esx_police_cad:show-license')
AddEventHandler('esx_police_cad:show-license', function(results)
		if results == 0 then
          results = "No tienes licencias"
        end
        if results == 1 then
          results = "Armas"
        end
        if results == 2 then
          results = "Vuelo"
        end
        if results == 3 then
          results = "Armas + Caza"
        end
        if results == 4 then
          results = "Armas + Vuelo"
        end
        if results == 5 then
          results = "Armas + Caza + Vuelo"
        end
        SendNUIMessage({
          licenseResults = results
        })
end)

AddEventHandler('esx_police_cad:show-notes', function(results)
        SendNUIMessage({
          noteResults = results
        })
end)

RegisterNetEvent('esx_police_cad:note_deleted')
AddEventHandler('esx_police_cad:note_deleted', function()
        SendNUIMessage({
          note_deleted = true
        })
end)

RegisterNetEvent('esx_police_cad:note_not_deleted')
AddEventHandler('esx_police_cad:note_not_deleted', function()
        SendNUIMessage({
           note_not_deleted = true
        })
end)

RegisterNetEvent('esx_police_cad:cr_deleted')
AddEventHandler('esx_police_cad:cr_deleted', function()
        SendNUIMessage({
            cr_deleted = true
        })
end)

RegisterNetEvent('esx_police_cad:cr_not_deleted')
AddEventHandler('esx_police_cad:cr_not_deleted', function()
        SendNUIMessage({
            cr_not_deleted = true
        })
end)

RegisterNetEvent('esx_police_cad:show-bolos')
AddEventHandler('esx_police_cad:show-bolos', function(results)
        SendNUIMessage({
          showBolos = results
        })
end)

RegisterNetEvent('esx_police_cad:bolo-deleted')
AddEventHandler('esx_police_cad:bolo-deleted', function()
        SendNUIMessage({
          bolo_deleted = true
        })
end)

RegisterNetEvent('esx_police_cad:note_not_deleted')
AddEventHandler('esx_police_cad:bolo-not-deleted', function()
        SendNUIMessage({
           bolo_not_deleted = true
        })
end)