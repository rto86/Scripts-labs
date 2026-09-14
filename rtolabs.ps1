# RtoLabs - Gestor Universal de Laboratorios

$GhcrUser = "rto86"

function Get-LabInfo {
    Write-Host ""
    $global:LabName = Read-Host "[?] Ingresa el NOMBRE del laboratorio (ej. overstack)"
    $global:LabName = $global:LabName.Trim().ToLower()

    if ([string]::IsNullOrWhiteSpace($global:LabName)) {
        Write-Host "[-] El nombre del laboratorio no puede estar vacio."
        Pause
        Show-Menu
    }

    $global:ContainerName = "$($global:LabName)-lab"
    $global:ImageName = "ghcr.io/${GhcrUser}/$($global:LabName):latest"
}

function Show-Menu {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "      RtoLabs - Gestor Universal           "
    Write-Host "=========================================="
    Write-Host "1) Desplegar / Arrancar un laboratorio"
    Write-Host "2) Detener un laboratorio"
    Write-Host "3) Reiniciar un laboratorio detenido"
    Write-Host "4) Destruir contenedor y limpiar"
    Write-Host "5) Ver contenedores en ejecucion"
    Write-Host "6) Salir"
    Write-Host "=========================================="

    $choice = Read-Host "Selecciona una opcion [1-6]"

    switch ($choice) {
        '1' {
            Get-LabInfo
            $port = Read-Host "[?] Ingresa el PUERTO local para mapear (ej. 5000)"
            if ([string]::IsNullOrWhiteSpace($port)) { $port = "5000" }

            Write-Host ""
            Write-Host "[+] Descargando imagen $global:ImageName..."
            docker pull $global:ImageName

            Write-Host "[+] Desplegando contenedor $global:ContainerName en puerto $port..."
            docker run -d --name $global:ContainerName -p "${port}:5000" $global:ImageName

            Write-Host ""
            Write-Host "[!] Laboratorio $($global:LabName) activo en: http://localhost:$port"
            Pause
            Show-Menu
        }
        '2' {
            Get-LabInfo
            Write-Host "[+] Deteniendo el laboratorio $global:ContainerName..."
            docker stop $global:ContainerName
            Write-Host "[!] Contenedor detenido."
            Pause
            Show-Menu
        }
        '3' {
            Get-LabInfo
            Write-Host "[+] Volviendo a arrancar $global:ContainerName..."
            docker start $global:ContainerName
            Write-Host "[!] Laboratorio reanudado."
            Pause
            Show-Menu
        }
        '4' {
            Get-LabInfo
            Write-Host "[+] Destruyendo el contenedor $global:ContainerName..."
            docker rm -f $global:ContainerName
            Write-Host "[!] Limpieza completada."
            Pause
            Show-Menu
        }
        '5' {
            Write-Host ""
            Write-Host "[+] Estado de los contenedores de RtoLabs:"
            docker ps -a --filter "name=-lab"
            Write-Host ""
            Pause
            Show-Menu
        }
        '6' {
            Write-Host "¡Buena suerte en las auditorias de RtoLabs!"
            exit
        }
        Default {
            Write-Host "Opcion no valida."
            Start-Sleep -Seconds 1
            Show-Menu
        }
    }
}

Show-Menu