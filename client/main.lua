local Framework = require 'client.framework'

RegisterNetEvent('nb-givecars:client:openMenu', function()
    local input = lib.inputDialog('Entregar Vehículo', {
        {type = 'number', label = 'ID del Jugador', description = 'ID del servidor (Dejar vacío para ti)', default = cache.serverId, required = false},
        {type = 'input', label = 'Modelo del Vehículo', description = 'Ej. zentorno, adder', required = true},
        {type = 'input', label = 'Matrícula', description = 'Opcional (Dejar vacío para aleatoria)', required = false},
    })
 
    if not input then return end
 
    TriggerServerEvent('nb-givecars:server:processGiveCar', {
        target = input[1],
        model = input[2],
        plate = input[3]
    })
end)

RegisterNetEvent('nb-givecars:client:spawnVehicle', function(model, plate, giverSource)
    if not IsModelInCdimage(model) then 
        return lib.notify({type = 'error', description = 'Model invalid: ' .. model})
    end
    
    local coords = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)
    
    Framework.SpawnVehicle(model, coords, heading, function(vehicle)
        if not DoesEntityExist(vehicle) then
            return lib.notify({type = 'error', description = 'Failed to spawn vehicle'})
        end

        SetVehicleNumberPlateText(vehicle, plate)
        
        if GetResourceState('qb-mechanicjob') == 'started' then
            TriggerEvent('qb-mechanicjob:client:ApplyVehicleMods', vehicle)
        end
        
        local props = Framework.GetVehicleProperties(vehicle)
        
        if props then
            props.plate = plate
        else
            props = { plate = plate }
        end
        
        TriggerServerEvent('nb-givecars:server:saveVehicle', {
            model = model,
            plate = plate,
            props = props,
            giver = giverSource
        })
        
        TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
    end)
end)
