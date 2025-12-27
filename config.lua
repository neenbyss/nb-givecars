Config = {}

Config.Framework = 'auto'

-- Sistema de llaves: 'brutal_keys', 'qb-vehiclekeys', 'qs-vehiclekeys', 'cd_garage', 'wasabi_carlock', 'jaksam', 'custom', 'none'
Config.KeySystem = 'brutal_keys'

-- Sistema de permisos
-- Si UseAcePermissions es true, ignora los rangos de admin del framework y usa SOLO permisos ACE.
-- Si es false, usa los rangos de admin del framework (ESX: admin/superadmin, QB: admin/god).
Config.UseAcePermissions = false
Config.PermissionGroup = 'group.admin' -- Ace permission (ej. 'command.givecar' o 'group.admin')

Config.CommandName = 'givecar'
Config.DeleteCommandName = 'delcarplate'

Config.Lang = {
    received_car = 'Has recibido un vehículo: %s',
    given_car = 'Has entregado un vehículo (%s) al ID %s',
    player_not_found = 'Jugador no encontrado',
    plate_already_exists = 'La matrícula generada ya existe, intentando de nuevo...',
    error_saving = 'Error al guardar el vehículo en la base de datos',
    car_deleted = 'Vehículo con matrícula %s eliminado correctamente de la base de datos',
    car_not_found = 'No se encontró ningún vehículo con la matrícula %s en la base de datos',
    delete_menu_title = 'Eliminar Vehículo de la BD',
    plate_label = 'Matrícula',
    plate_desc = 'Introduce la matrícula exacta del vehículo a eliminar'
}

Config.PlateFormat = 'NNN LLL'
