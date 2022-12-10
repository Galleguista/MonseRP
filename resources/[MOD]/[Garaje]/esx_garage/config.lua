Config = {}

Config.RangeCheck = 25.0 

Config.Garages = {


    ["B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(273.67422485352, -344.15573120117, 43.95)
            },
            ["vehicle"] = {
                ["position"] = vector3(272.50082397461, -337.40579223633, 43.93), 
                ["heading"] = 160.0
            }
        },
        ["camera"] = { 
            ["x"] = 283.28225708008, 
            ["y"] = -333.24017333984, 
            ["z"] = 50.004745483398, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 125.73228356242 
        }
    },


["E"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(1737.83, 3709.53, 33.17)
        },
        ["vehicle"] = {
            ["position"] = vector3(1724.19, 3712.04, 33.26), 
            ["heading"] = 19.67
        }
    }
	
   },


  ["F"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(146.5, 6366.51, 30.55)
        },
        ["vehicle"] = {
            ["position"] = vector3(138.44, 6362.35, 30.39), 
            ["heading"] = 30.85
        }
    }

   
 },
 

["H"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(-1185.25, -1508.09, 3.40)
        },
        ["vehicle"] = {
            ["position"] = vector3(-1177.03, -1482.25, 3.40), 
            ["heading"] = 213.23
        }
    }

},


["I"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(1036.15, -763.19, 57.0)
        },
        ["vehicle"] = {
            ["position"] = vector3(1038.06, -790.83, 57.0), 
            ["heading"] = 359.98
        }
    },
    ["camera"] = {  
        ["x"] = 1034.76, 
        ["y"] = -775.17, 
        ["z"] =  62.7, 
        ["rotationX"] = -35.401574149728, 
        ["rotationY"] = 0.0, 
        ["rotationZ"] = 180.40157422423 
    } 
  
},


["A"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(215.3, -809.8, 29.76)
        },
        ["vehicle"] = {
            ["position"] = vector3(231.39, -796.11, 29.59), 
            ["heading"] = 157.27
        }
    },
    
    ["camera"] = { 
        ["x"] = 231.94, 
        ["y"] = -803.61, 
        ["z"] = 32.51, 
        ["rotationX"] = -30.401574149728, 
        ["rotationY"] = 00.0, 
        ["rotationZ"] = 0.75157422423 
    } 
}, 


["P"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(362.3, 298.66, 102.90)
        },
        ["vehicle"] = {
            ["position"] = vector3(377.49, 288.45, 102.20), 
            ["heading"] = 72.26
        }
    } 

},


["Q"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(-330.02, -780.25, 32.98)
        },
        ["vehicle"] = {
            ["position"] = vector3(-334.69, -750.6, 32.99), 
            ["heading"] = 180.79
        }
    } 
},


["S"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(46.66, -1749.71, 28.65)
        },
        ["vehicle"] = {
            ["position"] = vector3(48.91, -1740.79, 28.30), 
            ["heading"] = 49.47
        }
    } 
},

["S"] = {
    ["positions"] = {
        ["menu"] = {
            ["position"] = vector3(950.57, -1740.54, 30.19)
        },
        ["vehicle"] = {
            ["position"] = vector3(959.38, -1746.44, 30.23), 
            ["heading"] = 182.02
        }
    } 
},


    ["Aircraft"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1234.2, -3380.18, 12.96),
                ["text"] = "[ E ] Garaje",
            },
            ["vehicle"] = {
                ["position"] = vector3(-1275.560, -3388.017, 12.99), 
                ["heading"] = 328.940,
                ["text"] = "[ E ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -1301.229, 
            ["y"] = -3385.397, 
            ["z"] = 24.265, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -87.73228356242 
        }
    },
}


Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
 	end
end

Config.AlignMenu = "right" 