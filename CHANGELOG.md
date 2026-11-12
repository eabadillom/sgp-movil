# Changelog

Todos los cambios importantes en este proyecto serán documentados en este archivo.

Este proyecto sigue versionado semántico (SemVer) y el formato de [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---
## [1.1.1] - 2026-11-12

### Changed
* Se corrige como se modifica y muestran las notificaciones.
* Se corrige la consulta de las incapacidades.
* Se corrige el actualizar de las listas de permisos/vacaciones/articulos/uniformes al aprobar o cancelar un elemento.

## [1.1.0] - 2026-11-11

### Added
* Agregar un módulo completo para el cambio de contraseña del usuario, incluyendo:
 * Modelos.
 * Conversores de objetos (mappers).
 * Pantallas.

### Changed
* Actualizar la función login de LoginDatasourceImpl para utilizar el nuevo mecanismo de acceso a la API para la solicitud del token.
* Se rediseñan pantallas para una mejor presentación de la aplicación

## [1.0.0] - 2025-09-28
### Added
- Login
- Dashboard (Pagina principal)
- SideMenu (Menu lateral)
- Incapacidades
 - Agregar nueva incapacidad
 - Detalle de la incapacidad (Cancelar una incapacidad) 
- Vacaciones
 - Detalle de las vacaciones (Aprobar o Cancelar una solicitud de vacaciones)
- Permisos
 - Detalle de los permisos (Aprobar o Cancelar una solicitud de permiso)
- Ausencias
 - Detalle de las ausencias (Justificar ausencia)
- Retardos
 - Detalle de los retardos (Justificar retardos)
- Uniformes
 - Detalle de los uniformes (Autorizar o Rechazar un uniforme)
- Articulos
 - Detalle de los articulos (Autorizar o Rechazar un articulo)

## Nota
Los cambios previos a esta versión (desde el inicio del proyecto) no están documentados por tratarse de la fase inicial de desarrollo.
