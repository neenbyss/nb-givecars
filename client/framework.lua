local Framework = {}
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

print('^2[nb-givecars] Client Framework detected: ' .. frameworkType .. '^0')

if frameworkType == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    function Framework.SpawnVehicle(model, coords, heading, cb)
        ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
            if cb then cb(vehicle) end
        end)
    end

    function Framework.GetVehicleProperties(vehicle)
        return ESX.Game.GetVehicleProperties(vehicle)
    end

elseif frameworkType == 'qbcore' or frameworkType == 'qbox' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Framework.SpawnVehicle(model, coords, heading, cb)
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            if cb then cb(vehicle) end
        end, coords, true)
    end

    function Framework.GetVehicleProperties(vehicle)
        return QBCore.Functions.GetVehicleProperties(vehicle)
    end

else
    function Framework.SpawnVehicle(model, coords, heading, cb)
        lib.requestModel(model)
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
        SetModelAsNoLongerNeeded(model)
        if cb then cb(vehicle) end
    end

    function Framework.GetVehicleProperties(vehicle)
        return lib.getVehicleProperties(vehicle) or {}
    end
end

return Framework
