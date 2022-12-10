local name = GetPlayerName(PlayerId())
local PlayerData				= {}
local _msec = 250

-- Libreria ESX
ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
        _msec = 0
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(25)
    end
    while ESX.GetPlayerData() == nil do
        _msec = 0
        Citizen.Wait(25)
    end
    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(_msec)
end)
-- Fin libreria ESX

-- Eventos
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    trabajoActual = PlayerData.job.label
	trabajoActualGrado = PlayerData.job.grade_label
	trabajoActualGradoRaw = PlayerData.job.grade_name
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	trabajoNombre = PlayerData.job.name
	trabajoActualGradoRaw = PlayerData.job.grade_name
    if trabajoActualGradoRaw ~= nil and trabajoActualGradoRaw == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			dineroSociedad = money
		end, trabajoNombre)
	end
end)
-- Fin de eventos

-- Inicio Funciones
openMenu = function()
    local id = GetPlayerServerId(PlayerId())
    local elements = {}
    local ped = PlayerPedId()
    local trabajoActual = PlayerData.job.label
    local JobGrade = PlayerData.job.grade_label
    local JobGradeName = PlayerData.job.grade_name
    local name = GetPlayerName(PlayerId())
    
    

    if Config.Informacion == true then
        table.insert(elements, {label = 'Información', value = 'infosapo'})
    end

    if Config.Varios == true then
        table.insert(elements, {label = 'Varios', value = 'variossapo'})
    end

    if Config.Gestionarempresa == true and PlayerData.job.grade_name == 'boss' then
        table.insert(elements, {label = 'Gestion de empresa', value = 'menuperso_grade'})
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            dineroSociedad = money
        end, trabajoNombre)
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_menu', {
        title = 'Menú Personal - ID: ' .. id,
        align = 'right',
        elements = elements
    }, function(data, menu)

        local val = data.current.value

        if data.current.value == 'infosapo' then
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'infosapo',
                {
                    title    = 'Información',
                    align    = 'right',
                    elements = {
                        {label = ' '..PlayerData.job.label..'  - '..PlayerData.job.grade_label},
                        -- {label = 'Mostrar Información',     value = 'Trabajos_mostrar'},
                        -- {label = 'Cachear',     value = 'interaccion_ciudadana'},
                        -- {label = 'Habilidades',     value = 'habilidades'},
                    },
                },
                function(data2, menu2)
                  
                    if data2.current.value == 'interaccion_ciudadana' then
                        OpenCitizenmenu()
                    end

                    if data2.current.value == 'habilidades' then
                        ExecuteCommand(Config['ComandoHabilidades'])
                    end
                end,
                function(data2, menu2)
                    menu2.close()
                end
            )

        
        
        elseif data.current.value == 'variossapo' then
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'infosapo',
                {
                    title    = 'Información',
                    align    = 'right',
                    elements = {
                        {label = 'Mostrar/Ocultar Propiedades',     value = 'propiedades'},
                        -- {label = 'Rockstar Editor',     value = 'rockstareditor'},
                        -- {label = 'Mostrar/Ocultar IDs',     value = 'idalternar'},
                    },
                },
                function(data2, menu2)

                    if data2.current.value == 'propiedades' then
                        ExecuteCommand(Config['ComandoPropiedades'])
                    end

                    if data2.current.value == 'rockstareditor' then
                        rockstarEditor()
                    end
                    
                    if data2.current.value == 'habilidades' then
                        ExecuteCommand(Config['ComandoHabilidades'])
                    end

                    if data2.current.value == 'idalternar' then
                        ExecuteCommand('verid')
                    end
                end,
                function(data2, menu2)
                    menu2.close()
                end
            )

        
        
        
        
        elseif data.current.value == 'menuperso_grade' then
            
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'menuperso_grade',
                {
                    title    = 'Gestion de Empresa',
                    align    = 'right',
                    elements = {
                                {label = 'Reclutar',     value = 'menuperso_grade_recruter'},
                                {label = 'Despedir',              value = 'menuperso_grade_virer'},
                                {label = 'Subir rango', value = 'menuperso_grade_promouvoir'},
                                {label = 'Bajar rango',  value = 'menuperso_grade_destituer'},
                                {label = 'Dinero de tu sociedad: '..dineroSociedad..'$'}
                    }
                },
                function(data2, menu2)
                    
                    if data2.current.value == 'menuperso_grade_recruter' then
                        if PlayerData.job.grade_name == 'boss' then
                                local job =  PlayerData.job.name
                                local grade = 0
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Ningún jugador cerca")
                            else
                                TriggerServerEvent('NB:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
                            end

                        else
                            Notify("No tienes los derechos.")

                        end
                        
                    end

                    if data2.current.value == 'menuperso_grade_virer' then
                        if PlayerData.job.grade_name == 'boss' then
                                local job =  PlayerData.job.name
                                local grade = 0
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Ningún jugador cerca")
                            else
                                TriggerServerEvent('NB:virerplayer', GetPlayerServerId(closestPlayer))
                            end

                        else
                            Notify("No tienes los derechos.")

                        end
                        
                    end

                    if data2.current.value == 'menuperso_grade_promouvoir' then

                        if PlayerData.job.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Ningún jugador cerca")
                            else
                                TriggerServerEvent('NB:promouvoirplayer', GetPlayerServerId(closestPlayer))
                            end

                        else
                            Notify("No tienes los ~derechos.")

                        end
                        
                        
                    end

                    if data2.current.value == 'menuperso_grade_destituer' then

                        if PlayerData.job.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Ningún jugador cerca")
                            else
                                TriggerServerEvent('NB:destituerplayer', GetPlayerServerId(closestPlayer))
                            end

                        else
                            Notify("No tienes los derechos.")

                        end
                        
                        
                    end

                    
                end,
                function(data2, menu2)
                    menu2.close()
                end
            )
        end
    end, function(data, menu) menu.close() end)
