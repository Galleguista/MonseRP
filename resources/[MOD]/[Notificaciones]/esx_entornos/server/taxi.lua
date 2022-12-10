ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- REGISTROS

RegisterServerEvent('AGM_taxi:getJob')
AddEventHandler('AGM_taxi:getJob',function()
	local source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayers[i] == source then
			TriggerClientEvent('AGM_taxi:setJob', xPlayers[i],xPlayer.job.name)
		end
	end
end)

RegisterServerEvent('AGM_taxi:alert')
AddEventHandler('AGM_taxi:alert', function(message, x, y, z)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'taxi' then
			
			TriggerClientEvent('AGM_taxi:setBlip', xPlayers[i], x, y, z)
		end
	end
end)

RegisterServerEvent('AGM_taxi:entorno:alert')
AddEventHandler('AGM_taxi:entorno:alert', function(message, x, y, z)
		TriggerClientEvent('AGM_taxi:setBlip', xPlayers[i], x, y, z)
end)

RegisterServerEvent('AGM_taxi:sendNotify')
AddEventHandler('AGM_taxi:sendNotify', function( msg, location, pos, IdPlayer  )
	TriggerClientEvent('AGM_taxi:sendNotify', -1, msg, location, pos, IdPlayer )
end, false)
