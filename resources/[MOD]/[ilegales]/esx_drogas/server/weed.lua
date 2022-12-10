local playersProcessingCannabis = {}

RegisterServerEvent('sapo_drogas:pickedUpCannabis')
AddEventHandler('sapo_drogas:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.addInventoryItem('cannabis', 1)
	
end)

RegisterServerEvent('sapo_drogas:processCannabis')
AddEventHandler('sapo_drogas:processCannabis', function()
	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

			
			xPlayer.removeInventoryItem('cannabis', 2)
			xPlayer.addInventoryItem('marijuana', 1)

			TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
			

			playersProcessingCannabis[_source] = nil
		end)
	else
	--	print(('sapo_drogas: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('sapo_drogas:cancelProcessing')
AddEventHandler('sapo_drogas:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
