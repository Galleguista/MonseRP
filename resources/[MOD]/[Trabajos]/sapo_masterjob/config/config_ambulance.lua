Config.Marker                     = { type = 1, x = 1.0, y = 1.0, z = 0.3, r = 255, g = 0, b = 0, a = 130, rotate = false }

Config.ReviveReward               = 700  -- recompensa por revivir, establézcala en 0 si no quiere que esté habilitada
Config.AntiCombatLog              = true
Config.LoadIpl                    = false

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 1 * minute  -- Tiempo hasta que la reaparición esté disponible
Config.BleedoutTimer              = 10 * minute -- Tiempo hasta que el jugador decsangra

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Deja que el jugador pague por reaparecer temprano, solo si puede permitírselo.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(316.06, -584.34, 42.80), heading = 331.05 }

Config.SpawnPointsVehicles = {coords = vector3(295.98, -607.06, 42.22), heading = 71.25, radius = 10.0}
Config.SpawnPointsHelicopters = {coords = vector3(351.19, -588.39, 73.06), heading = 251.33, radius = 10.0}

Config.HospitalBlip = {x = 299.53, y = -584.77, z = 28.67}

Config.Hospitals = {

	CentralLosSantos = {

		AmbulanceActions = {
			vector3(301.59, -599.27, 42.32)
		},

		BossActions = {
			vector3(334.92, -593.3, 42.32)
		},

		Pharmacies = {
			vector3(309.57, -568.59, 42.30)
		},

		Vehicles = {
			{
				Spawner = vector3(294.89, -601.05, 42.4),
				Delete = vector3(295.97, -607.05, 42.30),
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.3, r = 255, g = 0, b = 0, a = 130, rotate = true }				
			}
		},

		Helicopters = {
			{
				Spawner = vector3(338.52, -587.63, 73.17),
				Delete = vector3(351.19, -588.39, 73.06),
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.3, r = 255, g = 0, b = 0, a = 130, rotate = true }
			}
		},

		FastTravels = {
			{
                From = vector3(329.9, -601.02, 42.30),
                To = { coords = vector3(338.67, -584.69, 74.19), heading = 249.99 },
                Marker = { type = 1, x = 1.0, y = 1.0, z = 0.3, r = 255, g = 0, b = 0, a = 130, rotate = false }
            },
            {
                From = vector3(339.2, -583.31, 73.19),
                To = { coords = vector3(331.94, -595.47, 42.30), heading = 75.54 },
                Marker = { type = 1, x = 1.0, y = 1.0, z = 0.3, r = 255, g = 0, b = 0, a = 130, rotate = false }
            },

        },
	}
}

Config.AuthorizedVehiclesA = {
		{ model = 'ambulance', label = 'Ambulancia', price = 1},
		{ model = 'firetruk', label = 'Camión de Bomberos', price = 1}

}

Config.AuthorizedHelicoptersA = {
	{ model = 'polmav', label = 'Helicoptero LSMC', price = 10000 }

}
