local Framework = require 'server.framework'

lib.addCommand(Config.CommandName, {
    help = 'Abrir menu de entregar vehiculos',
}, function(source, args)
    if not Framework.IsAdmin(source) then
        return TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'No tienes permisos para usar este comando.'})
    end
    TriggerClientEvent('nb-givecars:client:openMenu', source)
end)

lib.addCommand(Config.DeleteCommandName, {
    help = 'Eliminar vehículo de la base de datos',
}, function(source, args)
    if not Framework.IsAdmin(source) then
        return TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'No tienes permisos para usar este comando.'})
    end
    TriggerClientEvent('nb-givecars:client:openDeleteMenu', source)
end)

lib.addCommand(Config.AdminCarCommandName, {
    help = 'Registrar el vehículo actual como propio (o asignar a un jugador). Debes estar dentro del vehículo.',
}, function(source, args)
    if not Framework.IsAdmin(source) then
        return TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'No tienes permisos para usar este comando.'})
    end
    TriggerClientEvent('nb-givecars:client:openAdminCarMenu', source)
end)

RegisterNetEvent('nb-givecars:server:getVehicleList', function(targetId)
    local src = source
    if not Framework.IsAdmin(src) then return end
    
    local identifier = nil
    local target = src -- Por defecto, el usuario mismo
    
    if targetId then
        target = tonumber(targetId)
        if not target then target = src end
    end
    
    local Player = Framework.GetPlayerFromId(target)
    if not Player then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.player_not_found})
    end
    
    identifier = Framework.GetPlayerIdentifier(target)
    
    local vehicles = Framework.GetAllVehicles(identifier)
    TriggerClientEvent('nb-givecars:client:receiveVehicleList', src, vehicles, targetId or src)
end)

RegisterNetEvent('nb-givecars:server:processDeleteCar', function(data)
    local src = source
    if not Framework.IsAdmin(src) then return end

    local plate = data.plate
    if not plate or plate == '' then return end
    
    plate = string.upper(plate)

    local success = Framework.DeleteOwnedVehicle(plate)
    
    local targetId = data.targetId
    
    if success then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success', 
            description = string.format(Config.Lang.car_deleted, plate)
        })
        -- Enviar evento para mostrar menú de continuar
        TriggerClientEvent('nb-givecars:client:showContinueMenu', src, targetId)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error', 
            description = string.format(Config.Lang.car_not_found, plate)
        })
        -- Si falla, también mostrar opción de continuar
        TriggerClientEvent('nb-givecars:client:showContinueMenu', src, targetId)
    end
end)

RegisterNetEvent('nb-givecars:server:processAdminCar', function(data)
    local src = source
    if not Framework.IsAdmin(src) then return end

    local plate = data.plate
    local model = data.model
    local vehiclePropsJson = type(data.props) == 'string' and data.props or json.encode(data.props or {})
    local targetId = data.targetId

    if not plate or plate == '' then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.admincar_error_saving})
    end

    plate = string.upper(plate)

    local force = data.force == true
    if Framework.PlateExistsInDb(plate) and not force then
        return TriggerClientEvent('nb-givecars:client:adminCarConfirmForce', src, {
            plate = plate,
            model = model,
            props = data.props,
            targetId = targetId
        })
    end

    if force and Framework.PlateExistsInDb(plate) then
        Framework.DeleteOwnedVehicle(plate)
    end

    local target = (targetId and tonumber(targetId) and tonumber(targetId) > 0) and tonumber(targetId) or src
    local Player = Framework.GetPlayerFromId(target)
    if not Player then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.player_not_found})
    end

    local identifier = Framework.GetPlayerIdentifier(target)
    local type = 'car'
    local success = Framework.InsertOwnedVehicle(identifier, plate, vehiclePropsJson, type, model, target)

    if success then
        if target == src then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                description = string.format(Config.Lang.admincar_success_self, plate)
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                description = string.format(Config.Lang.admincar_success_target, plate, target)
            })
            TriggerClientEvent('ox_lib:notify', target, {
                type = 'success',
                description = string.format(Config.Lang.received_car, model or plate)
            })
        end
        GiveKeys(target, plate, model)
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.admincar_error_saving})
    end
end)

RegisterNetEvent('nb-givecars:server:processGiveCar', function(data)
    local src = source
    if not Framework.IsAdmin(src) then 
        return print(string.format('^1[nb-givecars] Unauthorized attempt to give car by ID %s^0', src))
    end

    local target = tonumber(data.target)
    local model = data.model
    local plate = data.plate

    if not target then target = src end

    local Player = Framework.GetPlayerFromId(target)
    if not Player then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.player_not_found})
    end

    if not plate or plate == '' then
        plate = string.upper(lib.string.random('AAA 111'))
    end
    
    plate = string.upper(plate)

    TriggerClientEvent('nb-givecars:client:spawnVehicle', target, model, plate, src)
end)

RegisterNetEvent('nb-givecars:server:saveVehicle', function(data)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    
    local vehicleProps = data.props
    local vehiclePropsJson = json.encode(vehicleProps)
    local plate = data.plate
    local model = data.model
    local type = 'car'
    
    local success = Framework.InsertOwnedVehicle(identifier, plate, vehiclePropsJson, type, model, src)
    
    if success then
        if data.giver and data.giver ~= src then
            TriggerClientEvent('ox_lib:notify', data.giver, {
                type = 'success', 
                description = string.format(Config.Lang.given_car, model, src)
            })
        end
        
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success', 
            description = string.format(Config.Lang.received_car, model)
        })

        sendDiscordWebhook({
            url = Config.logs,
            name = "NB GiveCars Logs",
            embeds = {{
                title = "Vehículo Entregado",
                description = string.format("**Jugador:** %s (ID: %s)\n**Modelo:** %s\n**Matrícula:** %s", GetPlayerName(src), src, model, plate),
                color = 65280,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
            }}
        })
        GiveKeys(src, plate, model)
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = Config.Lang.error_saving})
    end
end)

function GiveKeys(source, plate, model)
    if Config.KeySystem == 'brutal_keys' then
        TriggerEvent('brutal_keys:server:addVehicleKey', source, plate, plate)
    elseif Config.KeySystem == 'qb-vehiclekeys' then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
    elseif Config.KeySystem == 'qs-vehiclekeys' then
        exports['qs-vehiclekeys']:GiveKeys(plate, model)
    elseif Config.KeySystem == 'wasabi_carlock' then
        exports.wasabi_carlock:GiveKey(plate)
    elseif Config.KeySystem == 'cd_garage' then
        TriggerClientEvent('cd_garage:AddKeys', source, plate)
    elseif Config.KeySystem == 'jaksam' then
        TriggerClientEvent('vehicles_keys:client:giveKeys', source, plate, model)
    elseif Config.KeySystem == 'custom' then
        print('Custom key system triggered for plate: ' .. plate)
    end
end

function sendDiscordWebhook(config)
    if not config.url then
        print("Error: No se proporcionó una URL de webhook")
        return
    end

    local payload = {
        content = config.msg or nil,
        username = config.name or "Webhook Bot",
        avatar_url = config.avatar or nil,
        embeds = config.embeds or nil
    }

    local payload_json = json.encode(payload)

    PerformHttpRequest(config.url, function(err, text, headers)
        if err then
            print("Error al enviar el webhook: " .. tostring(err))
        end
    end, 'POST', payload_json, {['Content-Type'] = 'application/json'})
end
