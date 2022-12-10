local dbReady = false
local crimal_record_query = "CREATE TABLE IF NOT EXISTS `criminal_records` ( `id` int(11) NOT NULL UNIQUE auto_increment, `offence` varchar(250) NOT NULL ,`user_id` varchar(250) NOT NULL, `officer_id` varchar(250) NOT NULL, `jail` int(11), `created_at` int (20), PRIMARY KEY(`id`))"
local note_query = "CREATE TABLE IF NOT EXISTS `epc_notes` ( `id` int(11) NOT NULL UNIQUE auto_increment, `title` varchar(250) NOT NULL ,`content` varchar(250) NOT NULL, `user_id` varchar(250) NOT NULL, `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,  PRIMARY KEY(`id`))"
local bolos_query = "CREATE TABLE IF NOT EXISTS `epc_bolos` ( `id` int(11) NOT NULL UNIQUE auto_increment, `gender` varchar(250) ,`height` varchar(250), `age` varchar(250), `type_of_crime` varchar(250), `note` varchar(250), `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,  PRIMARY KEY(`id`))"
ESX = nil
local licencias = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function ()
	print("Executed esx_police_cad queries table query")
	Wait(100)
	dbReady = true
end)


RegisterServerEvent('esx_police_cad:search-plate')
AddEventHandler('esx_police_cad:search-plate', function(plate)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate},
        function (result)
            if (result[1] ~= nil) then
                MySQL.Async.fetchAll('SELECT identifier,firstname,lastname FROM users WHERE identifier = @identifier', {['@identifier'] = result[1].owner},
                       function (result2)
                           if (result2[1] ~= nil) then
                              TriggerClientEvent('esx_police_cad:showdataplate', -1, result[1].plate,result[1].modelname ,result2[1].firstname,result2[1].lastname)
                           else
                               TriggerClientEvent('esx_police_cad:showdateplateNotFound', -1)
                           end
                   end)
            else
                TriggerClientEvent('esx_police_cad:showdateplateNotFound', -1)
            end
    end)
end)

RegisterServerEvent("esx_police:cogerFiltro")
AddEventHandler("esx_police:wolfFiltro", function()
    local usource = source
    local charges = {}
    MySQL.Async.fetchAll('SELECT * FROM fine_types', {
    }, function(fines)
        for j = 1, #fines do
            if fines[j].category == 0 or fines[j].category == 1 or fines[j].category == 2 or fines[j].category == 3 then
                table.insert(charges, fines[j])
            end
        end

        local officer = GetCharacterName(usource)

        TriggerClientEvent("esx_police:devolverFiltro", usource, charges, officer)
    end)
end)

RegisterServerEvent('esx_police_cad:search-players')
AddEventHandler('esx_police_cad:search-players', function(search)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE CONCAT(firstname, ' ', lastname) LIKE @search COLLATE utf8_general_ci", {['@search'] = '%'..search..'%'},
               function (result)
                   if (result ~= nil) then
                      TriggerClientEvent('esx_police_cad:returnsearch', -1, result)
                   else
                       TriggerClientEvent('esx_police_cad:noresults', -1)
                   end
           end)
end)


RegisterServerEvent('esx_police_cad:add-cr')
AddEventHandler('esx_police_cad:add-cr', function(data, officer)
    MySQL.Async.execute("INSERT INTO criminal_records SET reason = @reason, fine = @fine, time = CURDATE(), user_id = @user_id, officer_id = @officer_id", {
        ['@reason'] = data.reason,
        ['@fine'] = data.fine,
        ['@user_id'] = data.playerid,
        ['@officer_id'] = officer,
    },
        function (result)
            if (result ~= nil) then

            end
    end)
end)

RegisterServerEvent('esx_police_cad:add-photo')
AddEventHandler('esx_police_cad:add-photo', function(data, officer)
    print(data.title)
     MySQL.Async.execute("UPDATE users SET foto = @title WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        ['@title'] = data.title,
        },
        function (result)
            if (result ~= nil) then

            end
            end)  
end)

AddEventHandler('esx_police_cad:add-cr', function(data, officer)
    MySQL.Async.execute("INSERT INTO billing SET label = @label, amount = @amount, identifier = @identifier, sender = @sender, target_type = @target_type, target = @target", {
        ['@label'] = data.reason,
        ['@amount'] = data.fine,
        ['@identifier'] = data.playerid,
        ['@target_type'] = 'society',
        ['@target'] = 'society_police',
        ['@sender'] = officer,
    },
        function (result)
            if (result ~= nil) then

            end
    end)
end)

