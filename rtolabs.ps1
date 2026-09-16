# RtoLabs - Gestor Universal de Laboratorios / Universal Laboratory Manager

$GhcrUser = "rto86"

function Get-LabInfo {
    Write-Host ""
    $global:LabName = Read-Host "[?] Ingresa el NOMBRE del laboratorio (ej. overstack) / Enter laboratory NAME (e.g. overstack)"
    $global:LabName = $global:LabName.Trim().ToLower()

    if ([string]::IsNullOrWhiteSpace($global:LabName)) {
        Write-Host "[-] El nombre del laboratorio no puede estar vacío. / Laboratory name cannot be empty."
        Pause
        Show-Menu
    }

    $global:ContainerName = "$($global:LabName)-lab"
    $global:ImageName = "ghcr.io/${GhcrUser}/$($global:LabName):latest"
}

function Show-Menu {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "                 RtoLabs                  "
    Write-Host "=========================================="
    Write-Host "1) Desplegar / Arrancar un laboratorio / Deploy / Start a Lab"
    Write-Host "2) Detener un laboratorio / Shut down a Laboratory"
    Write-Host "3) Reiniciar un laboratorio detenido / Restart a stopped Lab"
    Write-Host "4) Destruir contenedor y limpiar / Destroy the container and clean up"
    Write-Host "5) Ver contenedores en ejecución / View Running Containers"
    Write-Host "6) Salir / Exit"
    Write-Host "=========================================="

    $choice = Read-Host "Selecciona una opción [1-6] / Select an option [1-6]"

    switch ($choice) {
        '1' {
            Get-LabInfo
            $port = Read-Host "[?] Ingresa el PUERTO local para mapear (ej. 5000) / Enter local PORT to map (e.g. 5000)"
            if ([string]::IsNullOrWhiteSpace($port)) { $port = "5000" }

            Write-Host ""
            Write-Host "[+] Descargando imagen $global:ImageName... / Downloading image $global:ImageName..."
            docker pull $global:ImageName

            Write-Host "[+] Desplegando contenedor $global:ContainerName en puerto $port... / Deploying container $global:ContainerName on port $port..."
            docker run -d --name $global:ContainerName -p "${port}:5000" $global:ImageName

            Write-Host ""
            Write-Host "[!] Laboratorio $($global:LabName) activo en: http://localhost:$port / Lab $($global:LabName) active at: http://localhost:$port"
            Pause
            Show-Menu
        }
        '2' {
            Get-LabInfo
            Write-Host "[+] Deteniendo el laboratorio $global:ContainerName... / Stopping laboratory $global:ContainerName..."
            docker stop $global:ContainerName
            Write-Host "[!] Contenedor detenido. / Container stopped."
            Pause
            Show-Menu
        }
        '3' {
            Get-LabInfo
            Write-Host "[+] Volviendo a arrancar $global:ContainerName... / Restarting $global:ContainerName..."
            docker start $global:ContainerName
            Write-Host "[!] Laboratorio reanudado. / Laboratory resumed."
            Pause
            Show-Menu
        }
        '4' {
            Get-LabInfo
            Write-Host "[+] Destruyendo el contenedor $global:ContainerName... / Destroying container $global:ContainerName..."
            docker rm -f $global:ContainerName
            Write-Host "[!] Limpieza completada. / Cleanup completed."
            Pause
            Show-Menu
        }
        '5' {
            Write-Host ""
            Write-Host "[+] Estado de los contenedores de RtoLabs: / RtoLabs containers status:"
            docker ps -a --filter "name=-lab"
            Write-Host ""
            Pause
            Show-Menu
        }
        '6' {
            Write-Host "¡Buena suerte en las auditorías de RtoLabs! / Good luck on your RtoLabs audits!"
            exit
        }
        Default {
            Write-Host "Opción no válida. / Invalid option."
            Start-Sleep -Seconds 1
            Show-Menu
        }
    }
}

Show-Menu