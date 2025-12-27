# 🚗 nb-givecars

> **Un script simple y moderno para entregar y gestionar vehículos de jugadores en FiveM, utilizando la potencia de ox_lib.**

![FiveM](https://img.shields.io/badge/FiveM-Ready-orange) ![Lua](https://img.shields.io/badge/Lua-5.4-blue) ![License](https://img.shields.io/badge/License-MIT-green)

`nb-givecars` permite a los administradores entregar vehículos propios a cualquier jugador y eliminarlos de la base de datos de forma segura, todo a través de menús intuitivos. Soporta múltiples frameworks y sistemas de llaves de forma nativa.

## ✨ Características

- 🔄 **Multi-Framework**: Detecta y se adapta automáticamente a **ESX**, **QBCore** o **Qbox**.
- 🔑 **Soporte de Llaves**: Integración nativa con los sistemas de llaves más populares:
  - `brutal_keys`
  - `qb-vehiclekeys`
  - `qs-vehiclekeys`
  - `wasabi_carlock`
  - `cd_garage`
  - `jaksam`
- 🖥️ **Interfaz Moderna**: Utiliza `ox_lib` para menús Input Dialog limpios y rápidos.
- �️ **Gestión Completa**: No solo permite dar coches, sino también eliminarlos de la base de datos por matrícula.
- �💾 **Persistencia**: Guarda correctamente las propiedades del vehículo (tuning, estado) en la base de datos (`owned_vehicles` o `player_vehicles`).
- 🛡️ **Seguridad Flexible**: Soporta tanto los rangos de administrador del framework (admin/god) como permisos **ACE** configurables.

## 📦 Requisitos

- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)
- Un framework compatible (ESX, QBCore, Qbox)

## 🚀 Instalación

1. Descarga el repositorio y colócalo en tu carpeta `resources`.
2. Asegúrate de tener `ox_lib` y `oxmysql` iniciados antes de este script.
3. Añade `ensure nb-givecars` en tu `server.cfg`.

## ⚙️ Configuración

Edita el archivo `config.lua` para adaptar el script a tu servidor:

```lua
Config = {}

-- Framework: 'esx', 'qbcore', 'qbox' o 'auto' (detecta automáticamente)
Config.Framework = 'auto'

-- Sistema de llaves
-- Opciones: 'brutal_keys', 'qb-vehiclekeys', 'qs-vehiclekeys', 'cd_garage', 'wasabi_carlock', 'jaksam', 'custom', 'none'
Config.KeySystem = 'brutal_keys'

-- Sistema de Permisos
-- true: Usa SOLO permisos ACE (ej. 'add_ace group.moderator group.admin allow')
-- false: Usa los rangos del framework (ESX: superadmin, QBCore: god, etc.)
Config.UseAcePermissions = false
Config.PermissionGroup = 'group.admin'

-- Nombres de los comandos
Config.CommandName = 'givecar'
Config.DeleteCommandName = 'delcarplate'
```

## 🎮 Uso

### Entregar Vehículo (`/givecar`)
1. Ejecuta el comando `/givecar` (o el configurado).
2. Rellena el menú:
   - **ID del Jugador**: El ID del servidor de quien recibirá el coche (déjalo vacío para dártelo a ti mismo).
   - **Modelo**: El nombre de spawn del vehículo (ej: `zentorno`, `adder`).
   - **Matrícula**: (Opcional) Una matrícula personalizada. Si se deja vacío, se generará una aleatoria.
3. ¡Listo! El jugador recibirá el vehículo con llaves y guardado en su garaje.

### Eliminar Vehículo (`/delcarplate`)
1. Ejecuta el comando `/delcarplate`.
2. Introduce la **matrícula exacta** del vehículo que quieres eliminar.
3. El script buscará el vehículo en la base de datos (sin importar el dueño) y lo borrará permanentemente.

## 🤝 Créditos

Creado por **Neenbyss**.
Si tienes problemas o sugerencias, siéntete libre de abrir un Issue o Pull Request.

---
*Hecho con ❤️ para la comunidad de FiveM.*
