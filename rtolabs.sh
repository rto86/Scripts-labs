#!/bin/bash

# RtoLabs - Gestor Universal de Laboratorios

GHCR_USER="rto86"

ask_lab_info() {
    echo ""
    read -p "[?] Ingresa el NOMBRE del laboratorio (ej. overstack): " LAB_NAME
    # Convertir a minúsculas y eliminar espacios accidentalmente introducidos
    LAB_NAME=$(echo "$LAB_NAME" | tr '[:upper:]' '[:lower:]' | xargs)

    if [ -z "$LAB_NAME" ]; then
        echo "[-] El nombre del laboratorio no puede estar vacío."
        read -p "Presiona Enter para reintentar..."
        show_menu
    fi

    CONTAINER_NAME="${LAB_NAME}-lab"
    IMAGE_NAME="ghcr.io/${GHCR_USER}/${LAB_NAME}:latest"
}

show_menu() {
    clear
    echo "=========================================="
    echo "      RtoLabs - Gestor Universal           "
    echo "=========================================="
    echo "1) Desplegar / Arrancar un laboratorio"
    echo "2) Detener un laboratorio"
    echo "3) Reiniciar un laboratorio detenido"
    echo "4) Destruir contenedor y limpiar"
    echo "5) Ver contenedores en ejecución"
    echo "6) Salir"
    echo "=========================================="
    read -p "Selecciona una opción [1-6]: " option

    case $option in
        1)
            ask_lab_info
            read -p "[?] Ingresa el PUERTO local para mapear (ej. 5000): " PORT
            if [ -z "$PORT" ]; then PORT="5000"; fi

            echo ""
            echo "[+] Descargando imagen $IMAGE_NAME..."
            docker pull $IMAGE_NAME

            echo "[+] Desplegando contenedor $CONTAINER_NAME en puerto $PORT..."
            docker run -d --name $CONTAINER_NAME -p $PORT:5000 $IMAGE_NAME

            echo ""
            echo "[!] Laboratorio $LAB_NAME activo en: http://localhost:$PORT"
            read -p "Presiona Enter para continuar..."
            show_menu
            ;;
        2)
            ask_lab_info
            echo "[+] Deteniendo el laboratorio $CONTAINER_NAME..."
            docker stop $CONTAINER_NAME
            echo "[!] Contenedor detenido."
            read -p "Presiona Enter para continuar..."
            show_menu
            ;;
        3)
            ask_lab_info
            echo "[+] Volviendo a arrancar $CONTAINER_NAME..."
            docker start $CONTAINER_NAME
            echo "[!] Laboratorio reanudado."
            read -p "Presiona Enter para continuar..."
            show_menu
            ;;
        4)
            ask_lab_info
            echo "[+] Destruyendo el contenedor $CONTAINER_NAME..."
            docker rm -f $CONTAINER_NAME
            echo "[!] Limpieza completada."
            read -p "Presiona Enter para continuar..."
            show_menu
            ;;
        5)
            echo ""
            echo "[+] Estado de los contenedores de RtoLabs:"
            docker ps -a --filter "name=-lab"
            echo ""
            read -p "Presiona Enter para continuar..."
            show_menu
            ;;
        6)
            echo "¡Buena suerte en las auditorías de RtoLabs!"
            exit 0
            ;;
        *)
            echo "Opción no válida."
            sleep 1
            show_menu
            ;;
    esac
}

show_menu