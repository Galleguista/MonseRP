function DeleteJobVehicle()
	local playerPed = PlayerPedId()
	vehicle = GetVehiclePedIsIn(playerPed, false)
	ESX.Game.DeleteVehicle(vehicle)
end