end

function rockstarEditor()

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personal',
        {
            title    = 'Rockstar Editor',
            align    = 'right',
            elements = {
            {label = 'Grabar', value = 'start_recording'},
            {label = 'Guardar grabación', value = 'save_recording'},
            {label = 'Descartar grabación', value = 'discard_recording'},
            }
        },
        function(data, menu)
        if data.current.value == 'start_recording' then
          StartRecording(1)
        elseif data.current.value == 'save_recording' then
          if(IsRecording()) then
            StopRecordingAndSaveClip()
          end
        elseif data.current.value == 'discard_recording' then
          StopRecordingAndDiscardClip()
        else
        end
      end, function(data, menu)
          menu.close()
    end)
end

OpenCitizenmenu = function()
    local id = GetPlayerServerId(PlayerId())
    local elements = {}
    local ped = PlayerPedId()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local trabajoActual = PlayerData.job.label
    local JobGrade = PlayerData.job.grade_label
    local JobGradeName = PlayerData.job.grade_name

    if IsPedSittingInAnyVehicle(ped) and not IsPlayerDead(ped) then
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            table.insert(elements, {label = 'Buscar a una persona', value = 'buscar'})
        else
            ESX.ShowNotification('No hay jugadores cerca')
        end
    else
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            table.insert(elements, {label = 'Buscar a una persona', value = 'buscar'})
        else
            ESX.ShowNotification('No hay jugadores cerca')
        end

    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_menu_2', {
        title = name .. ' - ID : ' .. id,
        align = 'right',
        elements = elements
    }, function(data3, menu2)
        local PlayeArmed = IsPedArmed(ped, 4)
        local PlayeArmed2 = IsPedArmed(ped, 5)
        local PlayeArmed3 = IsPedArmed(ped, 6)
        local PlayeArmed4 = IsPedArmed(ped, 7)
        if data3.current.value == 'buscar' then
            if (PlayeArmed or PlayeArmed2 or PlayeArmed3 or PlayeArmed4) then
                OpenBodySearchMenu(closestPlayer,groups)
            else
                ESX.ShowNotification("Necesitas empuñar un arma")
                ExecuteCommand('me empieza a cachear a la persona')
                ExecuteCommand('do podria?')
            end
        else
            print("Error en el codigo")
        end
    end, function(data, menu) menu.close() end)
