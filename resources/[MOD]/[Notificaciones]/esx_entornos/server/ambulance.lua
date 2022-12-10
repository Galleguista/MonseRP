ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- REGISTROS

RegisterServerEvent('AGM_ambulance:getJob')
AddEventHandler('AGM_ambulance:getJob',function()
	local source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayers[i] == source then
			TriggerClientEvent('AGM_ambulance:setJob', xPlayers[i],xPlayer.job.name)
		end
	end
end)

RegisterServerEvent('AGM_ambulance:alert')
AddEventHandler('AGM_ambulance:alert', function(message, x, y, z)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'ambulance' then
			
			TriggerClientEvent('AGM_ambulance:setBlip', xPlayers[i], x, y, z)
		end
	end
end)

RegisterServerEvent('AGM_ambulance:entorno:alert')
AddEventHandler('AGM_ambulance:entorno:alert', function(message, x, y, z)
		TriggerClientEvent('AGM_ambulance:setBlip', xPlayers[i], x, y, z)
end)

RegisterServerEvent('AGM_ambulance:auxilio:sendNotify')
AddEventHandler('AGM_ambulance:auxilio:sendNotify', function( msg, location, pos, IdPlayer  )
	TriggerClientEvent('AGM_ambulance:auxilio:sendNotify', -1, msg, location, pos, IdPlayer )
end, false)