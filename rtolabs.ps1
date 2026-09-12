# ==============================================================================
# RtoLabs - Gestor Universal de Laboratorios (PowerShell)
# ==============================================================================

$GhcrUser = "rto86"

function Get-LabInfo {
    Write-Host ""
    $global:LabName = Read-Host "[?] Ingresa el NOMBRE del laboratorio (ej. overstack)"
    $global:LabName = $global:LabName.Trim().ToLower()

    if ([string]::IsNullOrWhiteSpace($global:LabName)) {
        Write-Host "[-] El nombre del laboratorio no puede estar vacío." -ForegroundColor Red
        Pause
        Show-Menu
    }

    $global:ContainerName = "$($global:LabName)-lab"
    $global:ImageName = "ghcr.io/${GhcrUser}/$($global:LabName):latest"
}

function Show-Menu {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Purple
    Write-Host "      RtoLabs - Gestor Universal           " -ForegroundColor White
    Write-Host "==========================================" -ForegroundColor Purple
    Write-Host "1) Desplegar / Arrancar un laboratorio"
    Write-Host "2) Detener un laboratorio"
    Write-Host "3) Reiniciar un laboratorio detenido"
    Write-Host "4) Destruir contenedor y limpiar"
    Write-Host "5) Ver contenedores en ejecución"
    Write-Host "6) Salir"
    Write-Host "==========================================" -ForegroundColor Purple
    
    $choice = Read-Host "Selecciona una opción [1-6]"

    switch ($choice) {
        '1' {
            Get-LabInfo
            $port = Read-Host "[?] Ingresa el PUERTO local para mapear (ej. 5000)"
            if ([string]::IsNullOrWhiteSpace($port)) { $port = "5000" }

            Write-Host ""
            Write-Host "[+] Descargando imagen $global:ImageName..." -ForegroundColor Green
            docker pull $global:ImageName

            Write-Host "[+] Desplegando contenedor $global:ContainerName en puerto $port..." -ForegroundColor Green
            docker run -d --name $global:ContainerName -p "${port}:5000" $global:ImageName

            Write-Host ""
            Write-Host "[!] Laboratorio $($global:LabName) activo en: http://localhost:$port" -ForegroundColor Cyan
            Pause
            Show-Menu
        }
        '2' {
            Get-LabInfo
            Write-Host "[+] Deteniendo el laboratorio $global:ContainerName..." -ForegroundColor Yellow
            docker stop $global:ContainerName
            Write-Host "[!] Contenedor detenido." -ForegroundColor Yellow
            Pause
            Show-Menu
        }
        '3' {
            Get-LabInfo
            Write-Host "[+] Volviendo a arrancar $global:ContainerName..." -ForegroundColor Green
            docker start $global:ContainerName
            Write-Host "[!] Laboratorio reanudado." -ForegroundColor Cyan
            Pause
            Show-Menu
        }
        '4' {
            Get-LabInfo
            Write-Host "[+] Destruyendo el contenedor $global:ContainerName..." -ForegroundColor Red
            docker rm -f $global:ContainerName
            Write-Host "[!] Limpieza completada." -ForegroundColor Red
            Pause
            Show-Menu
        }
        '5' {
            Write-Host ""
            Write-Host "[+] Estado de los contenedores de RtoLabs:" -ForegroundColor Cyan
            docker ps -a --filter "name=-lab"
            Write-Host ""
            Pause
            Show-Menu
        }
        '6' {
            Write-Host "¡Buena suerte en las auditorías de RtoLabs!" -ForegroundColor Purple
            exit
        }
        Default {
            Write-Host "Opción no válida." -ForegroundColor Red
            Start-Sleep -Seconds 1
            Show-Menu
        }
    }
}

Show-Menu