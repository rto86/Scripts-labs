text
========================================================================
                  RTOLABS - GUIA DE DESPLIEGUE DE LABORATORIOS
========================================================================

Esta guia contiene las instrucciones necesarias para desplegar y gestionar
los laboratorios vulnerables de RtoLabs utilizando contenedores Docker.

------------------------------------------------------------------------
1. REQUISITOS PREVIOS DEL SISTEMA
------------------------------------------------------------------------

[ WINDOWS ]
- Docker Desktop (Version 4.20.0 o superior instalada y en ejecucion).
- PowerShell 5.1 o posterior / Windows Terminal.
- WSL2 (Windows Subsystem for Linux) habilitado.

[ LINUX (Ubuntu, Debian, Kali, Arch, etc.) ]
- Docker Engine (Version 20.10.0 o superior).
- Servicio Docker activo: sudo systemctl start docker
- Usuario añadido al grupo docker para evitar el uso de sudo.

[ MAC OS ]
- Docker Desktop para Mac (Version 4.20.0 o superior).
- Funciona en procesadores Intel y Apple Silicon (M1/M2/M3).

[ REQUISITOS GENERALES ]
- Conexion a Internet para descargar las imagenes desde ghcr.io.
- Mínimo 2 GB de memoria RAM libre.
- Mínimo 4 GB de espacio libre en disco.


------------------------------------------------------------------------
2. METODO 1: USO DE SCRIPTS AUTOMATIZADOS (RECOMENDADO)
------------------------------------------------------------------------

* EN LINUX / MAC OS:
  1. Abrir la terminal y descargar el script:
     curl -O https://raw.githubusercontent.com/rto86/Scripts-labs/main/rtolabs.sh

  2. Dar permisos de ejecucion:
     chmod +x rtolabs.sh

  3. Ejecutar:
     ./rtolabs.sh


* EN WINDOWS (PowerShell):
  1. Abrir PowerShell y descargar el script:
     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rto86/Scripts-labs/main/rtolabs.ps1" -OutFile "rtolabs.ps1"

  2. Ejecutar:
     .\rtolabs.ps1

  Nota: Si PowerShell da un error de ejecucion, ejecuta antes:
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


------------------------------------------------------------------------
3. METODO 2: COMANDOS GENERICOS MANUALES (DOCKER CLI)
------------------------------------------------------------------------

Reemplaza <NOMBRE_LABORATORIO> por el nombre de la maquina (ej: overstack)
y <PUERTO> por el puerto asignado.


A) DESCARGAR LA IMAGEN:
   docker pull ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

B) DESPLEGAR / INICIAR:
   docker run -d --name <NOMBRE_LABORATORIO>-lab -p <PUERTO>:<PUERTO_INTERNO> ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

   Acceso web en: http://localhost:<PUERTO>

C) VER ESTADO DEL CONTENEDOR:
   docker ps -a --filter "name=<NOMBRE_LABORATORIO>-lab"

D) DETENER EL LABORATORIO:
   docker stop <NOMBRE_LABORATORIO>-lab

E) REARRANCAR EL LABORATORIO DETENIDO:
   docker start <NOMBRE_LABORATORIO>-lab

F) ELIMINAR EL CONTENEDOR (LIMPIEZA):
   docker rm -f <NOMBRE_LABORATORIO>-lab

G) ELIMINAR LA IMAGEN DEL DISCO:
   docker rmi ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

========================================================================
                      RtoLabs - Automation Security
========================================================================