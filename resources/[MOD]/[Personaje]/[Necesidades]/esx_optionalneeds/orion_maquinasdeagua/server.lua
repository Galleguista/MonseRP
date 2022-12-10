

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('orion_maquinasdeagua:refillThirst')
AddEventHandler('orion_maquinasdeagua:refillThirst', function()
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
end)