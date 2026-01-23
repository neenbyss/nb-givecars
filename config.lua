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
    plate_desc = 'Introduce la matrícula exacta del vehículo a eliminar',
    select_vehicle = 'Seleccionar Vehículo',
    select_vehicle_desc = 'Elige el vehículo que deseas eliminar',
    vehicle_info = 'Matrícula: %s | Modelo: %s',
    confirm_delete_title = 'Confirmar Eliminación',
    confirm_delete_message = '¿Estás seguro de que deseas eliminar el vehículo?\n\nMatrícula: %s\nModelo: %s\n\nEsta acción no se puede deshacer.',
    no_vehicles_found = 'No se encontraron vehículos en la base de datos',
    continue_menu_title = 'Eliminación Completada',
    continue_deleting = 'Eliminar Otro Vehículo',
    continue_deleting_desc = 'Volver a la lista de vehículos para eliminar otro',
    exit_menu = 'Salir',
    exit_menu_desc = 'Finalizar y cerrar el menú de eliminación',
    what_to_do = '¿Qué deseas hacer?',
    what_to_do_desc = 'Elige una opción para continuar'
}

Config.PlateFormat = 'NNN LLL'