end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         if IsControlJustReleased(0, Config['Keymenu']) then
--             openMenu()
--         end
--     end
-- end)

RegisterCommand('personalmenu', function()
	openMenu()
end)

RegisterKeyMapping('personalmenu','Abrir Menu Personal','keyboard','F5')

Citizen.CreateThread(function()
    while true do
        if type == "ulow" or type == "low" then
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearPedBloodDamage(PlayerPedId())
            ClearPedWetness(PlayerPedId())
            ClearPedEnvDirt(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetWindSpeed(0.0)
            Citizen.Wait(300)
        elseif type == "medium" then
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Citizen.Wait(1000)
        else
            Citizen.Wait(1500)
        end
    end
end)

OpenBodySearchMenu = function(player)
    print(Config['ScriptName']..':getOtherPlayerData')
    if Config['UsePolicejob'] then
        ESX.TriggerServerCallback('sapopersonal:getOtherPlayerData', function(data)
            local elements = {}
            local trabajoActual = PlayerData.job.label
            local JobGrade = PlayerData.job.grade_label
            local JobGradeName = PlayerData.job.grade_name
            for i=1, #data.accounts, 1 do
                if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                    table.insert(elements, {
                        label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
                        value    = 'black_money',
                        itemType = 'item_account',
                        amount   = data.accounts[i].money
                    })
                    break
                end
            end
            table.insert(elements, {label = _U('guns_label')})
            for i=1, #data.weapons, 1 do
                table.insert(elements, {
                    label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                    value    = data.weapons[i].name,
                    itemType = 'item_weapon',
                    amount   = data.weapons[i].ammo
                })
            end
            table.insert(elements, {label = _U('inventory_label')})
            for i=1, #data.inventory, 1 do
                    if data.inventory[i].count > 0 then
                            table.insert(elements, {
                                    label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
                                    value    = data.inventory[i].name,
                                    itemType = 'item_standard',
                                    amount   = data.inventory[i].count
                            })
                    end
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                title    = _U('search'),
                align    = 'right',
                elements = elements
            }, function(data, menu)
                if data.current.value then
                    TriggerServerEvent('sapopersonal:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                    OpenBodySearchMenu(player)
                end
            end, function(data, menu)
                menu.close()
            end)
        end, GetPlayerServerId(player))
    elseif not Config['UsePolicejob'] then
        ESX.TriggerServerCallback(''..Config['ScriptName']..':getOtherPlayerData', function(data)
            local elements = {}
            local trabajoActual = PlayerData.job.label
            local JobGrade = PlayerData.job.grade_label
            local JobGradeName = PlayerData.job.grade_name
            for i=1, #data.accounts, 1 do
                if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                    table.insert(elements, {
                        label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
                        value    = 'black_money',
                        itemType = 'item_account',
                        amount   = data.accounts[i].money
                    })
                    break
                end
            end
            table.insert(elements, {label = _U('guns_label')})
            for i=1, #data.weapons, 1 do
                table.insert(elements, {
                    label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                    value    = data.weapons[i].name,
                    itemType = 'item_weapon',
                    amount   = data.weapons[i].ammo
                })
            end
            table.insert(elements, {label = _U('inventory_label')})
            for i=1, #data.inventory, 1 do
                    if data.inventory[i].count > 0 then
                            table.insert(elements, {
                                    label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
                                    value    = data.inventory[i].name,
                                    itemType = 'item_standard',
                                    amount   = data.inventory[i].count
                            })
                    end
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                title    = _U('search'),
                align    = 'right',
                elements = elements
            }, function(data, menu)
                if data.current.value then
                    TriggerServerEvent(''..Config['ScriptName']..':confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                    OpenBodySearchMenu(player)
                end
            end, function(data, menu)
                menu.close()
            end)
        end, GetPlayerServerId(player))
    end
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('sapopersonal:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('sapopersonal:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end