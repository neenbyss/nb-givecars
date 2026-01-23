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

local function ShowVehicleDeleteMenu()
    TriggerServerEvent('nb-givecars:server:getVehicleList')
end

RegisterNetEvent('nb-givecars:client:openDeleteMenu', function()
    ShowVehicleDeleteMenu()
end)

RegisterNetEvent('nb-givecars:client:receiveVehicleList', function(vehicles)
    if not vehicles or #vehicles == 0 then
        lib.notify({
            type = 'error',
            description = Config.Lang.no_vehicles_found
        })
        return
    end

    local options = {}
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        table.insert(options, {
            value = vehicle.plate,
            label = string.format('%s - %s', vehicle.plate, vehicle.model),
            description = string.format(Config.Lang.vehicle_info, vehicle.plate, vehicle.model)
        })
    end

    local selected = lib.inputDialog(Config.Lang.delete_menu_title, {
        {
            type = 'select',
            label = Config.Lang.select_vehicle,
            description = Config.Lang.select_vehicle_desc,
            options = options,
            required = true
        }
    })

    if not selected or not selected[1] then return end

    local plate = selected[1]
    local vehicleInfo = nil
    for i = 1, #vehicles do
        if vehicles[i].plate == plate then
            vehicleInfo = vehicles[i]
            break
        end
    end

    if not vehicleInfo then return end

    local confirm = lib.alertDialog({
        header = Config.Lang.confirm_delete_title,
        content = string.format(Config.Lang.confirm_delete_message, vehicleInfo.plate, vehicleInfo.model),
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Confirmar',
            cancel = 'Cancelar'
        }
    })

    if confirm and confirm ~= 'cancel' then
        TriggerServerEvent('nb-givecars:server:processDeleteCar', {
            plate = plate
        })
    end
end)

RegisterNetEvent('nb-givecars:client:showContinueMenu', function()
    local continueOptions = {
        {
            value = 'continue',
            label = Config.Lang.continue_deleting,
            description = Config.Lang.continue_deleting_desc
        },
        {
            value = 'exit',
            label = Config.Lang.exit_menu,
            description = Config.Lang.exit_menu_desc
        }
    }

    local selected = lib.inputDialog(Config.Lang.continue_menu_title, {
        {
            type = 'select',
            label = Config.Lang.what_to_do,
            description = Config.Lang.what_to_do_desc,
            options = continueOptions,
            required = true
        }
    })

    if not selected or not selected[1] then return end

    if selected[1] == 'continue' then
        ShowVehicleDeleteMenu()
    end
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
