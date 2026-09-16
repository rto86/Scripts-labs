#!/bin/bash

# RtoLabs - Gestor Universal de Laboratorios / Universal Laboratory Manager

GHCR_USER="rto86"

ask_lab_info() {
    echo ""
    read -p "[?] Ingresa el NOMBRE del laboratorio (ej. overstack) / Enter laboratory NAME (e.g. overstack): " LAB_NAME
    LAB_NAME=$(echo "$LAB_NAME" | tr '[:upper:]' '[:lower:]' | xargs)

    if [ -z "$LAB_NAME" ]; then
        echo "[-] El nombre del laboratorio no puede estar vacío. / Laboratory name cannot be empty."
        read -p "Presiona Enter para reintentar... / Press Enter to retry..."
        show_menu
    fi

    CONTAINER_NAME="${LAB_NAME}-lab"
    IMAGE_NAME="ghcr.io/${GHCR_USER}/${LAB_NAME}:latest"
}

show_menu() {
    clear
    echo "=========================================="
    echo "                 RtoLabs                  "
    echo "=========================================="
    echo "1) Desplegar un laboratorio / Deploy laboratory"
    echo "2) Detener un laboratorio / Shut down a Laboratory"
    echo "3) Reiniciar un laboratorio detenido / Restart a stopped Lab"
    echo "4) Destruir contenedor y limpiar / Destroy the container and clean up"
    echo "5) Ver contenedores en ejecución / View Running Containers"
    echo "6) Salir / Exit"
    echo "=========================================="
    read -p "Selecciona una opción [1-6] / Select an option [1-6]: " option

    case $option in
        1)
            ask_lab_info
            read -p "[?] Ingresa el PUERTO local para mapear (ej. 5000) / Enter local PORT to map (e.g. 5000): " PORT
            if [ -z "$PORT" ]; then PORT="5000"; fi

            echo ""
            echo "[+] Descargando imagen $IMAGE_NAME... / Downloading image $IMAGE_NAME..."
            docker pull $IMAGE_NAME

            echo "[+] Desplegando contenedor $CONTAINER_NAME en puerto $PORT... / Deploying container $CONTAINER_NAME on port $PORT..."
            docker run -d --name $CONTAINER_NAME -p $PORT:5000 $IMAGE_NAME

            echo ""
            echo "[!] Laboratorio $LAB_NAME activo en: http://localhost:$PORT / Lab $LAB_NAME active at: http://localhost:$PORT"
            read -p "Presiona Enter para continuar... / Press Enter to continue..."
            show_menu
            ;;
        2)
            ask_lab_info
            echo "[+] Deteniendo el laboratorio $CONTAINER_NAME... / Stopping laboratory $CONTAINER_NAME..."
            docker stop $CONTAINER_NAME
            echo "[!] Contenedor detenido. / Container stopped."
            read -p "Presiona Enter para continuar... / Press Enter to continue..."
            show_menu
            ;;
        3)
            ask_lab_info
            echo "[+] Volviendo a arrancar $CONTAINER_NAME... / Restarting $CONTAINER_NAME..."
            docker start $CONTAINER_NAME
            echo "[!] Laboratorio reanudado. / Laboratory resumed."
            read -p "Presiona Enter para continuar... / Press Enter to continue..."
            show_menu
            ;;
        4)
            ask_lab_info
            echo "[+] Destruyendo el contenedor $CONTAINER_NAME... / Destroying container $CONTAINER_NAME..."
            docker rm -f $CONTAINER_NAME
            echo "[!] Limpieza completada. / Cleanup completed."
            read -p "Presiona Enter para continuar... / Press Enter to continue..."
            show_menu
            ;;
        5)
            echo ""
            echo "[+] Estado de los contenedores de RtoLabs: / RtoLabs containers status:"
            docker ps -a --filter "name=-lab"
            echo ""
            read -p "Presiona Enter para continuar... / Press Enter to continue..."
            show_menu
            ;;
        6)
            echo "¡Buena suerte en las auditorías de RtoLabs! / Good luck on your RtoLabs audits!"
            exit 0
            ;;
        *)
            echo "Opción no válida. / Invalid option."
            sleep 1
            show_menu
            ;;
    esac
}

show_menu