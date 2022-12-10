Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.3 }
Config.MarkerColor                = { r = 255, g = 0, b = 0 }

Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true
Config.EnableNonFreemodePeds      = true
Config.EnableLicenses             = true

Config.EnableHandcuffTimer        = true
Config.HandcuffTimer              = 10 * 60000

Config.EnableJobBlip              = true

Config.SpawnPointsVehiclesP = {coords = vector3(451.3955, -982.276, 25.699), heading = 90.0, radius = 10.0}
Config.SpawnPointsHelicoptersP = {coords = vector3(449.5, -981.2, 43.6), heading = 92.5, radius = 10.0}

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(461.77, -999.44, 29.68)
		},

		Armories = {
			vector3(482.3933, -996.839, 29.699)
		},
		Vehicles = {
			{
				Spawner = vector3(458.9362, -992.613, 24.699)
			}
		},

		VehicleDeleters = {
			vector3(436.39, -975.84, 24.81),
		},

		helicoptersdeleter = {
			vector3(449.85, -981.1, 42.8)
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 42.6)
			}
		},

		BossActions = {
			vector3(475.39, -1015.14, 26.27)
		}

	}

}

Config.AuthorizedWeaponsP = {

    Shared = {
    	{ weapon = 'WEAPON_FLASHLIGHT',          price = 10 },
		{ weapon = 'WEAPON_NIGHTSTICK',    price = 10 },
		{ weapon = 'WEAPON_STUNGUN',    price = 10 },
	  { weapon = 'WEAPON_COMBATPISTOL',     price = 10 },
	  { weapon = 'WEAPON_PISTOL',     price = 10 },       
	  { weapon = 'weapon_pumpshotgun',     price = 10 },
	  { weapon = 'weapon_pumpshotgun',     price = 10 },
      { weapon = 'weapon_machinepistol',	price = 10 },
      { weapon = 'weapon_smg', price = 10 },
	  { weapon = 'weapon_carbinerifle',     price = 10},
	  { weapon = 'WEAPON_SPECIALCARBINE',     price = 10},        
	  { weapon = 'weapon_sniperrifle',        price = 10 },
	  { weapon = 'weapon_AssaultSMG',        price = 10 },
    }
}	

Config.AuthorizedVehiclesP = {
	{ model = 'police', label = 'Patrulla', price = 1}
}	

Config.AuthorizedHelicoptersP = {
	{ model = 'polmav', label = 'Helicoptero', price = 10000 }
}