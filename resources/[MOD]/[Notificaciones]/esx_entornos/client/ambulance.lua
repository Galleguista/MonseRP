ESX = nil
blip = nil
oldblip = nil
blips = {}
local target = {}


Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
  end
end)

AddEventHandler('playerSpawned', function(spawn)
  TriggerServerEvent('AGM_ambulance:getJob')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    TriggerServerEvent('AGM_ambulance:getJob')
end)

TriggerServerEvent('AGM_ambulance:getJob')

RegisterNetEvent('AGM_ambulance:setJob')
AddEventHandler('AGM_ambulance:setJob',function(theJob)
    job = theJob
end)

        
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/auxilio', 'Obligatorio para hacer rol de entorno')
end)


RegisterNetEvent('AGM_ambulance:auxilio:sendNotify')
AddEventHandler('AGM_ambulance:auxilio:sendNotify', function( msg, location, pos )
  if job == 'ambulance' then 
    target.pos = pos
    print(json.encode(target.pos))
    coords = GetEntityCoords(PlayerPedId())
    dist = CalculateTravelDistanceBetweenPoints(coords.x, coords.y, coords.z, target.pos.x, target.pos.y, target.pos.z) / 1000
    TriggerEvent("AGM_Notify:SetQueueMax", "forzar", 5)                                                                                                                    
    TriggerEvent('AGM_Notify:SendNotification',{text = "Auxilio  </br> Motivivo: "..msg.."  </br> Ubicación:  "..location.." </br>  Distancia: "..dist.." Km </br> <p> </p><b style='color:#3efe00'>[E Aceptar] </b> <b style='color:#fe0000'>[Q Denegar] </b>", 
    timeout = 15000,
      type = "error",
      progressBar = true,
      layout     = "centerRight",
      animation = {
        open = "gta_effects_fade_in",
        close = "gta_effects_fade_out"
      }
    })
  end  
end)



RegisterNetEvent('AGM_ambulance:setBlip')
AddEventHandler('AGM_ambulance:setBlip', function(x, y, z)


    contador = 6000

    auxilio_llamada = true 
    Citizen.CreateThread(function()
      blipPos = vector3(x, y, z)
      blip = AddBlipForCoord(x, y, z)
      SetBlipSprite(blip, Config['Ambulance'].SetBlipSprite)
      SetBlipScale(blip, Config['Ambulance'].SetBlipScale)
      SetBlipColour(blip, Config['Ambulance'].SetBlipColour)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(Config['Ambulance'].TextBlip )
      EndTextCommandSetBlipName(blip)
      table.insert(blips, blip)

      activarcontador = true
      
      
    while auxilio_llamada do
      if IsControlJustReleased(1, 38) then
        TriggerEvent("AGM_Notify:SendNotification", {
          text = 'Has aceptado la llamada',
          type = "error",
          timeout = 3000,
          layout = "centerRight",
          queue = "forzar"
        })
        
        activarcontador2 = true
        auxilio_llamada = false
        TriggerEvent('AGM_ambulance:remblip', blip)
        SetNewWaypoint(tonumber(x), tonumber(y))
      elseif IsControlJustReleased(1, 44) then
      
        TriggerEvent("AGM_Notify:SendNotification", {
          text = 'Has rechazado la llamada',
          type = "error",
          timeout = 3000,
          layout = "centerRight",
          queue = "forzar"
        })
        
        auxilio_llamada = false
        blipPos = nil  
        RemoveBlip(blip)
      end

      contador = contador - 1
      if contador <= 0 then
        auxilio_llamada = false 
        RemoveBlip(blip)
      end
      Citizen.Wait(0)
    end 

  end)
end)

RegisterNetEvent('AGM_ambulance:remblip')
AddEventHandler('AGM_ambulance:remblip', function(blip)
  local newblip = blip
  Wait(120)
  RemoveBlip(newblip)
end)

Citizen.CreateThread(function()
  local contador2 = 10
  while activarcontador2 == true do
    print ('activado')
    Citizen.Wait(120)
    if contador2 <= 0 then
      blipPos = nil 
      RemoveBlip(blip)
      activarcontador2 = false
    else
      contador2 = contador2 - 1
      print (contador2)
    end
  end 
end)


RegisterCommand('auxilio', function(source, args)
  local IdPlayer = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
  local playername = GetPlayerName(PlayerId())
  local ped = GetPlayerPed(PlayerId())
  local x, y, z = table.unpack(GetEntityCoords(ped, true))
  local street = GetStreetNameAtCoord(x, y, z)
  local location = GetStreetNameFromHashKey(street)
  local msg = table.concat(args, ' ')
  local pos = GetEntityCoords(PlayerPedId())

  if args[1] == nil then
    TriggerEvent('chatMessage', '[^1AUXILIO^0]', {255,255,255}, ' Escribe el motivo de la llamada.')
  else
    TriggerEvent('chatMessage', '[^1AUXILIO^0]', {255,255,255}, ' Has enviado un auxilio.')
    TriggerServerEvent('AGM_ambulance:auxilio:sendNotify', msg, location, pos, IdPlayer)
    TriggerServerEvent('AGM_ambulance:alert', message, x, y, z)
  end
end)