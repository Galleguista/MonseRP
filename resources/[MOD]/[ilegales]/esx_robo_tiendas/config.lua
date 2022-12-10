Config = {}
Translation = {}

Config.Shopkeeper = 416176080
Config.Locale = 'es'
Config.MaxSimultaneusRobs = 3
Config.MinCoolDownMinutes = 30
Config.MaxCoolDownMinutes = 60
Config.CivilianLimitMinutes = 5 * 60

Config.Shops = {
    {coords = vector3(24.45, -1344.98, 29.5-0.98), heading = 266.92, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-1222.06, -908.35, 12.33-0.98), heading = 35.05, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-46.81, -1758.01, 29.42-0.98), heading = 45.6, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-3040.25, 583.98, 7.91-0.98), heading = 266.0, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-3243.45, 999.97, 12.83-0.98), heading = 266.0, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1164.75, -322.79, 69.21-0.98), heading = 95.84, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1134.18, -982.51, 46.42-0.98), heading = 274.89, money = {5000, 8000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-1819.98, 794.31, 138.09-0.98), heading = 139.15, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(372.58, 326.37, 103.57-0.98), heading = 266.0, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-2966.02, 390.85, 15.04-0.98), heading = 85.6, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-1486.2, -377.88, 40.16-0.98), heading = 131.77, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(549.39, 2669.01, 42.16-0.98), heading = 93.51, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1392.87, 3606.39, 34.98-0.98), heading = 198.71, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1165.84, 2710.81, 38.16-0.98), heading = 180.97, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(2676.06, 3280.52, 55.24-0.98), heading = 332.88, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1958.94, 3741.99, 32.34-0.98), heading = 295.51, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1698.03, 4922.94, 42.06-0.98), heading = 320.8, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(1728.92, 6417.3, 35.04-0.98), heading = 238.0, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(2554.81, 380.89, 108.62-0.98), heading = 355.1, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-705.74, -913.83, 19.22-0.98), heading = 89.99, money = {5000, 10000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 20, second = 0}, robbed = false},
    {coords = vector3(-1819.83,794.22,138.08-0.98), heading = 129.5, money = {8000, 10000}, cops = 2, blip = false, name = 'Licorería', cooldown = {60,120}, robbed = false}, --Banham Canyon Drive

}

Translation = {
    ['es'] = {
        ['shopkeeper'] = 'tendero',
        ['robbed'] = "ya me han robado, no ~w~tengo más dinero!",
        ['cashrecieved'] = 'Robaste:',
        ['currency'] = '$',
        ['scared'] = 'Asustado:',
        ['no_cops'] = 'No hay policias~w~ suficientes!',
        ['cop_msg'] = 'Estoy viendo un atraco en esta tienda, les envío una foto del ladrón!',
        ['set_waypoint'] = 'Activa GPS hacia la tienda',
        ['hide_box'] = 'Cierra esta caja',
        ['robbery'] = 'Robo en curso',
        ['walked_too_far'] = 'Te has alejado demasiado!'
    }
}