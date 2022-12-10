ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- REGISTROS

RegisterServerEvent('AGM_mechanic:getJob')
AddEventHandler('AGM_mechanic:getJob',function()
	local source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayers[i] == source then
			TriggerClientEvent('AGM_mechanic:setJob', xPlayers[i],xPlayer.job.name)
		end
	end
end)

RegisterServerEvent('AGM_mechanic:alert')
AddEventHandler('AGM_mechanic:alert', function(message, x, y, z)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'mechanic' then
			
			TriggerClientEvent('AGM_mechanic:setBlip', xPlayers[i], x, y, z)
		end
	end
end)

RegisterServerEvent('AGM_mechanic:entorno:alert')
AddEventHandler('AGM_mechanic:entorno:alert', function(message, x, y, z)
		TriggerClientEvent('AGM_mechanic:setBlip', xPlayers[i], x, y, z)
end)

RegisterServerEvent('AGM_mechanic:sendNotify')
AddEventHandler('AGM_mechanic:sendNotify', function( msg, location, pos, IdPlayer  )
	TriggerClientEvent('AGM_mechanic:sendNotify', -1, msg, location, pos, IdPlayer )
end, false)