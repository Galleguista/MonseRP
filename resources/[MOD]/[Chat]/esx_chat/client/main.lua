RegisterNetEvent('esx_rpchat:sendProximityMessage')
AddEventHandler('esx_rpchat:sendProximityMessage', function(playerId, title, message, color)
	local player = PlayerId()
	local target = GetPlayerFromServerId(playerId)
    if Config.EnableOneSyncInfinity and target == -1 then
        return
    end

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(target)
	local playerCoords = GetEntityCoords(playerPed)
	local targetCoords = GetEntityCoords(targetPed)

	if target == player or #(playerCoords - targetCoords) < 20 then
		TriggerEvent('chat:addMessage', {args = {title, message}, color = color})
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/twt',  _U('twt_help'),  {{name = _U('generic_argument_name'), help = _U('generic_argument_help')}})
	TriggerEvent('chat:addSuggestion', '/anontwt',  _U('twtanon_help'),  {{name = _U('generic_argument_name'), help = _U('generic_argument_help')}})
	TriggerEvent('chat:addSuggestion', '/me',   _U('me_help'),   {{name = _U('generic_argument_name'), help = _U('generic_argument_help')}})
	TriggerEvent('chat:addSuggestion', '/do',   _U('do_help'),   {{name = _U('generic_argument_name'), help = _U('generic_argument_help')}})
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('chat:removeSuggestion', '/twt')
		TriggerEvent('chat:removeSuggestion', '/me')
		TriggerEvent('chat:removeSuggestion', '/do')
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 26, 0.3); margin: 1px; size : 10px; background-color: rgba(255, 0, 0, 0.2); border-radius: 3px;"><i class="fas fa-user"></i> ^1[{0}] Me : ^0{1}</div>',
            args = { id, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.9 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 26, 0.3); margin: 1px; size : 10px; background-color: rgba(255, 0, 0, 0.2); border-radius: 3px;"><i class="fas fa-user"></i> ^1[{0}] Me : ^0{1}</div>',
            args = { id, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(36, 33, 234, 0.7); margin: 1px; background-color: rgba(17, 14, 193, 0.2); border-radius: 3px;"><i class="fas fa-user"></i> ^4[{0}] Do : ^0{1}</div>',
            args = { id, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.9 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(36, 33, 234, 0.7); margin: 1px; background-color: rgba(17, 14, 193, 0.2); border-radius: 3px;"><i class="fas fa-user"></i> ^4[{0}] Do : ^0{1}</div>',
            args = { id, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageSuerte')
AddEventHandler('sendProximityMessageSuerte', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 217, 0.7); margin: 1px; background-color: rgba(166, 6, 164, 0.2); border-radius: 3px;"><i class="fas fa-user"></i>^0{1}</div>',
            args = { id, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.9 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 217, 0.7); margin: 1px; background-color: rgba(166, 6, 164, 0.2); border-radius: 3px;"><i class="fas fa-user"></i>^0{1}</div>',
            args = { id, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageIntentar')
AddEventHandler('sendProximityMessageIntentar', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 217, 0.7); margin: 1px; background-color: rgba(166, 6, 164, 0.2); border-radius: 3px;"><i class="fas fa-user"></i>^0{1}</div>',
            args = { id, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.9 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 2px; border: 2px solid rgba(220, 26, 217, 0.7); margin: 1px; background-color: rgba(166, 6, 164, 0.2); border-radius: 3px;"><i class="fas fa-user"></i>^0{1}</div>',
            args = { id, message }
        })
    end
end)