Config = {}
Config.Locale = 'es'

Config.Price = 50

Config.DrawDistance = 5.0
Config.MarkerSize   = {x = 1.3, y = 1.3, z = 0.2}
Config.MarkerColor  = {r = 255, g = 0, b = 0}
Config.MarkerType   = 1

Config.Zones = {}

Config.Shops = {
  {x=72.254,    y=-1399.102, z=28.45},
  {x=-703.776,  y=-152.258,  z=36.425},
  {x=-167.863,  y=-298.969,  z=38.743},
  {x=428.694,   y=-800.106,  z=28.500},
  {x=-829.413,  y=-1073.710, z=10.340},
  {x=-1447.797, y=-242.461,  z=48.830},
  {x=11.632,    y=6514.224,  z=30.887},
  {x=123.646,   y=-219.440,  z=53.557},
  {x=1696.291,  y=4829.312,  z=41.070},
  {x=618.093,   y=2759.629,  z=41.088},
  {x=1190.550,  y=2713.441,  z=37.230},
  {x=-1193.429, y=-772.262,  z=16.330},
  {x=-3172.496, y=1048.133,  z=19.870},
  {x=-1108.441, y=2708.923,  z=18.115},
  -- {x=476.34, y=-981.92, z=29.69},
}

for i=1, #Config.Shops, 1 do

	Config.Zones['Shop_' .. i] = {
	 	Pos   = Config.Shops[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end
