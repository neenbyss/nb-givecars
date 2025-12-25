# 🚗 nb-givecars

> **Un script simple y moderno para entregar vehículos a jugadores en FiveM, utilizando la potencia de ox_lib.**

![FiveM](https://img.shields.io/badge/FiveM-Ready-orange) ![Lua](https://img.shields.io/badge/Lua-5.4-blue) ![License](https://img.shields.io/badge/License-MIT-green)

`nb-givecars` permite a los administradores entregar vehículos propios a cualquier jugador (o a sí mismos) a través de un menú limpio e intuitivo. Soporta múltiples frameworks y sistemas de llaves de forma nativa.

## ✨ Características

- 🔄 **Multi-Framework**: Detecta y se adapta automáticamente a **ESX**, **QBCore** o **Qbox**.
- 🔑 **Soporte de Llaves**: Integración nativa con los sistemas de llaves más populares:
  - `brutal_keys`
  - `qb-vehiclekeys`
  - `qs-vehiclekeys`
  - `wasabi_carlock`
  - `cd_garage`
  - `jaksam`
- 🖥️ **Interfaz Moderna**: Utiliza `ox_lib` para un menú Input Dialog limpio y rápido.
- 💾 **Persistencia**: Guarda correctamente las propiedades del vehículo (tuning, estado) en la base de datos (`owned_vehicles` o `player_vehicles`).
- 🛡️ **Seguro**: Verificación de permisos de administrador en el lado del servidor.

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

-- Grupo de permisos (ox_lib permission system / ACEs)
Config.PermissionGroup = 'group.admin'

-- Nombre del comando
Config.CommandName = 'givecar'
```

## 🎮 Uso

1. Ejecuta el comando configurado (por defecto `/givecar`).
2. Se abrirá un menú donde podrás introducir:
   - **ID del Jugador**: El ID del servidor de quien recibirá el coche (déjalo vacío para dártelo a ti mismo).
   - **Modelo**: El nombre de spawn del vehículo (ej: `zentorno`, `adder`).
   - **Matrícula**: (Opcional) Una matrícula personalizada. Si se deja vacío, se generará una aleatoria.
3. ¡Listo! El jugador recibirá el vehículo con llaves y guardado en su garaje.

## 🤝 Créditos

Creado por **Neenbyss**.
Si tienes problemas o sugerencias, siéntete libre de abrir un Issue o Pull Request.

---
*Hecho con ❤️ para la comunidad de FiveM.*