RegisterServerEvent('esx_police_cad:add-note')
AddEventHandler('esx_police_cad:add-note', function(data)
    MySQL.Async.execute("INSERT INTO epc_notes SET title = @title, content = @content, user_id = @user_id", {
        ['@title'] = data.title,
        ['@content'] = data.content,
        ['@user_id'] = data.playerid,
    },
        function (result)
            if (result ~= nil) then

            end
    end)
end)

RegisterServerEvent('esx_police_cad:add-licencia')
AddEventHandler('esx_police_cad:add-licencia', function(data)
    if data.title == 'armas' then
        if (licencia == 0) then
            MySQL.Async.execute("UPDATE users SET licencia = 1 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 2) then
            MySQL.Async.execute("UPDATE users SET licencia = 4 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 3) then
            MySQL.Async.execute("UPDATE users SET licencia = 5 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)  
        end
    elseif data.title == 'caza' then  
        if (licencia == 1) then
            MySQL.Async.execute("UPDATE users SET licencia = 3 WHERE identifier = @user_id;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 4) then
            MySQL.Async.execute("UPDATE users SET licencia = 5 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 0) then
            ESX.ShowNotification('No puedes dar licencia de caza sin tener licencia de armas')
        end

    elseif data.title == 'vuelo' then
        if (licencia == 0) then
            MySQL.Async.execute("UPDATE users SET licencia = 2 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 1) then
            MySQL.Async.execute("UPDATE users SET licencia = 4 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)
        elseif (licencia == 3) then
            MySQL.Async.execute("UPDATE users SET licencia = 5 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
    end)    
        end
    end
end)

RegisterServerEvent('esx_police_cad:remove-licencia')
AddEventHandler('esx_police_cad:remove-licencia', function(data)
    if data.title == 'armas' then
        if (licencia == 5) then
            MySQL.Async.execute("UPDATE users SET licencia = 2 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        elseif (licencia == 4) then
            MySQL.Async.execute("UPDATE users SET licencia = 2 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        elseif (licencia == 3) then
            MySQL.Async.execute("UPDATE users SET licencia = 0 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)  
        elseif (licencia == 1) then
            MySQL.Async.execute("UPDATE users SET licencia = 0 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)  
        end
    elseif data.title == 'caza' then  
        if (licencia == 5) then
            MySQL.Async.execute("UPDATE users SET licencia = 4 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        elseif (licencia == 3) then
            MySQL.Async.execute("UPDATE users SET licencia = 1 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        end

    elseif data.title == 'vuelo' then
        if (licencia == 2) then
            MySQL.Async.execute("UPDATE users SET licencia = 0 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        elseif (licencia == 4) then
            MySQL.Async.execute("UPDATE users SET licencia = 1 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)
        elseif (licencia == 5) then
            MySQL.Async.execute("UPDATE users SET licencia = 3 WHERE identifier = @identifier;", {
        ['@identifier'] = data.playerid,
        },
        function (result)
            if (result ~= nil) then

            end
            end)    
        end
    end
end)

RegisterServerEvent('esx_police_cad:delete_note')
AddEventHandler('esx_police_cad:delete_note', function(note)
    noteId = note.id
    MySQL.Async.execute("DELETE FROM epc_notes WHERE id = @id", {
        ['@id'] = note.id,
    },
        function (result)
            MySQL.Async.fetchAll("SELECT id FROM epc_notes WHERE id = @id", {
                ['@id'] = noteId,
            },
            function (result2)
                if result2[1] == nil then
                    TriggerClientEvent('esx_police_cad:note_deleted', -1)
                else
                    TriggerClientEvent('esx_police_cad:note_not_deleted', -1)
                end
            end)
    end)
end)

RegisterServerEvent('esx_police_cad:delete_cr')
AddEventHandler('esx_police_cad:delete_cr', function(cr)
    crid = cr
    MySQL.Async.execute("DELETE FROM criminal_records WHERE id = @id", {
        ['@id'] = crid.id,
    },
        function (result)
            MySQL.Async.fetchAll("SELECT id FROM criminal_records WHERE id = @id", {
                ['@id'] = crid.id,
            },
            function (result2)
                if result2[1] == nil then
                    TriggerClientEvent('esx_police_cad:cr_deleted', -1)
                else
                    TriggerClientEvent('esx_police_cad:cr_not_deleted', -1)
                end
            end)
    end)
end)

RegisterServerEvent('esx_police_cad:get-note')
AddEventHandler('esx_police_cad:get-note', function(playerid)
    MySQL.Async.fetchAll("SELECT * FROM epc_notes WHERE user_id = @user_id", {['@user_id'] = playerid},
        function (result)
        TriggerClientEvent('esx_police_cad:show-notes', -1, result)
    end)
end)

RegisterServerEvent('esx_police_cad:get-cr')
AddEventHandler('esx_police_cad:get-cr', function(playerid)
    MySQL.Async.fetchAll("SELECT * FROM criminal_records WHERE user_id = @user_id", {['@user_id'] = playerid},
        function (result)
            if (result[1] ~= nil) then
                for key,value in pairs(result) do
                    result[key] = value
                    MySQL.Async.fetchAll("SELECT * FROM criminal_records WHERE user_id = @user_id", {['@user_id'] = playerid},
                            function (result)
--                                result['officer'] = result[1].firstname .. ' ' .. result[1].lastname
                        end)
                end
                TriggerClientEvent('esx_police_cad:show-cr', -1, result)
        end
    end)
end)

RegisterServerEvent('esx_police_cad:get-license')
AddEventHandler('esx_police_cad:get-license', function(playerid)
    MySQL.Async.fetchAll("SELECT licencia FROM users WHERE identifier = @user_id", {['@user_id'] = playerid},
        function (result)
            if (result[1] ~= nil) then
                licencia = result[1].licencia
                --if result[1] == "dmv" then
                 -- result = "Sürücü Lisansı"
                  TriggerClientEvent('esx_police_cad:show-license', -1, result[1].licencia)
               -- end
            else
--             cb('')
            end
    end)
end)

RegisterServerEvent('esx_police_cad:get-photo')
AddEventHandler('esx_police_cad:get-photo', function(playerid)
    MySQL.Async.fetchAll("SELECT foto FROM users WHERE identifier = @user_id", {['@user_id'] = playerid},
        function (result)
            if (result[1] ~= nil) then
                licencia = result[1].foto
                --if result[1] == "dmv" then
                 -- result = "Sürücü Lisansı"
                  TriggerClientEvent('esx_police_cad:show-photo', -1, result[1].photo)
               -- end
            else
--             cb('')
            end
    end)
end)

-- ESX.RegisterServerCallback('verlicencia_wolf', function(source, cb, playerid)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     MySQL.Async.fetchAll('SELECT licencia FROM users WHERE identifier = @identifier', {
--         ['@identifier'] = playerid
--     }, function(result)
--     print(result[1].licencia)
--         if result[1].licencia ~= nil then
--             licencia = result[1].licencia
--             cb(result[1].licencia)
--         else
--             cb('')
--         end
--     end)
-- end)

RegisterServerEvent('esx_police_cad:get-bolos')
AddEventHandler('esx_police_cad:get-bolos', function()

    MySQL.Async.fetchAll("SELECT * FROM epc_bolos order by id", {
    },
        function (result)
            if (result[1] ~= nil) then
                TriggerClientEvent('esx_police_cad:show-bolos', -1, result)
        end
    end)
end)

RegisterServerEvent('esx_police_cad:add-bolo')
AddEventHandler('esx_police_cad:add-bolo', function(data)
    MySQL.Async.execute("INSERT into epc_bolos SET name = @name, lastname = @lastname, apperance = @apperance, type_of_crime = @type_of_crime, fine = @fine ", {
        ['@name'] = data.name,
        ['@lastname'] = data.lastname,
        ['@apperance'] = data.apperance,
        ['@type_of_crime'] = data.type_of_crime,
        ['@fine'] = data.fine,
    },
        function (result)
             MySQL.Async.fetchAll("SELECT * FROM epc_bolos order by id desc", {
                },
                    function (result)
                        if (result[1] ~= nil) then
                            TriggerClientEvent('esx_police_cad:show-bolos', -1, result)
                    end
                end)
    end)
end)

RegisterServerEvent('esx_police_cad:delete-bolo')
AddEventHandler('esx_police_cad:delete-bolo', function(data)
    id = data.id
    MySQL.Async.execute("DELETE FROM epc_bolos WHERE id = @id", {
        ['@id'] = id,
    },
        function (result)
            MySQL.Async.fetchAll("SELECT id FROM epc_bolos WHERE id = @id", {
                ['@id'] = id,
            },
            function (result2)
                if result2[1] == nil then
                    TriggerClientEvent('esx_police_cad:bolo-deleted', -1)
                else
                    TriggerClientEvent('esx_police_cad:bolo-not-deleted', -1)
                end
            end)
    end)
end)




