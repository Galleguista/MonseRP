-------------------------------AMBULANCE-----------------------------------
Config.EUPOutFitsCategoriesA = {
    ['LSMD'] = { jobs = { 'ambulance' } },
}

Config.EUPOutFitsA = {
    ['Socorrista'] = {
        category = 'LSMD',
        ped = 'mp_m_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 16, 1 },  --torso
			{ 3, 16, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 15, 2 }, --pantalones
			{ 6, 17, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    },
    ['Conjunto A'] = {
        category = 'LSMD',
        ped = 'mp_m_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 14, 1 },  --torso
			{ 3, 12, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    },
    ['Conjunto A Femenino'] = {
        category = 'LSMD',
        ped = 'mp_f_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 28, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    },
    ['Socorrista Femenina'] = {
        category = 'LSMD',
        ped = 'mp_f_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 1 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 16, 1 },  --torso
			{ 3, 16, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 16, 1 }, --pantalones
			{ 6, 17, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    },
}
-------------------------------MECHANIC------------------------------------
Config.EUPOutFitsCategoriesM = {
	['Bennys'] = { jobs = { 'mechanic' } },
}

Config.EUPOutFitsM = {
	['Formal'] = {
		category = 'Bennys',
		ped = 'mp_m_freemode_01',
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 30, 1 },  --torso
			{ 3, 13, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 33, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Formal Femenino'] = {
		category = 'Bennys',
		ped = 'mp_f_freemode_01',
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 8, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 38, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Conjunto A'] = {
		category = 'Bennys',
		ped = 'mp_m_freemode_01',
		props = {
			{ 0, 46, 2 }, --casco
			{ 1, 0, 1 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 66, 3 },  --torso
			{ 3, 67, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 40, 3 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Conjunto A Femenino'] = {
		category = 'Bennys',
		ped = 'mp_f_freemode_01',
		props = {
			{ 0, 45, 2 }, --casco
			{ 1, 0, 1 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 60, 3 },  --torso
			{ 3, 74, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 40, 3 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
}
-------------------------------POLICE--------------------------------------
Config.EUPOutFitsCategoriesP = {
	['LSPD'] = { jobs = { 'police' } }
}

Config.EUPOutFitsP = {
	['Conjunto Moto'] = {
		category = 'LSPD',
		ped = 'mp_m_freemode_01',
		armor = 0,
		props = {
			{ 0, 40, 1 }, --casco
			{ 1, 25, 3 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 56, 1 },  --torso
			{ 3, 20, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Antidisturbios'] = {
		category = 'LSPD',
		ped = 'mp_m_freemode_01',
		armor = 100,
		props = {
			{ 0, 126, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 56, 1 },  --torso
			{ 3, 20, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 32, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 17, 3 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Chaleco en Patrullaje'] = {
		category = 'LSPD',
		ped = 'mp_m_freemode_01',
		armor = 100,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 56, 1 },  --torso
			{ 3, 20, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 11, 2 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Conjunto Moto Femenino'] = {
		category = 'LSPD',
		ped = 'mp_f_freemode_01',
		armor = 0,
		props = {
			{ 0, 39, 1 }, --casco
			{ 1, 27, 3 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 49, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Antidisturbios Femenino'] = {
		category = 'LSPD',
		ped = 'mp_f_freemode_01',
		armor = 100,
		props = {
			{ 0, 125, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 49, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 19, 3 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Chaleco en Patrullaje Femenino'] = {
		category = 'LSPD',
		ped = 'mp_f_freemode_01',
		armor = 100,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 49, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 7, 2 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Formal Femenino'] = {
		category = 'LSPD',
		ped = 'mp_f_freemode_01',
		armor = 0,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 8, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 38, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Formal'] = {
		category = 'LSPD',
		ped = 'mp_m_freemode_01',
		armor = 0,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 30, 1 },  --torso
			{ 3, 13, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 33, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Patrullaje'] = {
		category = 'LSPD',
		ped = 'mp_m_freemode_01',
		armor = 0,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 56, 1 },  --torso
			{ 3, 20, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 26, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
	['Patrullaje Femenino'] = {
		category = 'LSPD',
		ped = 'mp_f_freemode_01',
		armor = 0,
		props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 49, 1 },  --torso
			{ 3, 15, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 4, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
	},
}
------------------------------GARBAGE--------------------------------------
Config.EUPOutFitsCategoriesG = {
    ['Basurero'] = { jobs = { 'garbage' } },
}

Config.EUPOutFitsG = {
    ['Conjunto A'] = {
        category = 'Basurero',
        ped = 'mp_m_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 1, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 58, 1 },  --torso
			{ 3, 64, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 16, 1 }, --camsitetas
			{ 4, 37, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    },
    ['Conjunto A Femenino'] = {
        category = 'Basurero',
        ped = 'mp_f_freemode_01',
        props = {
			{ 0, 0, 1 }, --casco
			{ 1, 0, 2 }, --gafas
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
		components = {
			{ 1, 1, 1 },
			{ 11, 51, 1 },  --torso
			{ 3, 82, 1 },  -- brazos
			{ 10, 1, 1 }, -- pegatinas
			{ 8, 3, 1 }, --camsitetas
			{ 4, 36, 1 }, --pantalones
			{ 6, 25, 1 }, --zapatos
			{ 7, 1, 1 }, --cadena
			{ 9, 1, 1 }, --chaleco
			{ 5, 1, 1 }, --mochila
		}
    }
}
------------------------------GOPOSTAL--------------------------------------
Config.UniformsGo = { 
	
	male = {
		['tshirt_1'] = 15,  ['tshirt_2'] = 0,
		['torso_1'] = 95,   ['torso_2'] = 1,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 11,
		['pants_1'] = 35,   ['pants_2'] = 0,
		['shoes_1'] = 32,   ['shoes_2'] = 1,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0,
		['ears_1'] = -1,     ['ears_2'] = 0
	},
	female = {
		['tshirt_1'] = 34,  ['tshirt_2'] = 0,
		['torso_1'] = 9,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 9,
		['pants_1'] = 6,   ['pants_2'] = 2,
		['shoes_1'] = 52,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 2,
		['ears_1'] = -1,     ['ears_2'] = 0
	}
}