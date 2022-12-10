ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)



--ALCHOOl
--Cerveza

ESX.RegisterUsableItem('beer', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('beer', 1)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'drunk', 25000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_beer'))

end)
--Absenta
ESX.RegisterUsableItem('absinthe', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('absinthe', 1)
    TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
    TriggerClientEvent('esx_status:add', source, 'drunk', 35000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_absinthe'))
end)

--Especialidad del camarero

ESX.RegisterUsableItem('metreshooter', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('metreshooter', 1)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'drunk', 55000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_metreshooter'))
end)


--Champan 
ESX.RegisterUsableItem('champagne', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('champagne', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
    TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_champagne'))
end)


--Gintonic
ESX.RegisterUsableItem('gintonic', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gintonic', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 37000)
    TriggerClientEvent('esx_status:remove', source, 'stress', 37000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_gintonic'))
end)
--jager
ESX.RegisterUsableItem('jager', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jager', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_jager'))
end)

--jagerbomb
ESX.RegisterUsableItem('jagerbomb', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jagerbomb', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_jagerbomb'))
end)


--JagerCerberus
ESX.RegisterUsableItem('jagercerbere', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jagercerbere', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_jagercerbere'))
end)
--martini
ESX.RegisterUsableItem('martini', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('martini', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_martini'))
end)
--Mojito
ESX.RegisterUsableItem('mojito', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('mojito', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_mojito'))
end)
--Ron
ESX.RegisterUsableItem('rhum', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('rhum', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_rhum'))
end)

--Ron cocacola
ESX.RegisterUsableItem('rhumcoca', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('rhumcoca', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_rhumcoca'))
end)

--Ron Fruta
ESX.RegisterUsableItem('rhumfruit', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('rhumfruit', 1)
     TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
      TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_rhumfruit'))
end)
--tequila
ESX.RegisterUsableItem('tequila', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('tequila', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 35000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_tequila'))
end)
--Chupito tequila
ESX.RegisterUsableItem('tequila', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('tequila', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_tequila'))
end)

--Vino
ESX.RegisterUsableItem('vino', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vino', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 20000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_vino'))
end)

--Vodka

ESX.RegisterUsableItem('vodka', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vodka', 1)
     TriggerClientEvent('esx_status:add', source, 'drunk', 28000)
      TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_vodka'))
end)

--whisky
ESX.RegisterUsableItem('whisky', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('whisky', 1)
     TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
      TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
   TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_whisky'))
end)

--whiskycoca

ESX.RegisterUsableItem('whiskycoca', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('whiskycoca', 1)
    TriggerClientEvent('esx_status:add', source, 'drunk', 30000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 53000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_whiskycoca'))
end)
--Tequila chupito que quiero tomarme contigo 1000
ESX.RegisterUsableItem('teqpaf', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('teqpaf', 1)
    TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
     TriggerClientEvent('esx_status:remove', source, 'stress', 20000)
    TriggerClientEvent('esx_status:add', source, 'drunk', 35000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    xPlayer.showNotification(_U('used_teqpaf'))
end)