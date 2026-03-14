# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_Nothing at the moment._

## [1.5.0] - 2025-03-13

### Added

- **Comando AdminCar** (`Config.AdminCarCommandName`, por defecto `admincar`): el staff puede registrar el vehículo en el que está subido como propio o asignarlo a un jugador por ID. Solo aplica a vehículos que no estén en la base de datos; en caso contrario se ofrece la opción de forzar.
- **Opción de forzar** cuando el vehículo ya está en la BD: si la matrícula pertenece a otro jugador, se muestra un diálogo para confirmar si se desea forzar la asignación (se quita del dueño actual y se asigna al nuevo).
- Nuevas cadenas en `Config.Lang` para AdminCar: menú, confirmación de forzado y mensajes de éxito/error.
- Función `Framework.PlateExistsInDb(plate)` en el framework (ESX, QBCore/Qbox y fallback) para comprobar si una matrícula existe en la base de datos con independencia del dueño.

### Changed

- El flujo de AdminCar ahora distingue entre “vehículo no registrado” (inserción directa) y “vehículo ya registrado” (confirmación para forzar y reasignar).

## [1.4.0]

Versión base con comandos givecar y delcar, soporte multi-framework (ESX, QBCore/Qbox) y sistemas de llaves configurables.
