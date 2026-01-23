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

local currentTargetId = nil

local function ShowVehicleContextMenu(targetId)
    currentTargetId = targetId or cache.serverId
    TriggerServerEvent('nb-givecars:server:getVehicleList', currentTargetId)
end

RegisterNetEvent('nb-givecars:client:openDeleteMenu', function()
    local input = lib.inputDialog(Config.Lang.delete_menu_title, {
        {type = 'number', label = Config.Lang.player_id_label, description = Config.Lang.player_id_desc, default = cache.serverId, required = false},
    })
    
    if not input then return end
    
    local playerId = input[1]
    if not playerId or playerId == 0 then
        playerId = cache.serverId
    end
    
    ShowVehicleContextMenu(playerId)
end)

RegisterNetEvent('nb-givecars:client:receiveVehicleList', function(vehicles, targetId)
    if not vehicles or #vehicles == 0 then
        lib.notify({
            type = 'error',
            description = Config.Lang.no_vehicles_found
        })
        return
    end

    local menuOptions = {}
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        table.insert(menuOptions, {
            title = string.format('%s - %s', vehicle.plate, vehicle.model),
            description = string.format(Config.Lang.vehicle_info, vehicle.plate, vehicle.model),
            icon = 'trash',
            onSelect = function()
                local confirm = lib.alertDialog({
                    header = Config.Lang.confirm_delete_title,
                    content = string.format(Config.Lang.confirm_delete_message, vehicle.plate, vehicle.model),
                    centered = true,
                    cancel = true,
                    labels = {
                        confirm = 'Confirmar',
                        cancel = 'Cancelar'
                    }
                })

                if confirm and confirm ~= 'cancel' then
                    TriggerServerEvent('nb-givecars:server:processDeleteCar', {
                        plate = vehicle.plate,
                        targetId = targetId
                    })
                else
                    -- Si cancela, volver al menú
                    ShowVehicleContextMenu(targetId)
                end
            end
        })
    end

    -- Agregar opción para cambiar de jugador
    table.insert(menuOptions, {
        title = Config.Lang.change_player,
        description = Config.Lang.change_player_desc,
        icon = 'user',
        onSelect = function()
            local input = lib.inputDialog(Config.Lang.delete_menu_title, {
                {type = 'number', label = Config.Lang.player_id_label, description = Config.Lang.player_id_desc, default = targetId or cache.serverId, required = false},
            })
            
            if input then
                local playerId = input[1]
                if not playerId or playerId == 0 then
                    playerId = cache.serverId
                end
                ShowVehicleContextMenu(playerId)
            end
        end
    })

    lib.registerContext({
        id = 'nb_givecars_delete_menu',
        title = Config.Lang.delete_menu_title,
        options = menuOptions
    })

    lib.showContext('nb_givecars_delete_menu')
end)

RegisterNetEvent('nb-givecars:client:showContinueMenu', function(targetId)
    local confirm = lib.alertDialog({
        header = Config.Lang.continue_menu_title,
        content = Config.Lang.continue_question,
        centered = true,
        cancel = true,
        labels = {
            confirm = Config.Lang.continue_deleting,
            cancel = Config.Lang.exit_menu
        }
    })

    if confirm and confirm ~= 'cancel' then
        ShowVehicleContextMenu(targetId)
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
