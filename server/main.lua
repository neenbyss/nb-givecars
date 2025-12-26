local Framework = require 'server.framework'

lib.addCommand(Config.CommandName, {
    help = 'Abrir menu de entregar vehiculos',
}, function(source, args)
    if not Framework.IsAdmin(source) then
        return TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'No tienes permisos para usar este comando.'})
    end
    TriggerClientEvent('nb-givecars:client:openMenu', source)
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
