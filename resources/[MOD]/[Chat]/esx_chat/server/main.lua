ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
	end
	while true do 
		SavedPlayers = ESX.GetPlayers()
		Wait(120000)
	end
end)




AddEventHandler('chatMessage', function(source, name, message)

	if string.sub(message, 1, string.len("/")) ~= "/" then

		local name = GetPlayerName(source)

		TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, _U('oop_prefix', source), message, { 128, 128, 128 })

	end

	CancelEvent()

end)


RegisterCommand('pol', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end
	local target = ESX.GetPlayerFromId(source)

	if target.job ~= nil and target.job.name == "police" then
		args = table.concat(args, ' ')
		local name = GetPlayerName(source)

		TriggerClientEvent('chat:addMessage', -1, { args = { _U('pol_prefix', source), args }, color = { 0, 102, 255 } })
	else
		TriggerClientEvent('esx:showNotification', source, 'No eres ~r~policia!')
	end
end, false)

RegisterCommand('a', function(source, args, rawCommand)

	if source == 0 then

		print('esx_rpchat: you can\'t use this command from rcon!')

		return

	end

	args = table.concat(args, ' ')

	local name = GetPlayerName(source)

	TriggerClientEvent('chat:addMessage', -1, { args = { _U('a_prefix', source), args }, color = {255, 162, 0} })

end, false)


RegisterCommand('me', function(source, args, user)
	local name = GetPlayerName(source)
	TriggerClientEvent("sendProximityMessageMe", -1, source, table.concat(args, " "))
end)

RegisterCommand('do', function(source, args, user)
	local name = GetPlayerName(source)
	TriggerClientEvent("sendProximityMessageDo", -1, source, table.concat(args, " "))
end)

RegisterCommand('suerte', function(source, args, rawCommand)
	if source == 0 then
		return
	end
	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	local number = math.random(1,6)
	TriggerClientEvent("sendProximityMessageSuerte", -1, source, '^6' .. '['.. source ..'] ' .. '|' .. (' Ha tirado un dado y ha sacado un: ') .. '^7' .. number)
end)

RegisterCommand('intentar', function(source, args, rawCommand)
	if source == 0 then
		return
	end
	args = table.concat(args, ' ')
	local number = math.random(1,2)
	local name = GetPlayerName(source)
	if number == 1 then
		TriggerClientEvent("sendProximityMessageIntentar", -1, source, '^6' .. '['.. source ..'] ' .. '|' .. (' Ha intentado y ha salido: ^7 Sí'))
	else
		TriggerClientEvent("sendProximityMessageIntentar", -1, source, '^6' .. '['.. source ..'] ' .. '|' .. (' Ha intentado y ha salido: ^7 No'))
	end
end)

-- RegisterCommand('suerte', function(source, args, rawCommand)
-- 	if source == 0 then
-- 		return
-- 	end
-- 	args = table.concat(args, ' ')
-- 	local number = math.random(1,6)
-- 	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, '^2' .. '['.. source ..'] ' .. '|' .. (' Ha tirado un dado y ha sacado un: ') .. number)
-- end, false)

-- RegisterCommand('intentar', function(source, args, rawCommand)
-- 	if source == 0 then
-- 		return
-- 	end
-- 	args = table.concat(args, ' ')
-- 	local number = math.random(1,2)
-- 	if number == 1 then
-- 		TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, '^2' .. '['.. source ..'] ' .. '|' .. (' Ha intentado y ha salido: No'))
-- 	else
-- 		TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, '^2' .. '['.. source ..'] ' .. '|' .. (' Ha intentado y ha salido: Sí'))
-- 	end
-- end, false)

