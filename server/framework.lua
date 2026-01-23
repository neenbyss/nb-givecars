Framework = {}
local frameworkType = Config.Framework

if frameworkType == 'auto' then
    if GetResourceState('qbx_core') == 'started' then
        frameworkType = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        frameworkType = 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        frameworkType = 'esx'
    end
end

print('^2[nb-givecars] Framework detected: ' .. frameworkType .. '^0')

if frameworkType == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    function Framework.GetPlayerIdentifier(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.identifier
    end

    function Framework.GetPlayerFromId(source)
        return ESX.GetPlayerFromId(source)
    end

    function Framework.PlayerOwnsPlate(identifier, plate) 
        local count = MySQL.scalar.await('SELECT count(*) FROM owned_vehicles WHERE owner = ? AND plate = ?', {identifier, plate}) 
        return count > 0 
    end 

    function Framework.DeleteOwnedVehicle(plate) 
        local affected = MySQL.update.await('DELETE FROM owned_vehicles WHERE plate = ?', {plate}) 
        return affected > 0 
    end

    function Framework.GetAllVehicles()
        local vehicles = MySQL.query.await('SELECT plate, vehicle FROM owned_vehicles ORDER BY plate ASC')
        local result = {}
        if vehicles then
            for i = 1, #vehicles do
                local vehicleData = json.decode(vehicles[i].vehicle or '{}')
                local model = vehicleData.model or 'unknown'
                table.insert(result, {
                    plate = vehicles[i].plate,
                    model = model
                })
            end
        end
        return result
    end 

    function Framework.InsertOwnedVehicle(identifier, plate, vehiclePropsJson, type, model, source) 
        local type = type or 'car' 
        MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (?, ?, ?, ?, 1)', {identifier, plate, vehiclePropsJson, type}) 
        return true 
    end

    function Framework.IsAdmin(source)
        if Config.UseAcePermissions then
            return IsPlayerAceAllowed(source, Config.PermissionGroup)
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        local group = xPlayer.getGroup()
        return group == 'admin' or group == 'superadmin' or group == 'owner'
    end

elseif frameworkType == 'qbcore' or frameworkType == 'qbox' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Framework.GetPlayerIdentifier(source)
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.PlayerData.citizenid
    end

    function Framework.GetPlayerFromId(source)
        return QBCore.Functions.GetPlayer(source)
    end

    function Framework.PlayerOwnsPlate(identifier, plate)
        local count = MySQL.scalar.await('SELECT count(*) FROM player_vehicles WHERE citizenid = ? AND plate = ?', {identifier, plate})
        return count > 0
    end

    function Framework.DeleteOwnedVehicle(plate)
        local affected = MySQL.update.await('DELETE FROM player_vehicles WHERE plate = ?', {plate})
        return affected > 0
    end

    function Framework.GetAllVehicles()
        local vehicles = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles ORDER BY plate ASC')
        local result = {}
        if vehicles then
            for i = 1, #vehicles do
                local model = vehicles[i].vehicle or 'unknown'
                table.insert(result, {
                    plate = vehicles[i].plate,
                    model = model
                })
            end
        end
        return result
    end

    function Framework.InsertOwnedVehicle(identifier, plate, vehiclePropsJson, type, model, source)
        local license = 'unknown'
        if source then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then license = Player.PlayerData.license end
        end

        MySQL.insert.await('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            license,
            identifier,
            model,
            GetHashKey(model),
            vehiclePropsJson,
            plate,
            1
        })
        return true
    end

    function Framework.IsAdmin(source)
        if Config.UseAcePermissions then
            return IsPlayerAceAllowed(source, Config.PermissionGroup)
        end
        return QBCore.Functions.HasPermission(source, 'admin') or QBCore.Functions.HasPermission(source, 'god')
    end
else
    -- Fallback for standalone
    function Framework.IsAdmin(source)
        return IsPlayerAceAllowed(source, Config.PermissionGroup) or IsPlayerAceAllowed(source, 'command')
    end

    function Framework.GetAllVehicles()
        -- Try ESX table first
        local vehicles = MySQL.query.await('SELECT plate, vehicle FROM owned_vehicles ORDER BY plate ASC')
        if vehicles and #vehicles > 0 then
            local result = {}
            for i = 1, #vehicles do
                local vehicleData = json.decode(vehicles[i].vehicle or '{}')
                local model = vehicleData.model or 'unknown'
                table.insert(result, {
                    plate = vehicles[i].plate,
                    model = model
                })
            end
            return result
        end
        -- Try QBCore table
        vehicles = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles ORDER BY plate ASC')
        local result = {}
        if vehicles then
            for i = 1, #vehicles do
                local model = vehicles[i].vehicle or 'unknown'
                table.insert(result, {
                    plate = vehicles[i].plate,
                    model = model
                })
            end
        end
        return result
    end
end

function Framework.GeneratePlate()
    local plate = string.upper(lib.string.random('AAA 111'))
    return plate
end

return Framework
