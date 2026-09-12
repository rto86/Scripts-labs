# RtoLabs - Guía Global de Despliegue de Laboratorios

Repositorio oficial con los scripts y comandos de automatización para desplegar, gestionar y detener los laboratorios de la plataforma **RtoLabs**.

---

## Requisitos Previos del Sistema

Antes de intentar desplegar cualquier laboratorio, asegúrate de cumplir con los siguientes requisitos mínimos en tu equipo local:

### 1. Requisitos de Software

* **En Windows:**
  * **Docker Desktop** (Versión `4.20.0` o superior).
  * **PowerShell** (Versión `5.1` o superior, viene por defecto en Windows 10/11) o **Windows Terminal**.
  * WSL2 (Windows Subsystem for Linux) habilitado y actualizado (Recomendado).
* **En Linux (Ubuntu, Debian, Kali, Arch, etc.):**
  * **Docker Engine** (Versión `20.10.0` o superior).
  * Servidor/demonio de Docker en ejecución (`systemctl start docker`).
  * Tu usuario debe pertenecer al grupo `docker` (para ejecutar comandos sin `sudo`).
* **En macOS:**
  * **Docker Desktop para Mac** (Versión `4.20.0` o superior).
  * Soporte nativo para Chips Apple Silicon (M1/M2/M3) o Intel.
  * Terminal nativo o iTerm2.

### 2. Requisitos de Red y Sistema

* Conexión a Internet para descargar las imágenes desde GitHub Container Registry (`ghcr.io`).
* Un mínimo de **2 GB de RAM** libres en el sistema.
* **4 GB de espacio libre** en disco para el almacenamiento de imágenes Docker.

---

## ⚡ Método 1: Uso de Scripts Automatizados (Recomendado)

Dispones de scripts con menús interactivos para gestionar el laboratorio de forma sencilla.

### 🐧 En Linux / macOS (`rtolabs.sh`)

1. Descarga el script ejecutable:

   ```bash
   curl -O [https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.sh](https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.sh)

    Otorga permisos de ejecución:
    Bash

    chmod +x rtolabs.sh

    Ejecútalo en tu terminal:
    Bash

    ./rtolabs.sh

🪟 En Windows con PowerShell (rtolabs.ps1)

Abre PowerShell y descarga el script:
PowerShell

Invoke-WebRequest -Uri "[https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.ps1](https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.ps1)" -OutFile "rtolabs.ps1"

Ejecútalo en tu terminal:
PowerShell

.\rtolabs.ps1

 Nota para Windows: Si PowerShell bloquea la ejecución de scripts por políticas de seguridad, ejecuta primero: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

🛠️ Método 2: Comandos Genéricos Directos (Docker CLI)

Si prefieres gestionar el laboratorio manualmente con comandos nativos de Docker, utiliza la siguiente plantilla sustituyendo <NOMBRE_LABORATORIO> por el nombre oficial del laboratorio (ej. overstack) y <PUERTO> por el puerto indicado en la ficha web del laboratorio.

1. Descargar la imagen del laboratorio
Bash

docker pull ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

2.Desplegar / Iniciar el laboratorio
Bash

docker run -d --name <NOMBRE_LABORATORIO>-lab -p <PUERTO>:<PUERTO_INTERNO> ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

El laboratorio estará accesible inmediatamente en: http://localhost:<PUERTO> o http://127.0.0.1:<PUERTO>
3. Verificar el estado del contenedor
Bash

docker ps -a --filter "name=<NOMBRE_LABORATORIO>-lab"

4.Detener temporalmente el laboratorio
Bash

docker stop <NOMBRE_LABORATORIO>-lab

5.Volver a arrancar un laboratorio detenido
Bash

docker start <NOMBRE_LABORATORIO>-lab

6.Destruir y limpiar el contenedor
Bash

docker rm -f <NOMBRE_LABORATORIO>-lab

7.(Opcional) Eliminar la imagen del disco

Bash

docker rmi ghcr.io/rto86/<NOMBRE_LABORATORIO>:latest

---

### Archivo 2: `README.txt` (Texto plano accesible para cualquier sistema)

```text
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
     curl -O https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.sh

  2. Dar permisos de ejecucion:
     chmod +x rtolabs.sh

  3. Ejecutar:
     ./rtolabs.sh


* EN WINDOWS (PowerShell):
  1. Abrir PowerShell y descargar el script:
     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rto86/Scripts_labs/main/rtolabs.ps1" -OutFile "rtolabs.ps1"

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