RegisterCommand('rr', function(source, args, rawCommand)
    if source == 0 then
        print("esx_rpchat: you can't use this command from rcon!")
        return
    end

    local xLocalPlayer = ESX.GetPlayerFromId(source)
    if xLocalPlayer.job ~= nil then
        args = table.concat(args, ' ')
        local name = GetPlayerName(source)
        if Config.EnableESXIdentity then name = GetPlayerName(source) end

        if xLocalPlayer.job.name == "police" or xLocalPlayer.job.name == "ambulance" then
            for k,v in ipairs(SavedPlayers) do
                local p = ESX.GetPlayerFromId(v)
                if p.job ~= nil then
					local isValid = p.job.name == "police" or p.job.name == "ambulance"
					local Perfix
					if xLocalPlayer.job.name == "police" then Perfix = "🚔" 
				elseif xLocalPlayer.job.name == 'ambulance' then Perfix = "🚑"
				end
					if isValid then
                        TriggerClientEvent('chat:addMessage', v, { args = { _U('rpolems_prefix', name) .. " " .. Perfix, args }, color = { 255, 204, 255 } })
                    end
                end
            end
        end
	else
		TriggerClientEvent('esx:showNotification', source, 'No puedes usar esto!')
    end
end, false)

RegisterCommand('r', function(source, args, rawCommand)
    if source == 0 then
        print("esx_rpchat: you can't use this command from rcon!")
        return
    end

    local xLocalPlayer = ESX.GetPlayerFromId(source)
    if xLocalPlayer.job ~= nil then
        args = table.concat(args, ' ')
        local name = GetPlayerName(source)
		if Config.EnableESXIdentity then name = GetPlayerName(source) end
        if xLocalPlayer.job.name == "police" then
            for k,v in ipairs(SavedPlayers) do
				local p = ESX.GetPlayerFromId(v)
				local grade = xLocalPlayer.job.grade_label
                if p.job ~= nil and p.job.name == "police" then
                    TriggerClientEvent('chat:addMessage', v, { args = { _U('rpol_prefix', grade ..  " " .. name), args }, color = { 255, 197, 125 } })
                end
			end
        elseif xLocalPlayer.job.name == "ambulance" then
            for k,v in ipairs(SavedPlayers) do
				local p = ESX.GetPlayerFromId(v)
				local grade = xLocalPlayer.job.grade_label
                if p.job ~= nil and p.job.name == "ambulance" then
                    TriggerClientEvent('chat:addMessage', v, { args = { _U('rems_prefix', grade ..  " " .. name), args }, color = { 255, 0, 0 } })
                end
            end
		else
			TriggerClientEvent('esx:showNotification', source, 'No puedes usar esto!')
        end
    end
end, false)

RegisterCommand('msg', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you cant use this command from rcon!')
		return
	end
	if tonumber(args[1]) and args[2] then
		local id=tonumber(args[1])
		msg = table.concat(args, ' ', 2)
		local name =  GetPlayerName(source)
		local characterName = GetPlayerName(source)
		name = name
		local target = ESX.GetPlayerFromId(id)
		if(target ~= nil) then
			TriggerClientEvent('chat:addMessage', id, { args = { _U('msg_prefix', source.. "] " .. name), msg }, color = {0, 140, 19} })
			TriggerClientEvent('chat:addMessage', source, { args = { _U('msg_prefix', source.. "] " .. name), msg }, color = {0, 140, 19} })
		else
			TriggerClientEvent('esx:showNotification', source, "Este ID no está jugando...")
		end
	end

end, false)

RegisterCommand('pid', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end
	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.DisableESXIdentity then name = GetPlayerName(source) end
	TriggerClientEvent('chat:addMessage', -1, { args = { 'ID | ' .. name .. ' ['.. source ..']', args }, color = {255, 111, 0} })
	--print(('%s: %s'):format(name, args))
end, false)

RegisterCommand('rstaff', function(source, args, rawCommand)
    if source == 0 then
        print("esx_rpchat: you can't use this command from rcon!")
        return
	end
	
	local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'mod' then
		args = table.concat(args, ' ')
		local name = GetPlayerName(source)
		for k,v in ipairs(ESX.GetPlayers()) do
			local p = ESX.GetPlayerFromId(v)
			if p.getGroup() == "superadmin" or p.getGroup() == "admin" or p.getGroup() == "mod" then
				TriggerClientEvent('chat:addMessage', v, { args = { 'STAFF | ' .. name, args }, color = { 129, 27, 196} })
			end
        end
    end
end, false)





function GetRealPlayerName(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		if Config.EnableESXIdentity then
			if Config.OnlyFirstname then
				return xPlayer.get('firstName')
			else
				return xPlayer.getName()
			end
		else
			return xPlayer.getName()
		end
	else
		return GetPlayerName(playerId)
	end
end
